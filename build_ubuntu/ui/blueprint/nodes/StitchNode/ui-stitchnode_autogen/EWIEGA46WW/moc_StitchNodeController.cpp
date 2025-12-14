/****************************************************************************
** Meta object code from reading C++ file 'StitchNodeController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../../ui/blueprint/nodes/StitchNode/StitchNodeController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'StitchNodeController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::UI::StitchNodeController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::UI::StitchNodeController",
        "QML.Element",
        "auto",
        "stmapPathChanged",
        "",
        "propertyChanged",
        "property",
        "QVariant",
        "value",
        "stmapPath"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'stmapPathChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'propertyChanged'
        QtMocHelpers::SignalData<void(const QString &, const QVariant &)>(5, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { 0x80000000 | 7, 8 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'stmapPath'
        QtMocHelpers::PropertyData<QString>(9, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<StitchNodeController, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject NeuralStudio::UI::StitchNodeController::staticMetaObject = { {
    QMetaObject::SuperData::link<BaseNodeController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::UI::StitchNodeController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<StitchNodeController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->stmapPathChanged(); break;
        case 1: _t->propertyChanged((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QVariant>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (StitchNodeController::*)()>(_a, &StitchNodeController::stmapPathChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (StitchNodeController::*)(const QString & , const QVariant & )>(_a, &StitchNodeController::propertyChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->stmapPath(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setStmapPath(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::UI::StitchNodeController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::UI::StitchNodeController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI20StitchNodeControllerE_t>.strings))
        return static_cast<void*>(this);
    return BaseNodeController::qt_metacast(_clname);
}

int NeuralStudio::UI::StitchNodeController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = BaseNodeController::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 2;
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
void NeuralStudio::UI::StitchNodeController::stmapPathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::UI::StitchNodeController::propertyChanged(const QString & _t1, const QVariant & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2);
}
QT_WARNING_POP
