# WIDGET TYPES

---

### 🎨 Widget Type Entities (Universal UI Components)

---

## Universal Widgets (Cross-Node Functionality)

| Code | Widget Name | Description | Functional Group |
|:----:|:------------|:------------|:----------------:|
| `SEL` | SourceSelector | A unified UI for picking files, URLs, or hardware inputs. | Connectivity |
| `SET` | SettingsPanel | A collapsible grid of parameters specific to a node's logic. | Configuration |
| `PLY` | PlaybackControls | Transport bar (Play/Pause, Stop, Loop, Speed). | Control |
| `SCR` | TimelineScrubber | Interactive seek-bar with timecode and duration display. | Navigation |
| `MET` | LevelMeter | Multichannel VU/Peak meter for signal amplitude monitoring. | Monitoring |
| `STA` | StatusDisplay | Connection health, bitrate, and sync error reporting. | Analysis |
| `PVW` | MediaPreview | Small viewport for live video frames or texture thumbnails. | Visualization |
| `NAV` | ChapterNavigator | List-based navigation for markers, keyframes, or timestamps. | Navigation |
| `VOL` | VolumeControl | Fader/Knob combo with a dedicated mute toggle. | Processing |
| `EDT` | GradientEditor | Visual ramp for defining color or density transitions. | Generation |
| `GRF` | WaveformDisplay | Real-time or static plot of audio or signal data. | Analysis |
| `INF` | FormatInfo | Metadata display (Codec, Resolution, Sample Rate). | Information |
| `KFR` | KeyframeEditor | Interface for setting and interpolating values over time. | Animation |
| `PRO` | ProjectionMapper | Widgets for VR360, VR180, or Equirectangular mapping. | Structural |
| `CAP` | CaptureWidget | Controls for recording streams or taking screenshots. | Source |

---

## Node-Specific Reusable Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `SRC` | SourceFileSelector | Browses local filesystem for assets (Audio, Video, 3D). | High |
| `URL` | NetworkStreamInput | Input field for URLs/IPs with protocol validation (RTMP, HTTP, WS). | High |
| `CAM` | DeviceInputSelector | Dropdown for physical hardware selection (Webcams, Mics, Capture Cards). | High |
| `MTE` | MetadataEditor | Editable table for node tags, descriptions, and custom keys. | High |
| `LOG` | DebugConsole | Scrolling text area for error logs and system messages specific to that node. | High |
| `HST` | HealthStatusIndicator | Visual traffic light (Green/Yellow/Red) + connection uptime. | High |
| `PRT` | PortConfiguration | Visualizer for Input/Output data types and connection limits. | High |
| `PRE` | PresetManager | Dropdown + Save/Load buttons for node configuration states. | High |
| `UND` | HistoryStack | Undo/Redo list specifically for changes made within that node. | Med |
| `LIC` | LicenseKeyInput | Masked field for API keys or software licenses. | Low |
| `TAG` | TagCloudSelector | UI for selecting categories or grouping tags. | Med |

---

## Audio Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `WAV` | WaveformScrubber | Interactive waveform view for seeking and trimming. | High |
| `VUM` | MultiChannelMeter | 2-8 channel bar meters with peak hold. | High |
| `EQG` | GraphicEQEditor | Interactive frequency curve with drag handles. | Med |
| `SPC` | SpectrogramView | Heatmap visualization of frequency over time. | Med |
| `ADR` | ADSREnvelope | Graph editor for Attack, Decay, Sustain, Release. | Med |
| `SPA` | SpatialPanner | 2D/3D radar view for positioning sound sources. | Med |
| `CMP` | DynamicsCompressor | Visualization of threshold vs. ratio (knee curve). | Med |
| `PIT` | PitchShifterUI | Dial/Slider combo for semitone and cent adjustment. | Low |
| `MID` | MidiNoteGrid | Piano roll snippet for viewing/editing note data. | Med |
| `BUF` | BufferSettings | Controls for sample rate, bit depth, and buffer size. | High |
| `DLY` | DelayTapVisualizer | Visual representation of echo taps and feedback loops. | Low |
| `VOC` | VoiceActivityGate | Threshold slider with visual noise floor indicator. | Med |

