import QtQuick
import QtQuick.Controls

// ImageInfoWidget - Display image technical information
// Ultra-specific name: image + info + widget

Rectangle {
    id: root
    
    // Properties
    property int imageWidth: 0
    property int imageHeight: 0
    property int fileSizeBytes: 0
    property string colorFormat: "RGBA"
    property int bitDepth: 8
    property string colorSpace: "sRGB"
    property string fileFormat: "PNG"
    
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
            text: "Image Info"
            color: "#AAAAAA"
            font.pixelSize: 11
            font.bold: true
        }
        
        // Resolution
        Row {
            spacing: 10
            
            Text {
                text: "Resolution:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Text {
                text: imageWidth + " × " + imageHeight + " px"
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
            }
            
            Text {
                text: "(" + (imageWidth * imageHeight / 1000000).toFixed(1) + " MP)"
                color: "#888888"
                font.pixelSize: 9
                visible: imageWidth * imageHeight > 1000000
            }
        }
        
        // File size
        Row {
            spacing: 10
            
            Text {
                text: "File Size:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Text {
                text: formatFileSize(fileSizeBytes)
                color: "#FFFFFF"
                font.pixelSize: 11
                font.bold: true
            }
        }
        
        // Format
        Row {
            spacing: 10
            
            Text {
                text: "Format:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Rectangle {
                width: 45
                height: 18
                color: "#2196F3"
                radius: 2
                anchors.verticalCenter: parent.verticalCenter
                
                Text {
                    anchors.centerIn: parent
                    text: fileFormat
                    color: "white"
                    font.pixelSize: 9
                    font.bold: true
                }
            }
        }
        
        // Color format
        Row {
            spacing: 10
            
            Text {
                text: "Color:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Text {
                text: colorFormat + " @ " + bitDepth + "-bit"
                color: "#FFFFFF"
                font.pixelSize: 11
            }
        }
        
        // Color space
        Row {
            spacing: 10
            
            Text {
                text: "Color Space:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Text {
                text: colorSpace
                color: "#4CAF50"
                font.pixelSize: 11
            }
        }
        
        // Aspect ratio
        Row {
            spacing: 10
            
            Text {
                text: "Aspect Ratio:"
                color: "#888888"
                font.pixelSize: 10
                width: 80
            }
            
            Text {
                text: calculateAspectRatio()
                color: "#FFFFFF"
                font.pixelSize: 10
            }
        }
    }
    
    // Helper functions
    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + " B"
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB"
        if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(1) + " MB"
        return (bytes / 1024 / 1024 / 1024).toFixed(2) + " GB"
    }
    
    function calculateAspectRatio() {
        if (imageWidth === 0 || imageHeight === 0) return "N/A"
        
        var gcd = function(a, b) {
            return b === 0 ? a : gcd(b, a % b)
        }
        
        var divisor = gcd(imageWidth, imageHeight)
        var ratioW = imageWidth / divisor
        var ratioH = imageHeight / divisor
        
        // Check common ratios
        if (ratioW === 16 && ratioH === 9) return "16:9"
        if (ratioW === 4 && ratioH === 3) return "4:3"
        if (ratioW === 1 && ratioH === 1) return "1:1 (Square)"
        if (ratioW === 3 && ratioH === 2) return "3:2"
        if (ratioW === 21 && ratioH === 9) return "21:9 (Ultrawide)"
        
        return ratioW + ":" + ratioH
    }
}
