import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NeuralStudio.Blueprint 1.0

BaseManager {
    id: root
    
    title: "Audio Assets"
    description: "Browse and add audio files for music, sound effects, podcasts, and live streams"

    property AudioManagerController controller: null

    content: ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Header with actions and variant selector
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: controller ? `${controller.availableAudio.length} audio files` : "0 audio files"
                color: "#CCCCCC"
                font.pixelSize: 12
            }

            Item { Layout.fillWidth: true }
            
            // Variant selector for creating nodes
            ComboBox {
                id: variantSelector
                Layout.preferredWidth: 180
                model: [
                    {text: "Generic Audio", value: "audioclip"},
                    {text: "Music Track", value: "audioclipmusic"},
                    {text: "Podcast Episode", value: "audioclippodcast"},
                    {text: "Sound FX", value: "audioclipfx"},
                    {text: "Network Stream", value: "audiostream"},
                    {text: "Music Stream", value: "audiostreammusic"},
                    {text: "Podcast Stream", value: "audiostreampodcast"},
                    {text: "Voice/Mic Input", value: "audiostreamvoicecall"}
                ]
                textRole: "text"
                currentIndex: 0
                
                background: Rectangle {
                    color: parent.hovered ? "#3A3A3A" : "#2D2D2D"
                    border.color: "#555555"
                    border.width: 1
                    radius: 3
                }
                
                contentItem: Text {
                    text: variantSelector.displayText
                    color: "#FFFFFF"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 8
                }
            }
            
            // Create node button for stream/mic variants (no file needed)
            Button {
                text: "Add Variant Node"
                Layout.preferredWidth: 120
                visible: variantSelector.currentIndex >= 4  // Stream variants
                
                background: Rectangle {
                    color: parent.hovered ? "#43A047" : "#388E3C"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (controller) {
                        let variant = variantSelector.model[variantSelector.currentIndex].value
                        controller.createAudioNodeVariant(variant)
                    }
                }
            }

            Button {
                text: "Refresh"
                Layout.preferredWidth: 80
                
                background: Rectangle {
                    color: parent.hovered ? "#555555" : "#3A3A3A"
                    radius: 3
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (controller) {
                        controller.scanAudio()
                    }
                }
            }
        }

        // Audio files list
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: audioList
                anchors.fill: parent
                model: controller ? controller.availableAudio : []
                spacing: 5

                delegate: Rectangle {
                    width: audioList.width
                    height: 60
                    color: mouseArea.containsMouse ? "#2A2A2A" : "#1E1E1E"
                    radius: 4
                    border.color: modelData.inUse ? "#4CAF50" : "#444444"
                    border.width: modelData.inUse ? 2 : 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        // Icon with variant indicator
                        Rectangle {
                            width: 40
                            height: 40
                            color: {
                                let variant = modelData.suggestedVariant || "audioclip"
                                if (variant.includes("music")) return "#9C27B0"
                                if (variant.includes("podcast")) return "#FF6F00"
                                if (variant.includes("fx")) return "#00BCD4"
                                return modelData.quality === "Lossless" ? "#6BCF7F" : "#FFB84D"
                            }
                            radius: 6
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "♪"
                                    color: "white"
                                    font.pixelSize: 18
                                    font.bold: true
                                }
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: {
                                        let variant = modelData.suggestedVariant || "audioclip"
                                        if (variant.includes("music")) return "MUSIC"
                                        if (variant.includes("podcast")) return "PODCAST"
                                        if (variant.includes("fx")) return "FX"
                                        return "AUDIO"
                                    }
                                    color: "white"
                                    font.pixelSize: 6
                                }
                            }
                        }

                        // Audio info
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: modelData.name
                                color: "#FFFFFF"
                                font.pixelSize: 14
                                font.bold: modelData.inUse
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                spacing: 10
                                
                                Text {
                                    text: modelData.format
                                    color: "#888888"
                                    font.pixelSize: 10
                                }
                                
                                Text {
                                    text: modelData.quality
                                    color: modelData.quality === "Lossless" ? "#6BCF7F" : "#FFB84D"
                                    font.pixelSize: 10
                                }
                                
                                Text {
                                    text: (modelData.size / 1024 / 1024).toFixed(2) + " MB"
                                    color: "#888888"
                                    font.pixelSize: 10
                                }
                                
                                Text {
                                    visible: modelData.inUse
                                    text: "● In Use"
                                    color: "#4CAF50"
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }
                        }

                        // Add button (uses selected variant)
                        Button {
                            text: modelData.inUse ? "In Scene" : "Add"
                            enabled: !modelData.inUse && variantSelector.currentIndex < 4  // Only for file variants
                            Layout.preferredWidth: 70
                            
                            background: Rectangle {
                                color: parent.enabled ? (parent.hovered ? "#42A5F5" : "#2196F3") : "#555555"
                                radius: 3
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                if (controller) {
                                    let variant = variantSelector.model[variantSelector.currentIndex].value
                                    controller.createAudioNode(modelData.path, variant)
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                    }
                }
            }
        }

        // Empty state
        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: "No audio files found.\\nPlace .wav, .mp3, .ogg, .flac, or .m4a files in assets/audio"
            color: "#666666"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            visible: controller && controller.availableAudio.length === 0
        }
    }
}
