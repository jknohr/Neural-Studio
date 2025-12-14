/****************************************************************************
** Meta object code from reading C++ file 'BaseNodeController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/blueprint/nodes/BaseNodeController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'BaseNodeController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::UI::BaseNodeController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::UI::BaseNodeController",
        "nodeIdChanged",
        "",
        "enabledChanged",
        "graphControllerChanged",
        "propertyChanged",
        "property",
        "QVariant",
        "value",
        "visualInputEnabledChanged",
        "visualOutputEnabledChanged",
        "audioInputEnabledChanged",
        "audioOutputEnabledChanged",
        "graphController",
        "NodeGraphController*",
        "visualInputEnabled",
        "visualOutputEnabled",
        "audioInputEnabled",
        "audioOutputEnabled"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'nodeIdChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'enabledChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'graphControllerChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'propertyChanged'
        QtMocHelpers::SignalData<void(const QString &, const QVariant &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { 0x80000000 | 7, 8 },
        }}),
        // Signal 'visualInputEnabledChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'visualOutputEnabledChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'audioInputEnabledChanged'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'audioOutputEnabledChanged'
        QtMocHelpers::SignalData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'graphController'
        QtMocHelpers::PropertyData<NodeGraphController*>(13, 0x80000000 | 14, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 2),
        // property 'visualInputEnabled'
        QtMocHelpers::PropertyData<bool>(15, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 4),
        // property 'visualOutputEnabled'
        QtMocHelpers::PropertyData<bool>(16, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'audioInputEnabled'
        QtMocHelpers::PropertyData<bool>(17, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 6),
        // property 'audioOutputEnabled'
        QtMocHelpers::PropertyData<bool>(18, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 7),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<BaseNodeController, qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::UI::BaseNodeController::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::UI::BaseNodeController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<BaseNodeController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->nodeIdChanged(); break;
        case 1: _t->enabledChanged(); break;
        case 2: _t->graphControllerChanged(); break;
        case 3: _t->propertyChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QVariant>>(_a[2]))); break;
        case 4: _t->visualInputEnabledChanged(); break;
        case 5: _t->visualOutputEnabledChanged(); break;
        case 6: _t->audioInputEnabledChanged(); break;
        case 7: _t->audioOutputEnabledChanged(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::nodeIdChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::enabledChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::graphControllerChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)(const QString & , const QVariant & )>(_a, &BaseNodeController::propertyChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::visualInputEnabledChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::visualOutputEnabledChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::audioInputEnabledChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (BaseNodeController::*)()>(_a, &BaseNodeController::audioOutputEnabledChanged, 7))
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
        case 1: *reinterpret_cast<bool*>(_v) = _t->visualInputEnabled(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->visualOutputEnabled(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->audioInputEnabled(); break;
        case 4: *reinterpret_cast<bool*>(_v) = _t->audioOutputEnabled(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setGraphController(*reinterpret_cast<NodeGraphController**>(_v)); break;
        case 1: _t->setVisualInputEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 2: _t->setVisualOutputEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 3: _t->setAudioInputEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 4: _t->setAudioOutputEnabled(*reinterpret_cast<bool*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::UI::BaseNodeController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::UI::BaseNodeController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI18BaseNodeControllerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int NeuralStudio::UI::BaseNodeController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 8;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::UI::BaseNodeController::nodeIdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::UI::BaseNodeController::enabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void NeuralStudio::UI::BaseNodeController::graphControllerChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void NeuralStudio::UI::BaseNodeController::propertyChanged(const QString & _t1, const QVariant & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1, _t2);
}

// SIGNAL 4
void NeuralStudio::UI::BaseNodeController::visualInputEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void NeuralStudio::UI::BaseNodeController::visualOutputEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void NeuralStudio::UI::BaseNodeController::audioInputEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void NeuralStudio::UI::BaseNodeController::audioOutputEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}
QT_WARNING_POP