---

## Video Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `VPW` | ViewportPreview | Real-time video canvas with hover-zoom and fit/fill modes. | High |
| `HIS` | LumaHistogram | Graph showing brightness distribution. | High |
| `VEC` | ColorVectorscope | Circular plot for color saturation and hue analysis. | Med |
| `RGB` | RGBParade | Three side-by-side graphs for Red, Green, Blue levels. | Med |
| `CRP` | CropMaskEditor | Interactive box over preview to define ROIs (Regions of Interest). | Med |
| `GRD` | ColorGradingWheels | 3-way color wheels (Lift, Gamma, Gain). | Med |
| `LUT` | LutSelector | Grid preview of Look Up Tables applied to a sample frame. | Low |
| `KEY` | ChromaKeyPicker | Eyedropper tool + tolerance sliders for green screen. | Low |
| `RES` | ResolutionScaler | Dropdown for standard aspect ratios (16:9, 9:16) and pixel dimensions. | High |
| `FPS` | FrameRateControl | Slider/Input for FPS with drop-frame options. | High |
| `LNS` | LensDistortion | Grid mesh manipulation to correct/add fisheye effects. | Low |
| `MOT` | MotionVectorVis | Overlay arrows showing direction of movement in frame. | Low |

---

## 3D Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `OBJ` | MeshInspector | 3D spin-view of a model wireframe/solid. | High |
| `MAT` | MaterialSlotEditor | Drag-and-drop slots for Albedo, Normal, Roughness maps. | High |
| `LGT` | LightPropertyPanel | Controls for intensity, color temperature, and cone angle. | Med |
| `TRN` | TransformGizmo | Numerical input for World/Local Position, Rotation, Scale. | High |
| `FRU` | FrustumVisualizer | Visual representation of camera FOV and clip planes. | Low |
| `UVM` | UVMapViewer | 2D display of texture coordinates. | Low |
| `RIG` | BoneHierarchyTree | Collapsible tree view of skeletal armatures. | Low |
| `PHY` | PhysicsProperties | Sliders for mass, friction, bounce, and gravity. | Med |
| `SKY` | HDRIEnvironment | Spherical preview for selecting lighting environments. | Med |
| `PTS` | ParticleSystemUI | Controls for emission rate, lifetime, and spread. | Low |

---

## 3D Animation & Rigging

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `ANK` | AnimationKeyframeEditor | Timeline-based keyframe editor for 3D animations. | High |
| `RGC` | RigControlPanel | IK/FK switch, bone constraints, and rig settings. | Med |
| `SKW` | SkinWeightPainter | Visual bone weight painting on mesh surface. | Low |
| `BLN` | BlendShapeEditor | Morph target slider controls with preview. | Med |
| `ACL` | AnimationClipLibrary | Grid of animation clip thumbnails with playback. | High |
| `IKS` | IKSolver | Inverse kinematics chain configuration UI. | Med |
| `MTG` | MotionGraphEditor | State machine editor for animation blending. | Med |
| `RTC` | RetargetingControl | Map source skeleton to target skeleton bones. | Low |

---

## 3D Effects & Shaders

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `SHP` | ShaderPreview | Real-time shader preview sphere/cube with lighting. | High |
| `TXP` | TexturePreview | 2D texture preview with mip-map level control. | High |
| `NDP` | NodeGraphEditor | Visual shader graph with node connections. | Med |
| `UNP` | UniformPropertyEditor | Shader uniform/parameter controls (floats, colors, vectors). | High |
| `PFX` | PostFXStack | Ordered list of post-processing effects with toggles. | High |
| `RFL` | ReflectionProbe | Cubemap capture settings for reflections. | Med |
| `VOL` | VolumetricSettings | Controls for volumetric fog, god rays, scattering. | Med |
| `DOF` | DepthOfFieldControl | Focus distance, aperture, and bokeh shape settings. | Med |
| `BLM` | BloomControl | Threshold, intensity, and radius for bloom effect. | High |
| `SSR` | ScreenSpaceReflections | Quality/distance settings for SSR effect. | Med |

