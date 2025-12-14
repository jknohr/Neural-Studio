import QtQuick
import QtQuick.Controls

// VideoStreamRecordingWidget - Stream recording controls with time and file size
// Ultra-specific name: video + stream + recording + widget
// Used by: All VideoStream variants

Rectangle {
    id: root
    
    // Properties
    property bool isRecording: false
    property int recordingDuration: 0  // seconds
    property int fileSize: 0  // bytes
    property string outputPath: ""
    
    // Signals
    signal startRecording()
    signal stopRecording()
    signal pauseRecording()
    
    color: "#252525"
    border.color: isRecording ? "#F44336" : "#404040"
    border.width: isRecording ? 2 : 1
    radius: 5
    implicitHeight: 80
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Row {
            width: parent.width
            spacing: 10
            
            // Record button
            Button {
                id: recordBtn
                width: 50
                height: 50
                
                background: Rectangle {
                    color: isRecording ? "#F44336" : (recordBtn.hovered ? "#E57373" : "#D32F2F")
                    radius: isRecording ? 8 : 25
                    border.color: "#FFFFFF"
                    border.width: 2
                    
                    Behavior on radius {
                        NumberAnimation { duration: 200 }
                    }
                    
                    // Pulsing animation when recording
                    SequentialAnimation on opacity {
                        running: isRecording
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.6; duration: 800 }
                        NumberAnimation { from: 0.6; to: 1.0; duration: 800 }
                    }
                }
                
                onClicked: {
                    if (isRecording) {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                }
            }
            
            // Recording info
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 3
                
                Text {
                    text: isRecording ? "● REC" : "Ready to Record"
                    color: isRecording ? "#F44336" : "#CCCCCC"
                    font.pixelSize: 14
                    font.bold: true
                }
                
                Text {
                    visible: isRecording
                    text: formatDuration(recordingDuration)
                    color: "#FFFFFF"
                    font.pixelSize: 12
                    font.family: "monospace"
                }
                
                Text {
                    visible: isRecording
                    text: formatFileSize(fileSize)
                    color: "#888888"
                    font.pixelSize: 10
                }
            }
        }
        
        // Output path (when not recording)
        Text {
            visible: !isRecording && outputPath !== ""
            width: parent.width
            text: "Save to: " + outputPath
            color: "#777777"
            font.pixelSize: 9
            elide: Text.ElideMiddle
        }
    }
    
    // Helper functions
    function formatDuration(seconds) {
        var h = Math.floor(seconds / 3600)
        var m = Math.floor((seconds % 3600) / 60)
        var s = seconds % 60
        
        if (h > 0) {
            return h.toString().padStart(2, '0') + ":" + 
                   m.toString().padStart(2, '0') + ":" + 
                   s.toString().padStart(2, '0')
        }
        return m.toString().padStart(2, '0') + ":" + 
               s.toString().padStart(2, '0')
    }
    
    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B"
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB"
        if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(1) + " MB"
        return (bytes / 1024 / 1024 / 1024).toFixed(2) + " GB"
    }
}
