# NODE TYPES

---

### 🗃️ Refined Node Type Entities (Cross-Media Functional Roles)

Here is the updated table incorporating these more universal "Structural" and "Transmissive" categories:

|  Code  |        Type        |   Ethnicity        | Rank |    Role/Justification                                               |
|:------:|:------------------:|:------------------:|:----:|:-------------------------------------------------------------------:|
|   `AN` |    AudioNode       | **Source**         |   4  |  Provides initial data (audio input).                               |
|   `CA` |    CameraNode      | **Source**         |   4  |  Defines the view/initial scene input.                              |
|   `EF` |    EffectNode      | **Postprocessing** |  70  |  Applies final adjustments/effects (universal concept).             |
|   `FO` |    FontNode        | **Data**           |   0  |  Holds raw data (universal asset info).                             |
|   `MN` |    MonitorNode     | **Debug**          |  10  |  Used for viewing/debugging data flow (universal concept).          |
|   `GR` |    GraphicNode     | **Structural**     |   6  |  Loads Images, SVG, 2d Animations.                                  |
|   `TP` |    TransportNode   | **Transport**      | 100  |  TransportProtocolNode                                              |
|   `LN` |    LLMNode         | **Prompt**         | 100  |  Content generation/instruction (universal high-precedence).        |
|   `ML` |    MLNODE          | **Analysis**       |  80  |  Complex data analysis/processing (universal high-precedence).      |
|   `GN` |    GROUPNODE       | **Grouping**       |   3  |  Used for organizational structure (universal).                     |
|   `SQ` |    SEQUENCERNODE   | **Sequencer**      |   2  |  Defines order/timing of events (universal control).                |
|   `AP` |    APINODE         | **API**            |   2  |  External communication/data (universal source/sink).               |
|   `SC` |    ScriptNode      | **Control**        |  11  |  Directs or influences the flow based on logic (universal).         |
|   `AM` |    AnimationNode   | **Control**        |  11  |  Controls changes over time/motion (universal concept).             |
|   `DN` |    DimensionalNode | **Structural**     |   6  |  Defines spatial/physical **structure** (3D/Spatial Audio).         |
|   `SH` |    ShaderNode      | **Transmissive**   |  60  |  Logic for rendering/appearance (the *transmission* of light/sound).|
|   `TX` |    TextureNode     | **Data**           |   0  |  Holds raw data (universal asset info).                             |
|   `ST` |    StichNode       | **Grouping**       |   3  |  Combines inputs structurally (universal organization).             |
|   `EN` |    EncoderNode     | **Transmissive**   |  60  |  Converts data for storage/output (*transmission* format).          |
|   `DE` |    DecoderNode     | **Transmissive**   |  60  |  Converts back from *transmission* format.                          |
|   `OD` |    OutputDockNode  | **Dock**           | 200  |  The final sink for the pipeline data (universal endpoint).         |
|   `TM` |    TemporalNode    | **Control**        |  11  |  Manages time-based aspects (universal concept).                    |
|   `SP` |    SplitterNode    | **Supportive**     |   5  |  Utility node to duplicate or divide the stream (universal flow).   |
|   `CS` |    CSPNODE         | **Hardware**       |   1  |  Low-level computation/system layer (universal low-level link).     |
|   `FI` |    FilterNode      | **Postprocessing** |  70  |  Applies targeted adjustments to processed data (universal).        |
|   `TR` |    TriggerNode     | **Trigger**        |   9  |  Initiates an action based on a condition (universal event).        |
|   `AU` |    AuthNode        | **Authentication** |   4  |  Provides initial data (audio input).                               |
|   `OC` |    OutputChatNode  | **Chat**           |  10  |  ReactiveNode based on chat interactions                            |
|   `AC` |    AgentChatNode   | **Chat**           |  10  |  ReactiveNode based on chat interactions                            |
|   `RN` |    RecordingNode   | **Recording**      |  11  |  Records data (universal).                                          |
|   `RE` |    ReplayNode      | **Replay**         |  11  |  Replays data (universal).                                          |