#pragma once

#include "SceneManager.h"
#include <string>

namespace neural_studio {

    class OBJLoader
    {
          public:
        // Load an .obj file from disk.
        // Returns a Mesh with vertices and indices populated.
        // Returns an empty mesh (id=0) on failure.
        static Mesh Load(const std::string &path);
    };

}  // namespace neural_studio
