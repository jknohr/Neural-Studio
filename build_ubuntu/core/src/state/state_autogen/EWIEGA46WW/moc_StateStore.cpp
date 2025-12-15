/****************************************************************************
** Meta object code from reading C++ file 'StateStore.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../core/src/state/StateStore.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'StateStore.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio10StateStoreE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::StateStore::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::StateStore",
        "sceneObjectChanged",
        "",
        "nodeId",
        "keyframeAdded",
        "objectId",
        "timestamp",
        "settingsChanged",
        "platform"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'sceneObjectChanged'
        QtMocHelpers::SignalData<void(const QString &)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 },
        }}),
        // Signal 'keyframeAdded'
        QtMocHelpers::SignalData<void(quint64, qint64)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::ULongLong, 5 }, { QMetaType::LongLong, 6 },
        }}),
        // Signal 'settingsChanged'
        QtMocHelpers::SignalData<void(const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<StateStore, qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::StateStore::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::StateStore::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<StateStore *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->sceneObjectChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 1: _t->keyframeAdded((*reinterpret_cast<std::add_pointer_t<quint64>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[2]))); break;
        case 2: _t->settingsChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (StateStore::*)(const QString & )>(_a, &StateStore::sceneObjectChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (StateStore::*)(quint64 , qint64 )>(_a, &StateStore::keyframeAdded, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (StateStore::*)(const QString & )>(_a, &StateStore::settingsChanged, 2))
            return;
    }
}

const QMetaObject *NeuralStudio::StateStore::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::StateStore::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio10StateStoreE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int NeuralStudio::StateStore::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::StateStore::sceneObjectChanged(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void NeuralStudio::StateStore::keyframeAdded(quint64 _t1, qint64 _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2);
}

// SIGNAL 2
void NeuralStudio::StateStore::settingsChanged(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}
QT_WARNING_POP
