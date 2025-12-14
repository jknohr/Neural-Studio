/****************************************************************************
** Meta object code from reading C++ file 'VideoManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/VideoManager/VideoManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'VideoManagerController.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.10.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::Blueprint::VideoManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::Blueprint::VideoManagerController",
        "availableVideosChanged",
        "",
        "videosChanged",
        "scanVideos",
        "createVideoNode",
        "videoPath",
        "variantType",
        "createVideoNodeVariant",
        "x",
        "y",
        "getVideos",
        "QVariantList",
        "availableVideos",
        "videoVariants"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availableVideosChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'videosChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'scanVideos'
        QtMocHelpers::SlotData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'createVideoNode'
        QtMocHelpers::SlotData<void(const QString &, const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::QString, 7 },
        }}),
        // Slot 'createVideoNode'
        QtMocHelpers::SlotData<void(const QString &)>(5, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Slot 'createVideoNodeVariant'
        QtMocHelpers::SlotData<void(const QString &, float, float)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { QMetaType::Float, 9 }, { QMetaType::Float, 10 },
        }}),
        // Slot 'createVideoNodeVariant'
        QtMocHelpers::SlotData<void(const QString &, float)>(8, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { QMetaType::Float, 9 },
        }}),
        // Slot 'createVideoNodeVariant'
        QtMocHelpers::SlotData<void(const QString &)>(8, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'getVideos'
        QtMocHelpers::MethodData<QVariantList() const>(11, 2, QMC::AccessPublic, 0x80000000 | 12),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availableVideos'
        QtMocHelpers::PropertyData<QVariantList>(13, 0x80000000 | 12, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'videoVariants'
        QtMocHelpers::PropertyData<QStringList>(14, QMetaType::QStringList, QMC::DefaultPropertyFlags | QMC::Constant),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<VideoManagerController, qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::Blueprint::VideoManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<UI::BaseManagerController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::Blueprint::VideoManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<VideoManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availableVideosChanged(); break;
        case 1: _t->videosChanged(); break;
        case 2: _t->scanVideos(); break;
        case 3: _t->createVideoNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 4: _t->createVideoNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->createVideoNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[3]))); break;
        case 6: _t->createVideoNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2]))); break;
        case 7: _t->createVideoNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: { QVariantList _r = _t->getVideos();
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (VideoManagerController::*)()>(_a, &VideoManagerController::availableVideosChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (VideoManagerController::*)()>(_a, &VideoManagerController::videosChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->availableVideos(); break;
        case 1: *reinterpret_cast<QStringList*>(_v) = _t->videoVariants(); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::Blueprint::VideoManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::Blueprint::VideoManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22VideoManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return UI::BaseManagerController::qt_metacast(_clname);
}

int NeuralStudio::Blueprint::VideoManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = UI::BaseManagerController::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 9;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::Blueprint::VideoManagerController::availableVideosChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::Blueprint::VideoManagerController::videosChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
