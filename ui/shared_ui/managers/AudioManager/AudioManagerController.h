#pragma once
#include "../BaseManagerController.h"
#include <QStringList>
#include <QVariantList>
#include <QUuid>

namespace NeuralStudio {
    namespace Blueprint {

        class AudioManagerController : public UI::BaseManagerController
        {
            Q_OBJECT
            Q_PROPERTY(QVariantList availableAudio READ availableAudio NOTIFY availableAudioChanged)
            Q_PROPERTY(QStringList audioVariants READ audioVariants CONSTANT)

              public:
            explicit AudioManagerController(QObject *parent = nullptr);
            ~AudioManagerController() override;

            QString title() const override
            {
                return "Audio Assets";
            }
            QString nodeType() const override
            {
                return "AudioNode";
            }

            QVariantList availableAudio() const
            {
                return m_availableAudio;
            }

            QStringList audioVariants() const
            {
                return m_audioVariants;
            }

            Q_INVOKABLE QVariantList getAudio() const
            {
                return m_availableAudio;
            }

              public slots:
            void scanAudio();

            // Create node with specific variant type and generate UUID
            void createAudioNode(const QString &audioPath, const QString &variantType = "audioclip");

            // Create node without audio file (e.g., for microphone/stream variants)
            void createAudioNodeVariant(const QString &variantType, float x = 0.0f, float y = 0.0f);

              signals:
            void availableAudioChanged();
            void audioChanged();

              private:
            QString m_audioDirectory;
            QVariantList m_availableAudio;
            QStringList m_audioVariants;  // List of available variant types

            // Helper to generate unique node ID
            QString generateNodeId();

            // Helper to detect audio file type/category
            QString detectAudioCategory(const QString &filePath);
        };

    }  // namespace Blueprint
}  // namespace NeuralStudio
