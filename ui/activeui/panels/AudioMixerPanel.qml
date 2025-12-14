import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../app"
import "../monitors"

// AudioMixerPanel - OBS-style audio mixer with multiple channels
DockPanel {
    id: mixerPanel
    
    title: "Audio Mixer"
    
    // Audio channels from controller
    property var channelModel: [
        { name: "Desktop Audio", levelL: 0.7, levelR: 0.65, muted: false },
        { name: "Mic/Aux", levelL: 0.4, levelR: 0.35, muted: false }
    ]
    
    signal channelMuteToggled(int index)
    signal channelVolumeChanged(int index, real value)
    
    RowLayout {
        anchors.fill: parent
        spacing: 8
        
        Repeater {
            model: channelModel
            
            AudioMeterChannel {
                channelName: modelData.name
                levelL: modelData.levelL
                levelR: modelData.levelR
                isMuted: modelData.muted
                
                onMuteToggled: mixerPanel.channelMuteToggled(index)
                onVolumeChanged: (value) => mixerPanel.channelVolumeChanged(index, value)
            }
        }
        
        Item { Layout.fillWidth: true }
    }
    
    footerComponent: Component {
        RowLayout {
            spacing: 4
            
            ToolButton { 
                width: 24; height: 24
                MaterialIcon { anchors.centerIn: parent; icon: "settings"; size: 16; color: "#888" }
            }
            
            Item { Layout.fillWidth: true }
        }
    }
}
