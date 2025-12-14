import QtQuick
import QtQuick.Controls

// NoiseParametersWidget - Configure procedural noise generation
// Ultra-specific name: noise + parameters + widget

Rectangle {
    id: root
    
    property string noiseType: "perlin"
    property real scale: 50.0
    property int octaves: 4
    property real persistence: 0.5
    property int seed: 0
    
    signal parametersChanged()
    
    color: "#252525"
    border.color: "#404040"
    border.width: 1
    radius: 5
    implicitHeight: 160
    
    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        Text {
            text: "Noise Parameters"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Type:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                width: 150
                model: ["Perlin", "Simplex", "Worley", "Voronoi"]
                currentIndex: 0
                
                onCurrentTextChanged: {
                    noiseType = currentText.toLowerCase()
                    parametersChanged()
                }
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Scale:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            Slider {
                width: 120
                from: 1
                to: 200
                value: scale
                onValueChanged: {
                    scale = value
                    parametersChanged()
                }
            }
            
            Text {
                text: scale.toFixed(1)
                color: "#FFFFFF"
                font.pixelSize: 10
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Octaves:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            SpinBox {
                width: 100
                from: 1
                to: 8
                value: octaves
                onValueChanged: {
                    octaves = value
                    parametersChanged()
                }
            }
        }
        
        Row {
            spacing: 10
            
            Text {
                text: "Seed:"
                color: "#CCCCCC"
                font.pixelSize: 10
                width: 60
            }
            
            SpinBox {
                width: 100
                from: 0
                to: 99999
                value: seed
                onValueChanged: {
                    seed = value
                    parametersChanged()
                }
            }
            
            Button {
                text: "Random"
                width: 70
                height: 30
                onClicked: {
                    seed = Math.floor(Math.random() * 100000)
                    parametersChanged()
                }
            }
        }
    }
}