---

## Developer Tools

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `TRM` | TerminalWidget | Embedded terminal emulator for shell commands. | High |
| `CBE` | CodeBlockExecutor | Code editor with syntax highlighting + Run button. | High |
| `REP` | REPLConsole | Read-Eval-Print-Loop for interactive coding (Python/JS/Lua). | High |
| `DBG` | DebuggerPanel | Breakpoints, step-through, variable inspection. | Med |
| `PRF` | ProfilerGraph | CPU/GPU/Memory usage timeline visualization. | High |
| `PKG` | PackageManager | Install/update dependencies with version control. | Med |
| `GIT` | GitIntegration | Commit, branch, diff viewer for version control. | Med |
| `API` | APITester | HTTP request builder with headers/body/response preview. | High |
| `RGX` | RegexTester | Live regex pattern testing with match highlighting. | Med |
| `JSF` | JSONFormatter | Pretty-print JSON with collapsible tree view. | High |

---

## Font & Typography

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `FNT` | FontSelector | Dropdown with font preview and installed fonts list. | High |
| `TYP` | TypographyPanel | Font size, weight, spacing, line-height controls. | High |
| `KRN` | KerningEditor | Visual character pair spacing adjustment. | Low |
| `GLP` | GlyphPicker | Grid of font glyphs/characters for selection. | Med |
| `TXO` | TextOutlineControl | Stroke width, color, and offset for text outlines. | Med |
| `TXS` | TextShadowControl | Shadow offset, blur, and color controls. | Med |
| `TXW` | TextWarpControl | Arc, wave, bulge text deformation controls. | Low |

---

## Stitching & Compositing

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `STC` | StitchControlPanel | Seam blending, alignment, and overlap controls. | Med |
| `SMP` | SeamMaskPainter | Brush tool to manually refine stitch seams. | Low |
| `CMP` | CompositeLayerStack | Layer order with blend modes and opacity. | High |
| `MTP` | MultiviewPreview | Side-by-side preview of multiple camera angles. | Med |
| `PTZ` | PTZCalibration | Pan/Tilt/Zoom calibration for multi-camera setups. | Low |
| `FEA` | FeatureMatchVisualizer | Shows detected feature points across images. | Low |

---

## Machine Learning Enhancements

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `MLA` | ModelArchitectureViewer | Visual network layer diagram with dimensions. | Med |
| `DST` | DatasetBrowser | Thumbnail grid of training data with labels. | High |
| `AUG` | DataAugmentationControl | Settings for rotation, flip, crop, color jitter. | Med |
| `LDR` | LoRASelector | Dropdown for selecting/loading LoRA adapters. | Med |
| `IPT` | InpaintMaskEditor | Brush-based mask for AI inpainting regions. | Med |
| `SGM` | SegmentationOverlay | Color-coded mask overlay for semantic segmentation. | Med |
| `DTC` | DetectionBoundingBoxes | Visualize object detection boxes with confidence scores. | High |
| `POS` | PoseEstimationViewer | Skeletal overlay for human/object pose detection. | Med |
| `STY` | StyleTransferPresets | Grid of artistic style thumbnails for neural style transfer. | Med |
| `UPS` | UpscalerComparison | Side-by-side before/after upscaling preview. | High |

---

