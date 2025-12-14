#pragma once

#include <string>
#include <vector>
#include <cstdint>

namespace NeuralStudio {

    struct VRHeadsetProfile {
        std::string id;
        std::string name;
        bool enabled = false;
        uint32_t eyeWidth = 1920;
        uint32_t eyeHeight = 1080;
        double framerate = 90.0;
        int srtPort = 5000;
    };

    namespace Profiles {
        inline VRHeadsetProfile Quest3()
        {
            VRHeadsetProfile p;
            p.id = "quest3";
            p.name = "Meta Quest 3";
            p.eyeWidth = 2064;
            p.eyeHeight = 2208;
            p.framerate = 90.0;
            p.srtPort = 8001;
            return p;
        }

        inline VRHeadsetProfile ValveIndex()
        {
            VRHeadsetProfile p;
            p.id = "index";
            p.name = "Valve Index";
            p.eyeWidth = 1440;
            p.eyeHeight = 1600;
            p.framerate = 120.0;
            p.srtPort = 8002;
            return p;
        }

        inline VRHeadsetProfile VivePro2()
        {
            VRHeadsetProfile p;
            p.id = "vivepro2";
            p.name = "HTC Vive Pro 2";
            p.eyeWidth = 2448;
            p.eyeHeight = 2448;
            p.framerate = 90.0;
            p.srtPort = 8003;
            return p;
        }
    }  // namespace Profiles

}  // namespace NeuralStudio
