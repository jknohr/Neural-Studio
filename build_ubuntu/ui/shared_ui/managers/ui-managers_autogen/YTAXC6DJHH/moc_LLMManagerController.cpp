/****************************************************************************
** Meta object code from reading C++ file 'LLMManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/LLMManager/LLMManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'LLMManagerController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::Blueprint::LLMManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::Blueprint::LLMManagerController",
        "availableModelsChanged",
        "",
        "modelsChanged",
        "refreshModels",
        "createLLMNode",
        "modelId",
        "provider",
        "getModels",
        "QVariantList",
        "availableModels"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availableModelsChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'modelsChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'refreshModels'
        QtMocHelpers::SlotData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'createLLMNode'
        QtMocHelpers::SlotData<void(const QString &, const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 }, { QMetaType::QString, 7 },
        }}),
        // Method 'getModels'
        QtMocHelpers::MethodData<QVariantList() const>(8, 2, QMC::AccessPublic, 0x80000000 | 9),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availableModels'
        QtMocHelpers::PropertyData<QVariantList>(10, 0x80000000 | 9, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<LLMManagerController, qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::Blueprint::LLMManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<UI::BaseManagerController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::Blueprint::LLMManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<LLMManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availableModelsChanged(); break;
        case 1: _t->modelsChanged(); break;
        case 2: _t->refreshModels(); break;
        case 3: _t->createLLMNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 4: { QVariantList _r = _t->getModels();
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (LLMManagerController::*)()>(_a, &LLMManagerController::availableModelsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (LLMManagerController::*)()>(_a, &LLMManagerController::modelsChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->availableModels(); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::Blueprint::LLMManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::Blueprint::LLMManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint20LLMManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return UI::BaseManagerController::qt_metacast(_clname);
}

int NeuralStudio::Blueprint::LLMManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
void NeuralStudio::Blueprint::LLMManagerController::availableModelsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::Blueprint::LLMManagerController::modelsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
