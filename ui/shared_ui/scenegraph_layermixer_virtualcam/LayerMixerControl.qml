import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../theme"

Rectangle {
    id: root
    color: "#222222"
    
    // Model bound to controller.layers
    property var layerModel: [] // List of objects
    signal opacityChanged(string id, real value)
    signal visibilityToggled(string id)
    
    // Helper to filter model by type category
    function getModelForCategory(categoryStr) {
        var filtered = []
        for(var i=0; i<layerModel.length; i++) {
            var t = layerModel[i].type
            // Map types (1=Video, 2=Audio, etc.) to categories
            // Categories: "VIDEO" (1,5,9), "AUDIO" (2), "3D" (3,4), "LOGIC" (6,7,8)
            if (categoryStr === "VIDEO" && (t===1 || t===5 || t===9)) filtered.push(layerModel[i])
            else if (categoryStr === "AUDIO" && (t===2)) filtered.push(layerModel[i])
            else if (categoryStr === "3D" && (t===3 || t===4)) filtered.push(layerModel[i])
            else if (categoryStr === "LOGIC" && (t>=6 && t<=8)) filtered.push(layerModel[i])
        }
        return filtered
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        Text {
            text: "MIXER CONSOLE"
            color: "#888888"
            font.bold: true
            font.pixelSize: 10
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            RowLayout {
                spacing: 20 // Space between groups
                
                // Group 1: VIDEO / GFX
                MixerGroup {
                    groupTitle: "VIDEO / GFX"
                    groupModel: root.getModelForCategory("VIDEO")
                    onOpacityChanged: root.opacityChanged(id, value)
                    onVisibilityToggled: root.visibilityToggled(id)
                }

                // Group 2: 3D / CAMS
                MixerGroup {
                    groupTitle: "SCENE / 3D"
                    groupModel: root.getModelForCategory("3D")
                    onOpacityChanged: root.opacityChanged(id, value)
                    onVisibilityToggled: root.visibilityToggled(id)
                }

                // Group 3: AUDIO
                MixerGroup {
                    groupTitle: "AUDIO"
                    groupModel: root.getModelForCategory("AUDIO")
                    onOpacityChanged: root.opacityChanged(id, value)
                    onVisibilityToggled: root.visibilityToggled(id)
                }
                
                // Group 4: LOGIC
                MixerGroup {
                    groupTitle: "AI / LOGIC"
                    groupModel: root.getModelForCategory("LOGIC")
                    onOpacityChanged: root.opacityChanged(id, value)
                    onVisibilityToggled: root.visibilityToggled(id)
                }
            }
        }
    }
    
    // Inline Component for Mixer Group
    component MixerGroup : ColumnLayout {
        property string groupTitle: ""
        property var groupModel: []
        signal opacityChanged(string id, real value)
        signal visibilityToggled(string id)
        
        spacing: 5
        
        // Group Header
        Rectangle {
            Layout.fillWidth: true
            height: 20
            color: "#333"
            visible: groupModel.length > 0
            Text { anchors.centerIn: parent; text: groupTitle; color: "#aaa"; font.pixelSize: 9 }
        }
        
        RowLayout {
            spacing: 2
            visible: groupModel.length > 0
            
            Repeater {
                model: groupModel
                delegate: Rectangle {
                    // Start Channel Strip
                    width: 60
                    height: 150 // fixed height for aligned faders
                    color: "#2a2a2a"
                    radius: 4
                    
                    property var layerData: modelData
                    
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 4; spacing: 4
                        
                        // Mute
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 40; height: 18
                            color: layerData.visible ? "#4CAF50" : "#F44336"
                            radius: 2
                            Text { anchors.centerIn: parent; text: "ON"; font.pixelSize: 8; color: "white" }
                            MouseArea { anchors.fill: parent; onClicked: visibilityToggled(layerData.id) }
                        }
                        
                        // Fader
                        Rectangle {
                            Layout.fillHeight: true; width: 6; color: "#111"; radius: 3
                            Layout.alignment: Qt.AlignHCenter
                            Rectangle {
                                width: 20; height: 10; color: "#ccc"; radius: 2
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height * (1.0 - layerData.opacity) - 5
                                MouseArea {
                                    anchors.fill: parent; drag.target: parent; drag.axis: Drag.YAxis
                                    drag.minimumY: -5; drag.maximumY: parent.parent.height - 5
                                    onPositionChanged: {
                                        var val = 1.0 - (parent.y + 5) / parent.parent.height
                                        opacityChanged(layerData.id, Math.max(0, Math.min(1, val)))
                                    }
                                }
                            }
                        }
                        
                        // Name
                        Text {
                            Layout.maximumWidth: parent.width
                            text: layerData.name
                            color: "white"; font.pixelSize: 8
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
