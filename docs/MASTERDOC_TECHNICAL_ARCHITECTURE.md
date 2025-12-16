# Neural Studio: Technical Architecture Specification
## Metadata-Assisted Volumetric VR Streaming System

**Document Version:** 1.0  
**Target Architecture:** x86_64 Linux (Ubuntu 24.04+)  
**Language Stack:** C++23, Rust, Mojo  
**Build System:** CMake 3.28+

---

## Table of Contents

1. [System Architecture Overview](#1-system-architecture-overview)
2. [Memory Architecture (UMA Zero-Copy Pipeline)](#2-memory-architecture-uma-zero-copy-pipeline)
3. [Server-Side Pipeline](#3-server-side-pipeline)
4. [Network Transport Layer](#4-network-transport-layer)
5. [Client-Side Reconstruction](#5-client-side-reconstruction)
6. [Codec Implementation Strategy](#6-codec-implementation-strategy)
7. [Build System Configuration](#7-build-system-configuration)
8. [Performance Targets and Timing](#8-performance-targets-and-timing)
9. [Development Phases](#9-development-phases)

---

## 1. System Architecture Overview

### 1.1 Core Innovation: One Compute, Two Targets

The system performs geometric analysis (optical flow + disparity estimation) **once** on the server NPU, then uses this data **twice**:

1. **Target 1 (Encoder):** Feed disparity map to AV2 encoder for inter-view prediction → 50% bandwidth reduction
2. **Target 2 (Client):** Send motion vectors to client for FSR4 frame generation → 2x framerate (45fps → 90fps)

**Key Principle:** Server computational cost is amortized across both compression and client-side rendering acceleration.

### 1.2 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         SERVER (Edge/Cloud)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐                                              │
│  │ 8K Stereo    │  Raw YUV420 (Left + Right Eye)               │
│  │ Camera Input │  → Shared UMA Memory Block                   │
│  └──────┬───────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────┐                      │
│  │  NPU (Neural Processing Unit)        │  <3ms                │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Dense Optical Flow Kernel      │──┼──→ Motion Vectors   │
│  │  │ (Temporal: Frame N → N+1)      │  │    (Temporal Δ)     │
│  │  └────────────────────────────────┘  │                      │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Disparity Estimation Kernel    │──┼──→ Disparity Map    │
│  │  │ (Spatial: Left Eye → Right)    │  │    (Geometric Δ)    │
│  │  └────────────────────────────────┘  │                      │
│  └──────────────────────────────────────┘                      │
│         │                        │                              │
│         │ Motion Vectors         │ Disparity Map                │
│         ▼                        ▼                              │
│  ┌──────────────────────────────────────┐                      │
│  │  WebTransport Packetizer (Rust)      │                      │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Channel 1: Datagrams (UDP)     │──┼──→ QUIC Stream 0    │
│  │  │ Priority: HIGH | Unreliable    │  │    (Metadata)       │
│  │  │ Payload: Motion Vectors        │  │                      │
│  │  └────────────────────────────────┘  │                      │
│  └──────────────────────────────────────┘                      │
│                                │                                │
│                                ▼                                │
│  ┌──────────────────────────────────────┐                      │
│  │  Hybrid Video Encoder (VPU + CPU)    │  ~10ms               │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ AV2 Multi-View Encoder         │  │                      │
│  │  │ - Input: Disparity Map         │  │                      │
│  │  │ - Bypass: Internal Motion Est. │  │                      │
│  │  │ - Output: Left Eye (Full) +    │  │                      │
│  │  │           Right Eye (Residual) │  │                      │
│  │  └────────────────────────────────┘  │                      │
│  └──────────────────────────────────────┘                      │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────┐                      │
│  │  Channel 2: Uni-Streams (Reliable)   │                      │
│  │  Payload: AV2 OBU Chunks             │──→ QUIC Streams 1-N  │
│  └──────────────────────────────────────┘                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                            │
                            │ WebTransport/QUIC
                            │ (HTTP/3 over UDP)
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT (Browser / Headset)                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────┐                      │
│  │  WebTransport Receiver (WASM/Rust)   │                      │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Datagram Handler (Async)       │◄─┼── Metadata arrives  │
│  │  │ → Motion Vectors Decoded       │  │    T+20ms            │
│  │  └────────────────────────────────┘  │                      │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Stream Handler (Reliable)      │◄─┼── Video arrives     │
│  │  │ → AV2 OBU Buffer               │  │    T+30ms            │
│  │  └────────────────────────────────┘  │                      │
│  └──────────────────────────────────────┘                      │
│         │                        │                              │
│         │ Metadata               │ Video Packets                │
│         ▼                        ▼                              │
│  ┌──────────────────────────────────────┐                      │
│  │  AV2 Decoder (WASM + SIMD)           │  ~5ms                │
│  │  - Input: OBU Chunks                 │                      │
│  │  - Output: YUV420 Buffer             │                      │
│  └──────────────────────────────────────┘                      │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────┐                      │
│  │  FSR4 Frame Generator (WebGPU)       │  <2ms/frame          │
│  │  ┌────────────────────────────────┐  │                      │
│  │  │ Inject: Server Motion Vectors  │  │                      │
│  │  │ Bypass: GPU Optical Flow       │  │                      │
│  │  │ Generate: Frame N+0.5          │  │                      │
│  │  └────────────────────────────────┘  │                      │
│  └──────────────────────────────────────┘                      │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────┐                      │
│  │  VR Compositor (WebXR / OpenXR)      │                      │
│  │  - Display: 90Hz Stereoscopic        │                      │
│  │  - Latency: <20ms Motion-to-Photon   │                      │
│  └──────────────────────────────────────┘                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Memory Architecture (UMA Zero-Copy Pipeline)

### 2.1 Unified Memory Architecture (UMA)

**Hardware Target:** AMD APU (e.g., Ryzen 7840U) or ARM SoC with shared RAM/VRAM

**Key Principle:** Data is never copied between CPU RAM and GPU VRAM. All compute units (CPU, NPU, GPU, VPU) access the same physical memory via different virtual addresses.

### 2.2 Memory Layout

```
Physical Memory (32GB Unified RAM)
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  [0x00000000] ┌─────────────────────────────────────────┐  │
│               │ Video Frame Buffer (Ring Buffer)        │  │
│               │ - 8K YUV420 Stereo: ~50MB per frame     │  │
│               │ - 4 Frames Buffered: 200MB              │  │
│               └─────────────────────────────────────────┘  │
│                            ▲                                │
│                            │ DMA Transfer (Zero Copy)       │
│                            │                                │
│  [0x0C800000] ┌─────────────────────────────────────────┐  │
│               │ NPU Working Memory (Read/Write)         │  │
│               │ - Optical Flow Scratch: 100MB           │  │
│               │ - Disparity Map Output: 16MB            │  │
│               └─────────────────────────────────────────┘  │
│                            │                                │
│                            │ Pointer Passed (No Copy)       │
│                            ▼                                │
│  [0x12C00000] ┌─────────────────────────────────────────┐  │
│               │ Encoder Reference Frames (Read Only)    │  │
│               │ - AV2 Encoder accesses Frame Buffer     │  │
│               │ - Disparity Map used for prediction     │  │
│               └─────────────────────────────────────────┘  │
│                            │                                │
│                            │ Encoded Bitstream              │
│                            ▼                                │
│  [0x20000000] ┌─────────────────────────────────────────┐  │
│               │ Network Transmit Buffer                 │  │
│               │ - OBU Packets: 2MB                      │  │
│               │ - Metadata Datagrams: 64KB              │  │
│               └─────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Mojo Memory Management

**Why Mojo:** LLVM-based systems language with direct hardware addressing and zero-cost abstractions.

```mojo
struct FrameBuffer:
    var ptr: DTypePointer[DType.uint8]
    var width: Int
    var height: Int
    var stride: Int
    
    fn __init__(inout self, width: Int, height: Int):
        # Allocate aligned UMA memory (4KB page boundary)
        self.ptr = DTypePointer[DType.uint8].alloc(
            width * height * 3 // 2,  # YUV420 size
            alignment=4096
        )
        self.width = width
        self.height = height
        self.stride = width

fn npu_optical_flow(
    frame_n: FrameBuffer, 
    frame_n_plus_1: FrameBuffer
) -> MotionVectorField:
    # NPU kernel call via MLIR lowering
    # Compiler generates direct hardware instructions
    return __mlir_op.`npu.optical_flow`(
        frame_n.ptr,
        frame_n_plus_1.ptr,
        frame_n.width,
        frame_n.height
    )
```

---

## 3. Server-Side Pipeline

### 3.1 Phase A: Geometric Analysis (NPU)

**Hardware:** Dedicated NPU (Neural Processing Unit)  
**Target Latency:** <3ms per frame

#### 3.1.1 Dense Optical Flow Algorithm

**Implementation:** Farnebäck Optical Flow (hardware-accelerated)

**Input:**
- Frame N: YUV420 8K (7680x4320) @ 16-bit precision
- Frame N+1: YUV420 8K

**Output:**
- Motion Vector Field: 2-channel float32 (Δx, Δy per 16x16 block)
- Size: (480 × 270 × 2 × 4 bytes) = 1.04MB

**Kernel Pseudocode:**
```cpp
// NPU executes this in parallel across tile grid
__kernel void optical_flow_tile(
    __global const uint8_t* frame_n,
    __global const uint8_t* frame_n_1,
    __global float2* motion_vectors,
    int width, int height
) {
    int tile_x = get_global_id(0);  // 0-479
    int tile_y = get_global_id(1);  // 0-269
    
    // Load 16x16 pixel block from frame N
    float16x16 block_n = load_block(frame_n, tile_x, tile_y);
    
    // Search 16x16 neighborhood in frame N+1
    float2 best_match = {0, 0};
    float min_sad = INFINITY;
    
    for (int dy = -8; dy <= 8; dy++) {
        for (int dx = -8; dx <= 8; dx++) {
            float16x16 candidate = load_block(
                frame_n_1, 
                tile_x + dx, 
                tile_y + dy
            );
            float sad = sum_absolute_diff(block_n, candidate);
            if (sad < min_sad) {
                min_sad = sad;
                best_match = {dx, dy};
            }
        }
    }
    
    motion_vectors[tile_y * 480 + tile_x] = best_match;
}
```

#### 3.1.2 Disparity Estimation

**Algorithm:** Semi-Global Block Matching (SGBM)

**Input:**
- Left Eye: YUV420 8K
- Right Eye: YUV420 8K

**Output:**
- Disparity Map: 1-channel float32 (depth per pixel)
- Size: (7680 × 4320 × 4 bytes) = 132MB (lossless compressed to ~16MB)

**Optimization:** Use epipolar geometry constraint (horizontal search only)

```cpp
__kernel void disparity_sgbm(
    __global const uint8_t* left_eye,
    __global const uint8_t* right_eye,
    __global float* disparity_map,
    int width, int height,
    int max_disparity  // Typical: 128 pixels
) {
    int x = get_global_id(0);
    int y = get_global_id(1);
    
    float16 left_patch = load_patch(left_eye, x, y);
    
    float min_cost = INFINITY;
    int best_disparity = 0;
    
    // Epipolar constraint: search only horizontal line
    for (int d = 0; d < max_disparity; d++) {
        if (x - d < 0) break;
        
        float16 right_patch = load_patch(right_eye, x - d, y);
        float cost = census_transform_cost(left_patch, right_patch);
        
        if (cost < min_cost) {
            min_cost = cost;
            best_disparity = d;
        }
    }
    
    disparity_map[y * width + x] = best_disparity;
}
```

### 3.2 Phase B: Hybrid Encoding (VPU + CPU)

**Technology:** AV2 Multi-View (MV-AV2) with auxiliary metadata

#### 3.2.1 AV2 Encoder Configuration

**Library:** `libaom` (AOMedia Video Model - experimental branch)

**Critical Compiler Flags:**
```cmake
set(AV2_ENCODER_FLAGS
    -DCONFIG_AV1_ENCODER=1
    -DCONFIG_MULTITHREAD=1
    -DCONFIG_RUNTIME_CPU_DETECT=1
    -DENABLE_AVX2=1
    -DENABLE_NEON=1  # ARM fallback
)
```

**Encoding Parameters:**
```c
aom_codec_enc_cfg_t cfg;
aom_codec_enc_config_default(aom_codec_av1_cx(), &cfg, AOM_USAGE_REALTIME);

// Critical realtime settings
cfg.g_profile = 0;  // Main profile
cfg.g_w = 7680;     // 8K width
cfg.g_h = 4320;     // 8K height
cfg.g_timebase.num = 1;
cfg.g_timebase.den = 45;  // 45fps input
cfg.rc_target_bitrate = 50000;  // 50Mbps target
cfg.g_error_resilient = 1;  // Enable error recovery
cfg.g_lag_in_frames = 0;    // Zero latency mode
cfg.kf_max_dist = 90;       // Keyframe every 2 seconds

// Speed vs quality tradeoff
cfg.cpu_used = 8;  // Maximum speed (0=slowest/best, 8=fastest/acceptable)

// Multi-view specific
cfg.enable_interframe_prediction = 1;
cfg.enable_inter_view_prediction = 1;  // Use disparity map
```

#### 3.2.2 Inter-View Prediction Logic

**Concept:** Right eye frame is predicted from left eye using disparity map

```c
// Pseudo-code for encoder integration
void encode_stereoscopic_frame(
    const uint8_t* left_eye_yuv,
    const uint8_t* right_eye_yuv,
    const float* disparity_map,
    aom_codec_ctx_t* encoder
) {
    // 1. Encode left eye normally (I/P frame)
    aom_image_t left_img;
    aom_img_wrap(&left_img, AOM_IMG_FMT_I420, 7680, 4320, 1, left_eye_yuv);
    aom_codec_encode(encoder, &left_img, frame_count, 1, 0);
    
    // 2. Calculate predicted right eye from left + disparity
    uint8_t* predicted_right = malloc(7680 * 4320 * 3 / 2);
    for (int y = 0; y < 4320; y++) {
        for (int x = 0; x < 7680; x++) {
            int disparity = (int)disparity_map[y * 7680 + x];
            int source_x = x + disparity;
            
            if (source_x >= 0 && source_x < 7680) {
                predicted_right[y * 7680 + x] = left_eye_yuv[y * 7680 + source_x];
            }
        }
    }
    
    // 3. Encode residual (actual - predicted)
    uint8_t* residual = malloc(7680 * 4320 * 3 / 2);
    for (int i = 0; i < 7680 * 4320 * 3 / 2; i++) {
        residual[i] = right_eye_yuv[i] - predicted_right[i] + 128;  // Offset
    }
    
    aom_image_t residual_img;
    aom_img_wrap(&residual_img, AOM_IMG_FMT_I420, 7680, 4320, 1, residual);
    aom_codec_encode(encoder, &residual_img, frame_count, 1, AOM_EFLAG_FORCE_KF);
}
```

**Compression Ratio:** ~50% bitrate reduction compared to side-by-side encoding

---

## 4. Network Transport Layer

### 4.1 WebTransport Protocol Stack

**Base Protocol:** QUIC (RFC 9000) over UDP  
**Application Layer:** WebTransport (RFC 9114)

**Why WebTransport > WebRTC:**
- Lower latency (no DTLS renegotiation overhead)
- Finer control over stream priorities
- Native HTTP/3 integration
- Better NAT traversal via QUIC connection migration

### 4.2 Stream Architecture

```
WebTransport Session
├─ Stream 0 (Bidirectional, Init)
│  └─ Handshake: Client capabilities, codec support
│
├─ Datagrams (Unreliable, Unordered)
│  ├─ Metadata Packet 0: Motion Vectors for Frame N
│  ├─ Metadata Packet 1: Motion Vectors for Frame N+1
│  └─ ... (fire-and-forget)
│
├─ Uni-Stream 1 (Reliable, Ordered)
│  └─ Video Chunk: Left Eye I-Frame (OBU sequence)
│
├─ Uni-Stream 2 (Reliable, Ordered)
│  └─ Video Chunk: Right Eye Residual (OBU sequence)
│
├─ Uni-Stream 3 (Reliable, Ordered)
│  └─ Video Chunk: Left Eye P-Frame
│
└─ ... (N streams for video, datagrams for metadata)
```

### 4.3 Metadata Packet Format

**Protocol:** MoQ (Media over QUIC) - Simplified

```
Metadata Datagram (UDP payload, max 1200 bytes)
┌────────────────────────────────────────────────────┐
│ Header (16 bytes)                                  │
├────────────────────────────────────────────────────┤
│ Magic: 0x4E56 (NV = Neural Video)                  │ 2 bytes
│ Version: 0x01                                      │ 1 byte
│ Packet Type: 0x01 (Motion Vectors)                │ 1 byte
│ Frame Number: uint32                              │ 4 bytes
│ Timestamp: uint64 (microseconds)                  │ 8 bytes
├────────────────────────────────────────────────────┤
│ Payload (1184 bytes max)                           │
├────────────────────────────────────────────────────┤
│ Motion Vector Count: uint16                        │ 2 bytes
│ Compression: 0x00 (None) or 0x01 (Zstd)           │ 1 byte
│ Reserved: 0x00                                     │ 1 byte
│ Motion Vectors: float2[N]                          │ N*8 bytes
│   - Each vector: {float32 dx, float32 dy}         │
│   - Typical N = 129,600 (480x270 tiles)           │
│   - Uncompressed: 1,036,800 bytes                 │
│   - Zstd compressed: ~50KB                         │
└────────────────────────────────────────────────────┘
```

**Compression Strategy:** Use Zstandard (Zstd) level 1 for 20:1 ratio on motion vectors

### 4.4 Rust Implementation (wtransport crate)

```rust
use wtransport::endpoint::{Endpoint, IncomingSession};
use tokio::io::AsyncWriteExt;

#[tokio::main]
async fn main() {
    let config = ServerConfig::builder()
        .with_bind_address("0.0.0.0:4433".parse().unwrap())
        .with_certificate_path("cert.pem")
        .with_key_path("key.pem")
        .build();
    
    let endpoint = Endpoint::server(config).unwrap();
    
    while let Some(session) = endpoint.accept().await {
        tokio::spawn(handle_client(session));
    }
}

async fn handle_client(session: IncomingSession) {
    let connection = session.await.unwrap();
    
    // Spawn metadata sender (datagrams)
    tokio::spawn(async move {
        let mut metadata_tx = connection.datagrams();
        loop {
            let motion_vectors = get_latest_motion_vectors().await;
            let packet = serialize_metadata(motion_vectors);
            metadata_tx.send_datagram(packet.into()).await.unwrap();
            tokio::time::sleep(Duration::from_millis(11)).await;  // 90Hz
        }
    });
    
    // Spawn video sender (streams)
    tokio::spawn(async move {
        let video_stream = connection.open_uni().await.unwrap();
        loop {
            let obu_chunk = encode_next_frame().await;
            video_stream.write_all(&obu_chunk).await.unwrap();
        }
    });
}
```

---

## 5. Client-Side Reconstruction

### 5.1 WASM Decoder Architecture

**Compilation Target:** `wasm32-unknown-unknown` (pure WASM) or `wasm32-wasi` (with WASI)

**Build Command:**
```bash
# Compile AV2 decoder to WASM
emcc \
    -O3 \
    -s WASM=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s EXPORTED_FUNCTIONS='["_av2_decode_frame"]' \
    -s EXPORTED_RUNTIME_METHODS='["cwrap"]' \
    -s SIMD=1 \
    -msimd128 \
    av2_decoder.c \
    -o av2_decoder.wasm
```

**JavaScript Wrapper:**
```javascript
// Load WASM module
const av2Module = await WebAssembly.instantiateStreaming(
    fetch('av2_decoder.wasm')
);

const av2_decode = av2Module.instance.exports.av2_decode_frame;

// Decode OBU chunk
function decodeFrame(obuData) {
    const inputPtr = av2Module.instance.exports.malloc(obuData.length);
    const heap = new Uint8Array(av2Module.instance.exports.memory.buffer);
    heap.set(obuData, inputPtr);
    
    const outputPtr = av2_decode(
        inputPtr,
        obuData.length,
        7680,  // width
        4320   // height
    );
    
    // outputPtr points to YUV420 planar data
    const ySize = 7680 * 4320;
    const uvSize = (7680 / 2) * (4320 / 2);
    
    const yPlane = heap.slice(outputPtr, outputPtr + ySize);
    const uPlane = heap.slice(outputPtr + ySize, outputPtr + ySize + uvSize);
    const vPlane = heap.slice(outputPtr + ySize + uvSize, outputPtr + ySize + 2*uvSize);
    
    return {y: yPlane, u: uPlane, v: vPlane};
}
```

### 5.2 FSR4 Frame Generation with Metadata Injection

**Technology:** AMD FidelityFX Super Resolution 4 (FSR 4.0)

**Key Modification:** Replace GPU-computed optical flow with server-provided motion vectors

```glsl
// FSR4 Frame Generation Shader (Modified)
#version 450

layout(local_size_x = 16, local_size_y = 16) in;

layout(binding = 0) uniform sampler2D frameN;        // Current frame
layout(binding = 1) uniform sampler2D frameN_minus_1; // Previous frame
layout(binding = 2) uniform sampler2D motionVectors;  // SERVER DATA (not computed!)
layout(binding = 3, rgba16f) writeonly uniform image2D output;

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 uv = vec2(pixel) / vec2(7680.0, 4320.0);
    
    // BYPASS: Standard FSR would call `computeOpticalFlow()` here
    // INJECT: Use server motion vectors instead
    vec2 motion = texture(motionVectors, uv).xy;  // Pre-computed on server!
    
    // Warp previous frame using motion
    vec2 prev_uv = uv - motion / vec2(7680.0, 4320.0);
    vec4 warpedPrev = texture(frameN_minus_1, prev_uv);
    
    // Blend current and warped previous (temporal reprojection)
    vec4 current = texture(frameN, uv);
    vec4 interpolated = mix(warpedPrev, current, 0.5);
    
    imageStore(output, pixel, interpolated);
}
```

**Performance Impact:**
- Standard FSR4: ~8ms per frame (GPU computes optical flow)
- Metadata-Injected FSR4: ~2ms per frame (GPU only does warping)
- **Savings:** 6ms per frame = battery life improvement on mobile VR

### 5.3 WebGPU Rendering Pipeline

```javascript
// WebGPU setup for VR rendering
const adapter = await navigator.gpu.requestAdapter();
const device = await adapter.requestDevice();

// Create FSR4 compute pipeline
const fsr4Pipeline = device.createComputePipeline({
    layout: 'auto',
    compute: {
        module: device.createShaderModule({code: fsr4ShaderCode}),
        entryPoint: 'main'
    }
});

// Render loop (90Hz target)
function renderVRFrame(timestamp) {
    // 1. Receive metadata (motion vectors)
    const motionVectors = receiveMetadataFromWebTransport();
    
    // 2. Decode video frame (45fps)
    if (shouldDecodeNewFrame(timestamp)) {
        const yuvFrame = decodeAV2Frame();
        uploadYUVtoGPU(yuvFrame);
    }
    
    // 3. Generate interpolated frame (90Hz = 2x real frames)
    const commandEncoder = device.createCommandEncoder();
    const passEncoder = commandEncoder.beginComputePass();
    
    passEncoder.setPipeline(fsr4Pipeline);
    passEncoder.setBindGroup(0, bindGroup);
    passEncoder.dispatchWorkgroups(
        Math.ceil(7680 / 16),  // X tiles
        Math.ceil(4320 / 16)   // Y tiles
    );
    passEncoder.end();
    
    device.queue.submit([commandEncoder.finish()]);
    
    // 4. Present to VR headset
    const xrSession = navigator.xr.getSession();
    const pose = xrFrame.getViewerPose(xrReferenceSpace);
    
    for (const view of pose.views) {
        const viewport = xrSession.renderState.baseLayer.getViewport(view);
        renderViewToFramebuffer(view, viewport, outputTexture);
    }
    
    xrSession.requestAnimationFrame(renderVRFrame);
}
```

---

## 6. Codec Implementation Strategy

### 6.1 AV1 vs AV2 Decision Matrix

| Aspect | AV1 (Production) | AV2 (Experimental) |
|--------|-----------------|-------------------|
| **Hardware Encoding** | NVENC (RTX 40), VCE (AMD 7000) | None (software only) |
| **Encoding Speed** | Real-time (1080p @ 60fps) | ~10x slower than real-time |
| **Decoding Support** | Native in Chrome/Firefox | WASM decoder required |
| **Bitrate Efficiency** | Baseline | +20-30% improvement |
| **Development Risk** | Low (stable APIs) | High (spec unstable) |
| **Recommendation** | **Use for MVP** | Research prototype only |

### 6.2 Phased Codec Rollout

**Phase 1 (Months 0-3):** AV1 + Hardware Encoding
```cmake
# CMakeLists.txt
find_package(FFmpeg REQUIRED COMPONENTS avcodec avformat)
target_compile_definitions(neural_studio PRIVATE ENABLE_AV1=1 ENABLE_AV2=0)
```

**Phase 2 (Months 4-6):** Parallel AV2 Software Path
```cmake
# Add AV2 as experimental option
option(ENABLE_AV2_EXPERIMENTAL "Enable experimental AV2 codec" OFF)
if(ENABLE_AV2_EXPERIMENTAL)
    add_subdirectory(third_party/aom)  # Fetch AVM branch
    target_compile_definitions(neural_studio PRIVATE ENABLE_AV2=1)
endif()
```

**Phase 3 (Months 7+):** User-Selectable Codec in UI
```cpp
// Runtime codec selection
enum class VideoCodec {
    H264,  // Fallback
    HEVC,  // H.265
    AV1,   // Production
    AV2    // Experimental (warn user)
};

class StreamConfig {
public:
    VideoCodec codec = VideoCodec::AV1;
    int target_bitrate = 50'000;  // kbps
    bool use_metadata_streaming = true;
};
```

### 6.3 Building AVM (AV2 Encoder) from Source

**Build Script (`build_av2.sh`):**
```bash
#!/bin/bash
set -e

# Clone AOMedia Video Model (experimental AV2)
git clone https://aomedia.googlesource.com/aom avm
cd avm
git checkout avm  # AV2 development branch

# Create build directory
mkdir -p build && cd build

# Configure with CMake
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_TESTS=0 \
    -DENABLE_DOCS=0 \
    -DCONFIG_AV1_ENCODER=1 \
    -DCONFIG_MULTITHREAD=1 \
    -DCONFIG_RUNTIME_CPU_DETECT=1 \
    -DCMAKE_INSTALL_PREFIX=/usr/local

# Build (use all cores)
make -j$(nproc)
sudo make install

# Verify
aomenc --help | grep "AOMedia"
```

**Rust FFI Binding (`build.rs`):**
```rust
// build.rs - Link to libaom at compile time
use std::env;
use std::path::PathBuf;

fn main() {
    println!("cargo:rustc-link-lib=aom");
    println!("cargo:rustc-link-search=native=/usr/local/lib");
    
    let bindings = bindgen::Builder::default()
        .header("/usr/local/include/aom/aom_encoder.h")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");
    
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("aom_bindings.rs"))
        .expect("Couldn't write bindings!");
}
```

**Usage in Rust:**
```rust
// src/encoder.rs
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
include!(concat!(env!("OUT_DIR"), "/aom_bindings.rs"));

pub struct AV2Encoder {
    ctx: aom_codec_ctx_t,
    cfg: aom_codec_enc_cfg_t,
}

impl AV2Encoder {
    pub fn new(width: u32, height: u32, bitrate: u32) -> Self {
        unsafe {
            let mut cfg: aom_codec_enc_cfg_t = std::mem::zeroed();
            aom_codec_enc_config_default(
                aom_codec_av1_cx(),
                &mut cfg,
                AOM_USAGE_REALTIME
            );
            
            cfg.g_w = width;
            cfg.g_h = height;
            cfg.rc_target_bitrate = bitrate;
            cfg.g_lag_in_frames = 0;  // Zero latency
            
            let mut ctx: aom_codec_ctx_t = std::mem::zeroed();
            aom_codec_enc_init_ver(
                &mut ctx,
                aom_codec_av1_cx(),
                &cfg,
                0,
                AOM_ENCODER_ABI_VERSION as i32
            );
            
            Self { ctx, cfg }
        }
    }
    
    pub fn encode_frame(&mut self, yuv_data: &[u8]) -> Vec<u8> {
        // ... encoding logic
    }
}
```

---

## 7. Build System Configuration

### 7.1 CMake Dependency Graph

```
Neural Studio
├─ Qt 6.10.1 (UI Framework)
│  ├─ Qt6::Core
│  ├─ Qt6::Quick
│  ├─ Qt6::Quick3D (3D SceneGraph)
│  └─ Qt6::Multimedia
│
├─ Vulkan (Rendering)
│  ├─ Vulkan-Loader
│  ├─ Vulkan-ValidationLayers
│  └─ glslang (Shader compiler)
│
├─ OpenXR (VR/AR Runtime)
│  ├─ openxr_loader
│  └─ Monado (Open-source runtime)
│
├─ OpenUSD (3D Asset Pipeline)
│  ├─ pxr (Pixar USD core)
│  └─ MaterialX (Shader graphs)
│
├─ ObjectBox (Database)
│  └─ objectbox-c (C API)
│
├─ FFmpeg (Video I/O)
│  ├─ libavcodec (AV1/HEVC encoding)
│  ├─ libavformat (Container muxing)
│  └─ libavfilter (Video processing)
│
├─ ONNX Runtime (AI/ML)
│  └─ onnxruntime (CPU + CUDA backends)
│
├─ Wasmtime (WASM Plugins)
│  └─ wasmtime-c-api
│
├─ Network Stack
│  ├─ libquic (QUIC protocol - Rust via C FFI)
│  └─ wtransport (WebTransport - Rust crate)
│
└─ Audio Stack
   ├─ PipeWire (Modern Linux audio)
   ├─ JACK (Pro audio)
   └─ libspatializer (Ambisonics)
```

### 7.2 CMakeLists.txt Structure

```cmake
cmake_minimum_required(VERSION 3.28)
project(NeuralStudio VERSION 1.0.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ============================================================
# Option Flags (from CMakePresets.json)
# ============================================================
option(ENABLE_VULKAN "Enable Vulkan rendering" ON)
option(ENABLE_OPENXR "Enable OpenXR VR support" ON)
option(ENABLE_OPENUSD "Enable OpenUSD 3D pipeline" ON)
option(ENABLE_WEBTRANSPORT "Enable WebTransport streaming" ON)
option(ENABLE_AV2 "Enable AV2 codec (experimental)" OFF)
option(ENABLE_METADATA_STREAMING "Enable metadata-assisted streaming" ON)

# ============================================================
# Find Core Dependencies
# ============================================================
find_package(Qt6 6.10 REQUIRED COMPONENTS 
    Core Quick Quick3D Multimedia Widgets)
find_package(Vulkan REQUIRED)
find_package(OpenXR REQUIRED)
find_package(FFmpeg REQUIRED COMPONENTS avcodec avformat avutil swscale)
find_package(ONNX Runtime REQUIRED)

# OpenUSD (custom find module)
set(pxr_DIR $ENV{HOME}/USD)
find_package(pxr REQUIRED)

# ObjectBox (FetchContent)
include(FetchContent)
FetchContent_Declare(
    objectbox
    URL https://github.com/objectbox/objectbox-c/releases/download/v0.21.0/objectbox-linux-x64.tar.gz
)
FetchContent_MakeAvailable(objectbox)

# ============================================================
# Rust Interop (WebTransport)
# ============================================================
if(ENABLE_WEBTRANSPORT)
    # Build Rust crate and link to C++
    add_custom_target(
        rust_webtransport ALL
        COMMAND cargo build --release
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/rust/webtransport
    )
    
    add_library(webtransport_static STATIC IMPORTED)
    set_target_properties(webtransport_static PROPERTIES
        IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/rust/webtransport/target/release/libwebtransport.a
    )
    add_dependencies(webtransport_static rust_webtransport)
endif()

# ============================================================
# Experimental AV2 Codec
# ============================================================
if(ENABLE_AV2)
    add_subdirectory(third_party/avm)  # AOMedia Video Model
    target_compile_definitions(neural_studio PRIVATE ENABLE_AV2=1)
endif()

# ============================================================
# Main Executable
# ============================================================
add_executable(neural_studio
    src/main.cpp
    src/ui/activeframe.cpp
    src/ui/blueprintframe.cpp
    src/scenegraph/node.cpp
    src/scenegraph/camera.cpp
    src/streaming/encoder.cpp
    src/streaming/transport.cpp
    src/vr/openxr_backend.cpp
    src/3d/usd_importer.cpp
)

target_link_libraries(neural_studio PRIVATE
    Qt6::Core Qt6::Quick Qt6::Quick3D
    Vulkan::Vulkan
    OpenXR::openxr_loader
    pxr::usd pxr::usdImaging
    objectbox
    FFmpeg::avcodec FFmpeg::avformat
    onnxruntime
    webtransport_static
    pthread dl
)

# ============================================================
# Install Rules
# ============================================================
install(TARGETS neural_studio DESTINATION bin)
install(DIRECTORY assets/ DESTINATION share/neural_studio/assets)
```

### 7.3 Build Commands

```bash
# Configure with experimental features
cmake --preset ubuntu-experimental

# Build with all cores
cmake --build build_ubuntu_experimental --parallel

# Run
./build_ubuntu_experimental/neural_studio

# Install system-wide
sudo cmake --install build_ubuntu_experimental
```

---

## 8. Performance Targets and Timing

### 8.1 Latency Budget (Target: <20ms Motion-to-Photon)

| Stage | Target Time | Critical Path |
|-------|-------------|---------------|
| **Server: Camera Capture** | 2ms | V4L2 MMAP buffer swap |
| **Server: NPU Analysis** | 3ms | Optical flow + disparity |
| **Server: Metadata Send** | 0.1ms | UDP datagram (no retransmit) |
| **Network: Transit** | 5ms | Assuming 5ms RTT (edge server) |
| **Client: Metadata Receive** | 0.1ms | UDP recv() syscall |
| **Server: AV2 Encoding** | 10ms | VPU hardware acceleration |
| **Network: Transit** | 5ms | Reliable QUIC stream |
| **Client: AV2 Decoding** | 5ms | WASM SIMD decoder |
| **Client: FSR4 Generation** | 2ms | WebGPU compute shader |
| **Client: VR Compositor** | 2ms | Direct-to-display scanout |
| **Total (Worst Case)** | **34.2ms** | **Exceeds 20ms target** |

**Optimization Strategies:**
1. **Edge Deployment:** Reduce network RTT from 10ms → 2ms (total: 26.2ms)
2. **Hardware Decode:** Replace WASM with native decoder (5ms → 1ms, total: 22.2ms)
3. **Predictive Rendering:** Start FSR4 before decode finishes (overlap 3ms, total: 19.2ms)

### 8.2 Bandwidth Requirements

**8K Stereoscopic @ 45fps (uncompressed):**
- Resolution per eye: 7680 × 4320
- YUV420 size: 7680 × 4320 × 1.5 = 49.77 MB/frame
- Both eyes: 99.54 MB/frame
- At 45fps: 4,479 MB/s = **35.8 Gbps** ❌ (not feasible)

**With AV2 Inter-View Prediction:**
- Left eye (I-frame): 50 Mbps
- Right eye (residual): 25 Mbps (50% reduction)
- Total: **75 Mbps** ✅ (achievable on 5G/Wi-Fi 6)

**Metadata Overhead:**
- Motion vectors: 50 KB/frame × 45fps = 2.25 MB/s = **18 Mbps**
- Total with metadata: **93 Mbps**

### 8.3 Memory Footprint

**Server:**
- Frame buffers (4× 8K YUV420): 200 MB
- NPU working memory: 100 MB
- AV2 encoder state: 500 MB
- Network transmit queue: 50 MB
- **Total: ~850 MB**

**Client (WASM):**
- AV2 decoder state: 200 MB
- Frame buffers (2× decoded): 100 MB
- FSR4 intermediate buffers: 150 MB
- **Total: ~450 MB**

---

## 9. Development Phases

### Phase 1: Foundation (Months 0-2)
**Goal:** Prove zero-copy pipeline + basic streaming

**Deliverables:**
1. ✅ UMA memory allocator (Mojo)
2. ✅ NPU optical flow kernel (placeholder: CPU-based Farnebäck)
3. ✅ AV1 encoder integration (FFmpeg + NVENC)
4. ✅ WebTransport server (Rust + wtransport)
5. ✅ Client WASM decoder (dav1d compiled to WASM)

**Test:** Stream 1080p @ 30fps with <50ms latency

### Phase 2: Metadata Streaming (Months 3-4)
**Goal:** Implement "one compute, two targets"

**Deliverables:**
1. ✅ Serialize motion vectors to MoQ datagrams
2. ✅ Client-side FSR4 integration (WebGPU)
3. ✅ Metadata injection into FSR4 shader
4. ✅ Frame generation (30fps → 60fps interpolation)

**Test:** Perceptual quality of generated frames vs. real frames

### Phase 3: Stereoscopic & VR (Months 5-6)
**Goal:** 8K VR streaming

**Deliverables:**
1. ✅ Disparity estimation kernel (SGBM)
2. ✅ AV1 multi-view encoding (hack: use separate streams)
3. ✅ OpenXR integration (desktop VR headset)
4. ✅ WebXR client (browser-based VR)

**Test:** 4K per eye @ 45fps with <30ms latency

### Phase 4: AV2 Research (Months 7-9)
**Goal:** Replace AV1 with AV2 for bandwidth reduction

**Deliverables:**
1. ✅ AVM encoder build system
2. ✅ Inter-view prediction patch (modify libaom)
3. ✅ WASM AV2 decoder (compile AVM decoder)
4. ✅ A/B test: AV1 vs AV2 bitrate comparison

**Test:** 50% bitrate reduction on synthetic stereo content

### Phase 5: Production Hardening (Months 10-12)
**Goal:** Deploy to edge servers + optimize

**Deliverables:**
1. ✅ Kubernetes deployment manifests
2. ✅ Client-side adaptive bitrate (ABR)
3. ✅ Error recovery (packet loss handling)
4. ✅ User-selectable transport profiles (UI)
5. ✅ Performance telemetry (Prometheus + Grafana)

**Test:** 1000 concurrent users streaming 4K VR

---

## Appendix A: Hardware Recommendations

### Server (Edge/Cloud)
- **CPU:** AMD Ryzen 9 7950X (16-core, 5.7GHz)
- **NPU:** AMD XDNA (Ryzen AI 300 series) or discrete Hailo-8
- **GPU:** NVIDIA RTX 4090 (NVENC AV1 encoding)
- **RAM:** 64GB DDR5-6000 (UMA for APU builds)
- **Network:** 10GbE NIC (DPDK for kernel bypass)
- **Storage:** 2TB NVMe (frame buffer swap)

### Client (VR Headset)
- **SoC:** Qualcomm Snapdragon XR2 Gen 2
- **RAM:** 12GB LPDDR5X
- **Display:** 4K per eye @ 90Hz (Meta Quest 3 spec)
- **Network:** Wi-Fi 6E (6GHz band, <2ms latency)

---

## Appendix B: References

1. **WebTransport Spec:** RFC 9114 (IETF)
2. **AV1 Bitstream Spec:** AV1 Bitstream & Decoding Process Specification v1.0
3. **AV2 (AVM):** https://aomedia.googlesource.com/aom/+/refs/heads/avm
4. **FSR 4.0 Docs:** AMD GPUOpen - FidelityFX Super Resolution
5. **QUIC Protocol:** RFC 9000 (IETF)
6. **OpenXR Spec:** Khronos OpenXR 1.0.32
7. **Farnebäck Optical Flow:** "Two-Frame Motion Estimation Based on Polynomial Expansion" (Farnebäck, 2003)
8. **SGBM Stereo:** "Depth Discontinuities by Pixel-to-Pixel Stereo" (Hirschmüller, 2005)

---

**End of Technical Specification**
