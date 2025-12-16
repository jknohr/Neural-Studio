# PIPELINE TYPES

---

### 🗃️ Pipeline Type Entities (Media adjustments before Scene Rendering Pipelines)

Here is the updated table incorporating these more universal "Structural" and "Transmissive" categories:

|  Pipeline  |        Type                  |   Ethnicity        | Rank |    Role/Justification                                               |
|:----------:|:----------------------------:|:------------------:|:----:|:-------------------------------------------------------------------:|
|   `ZA`     |    AudioPipeline             | **MetaData**       |  11  |  Records data (universal).                                          |
|   `RP`     |    VisualPipeline            | **MetaData**       |  11  |  Replays data (universal).                                          |
|   `PR`     |    RenderPipeline            | **Preprocessing**  |   1  |  PreprocessingPipeline                                              |
|   `AN`     |    3DObjectPipeline          | **Source**         |   4  |  Provides initial data (audio input).                               |
|   `AM`     |    AnimationPipeline         | **Animation**      |   4  |  Provides initial data (audio input).                               |
|   `CA`     |    CameraPipeline            | **Source**         |   4  |  Defines the view/initial scene input.                              |
|   `EF`     |    EffectPipeline            | **Effect**         |  70  |  Applies final adjustments/effects (universal concept).             |
|   `FO`     |    FontPipeline              | **Data**           |   0  |  Holds raw data (universal asset info).                             |
|   `MN`     |    MonitorPipeline           | **Debug**          |  10  |  Used for viewing Previewing Sources                                |
|   `GR`     |    GraphicPipeline           | **Source**         |   6  |  Loads Images, SVG, 2d Animations.                                  |
|   `TP`     |    TransportPipeline         | **Transport**      | 100  |  TransportProtocolPipeline                                          |
|   `TD`     |    TransportDataPipeline     | **Transport**      |  10  |  TransportDataPipeline                                              |
|   `LX`     |    LLMPipeline               | **Prompt**         | 100  |  Content generation/instruction/Evaluation (uh-precedence).         |
|   `ML`     |    MLPipeline                | **Analysis**       |  80  |  Complex data analysis/processing (uh-precedence).                  |
|   `SQ`     |    SEQUENCERPipeline         | **Sequencer**      |   2  |  Defines order/timing of events (universal control).                |
|   `AP`     |    APIPipeline               | **API**            |   2  |  External communication/data (universal source/sink).               |
|   `SC`     |    ScriptPipeline            | **Control**        |  11  |  Directs or influences the flow based on logic (universal).         |
|   `LI`     |    LightPipeline             | **Control**        |  11  |  Controls changes over time/motion (universal concept).             |
|   `DN`     |    TransformationPipeline    | **Structural**     |   6  |  Defines spatial/physical **structure** (3D/Spatial Audio).         |
|   `SH`     |    RenderingPipeline         | **Transmissive**   |  60  |  Logic for rendering/appearance (the *transmission* of light).      |
|   `TX`     |    TexturePipeline           | **Data**           |   0  |  Holds raw data (universal asset info).                             |
|   `ST`     |    StichPipeline             | **Grouping**       |   3  |  Combines inputs structurally (universal organization).             |
|   `EN`     |    EncoderPipeline           | **Transmissive**   |  60  |  Converts data for storage/output (*transmission* format).          |
|   `DE`     |    DecoderPipeline           | **Transmissive**   |  60  |  Converts back from *transmission* format.                          |
|   `OD`     |    OutputDockPipeline        | **Dock**           | 200  |  The final sink for the pipeline data (universal endpoint).         |
|   `TM`     |    TemporalPipeline          | **Control**        |  11  |  Manages time-based aspects (universal concept).                    |
|   `SP`     |    SplitterPipeline          | **Supportive**     |   5  |  Utility Pipeline to duplicate or divide the stream (universal flow)|
|   `CS`     |    CSPPipeline               | **Hardware**       |   1  |  Low-level computation/system layer (universal low-level link).     |
|   `FI`     |    FilterPipeline            | **Postprocessing** |  70  |  Applies targeted adjustments to processed data (universal).        |
|   `TR`     |    TriggerPipeline           | **Trigger**        |   9  |  Initiates an action based on a condition (universal event).        |
|   `AU`     |    AuthPipeline              | **Authentication** |   4  |  AuthenticationPipeline                                             |
|   `OC`     |    OutputChatPipeline        | **Chat**           |  10  |  ReactivePipeline based on chat interactions                        |
|   `AC`     |    AgentChatPipeline         | **Chat**           |  10  |  ReactivePipeline based on chat interactions                        |
|   `RE`     |    RecordingPipeline         | **Recording**      |  10  |  Records data (universal).                                          |
|   `RY`     |    ReplayPipeline            | **Replay**         |  10  |  Replays data (universal).                                          |
|   `SU`     |    SubtitlePipeline          | **Subtitle**       |  10  |  SubtitlePipeline (universal). and Translation to languages         |
|   `DU`     |    DubPipeline               | **Dubbing**        |  10  |  DubbingPipeline (universal). and Translation to languages          |
|   `SV`     |    StoragePipeline           | **Storage**        |  10  |  StoragePipeline (universal).                                       |
|   `PC`     |    PostConversionPipeline    | **Postprocessing** |  100 |  PostConversionPipeline (universal).                                |
|   `DI`     |    DataInjectionPipeline     | **Data**           |  200 |  DataInjectionPipeline for MetaData, SRT, WHIP, WEBTRANSPORT, RTMP  |
|   `DP`     |    DataProcessingPipeline    | **Data**           |  200 |  DataProcessingPipeline of                                          |
|   `CD`     |    CDNPipeline               | **CDN**            | 200  |  CDN Pipeline for streaming                                         |
|   `ES`     |    EndStreamPipeline         | **Service**        |  10  |  EndStreamPipeline (universal).                                     |
|   `PS`     |    PauseStreamPipeline       | **Service**        |  10  |  PauseStreamPipeline (universal).                                   |
|   `RS`     |    ResumeStreamPipeline      | **Service**        |  10  |  ResumeStreamPipeline (universal).                                  |
|   `SL`     |    StreamPreludePipeline     | **Service**        |  10  |  StreamPipeline (universal).                                        |
|   `TS`     |    TestServicesPipeline      | **Service**        |  100 |  TestServicesPipeline (universal).                                  |
|   `EM`     |    EmbeddingPipeline         | **Data**           |  200 |  EmbeddingPipeline                                                  |
|   `WV`     |    WebViewPipeline           | **Service**        |  10  |  WebBrowserPipeline (universal).                                    |
|   `AV`     |    AvatarPipeline            | **Service**        |  100 |  AvatarPipeline (universal).                                        |
                                          |







