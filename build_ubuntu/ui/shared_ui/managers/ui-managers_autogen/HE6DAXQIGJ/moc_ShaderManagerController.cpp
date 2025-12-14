/****************************************************************************
** Meta object code from reading C++ file 'ShaderManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/ShaderManager/ShaderManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ShaderManagerController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::Blueprint::ShaderManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::Blueprint::ShaderManagerController",
        "availableShadersChanged",
        "",
        "shadersChanged",
        "scanShaders",
        "createShaderNode",
        "shaderPath",
        "getShaders",
        "QVariantList",
        "availableShaders"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availableShadersChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'shadersChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'scanShaders'
        QtMocHelpers::SlotData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'createShaderNode'
        QtMocHelpers::SlotData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'getShaders'
        QtMocHelpers::MethodData<QVariantList() const>(7, 2, QMC::AccessPublic, 0x80000000 | 8),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availableShaders'
        QtMocHelpers::PropertyData<QVariantList>(9, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<ShaderManagerController, qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::Blueprint::ShaderManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<UI::BaseManagerController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::Blueprint::ShaderManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<ShaderManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availableShadersChanged(); break;
        case 1: _t->shadersChanged(); break;
        case 2: _t->scanShaders(); break;
        case 3: _t->createShaderNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: { QVariantList _r = _t->getShaders();
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (ShaderManagerController::*)()>(_a, &ShaderManagerController::availableShadersChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (ShaderManagerController::*)()>(_a, &ShaderManagerController::shadersChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->availableShaders(); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::Blueprint::ShaderManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::Blueprint::ShaderManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint23ShaderManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return UI::BaseManagerController::qt_metacast(_clname);
}

int NeuralStudio::Blueprint::ShaderManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = UI::BaseManagerController::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 5;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::Blueprint::ShaderManagerController::availableShadersChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::Blueprint::ShaderManagerController::shadersChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
