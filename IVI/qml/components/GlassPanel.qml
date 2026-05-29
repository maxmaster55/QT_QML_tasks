import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: panelRoot
    radius: 24 
    
    Behavior on opacity { NumberAnimation { duration: 250 } }

    // Modern Deep Automotive Slate Background
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#16192b" 
        }
        GradientStop {
            position: 1.0
            color: "#0b0d16" 
        }
    }

    // Outer subtle structural bounding line
    border.width: 1
    border.color: "#22263f"

    // ── Specular Inner Rim (Fixed property from fillColor to color) ──
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: parent.radius - 1
        color: "transparent" // <-- Fixed here!
        border.width: 1
        
        // Light-bleed highlight line along the top rim
        border.color: Qt.rgba(1.0, 1.0, 1.0, 0.08) 
    }

    // ── Ambient Background Glow Layer ──
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        opacity: 0.15
        
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#4f8cff" } 
            GradientStop { position: 0.5; color: "transparent" }
        }
    }
}