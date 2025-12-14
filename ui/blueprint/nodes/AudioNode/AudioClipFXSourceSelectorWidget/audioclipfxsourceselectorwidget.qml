import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

// AudioClipFXSourceSelectorWidget - Sound effects library browser
// Ultra-specific name: audio + clip + fx + source + selector + widget
// Used by: AudioClipFX variant

Rectangle {
    id: root
    
    property string selectedFile: ""
    property string fxName: ""
    property string category: ""
    property int duration: 0  // milliseconds
    
    signal fileSelected(string filePath)
    
    color: "#2D2D2D"
    border.color: "#505050"
    border.width: 1
    radius: 5
    implicitHeight: 80
    
    FileDialog {
        id: fxFileDialog
        title: "Select Sound Effect"
        nameFilters: ["Audio files (*.wav *.mp3 *.ogg *.m4a)", "All files (*)"]
        onAccepted: {
            selectedFile = fxFileDialog.selectedFile.toString()
            fxName = selectedFile.split('/').pop().split('\\').pop()
            fileSelected(selectedFile)
        }
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Row {
            width: parent.width
            spacing: 10
            
            Text {
                text: "Sound Effect"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: category ? "🔊 " + category : ""
                color: "#00BCD4"
                font.pixelSize: 10
            }
            
            Text {
                text: duration > 0 ? (duration / 1000).toFixed(1) + "s" : ""
                color: "#757575"
                font.pixelSize: 10
            }
        }
        
        Row {
            width: parent.width
            spacing: 10
            
            Rectangle {
                width: parent.width - 80
                height: 35
                color: "#1A1A1A"
                border.color: "#404040"
                border.width: 1
                radius: 3
                
                Text {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: fxName || "No sound effect selected"
                    color: fxName ? "#FFFFFF" : "#777777"
                    font.pixelSize: 11
                    elide: Text.ElideMiddle
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                width: 65
                height: 35
                text: "Browse..."
                
                background: Rectangle {
                    color: parent.hovered ? "#00ACC1" : "#00838F"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: fxFileDialog.open()
            }
        }
    }
}
