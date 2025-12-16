# UIELEMENT TYPES

---

### ⚛️ Atomic UI Component Types (Primitive Building Blocks)

**Philosophy:** All 239 Widget types are composed from these atomic UIElements.

**Example:** `VolumeControl (Widget)` = `SLD (Slider)` + `BTN (ToggleButton)` + `MTR (Meter)`

---

## Input Controls

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `BTN` | PushButton | Click-to-trigger action button | Play, Stop, Export |
| `TGL` | ToggleButton | On/off state button | Mute, Solo, Loop |
| `CHK` | Checkbox | Boolean selection | Enable feature |
| `RAD` | RadioButton | Single selection from group | Quality: Low/Med/High |
| `SLD` | LinearSlider | Horizontal/vertical drag bar | Volume, Opacity |
| `KNB` | RotaryKnob | Circular dial control | Gain, Pan, Frequency |
| `RNG` | RangeSlider | Dual-handle min/max selector | Trim start/end |
| `XYP` | XYPad | 2D coordinate controller | Vector position |
| `JOY` | Joystick | Radial 2D input | Camera control |

---

## Text Input

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `TXT` | TextInput | Single-line text field | Filename, URL |
| `NUM` | NumericInput | Number field with steppers | Frame count, BPM |
| `TXA` | TextArea | Multi-line text editor | Prompt, description |
| `CDE` | CodeEditor | Syntax-highlighted code | Script, shader |
| `MSK` | MaskedInput | Formatted input (phone, date) | API key, timecode |
| `SRC` | SearchBox | Text input with search icon | File search, filter |

---

## Selection Controls

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `DRP` | Dropdown | Single-select menu | Format, preset |
| `CMB` | Combobox | Editable dropdown | Font with custom |
| `MSL` | MultiSelect | Checkbox dropdown | Tags, categories |
| `LST` | ListBox | Scrollable selection list | Files, layers |
| `TBL` | TableView | Row/column data grid | Database records |
| `TRE` | TreeView | Hierarchical list | Folder structure |
| `GRD` | GridView | Thumbnail grid | Asset browser |

---

## Display Elements

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `LBL` | Label | Static text display | "Volume:", headings |
| `NDI` | NumericDisplay | Read-only number | FPS counter, latency |
| `PRG` | ProgressBar | Completion percentage | Upload, render |
| `MTR` | Meter | Level indicator | Audio VU, GPU usage |
| `SPN` | Spinner | Loading animation | Processing state |
| `ICN` | Icon | Graphical symbol | Status, type indicator |
| `IMG` | ImageDisplay | Static image preview | Thumbnail, logo |
| `CLR` | ColorSwatch | Color preview box | Current color |

---

## Interactive Graphics

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `CVS` | Canvas | Freeform drawing surface | Mask painting, sketch |
| `VPT` | Viewport | 3D/2D render preview | Scene view, texture |
| `GRF` | GraphWidget | Line/bar chart | Waveform, histogram |
| `CRV` | CurveEditor | Bezier curve control | Easing, color ramp |
| `COL` | ColorPicker | HSLA color selector | Tint, background |
| `GRD` | GradientEditor | Multi-stop color ramp | Color grading |

---

## Containers & Layout

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `PNL` | Panel | Bordered container | Settings group |
| `TAB` | TabBar | Switchable views | Settings/Logs/Info |
| `ACC` | Accordion | Collapsible sections | Property groups |
| `SCR` | ScrollArea | Overflow scrolling | Long lists |
| `SPL` | Splitter | Resizable divider | Left/right panels |
| `STK` | Stack | Layered views | Wizard steps |
| `FRM` | Frame | Decorative border | Highlighted section |

---

## Navigation

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `BRD` | Breadcrumb | Path navigator | File/folder trail |
| `PAG` | Pagination | Page controls | Next/Prev/Count |
| `MNU` | MenuBar | Top-level menu | File/Edit/View |
| `CTX` | ContextMenu | Right-click menu | Actions |
| `TLB` | Toolbar | Icon button row | Common actions |
| `SDB` | Sidebar | Side panel | Navigation tree |

---