## AI/ML Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `PRM` | PromptTextArea | Multi-line input with syntax highlighting for system prompts. | High |
| `CTX` | ContextWindowBar | Visual bar showing token usage vs. model limit. | High |
| `TMP` | HyperparamGrid | Sliders for Temperature, Top-P, Frequency Penalty. | High |
| `CHT` | ChatThreadView | Scrollable list of message bubbles (User/Assistant). | High |
| `ROL` | RoleSwitcher | Dropdown to force a message as "System", "User", or "AI". | Med |
| `EMB` | EmbeddingCluster | 2D scatter plot visualization of vector data. | Low |
| `CNF` | ConfidenceScore | Large percentage display with color coding (Green=High). | Med |
| `TRA` | TrainingLossGraph | Real-time line chart of loss/accuracy over epochs. | Low |
| `IMG` | DiffusionSeed | Input for seed number + "Randomize" dice button. | Med |
| `RAG` | DocRetrieverList | List of documents cited/retrieved for the current answer. | Med |
| `JSN` | JSONSchemaEditor | Tree-view editor for defining structured output formats. | Med |

---

## Sequencer & Trigger Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `TLN` | MiniTimeline | Linear track view of events within this node. | High |
| `KFI` | KeyframeInterpolator | Graph editor for easing curves (Bezier, Linear, Step). | High |
| `CLK` | ClockSource | Selection for system time, internal clock, or external timecode. | Med |
| `BPM` | MetronomeSettings | Controls for Beats Per Minute and Time Signature. | Med |
| `TRG` | TriggerLogicBuilder | UI to build "If X > Y then Fire" rules. | High |
| `LOP` | LoopRegionSelector | UI to define start/end points for cycling playback. | High |

---

## API & Network Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `HDR` | RequestHeaderGrid | Key-Value pair editor for HTTP headers. | Med |
| `PAY` | PayloadBodyEditor | JSON/XML editor for API requests. | Med |
| `LAT` | LatencyGraph | Rolling chart of ping/response times. | High |
| `TOK` | AuthTokenManager | Secure vault UI for managing Bearer tokens/OAuth. | Med |
| `SSL` | CertificateInfo | Display for SSL/TLS validity and expiry. | Low |
| `GPU` | VRAMUsageBar | Bar chart showing GPU memory consumption. | Med |
| `SER` | SerialBaudRate | Settings for connecting to Arduino/Serial devices. | Low |

---

## Script & Control Logic Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `ACS` | AutoCriteriaSelector | Visual "If/Else" block builder for filtering data streams based on conditions. | High |
| `INJ` | InjectionLogic | Text area or slot for inserting code snippets, prompts, or metadata into a stream. | Med |
| `EXT` | ExtractionLogic | UI to define Regex patterns or JSON paths to pull specific data out of a payload. | Med |
| `DLA` | TaskLatencyDelay | Slider (ms/frames) to intentionally delay a signal for sync purposes. | High |
| `EVL` | EventList | Scrolling log of triggered events with timestamps and "Clear" button. | High |
| `QUE` | JobQueue | Visual stack of pending background tasks with drag-to-reorder support. | Med |
| `LPC` | LoopController | Numeric input for defining iteration counts or "While" conditions. | Med |
| `GTE` | LogicGate | Visual switch for boolean operations (AND, OR, XOR, NOT). | Low |
| `RTY` | RetryPolicy | Spinner/Input for setting "Max Retries" and "Backoff Time" on failure. | Low |
| `CRN` | CronScheduler | UI for setting recurring automated tasks (e.g., "Every 5 mins"). | Med |
| `THL` | ThresholdTrigger | Slider + "Above/Below" toggle to fire an event when a value crosses a line. | High |

---

## Visual Effect Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `COL` | ColorSelector | Full HSLA color picker with alpha transparency bar and hex input. | High |
| `PAL` | PaletteManager | Grid of savable color swatches for quick reuse. | High |
| `CRV` | GraphCurveSelector | Interactive cubic-bezier editor for easing or color transfer functions. | High |
| `ENH` | EnhanceSelector | Dropdown/Toggle combo for upscaling (DLSS/FSR) or sharpening algorithms. | Med |
| `GRS` | GradientStops | Multi-handle slider for defining color ramps. | Med |
| `BLM` | BlendModeSelect | Dropdown for composition modes (Multiply, Screen, Overlay, Add). | High |
| `MSK` | MaskLayerSelect | UI to pick which channel (R, G, B, A) serves as a mask. | Med |
| `LUB` | LutBrowser | Grid view of small thumbnails previewing color grading presets. | Med |
| `VGN` | VignetteControl | Circular UI to adjust edge darkening radius and feather. | Low |
| `EXP` | ExposureSlider | Specialized slider centered at 0 with EV (Exposure Value) steps. | Med |

