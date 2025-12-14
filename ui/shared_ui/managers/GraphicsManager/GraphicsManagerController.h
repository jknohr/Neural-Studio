#pragma once
#include "../BaseManagerController.h"
#include <QStringList>
#include <QVariantList>
#include <QUuid>

namespace NeuralStudio {
    namespace Blueprint {

        class GraphicsManagerController : public UI::BaseManagerController
        {
            Q_OBJECT
            Q_PROPERTY(QVariantList availableGraphics READ availableGraphics NOTIFY availableGraphicsChanged)
            Q_PROPERTY(QStringList graphicsVariants READ graphicsVariants CONSTANT)

              public:
            explicit GraphicsManagerController(QObject *parent = nullptr);
            ~GraphicsManagerController() override;

            QString title() const override
            {
                return "Graphics";
            }
            QString nodeType() const override
            {
                return "GraphicsNode";
            }

            QVariantList availableGraphics() const
            {
                return m_availableGraphics;
            }

            QStringList graphicsVariants() const
            {
                return m_graphicsVariants;
            }

            Q_INVOKABLE QVariantList getGraphics() const
            {
                return m_availableGraphics;
            }

              public slots:
            void scanGraphics();

            // Create node with specific graphics file and variant type, generates UUID
            void createGraphicsNode(const QString &graphicPath, const QString &variantType = "graphicsimage");

            // Create node without file (e.g., for generator/screenshot variants)
            void createGraphicsNodeVariant(const QString &variantType, float x = 0.0f, float y = 0.0f);

              signals:
            void availableGraphicsChanged();
            void graphicsChanged();

              private:
            QString generateNodeId() const;
            QString detectGraphicsVariant(const QString &filePath) const;

            QString m_graphicsDirectory;
            QVariantList m_availableGraphics;
            QStringList m_graphicsVariants;
        };

    }  // namespace Blueprint
}  // namespace NeuralStudio
