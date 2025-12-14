/****************************************************************************
** Meta object code from reading C++ file 'RTXUpscaleNodeController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../../ui/blueprint/nodes/RTXUpscaleNode/RTXUpscaleNodeController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'RTXUpscaleNodeController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::UI::RTXUpscaleNodeController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::UI::RTXUpscaleNodeController",
        "QML.Element",
        "auto",
        "qualityModeChanged",
        "",
        "scaleFactorChanged",
        "qualityMode",
        "scaleFactor"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'qualityModeChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'scaleFactorChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'qualityMode'
        QtMocHelpers::PropertyData<int>(6, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'scaleFactor'
        QtMocHelpers::PropertyData<int>(7, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<RTXUpscaleNodeController, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject NeuralStudio::UI::RTXUpscaleNodeController::staticMetaObject = { {
    QMetaObject::SuperData::link<BaseNodeController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::UI::RTXUpscaleNodeController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<RTXUpscaleNodeController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->qualityModeChanged(); break;
        case 1: _t->scaleFactorChanged(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (RTXUpscaleNodeController::*)()>(_a, &RTXUpscaleNodeController::qualityModeChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (RTXUpscaleNodeController::*)()>(_a, &RTXUpscaleNodeController::scaleFactorChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<int*>(_v) = _t->qualityMode(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->scaleFactor(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setQualityMode(*reinterpret_cast<int*>(_v)); break;
        case 1: _t->setScaleFactor(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::UI::RTXUpscaleNodeController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::UI::RTXUpscaleNodeController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio2UI24RTXUpscaleNodeControllerE_t>.strings))
        return static_cast<void*>(this);
    return BaseNodeController::qt_metacast(_clname);
}

int NeuralStudio::UI::RTXUpscaleNodeController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void NeuralStudio::UI::RTXUpscaleNodeController::qualityModeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::UI::RTXUpscaleNodeController::scaleFactorChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
