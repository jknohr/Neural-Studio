#pragma once
#include "../BaseManagerController.h"
#include <QStringList>
#include <QVariantList>
#include <QUuid>

namespace NeuralStudio {
    namespace Blueprint {

        class VideoManagerController : public UI::BaseManagerController
        {
            Q_OBJECT
            Q_PROPERTY(QVariantList availableVideos READ availableVideos NOTIFY availableVideosChanged)
            Q_PROPERTY(QStringList videoVariants READ videoVariants CONSTANT)

              public:
            explicit VideoManagerController(QObject *parent = nullptr);
            ~VideoManagerController() override;

            QString title() const override
            {
                return "Video Assets";
            }
            QString nodeType() const override
            {
                return "VideoNode";
            }

            QVariantList availableVideos() const
            {
                return m_availableVideos;
            }

            QStringList videoVariants() const
            {
                return m_videoVariants;
            }

            Q_INVOKABLE QVariantList getVideos() const
            {
                return m_availableVideos;
            }

              public slots:
            void scanVideos();

            // Create node with specific video file and variant type, generates UUID
            void createVideoNode(const QString &videoPath, const QString &variantType = "videofile");

            // Create node without video file (e.g., for camera/stream variants)
            void createVideoNodeVariant(const QString &variantType, float x = 0.0f, float y = 0.0f);

              signals:
            void availableVideosChanged();
            void videosChanged();

              private:
            QString generateNodeId() const;
            QString detectVideoVariant(const QString &filePath) const;

            QString m_videosDirectory;
            QVariantList m_availableVideos;
            QStringList m_videoVariants;
        };

    }  // namespace Blueprint
}  // namespace NeuralStudio
