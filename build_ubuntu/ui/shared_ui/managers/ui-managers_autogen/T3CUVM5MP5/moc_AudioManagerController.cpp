/****************************************************************************
** Meta object code from reading C++ file 'AudioManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/AudioManager/AudioManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'AudioManagerController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::Blueprint::AudioManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::Blueprint::AudioManagerController",
        "availableAudioChanged",
        "",
        "audioChanged",
        "scanAudio",
        "createAudioNode",
        "audioPath",
        "variantType",
        "createAudioNodeVariant",
        "x",
        "y",
        "getAudio",
        "QVariantList",
        "availableAudio",
        "audioVariants"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availableAudioChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'audioChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'scanAudio'
        QtMocHelpers::SlotData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'createAudioNode'
        QtMocHelpers::SlotData<void(const QString &, const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::QString, 7 },
        }}),
        // Slot 'createAudioNode'
        QtMocHelpers::SlotData<void(const QString &)>(5, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Slot 'createAudioNodeVariant'
        QtMocHelpers::SlotData<void(const QString &, float, float)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { QMetaType::Float, 9 }, { QMetaType::Float, 10 },
        }}),
        // Slot 'createAudioNodeVariant'
        QtMocHelpers::SlotData<void(const QString &, float)>(8, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 7 }, { QMetaType::Float, 9 },
        }}),
        // Slot 'createAudioNodeVariant'
        QtMocHelpers::SlotData<void(const QString &)>(8, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Method 'getAudio'
        QtMocHelpers::MethodData<QVariantList() const>(11, 2, QMC::AccessPublic, 0x80000000 | 12),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availableAudio'
        QtMocHelpers::PropertyData<QVariantList>(13, 0x80000000 | 12, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'audioVariants'
        QtMocHelpers::PropertyData<QStringList>(14, QMetaType::QStringList, QMC::DefaultPropertyFlags | QMC::Constant),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<AudioManagerController, qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::Blueprint::AudioManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<UI::BaseManagerController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::Blueprint::AudioManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<AudioManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availableAudioChanged(); break;
        case 1: _t->audioChanged(); break;
        case 2: _t->scanAudio(); break;
        case 3: _t->createAudioNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 4: _t->createAudioNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->createAudioNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[3]))); break;
        case 6: _t->createAudioNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2]))); break;
        case 7: _t->createAudioNodeVariant((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: { QVariantList _r = _t->getAudio();
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (AudioManagerController::*)()>(_a, &AudioManagerController::availableAudioChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (AudioManagerController::*)()>(_a, &AudioManagerController::audioChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->availableAudio(); break;
        case 1: *reinterpret_cast<QStringList*>(_v) = _t->audioVariants(); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::Blueprint::AudioManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::Blueprint::AudioManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint22AudioManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return UI::BaseManagerController::qt_metacast(_clname);
}

int NeuralStudio::Blueprint::AudioManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
void NeuralStudio::Blueprint::AudioManagerController::availableAudioChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::Blueprint::AudioManagerController::audioChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