## Feedback & Notification

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `TTP` | Tooltip | Hover info popup | Help text |
| `NTF` | Notification | Toast message | Success/error alert |
| `MOD` | Modal | Blocking dialog | Confirmation |
| `DRW` | Drawer | Slide-in panel | Properties |
| `BDG` | Badge | Count indicator | Unread, errors |
| `ALT` | Alert | Inline warning | Validation error |

---

## Specialized Input

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `FLP` | FilePicker | File browser dialog | Select video file |
| `DTP` | DatePicker | Calendar selector | Schedule |
| `TMP` | TimePicker | Hour/minute selector | Timecode |
| `RAT` | RatingStars | 1-5 star selector | Quality rating |
| `SEG` | SegmentedControl | Horizontal pill selector | View mode |
| `SWC` | Switch | iOS-style toggle | On/off |

---

## Timeline & Animation

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `TML` | Timeline | Scrubber with markers | Video editing |
| `KEY` | KeyframeTrack | Animated property track | Position over time |
| `RUL` | Ruler | Measurement scale | Pixels, seconds |
| `PLH` | Playhead | Current time indicator | Frame position |
| `ZOM` | ZoomControl | Timeline zoom slider | Detail level |

---

## Data Visualization

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `LIN` | LineChart | Time-series plot | CPU usage |
| `BAR` | BarChart | Categorical comparison | Frequency bands |
| `PIE` | PieChart | Proportion display | Storage usage |
| `SCT` | ScatterPlot | X/Y data points | Embedding space |
| `HMP` | Heatmap | 2D intensity grid | Spectrogram |
| `TRE` | TreeMap | Hierarchical boxes | File sizes |

---

## 3D Controls

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `GIZ` | TransformGizmo | 3D move/rotate/scale handles | Object manipulation |
| `ORB` | OrbitControl | Camera orbit interaction | Scene navigation |
| `VEC` | VectorInput | X/Y/Z numeric inputs | Position, rotation |
| `QUA` | QuaternionEditor | Rotation input (advanced) | Precise rotation |

---

## Terminal & Code

| Code | UIElement Type | Description | Example Usage |
|:----:|:---------------|:------------|:--------------|
| `TRM` | Terminal | Shell emulator | Command execution |
| `LOG` | LogViewer | Scrolling text output | Error messages |
| `SYN` | SyntaxHighlighter | Code coloring | Shader, script |
| `ACM` | Autocomplete | Suggestion dropdown | Code completion |

---

**Total Atomic UIElement Types**: 80  
**Categories**: 15 functional groups

---

## Composition Examples

### VolumeControl Widget (W-VOL)
```
Components:
- SLD (LinearSlider) - volume level
- BTN (ToggleButton) - mute
- MTR (Meter) - level display
```

### ColorGradingWheels Widget (W-GRD)
```
Components:
- 3x COL (ColorPicker) - Lift, Gamma, Gain
- 3x LBL (Label) - wheel labels
- BTN (PushButton) - reset
```

### KeyframeEditor Widget (W-KFR)
```
Components:
- TML (Timeline) - time axis
- KEY (KeyframeTrack) - animation curve
- CRV (CurveEditor) - interpolation
- BTN (PushButton) - add/delete keys
```

### SettingsPanel Widget (W-SET)
```
Components:
- ACC (Accordion) - collapsible sections
- SLD (Slider) - numeric parameters
- DRP (Dropdown) - enum options
- CHK (Checkbox) - boolean flags
- BTN (PushButton) - apply/reset
```

---

## Benefits of Atomic Design

✅ **Reusability** - 80 primitives → 239+ widgets  
✅ **Consistency** - Same slider everywhere  
✅ **Maintainability** - Fix slider once, all widgets inherit  
✅ **Composability** - Mix primitives for new widgets  
✅ **Theme-ability** - Style primitives, propagates to all widgets  
✅ **Accessibility** - Implement once at primitive level  
✅ **Testing** - Test 80 primitives vs 3000+ widgets  

---

## Widget Composition Format

```json
{
  "widgetId": "WVOL-uuid",
  "widgetType": "VolumeControl",
  "components": [
    {"type": "SLD", "props": {"min": 0, "max": 1, "value": 0.8}},
    {"type": "BTN", "props": {"toggle": true, "icon": "mute"}},
    {"type": "MTR", "props": {"channels": 2, "peak": true}}
  ]
}
```

---

**Version:** 1.0  
**Last Updated:** 2025-12-15
