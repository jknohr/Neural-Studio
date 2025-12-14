import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// VideoFilePointCloudSourceSelectorWidget - Volumetric point cloud video file picker
// Ultra-specific name: video + file + pointcloud + source + selector + widget
// Used by: VideoFilePointCloud variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fileName: ""
    property string format: "PLY"
    property int pointCount: 0
    property bool hasColor: false
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 100
    
    FileDialog {
        id: fileDialog
        title: "Select Point Cloud Video"
        nameFilters: ["Point Cloud (*.ply *.e57 *.las *.pcd *.pts)", "All files (*)"]
        
        onAccepted: {
            selectedFile = fileDialog.selectedFile.toString()
            fileName = selectedFile.split('/').pop().split('\\').pop()
            var ext = fileName.split('.').pop().toUpperCase()
            format = ext
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
                text: "Point Cloud Source"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Rectangle {
                visible: fileName !== ""
                width: 35
                height: 16
                color: "#00E676"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "6DOF"
                    color: "black"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
            
            Rectangle {
                visible: hasColor
                width: 45
                height: 16
                color: "#FF6F00"
                radius: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "COLOR"
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
                spacing: 4
                
                Text {
                    width: parent.width
                    text: fileName || "No point cloud selected"
                    color: fileName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 12
                    font.bold: fileName !== ""
                    elide: Text.ElideMiddle
                }
                
                Row {
                    spacing: 12
                    visible: fileName !== ""
                    
                    Text {
                        text: format
                        color: "#4CAF50"
                        font.pixelSize: 10
                        font.bold: true
                    }
                    
                    Text {
                        visible: pointCount > 0
                        text: (pointCount / 1000000).toFixed(1) + "M points"
                        color: "#888888"
                        font.pixelSize: 10
                    }
                }
            }
            
            Button {
                width: 65
                height: 50
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#00E5FF" : "#00BCD4"
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
        
        Text {
            visible: pointCount > 10000000
            text: "⚠ Large point cloud may impact performance"
            color: "#FF9800"
            font.pixelSize: 9
        }
    }
}
