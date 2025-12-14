import QtQuick
import QtQuick.Controls

// VideoChapterNavigatorWidget - Chapter navigation for tutorial videos
// Ultra-specific name: video + chapter + navigator + widget

Rectangle {
    id: root
    
    property var chapters: []
    property int currentChapter: 0
    
    signal jumpToChapter(int index)
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 140
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 6
        
        Text {
            text: "Chapters"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        ScrollView {
            width: parent.width
            height: 110
            clip: true
            
            ListView {
                model: chapters
                spacing: 3
                
                delegate: Rectangle {
                    width: parent ? parent.width : 0
                    height: 30
                    color: {
                        if (index === currentChapter) return "#2196F3"
                        if (mouseArea.containsMouse) return "#3A3A3A"
                        return "#2D2D2D"
                    }
                    radius: 3
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 10
                        
                        Rectangle {
                            width: 20
                            height: 20
                            color: index === currentChapter ? "#FFFFFF" : "#FF6F00"
                            radius: 2
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                color: index === currentChapter ? "#2196F3" : "white"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                        
                        Column {
                            spacing: 2
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: modelData.title || "Chapter " + (index + 1)
                                color: "# FFFFFF"
                                font.pixelSize: 11
                                font.bold: index === currentChapter
                            }
                            
                            Text {
                                visible: modelData.time !== undefined
                                text: formatTime(modelData.time)
                                color: "#888888"
                                font.pixelSize: 9
                            }
                        }
                    }
                    
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: jumpToChapter(index)
                    }
                }
            }
        }
    }
    
    function formatTime(seconds) {
        var m = Math.floor(seconds / 60)
        var s = Math.floor(seconds % 60)
        return m + ":" + s.toString().padStart(2, '0')
    }
}
