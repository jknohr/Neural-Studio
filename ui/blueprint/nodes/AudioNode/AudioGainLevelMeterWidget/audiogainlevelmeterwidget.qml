import QtQuick
import QtQuick.Controls

// AudioGainLevelMeterWidget - VU meter for visual level monitoring
// Ultra-specific name: audio + gain + level + meter + widget
// Used by: ALL audio variants for quick level check

Rectangle {
    id: root
    
    // Properties from audio source
    property real leftLevel: 0.0   // 0.0 to 1.0 (linear)
    property real rightLevel: 0.0  // 0.0 to 1.0
    property bool stereo: true
    property bool showPeakHold: true
    property real clipThreshold: 0.95
    
    // Internal state
    property real leftPeak: 0.0
    property real rightPeak: 0.0
    
    color: "transparent"
    width: stereo ? 60 : 35
    implicitWidth: width
    implicitHeight: 150
    
    Row {
        anchors.fill: parent
        spacing: 5
        
        // Left/Mono channel
        Rectangle {
            width: (parent.width - (stereo ? 5 : 0)) / (stereo ? 2 : 1)
            height: parent.height
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 3
            
            // Level fill
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 4
                height: (parent.height - 4) * leftLevel
                radius: 2
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#4CAF50" }
                    GradientStop { position: 0.7; color: "#FFEB3B" }
                    GradientStop { position: 0.9; color: "#FF9800" }
                    GradientStop { position: 1.0; color: "#F44336" }
                }
                
                Behavior on height {
                    NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
                }
            }
            
            // Peak hold
            Rectangle {
                visible: showPeakHold && leftPeak > 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - 4) * leftPeak
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 4
                height: 2
                color: leftPeak > clipThreshold ? "#FF0000" : "#00E676"
            }
        }
        
        // Right channel
        Rectangle {
            visible: stereo
            width: (parent.width - 5) / 2
            height: parent.height
            color: "#1A1A1A"
            border.color: "#404040"
            border.width: 1
            radius: 3
            
            // Level fill
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 4
                height: (parent.height - 4) * rightLevel
                radius: 2
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#4CAF50" }
                    GradientStop { position: 0.7; color: "#FFEB3B" }
                    GradientStop { position: 0.9; color: "#FF9800" }
                    GradientStop { position: 1.0; color: "#F44336" }
                }
                
                Behavior on height {
                    NumberAnimation { duration: 50; easing.type: Easing.OutQuad }
                }
            }
            
            // Peak hold
            Rectangle {
                visible: showPeakHold && rightPeak > 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: (parent.height - 4) * rightPeak
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 4
                height: 2
                color: rightPeak > clipThreshold ? "#FF0000" : "#00E676"
            }
        }
    }
    
    // Peak hold decay timer
    Timer {
        interval: 50
        running: true
        repeat: true
        
        onTriggered: {
            if (leftLevel > leftPeak) {
                leftPeak = leftLevel
                peakHoldTimer.restart()
            }
            if (rightLevel > rightPeak) {
                rightPeak = rightLevel
                peakHoldTimer.restart()
            }
        }
    }
    
    Timer {
        id: peakHoldTimer
        interval: 2000
        onTriggered: {
            leftPeak = 0
            rightPeak = 0
        }
    }
}
