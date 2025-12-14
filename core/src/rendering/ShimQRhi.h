#pragma once
#include <QObject>
#include <QSize>

// Shim definitions for missing Qt RHI classes
// This allows compilation when Qt RHI is not available (e.g. standard Qt 6 install without RHI module)

class QRhiResource
{
      public:
    virtual ~QRhiResource() {}
    void deleteLater()
    {
        delete this;
    }
};

class QRhiTexture : public QRhiResource
{
      public:
    enum Format {
        RGBA8,
        RGBA16F,
        RGBA32F,
        RGBA8_SRGB
    };
    enum Flag {
        UsedAsTransferSource,
        RenderTarget,
        UsedAsTexture
    };

    void *nativeTexture()
    {
        return nullptr;
    }
    QSize pixelSize()
    {
        return QSize();
    }
    bool create()
    {
        return true;
    }  // Return true to simulate success
};

class QRhiRenderPassDescriptor : public QRhiResource
{
      public:
    bool isCompatible(QRhiRenderPassDescriptor *other) const
    {
        return true;
    }
    const void *serializedFormat() const
    {
        return nullptr;
    }
    size_t serializedFormatSize() const
    {
        return 0;
    }
    void deleteLater()
    {
        delete this;
    }
};

class QRhiTextureRenderTargetDescription
{
      public:
    QRhiTextureRenderTargetDescription() {}
    QRhiTextureRenderTargetDescription(QRhiTexture *texture) {}
    // Add other constructors if needed
};

class QRhiTextureRenderTarget : public QRhiResource
{
      public:
    bool create()
    {
        return true;
    }
    QRhiRenderPassDescriptor *newCompatibleRenderPassDescriptor()
    {
        return new QRhiRenderPassDescriptor();
    }
    void setRenderPassDescriptor(QRhiRenderPassDescriptor *desc) {}
    void deleteLater()
    {
        delete this;
    }
};

class QRhiCommandBuffer : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiBuffer : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiSampler : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiShaderResourceBindings : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiGraphicsPipeline : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiComputePipeline : public QRhiResource
{
      public:
    void deleteLater()
    {
        delete this;
    }
};

class QRhiSwapChain : public QRhiResource
{
      public:
    QRhiRenderPassDescriptor *newCompatibleRenderPassDescriptor()
    {
        return new QRhiRenderPassDescriptor();
    }
    bool createOrResize()
    {
        return true;
    }
    void deleteLater()
    {
        delete this;
    }
};

class QRhi
{
      public:
    static QRhi *create(int backend, void *params, int flags = 0, void *nativeHandles = nullptr)
    {
        return new QRhi();
    }

    // Factory methods
    QRhiTexture *newTexture(QRhiTexture::Format format, const QSize &pixelSize, int sampleCount = 1, int flags = 0)
    {
        return new QRhiTexture();
    }

    QRhiTextureRenderTarget *newTextureRenderTarget(const QRhiTextureRenderTargetDescription &desc, int flags = 0)
    {
        return new QRhiTextureRenderTarget();
    }

    // other factory methods maybe needed
    void deleteLater()
    {
        delete this;
    }
};
