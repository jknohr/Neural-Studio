import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// ControlsPanel - Main streaming/recording controls
DockPanel {
    id: controlsPanel
    
    title: "Controls"
    
    property bool isStreaming: false
    property bool isRecording: false
    property bool isVirtualCamActive: false
    
    signal toggleStream()
    signal toggleRecord()
    signal toggleVirtualCam()
    signal openSettings()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 4
        
        Button {
            Layout.fillWidth: true
            text: isStreaming ? "Stop Streaming" : "Start Streaming"
            highlighted: isStreaming
            
            onClicked: toggleStream()
        }
        
        Button {
            Layout.fillWidth: true
            text: isRecording ? "Stop Recording" : "Start Recording"
            highlighted: isRecording
            
            onClicked: toggleRecord()
        }
        
        Button {
            Layout.fillWidth: true
            text: isVirtualCamActive ? "Stop Virtual Camera" : "Start Virtual Camera"
            highlighted: isVirtualCamActive
            
            onClicked: toggleVirtualCam()
        }
        
        Item { Layout.fillHeight: true }
        
        Button {
            Layout.fillWidth: true
            text: "Settings"
            
            onClicked: openSettings()
        }
    }
}
