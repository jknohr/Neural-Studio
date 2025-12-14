import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NeuralStudio.UI 1.0
import "../../" // For BaseNode.qml

BaseNode {
    id: root
    title: "Camera Source"
    headerColor: "#E74C3C" // Red for Live Inputs

    // Instantiate specific controller
    CameraNodeController {
        id: nodeController
    }

    // Bind BaseNode controller property
    controller: nodeController

    // Content
    ColumnLayout {
        spacing: 5
        
        Label {
            text: "Device ID:"
            color: "#bdc3c7"
            font.pixelSize: 10
        }

        Label {
            text: nodeController.deviceId !== "" ? nodeController.deviceId : "No Device Selected"
            color: "white"
            font.bold: true
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
