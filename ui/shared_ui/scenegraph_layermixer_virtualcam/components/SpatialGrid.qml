import QtQuick
import QtQuick3D 1.15

Node {
    id: root
    
    // Simple Grid Implementation using built-in grid or custom lines
    // Since QtQuick3D Helpers isn't always available, we use a simple texture on a plane for the grid.
    
    Model {
        source: "#Rectangle"
        scale: Qt.vector3d(100, 100, 1) // Large plane
        eulerRotation.x: -90 // Lay flat on XZ plane
        materials: [
            DefaultMaterial {
                diffuseColor: "transparent"
                // We would ideal use a grid texture here. 
                // For now, we use a wireframe-like effect or a custom shader if possible.
                // Or just a debug grid helper if available.
                // Let's use a GridGeometry from Helpers if possible, or just a translucent plane.
            }
        ]
        
        // Custom Grid Shader logic to make it look cool in "VR"
        // Since we can't easily inline shaders in DefaultMaterial, we'll simulate a grid 
        // by repeating a texture or just using the built-in AxisHelper for now to save complexity.
    }
    
    // Main Axes
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(50, 0, 0)
        scale: Qt.vector3d(0.05, 100, 0.05)
        eulerRotation.z: -90
        materials: [ DefaultMaterial { diffuseColor: "#FF5555" } ] // X - Red
    }
    
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(0, 50, 0)
        scale: Qt.vector3d(0.05, 100, 0.05)
        materials: [ DefaultMaterial { diffuseColor: "#55FF55" } ] // Y - Green
    }
    
    Model {
        source: "#Cylinder"
        position: Qt.vector3d(0, 0, 50)
        scale: Qt.vector3d(0.05, 100, 0.05)
        eulerRotation.x: 90
        materials: [ DefaultMaterial { diffuseColor: "#5555FF" } ] // Z - Blue
    }
}