---

## 3D Transform & Scene Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `T3D` | 3dTransformation | Grouped input set for Translation (X,Y,Z), Rotation (X,Y,Z), Scale (X,Y,Z). | High |
| `PIV` | PivotPointAdj | 3-axis offset inputs to change the center of rotation. | Low |
| `NRM` | NormalSmoother | Slider/Angle input to define auto-smooth angles for meshes. | Low |
| `LOD` | LodLevelSelect | Slider to manually force a specific Level of Detail mesh. | Med |
| `WFR` | WireframeToggle | Checkbox to overlay mesh topology on the preview. | Med |
| `SHD` | ShadowCaster | Checkbox + Resolution dropdown for shadow map settings. | Med |
| `FOG` | FogDensity | Slider for volumetric fog thickness and start/end distance. | Low |

---

## Generic UI Controls

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `SLD` | StandardSlider | Horizontal drag bar for 0.0 to 1.0 float values. | Very High |
| `DIA` | RotaryDial | Circular knob control (often used for Audio or Angle). | High |
| `MSL` | MultiSelect | Dropdown with checkboxes to allow selecting multiple tags/options. | High |
| `UIN` | UrlInput | Text field with validation for HTTP/RTMP formatting + "Open" icon. | High |
| `RNG` | MinMaxRange | Dual-handle slider to define a value window (e.g., "Trim Start/End"). | High |
| `INT` | IntegerStep | Number box with up/down arrows that only accepts whole numbers. | High |
| `XYP` | XYController | 2D pad for controlling two values simultaneously (Vector2). | Med |
| `TOG` | SwitchToggle | iPhone-style sliding switch for boolean states. | Very High |
| `RAD` | RadioCluster | Group of buttons where only one can be active at a time. | High |
| `PTH` | FilePathBreadcrumb | Clickable path segments for navigating folders. | Med |

---

## Data Management Widgets

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `LIB` | LibraryGrid | Thumbnail grid for browsing assets with search and sort. | High |
| `LNG` | LanguageSelector | Dropdown with flag icons and ISO codes (en-US, ja-JP). | High |
| `VER` | VersionHistory | List of timestamps/commits to rollback changes. | Med |
| `TGI` | TagInput | Text field that converts comma-separated text into "Chips". | High |
| `MED` | MetaDictEditor | Key-Value table for adding custom properties to a file/node. | Med |
| `JTV` | JsonTreeViewer | Collapsible text view for inspecting raw JSON data. | Med |
| `CSV` | TableDataView | Spreadsheet-like grid for viewing array data. | Low |
| `FIL` | FilterSearch | Search bar with advanced filter icons (File Type, Date, Size). | High |

---

## Specialized Audio Processing

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `FLT` | FilterTypeSelect | Dropdown for LowPass, HighPass, BandPass, Notch. | High |
| `RQS` | ResonanceQ | Slider specifically for filter peak/width. | Med |
| `MXR` | MatrixMixer | Grid of knobs routing Input Channels (rows) to Output Channels (cols). | Low |
| `ENV` | EnvelopeGraph | Visual editor for ADSR (Attack, Decay, Sustain, Release) curves. | Med |
| `FFT` | SpectrumVis | Real-time bar graph of frequency bands. | Med |
| `SDL` | StereoDelay | Two time-inputs (L/R) with a "Link" chain icon. | Low |

---

