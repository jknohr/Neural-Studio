/****************************************************************************
** Meta object code from reading C++ file 'BaseManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/BaseManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'BaseManagerController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::UI::BaseManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::UI::BaseManagerController",
        "graphControllerChanged",
        "",
        "managedNodesChanged",
        "nodePresetsChanged",
        "errorOccurred",
        "message",
        "isManaging",
        "nodeId",
        "getResourceForNode",
        "getNodeInfo",
        "QVariantMap",
        "savePreset",
        "presetName",
        "loadPreset",
        "x",
        "y",
        "deletePreset",
        "createNode",
        "nodeType",
        "graphController",
        "NodeGraphController*",
        "title",
        "managedNodes",
        "nodePresets",
        "QVariantList"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'graphControllerChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'managedNodesChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'nodePresetsChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'isManaging'
        QtMocHelpers::MethodData<bool(const QString &) const>(7, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getResourceForNode'
        QtMocHelpers::MethodData<QString(const QString &) const>(9, 2, QMC::AccessPublic, QMetaType::QString, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'getNodeInfo'
        QtMocHelpers::MethodData<QVariantMap(const QString &) const>(10, 2, QMC::AccessPublic, 0x80000000 | 11, {{
            { QMetaType::QString, 8 },
        }}),
        // Method 'savePreset'
        QtMocHelpers::MethodData<void(const QString &, const QString &)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 }, { QMetaType::QString, 13 },
        }}),
        // Method 'loadPreset'
        QtMocHelpers::MethodData<QString(const QString &, float, float)>(14, 2, QMC::AccessPublic, QMetaType::QString, {{
            { QMetaType::QString, 13 }, { QMetaType::Float, 15 }, { QMetaType::Float, 16 },
        }}),
        // Method 'loadPreset'
        QtMocHelpers::MethodData<QString(const QString &, float)>(14, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::QString, {{
            { QMetaType::QString, 13 }, { QMetaType::Float, 15 },
        }}),
        // Method 'loadPreset'
        QtMocHelpers::MethodData<QString(const QString &)>(14, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::QString, {{
            { QMetaType::QString, 13 },
        }}),
        // Method 'deletePreset'
        QtMocHelpers::MethodData<void(const QString &)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 13 },
        }}),
        // Method 'createNode'
        QtMocHelpers::MethodData<void(const QString &, float, float)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 19 }, { QMetaType::Float, 15 }, { QMetaType::Float, 16 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'graphController'
        QtMocHelpers::PropertyData<NodeGraphController*>(20, 0x80000000 | 21, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 0),
        // property 'title'
        QtMocHelpers::PropertyData<QString>(22, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'managedNodes'
        QtMocHelpers::PropertyData<QStringList>(23, QMetaType::QStringList, QMC::DefaultPropertyFlags, 1),
        // property 'nodePresets'
        QtMocHelpers::PropertyData<QVariantList>(24, 0x80000000 | 25, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<BaseManagerController, qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::UI::BaseManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::UI::BaseManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<BaseManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->graphControllerChanged(); break;
        case 1: _t->managedNodesChanged(); break;
        case 2: _t->nodePresetsChanged(); break;
        case 3: _t->errorOccurred((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: { bool _r = _t->isManaging((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { QString _r = _t->getResourceForNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QString*>(_a[0]) = std::move(_r); }  break;
        case 6: { QVariantMap _r = _t->getNodeInfo((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->savePreset((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 8: { QString _r = _t->loadPreset((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[3])));
            if (_a[0]) *reinterpret_cast<QString*>(_a[0]) = std::move(_r); }  break;
        case 9: { QString _r = _t->loadPreset((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2])));
            if (_a[0]) *reinterpret_cast<QString*>(_a[0]) = std::move(_r); }  break;
        case 10: { QString _r = _t->loadPreset((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QString*>(_a[0]) = std::move(_r); }  break;
        case 11: _t->deletePreset((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->createNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<float>>(_a[3]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (BaseManagerController::*)()>(_a, &BaseManagerController::graphControllerChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseManagerController::*)()>(_a, &BaseManagerController::managedNodesChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseManagerController::*)()>(_a, &BaseManagerController::nodePresetsChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseManagerController::*)(const QString & )>(_a, &BaseManagerController::errorOccurred, 3))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< NodeGraphController* >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<NodeGraphController**>(_v) = _t->graphController(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->title(); break;
        case 2: *reinterpret_cast<QStringList*>(_v) = _t->managedNodes(); break;
        case 3: *reinterpret_cast<QVariantList*>(_v) = _t->nodePresets(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setGraphController(*reinterpret_cast<NodeGraphController**>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::UI::BaseManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::UI::BaseManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI21BaseManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int NeuralStudio::UI::BaseManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 13)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 13;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::UI::BaseManagerController::graphControllerChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::UI::BaseManagerController::managedNodesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void NeuralStudio::UI::BaseManagerController::nodePresetsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void NeuralStudio::UI::BaseManagerController::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}
QT_WARNING_POP
