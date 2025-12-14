#ifndef USD_STAGE_MANAGER_H
#define USD_STAGE_MANAGER_H

#include <QObject>
#include <QString>
#include <vector>
#include <string>
#include <memory>
#include <utility>  // For std::pair

#ifdef __linux__
// Linux specific includes if needed
#endif

// OpenUSD Includes
#ifdef NEURAL_STUDIO_USE_USD
#include "pxr/usd/usd/stage.h"
#include "pxr/usd/usdGeom/mesh.h"
#include "pxr/usd/usd/prim.h"
#include "pxr/usd/usdGeom/xform.h"
#endif

namespace NeuralStudio {
    namespace USD {

        struct PrimInfo {
            QString name;
            QString path;
            QString type;
            int childCount = 0;
        };

        struct PrimMesh {
            std::vector<float> vertices;
            std::vector<int> indices;
            std::vector<float> normals;
            bool isValid = false;
        };

        struct PrimTransform {
            std::vector<double> position = {0, 0, 0};
            std::vector<double> rotation = {1, 0, 0, 0};  // Quaternion (w, x, y, z)
            std::vector<double> scale = {1, 1, 1};
        };

        class UsdStageManager : public QObject
        {
            Q_OBJECT
              public:
            explicit UsdStageManager(QObject *parent = nullptr);
            ~UsdStageManager();

            // Stage management
            bool createNewStage(const QString &identifier);
            bool openStage(const QString &filePath);
            bool saveStage() const;
            bool saveStageAs(const QString &filePath) const;
            bool hasStage() const;

            // Prim management
            bool addPrim(const QString &path, const QString &type);
            std::vector<PrimInfo> getStageStructure() const;

            // Data Extraction
            PrimMesh getPrimMesh(const QString &primPath);
            PrimTransform getPrimTransform(const std::string &primPath);

            // Modification
            bool setPrimTransform(const std::string &primPath, const PrimTransform &xform);

              public slots:
            void printStageTraverse();

              private:
#ifdef NEURAL_STUDIO_USE_USD
            pxr::UsdStageRefPtr m_stage;
#else
            void *m_stage = nullptr;  // Dummy pointer when USD is disabled
#endif
        };

    }  // namespace USD
}  // namespace NeuralStudio

#endif  // USD_STAGE_MANAGER_H