## Navigation & UI Flow

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `MNU` | HamburgerMenu | Collapsible list of secondary actions (Export, Delete, Duplicate). | Very High |
| `CMN` | ContextMenu | Right-click style floating list for quick actions. | High |
| `OSR` | OmniSearch | Input field that queries files, nodes, and commands simultaneously. | High |
| `SFT` | SearchFilterTag | Clickable chips to narrow search (e.g., "Only Audio", "Only Errors"). | High |
| `TAB` | TabBar | Horizontal row of buttons to switch between "Views" (e.g., Settings vs. Logs). | High |
| `BKR` | BookmarkToggle | Star/Heart icon to pin an item to a "Favorites" list. | High |
| `PAG` | PaginationBar | Controls for "Next Page", "Previous Page", and "Items per page". | Med |

---

## Streaming & Chat Integration

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `FND` | FundingGoalBar | Progress bar showing current donations vs. target amount. | Med |
| `TIP` | RecentTipper | Text display showing the name/amount of the last donation. | Med |
| `CNT` | NumericCounter | Simple incrementing number display (e.g., "Days Since Incident"). | High |
| `CDN` | CountdownTimer | HH:MM:SS display counting down to a specific timestamp. | High |
| `ALR` | AlertBoxPreview | Mini-canvas showing how a donation alert will look on stream. | Low |
| `SUB` | SubTrain | Visual chain or meter representing consecutive subscriptions. | Low |
| `POL` | PollResultGraph | Bar chart showing real-time voting percentages. | Med |

---

## Transcription & Subtitles

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `TRS` | TranscriptionSelector | Dropdown to pick the specific Whisper/model version (Tiny, Large, Turbo). | Med |
| `SLG` | SourceLangSelect | Dropdown to define the spoken language (or set to "Auto-Detect"). | High |
| `SST` | SubtitleStyle | Controls for font face, outline thickness, and background opacity. | Med |
| `WCF` | WordConfidence | Visual highlight (color coding) of words with low transcription certainty. | Low |
| `KWD` | KeywordSpotter | List input for specific words to trigger events (e.g., "Hey Computer"). | Med |
| `DIA` | DiarizationToggle | Switch to enable/disable Speaker A vs. Speaker B detection. | Low |

---

## Database & Data Export

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `DBC` | DBConnectionStatus | Indicator for SQL/NoSQL server reachability + Latency. | Med |
| `QRY` | QueryBuilderUI | Visual blocks to construct SQL queries (Select X from Y where Z). | Med |
| `TBL` | DataTableView | Spreadsheet-like view of database rows with sorting headers. | High |
| `SCH` | SchemaMapper | UI to draw lines linking Node inputs to Database columns. | Med |
| `CAC` | CacheClearBtn | Button to purge local temp files or Redis cache. | High |
| `EPT` | ExportFormatSel | Dropdown to choose output (CSV, JSON, XML, Parquet). | High |

---

## Optimization & System

| Code | Widget Name | Function/Role | Reusability |
|:----:|:------------|:--------------|:-----------:|
| `REC` | RecommendedSettings | "Magic Wand" button that auto-configures the node based on hardware. | High |
| `OPT` | OptimizeToggle | Switch to trade quality for performance (e.g., "Low Latency Mode"). | High |
| `HRD` | HardwareAccelSel | Dropdown to force CUDA, OpenCL, Metal, or CPU processing. | High |
| `RST` | FactoryReset | "Red Button" to revert all parameters to default. | High |
| `WIZ` | SetupWizardStep | A single slide of a multi-step guided configuration. | Med |
| `ERR` | AutoFixButton | Button that appears only when an error is detected to attempt a repair. | Med |

---

**Total Widget Types**: 239  
**Categories**: 28 functional groups

---

## Notes

- **Reusability**: Very High = Used across all node types, High = Used in multiple contexts, Med = Domain-specific, Low = Single-node specialized
- **Consolidation**: Generic variants (*SettingsWidget, *SourceSelectorWidget) use base codes (SET, SEL)
- **Specialized**: Unique functionality gets dedicated codes (GradientEditor, NoiseParameters)
