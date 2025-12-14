import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFileStereoscopicSourceSelectorWidget - 3D stereoscopic video file picker
// Ultra-specific name: video + file + stereoscopic + source + selector + widget
// Used by: VideoFileStereoscopic variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fileName: ""
    property string stereoLayout: "sbs"  // "sbs" (side-by-side) or "tb" (top-bottom)
    property bool eyeSwap: false
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 95
    
    FileDialog {
        id: fileDialog
        title: "Select 3D Stereoscopic Video"
        nameFilters: ["3D Video (*.mp4 *.mkv *.sbs *.tab)", "All files (*)"]
        
        onAccepted: {
            selectedFile = fileDialog.selectedFile.toString()
            fileName = selectedFile.split('/').pop().split('\\').pop()
            // Auto-detect layout from filename
            if (fileName.toLowerCase().includes("sbs")) stereoLayout = "sbs"
            else if (fileName.toLowerCase().includes("tab") || fileName.toLowerCase().includes("tb")) stereoLayout = "tb"
            fileSelected(selectedFile)
        }
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Row {
            width: parent.width
            spacing: 8
            
            Text {
                text: "3D Stereoscopic Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: fileName !== ""
                width: 30
                height: 16
                color: "#E91E63"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "3D"
                    color: "white"
                    font.pixelSize: 9
                    font.bold: true
                }
            }
            
            Rectangle {
                visible: fileName !== ""
                width: 35
                height: 16
                color: "#9C27B0"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: stereoLayout.toUpperCase()
                    color: "white"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Column {
                width: parent.width - 80
                spacing: 3
                
                Text {
                    width: parent.width
                    text: fileName || "No 3D video selected"
                    color: fileName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: fileName !== ""
                    elide: Text.ElideMiddle
                }
                
                Text {
                    visible: fileName !== ""
                    text: (stereoLayout === "sbs" ? "Side-by-Side" : "Top-Bottom") + (eyeSwap ? " (Eyes Swapped)" : "")
                    color: eyeSwap ? "#FF9800" : "#888888"
                    font.pixelSize: 10
                }
            }
            
            Button {
                width: 65
                height: 40
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#EC407A" : "#E91E63"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: fileDialog.open()
            }
        }
    }
}
