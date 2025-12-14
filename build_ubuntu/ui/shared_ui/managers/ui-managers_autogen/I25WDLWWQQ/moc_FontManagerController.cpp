/****************************************************************************
** Meta object code from reading C++ file 'FontManagerController.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../ui/shared_ui/managers/FontManager/FontManagerController.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FontManagerController.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t {};
} // unnamed namespace

template <> constexpr inline auto NeuralStudio::Blueprint::FontManagerController::qt_create_metaobjectdata<qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NeuralStudio::Blueprint::FontManagerController",
        "availableFontsChanged",
        "",
        "fontsChanged",
        "scanFonts",
        "createFontNode",
        "fontPath",
        "getFonts",
        "QVariantList",
        "availableFonts"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'availableFontsChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'fontsChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'scanFonts'
        QtMocHelpers::SlotData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'createFontNode'
        QtMocHelpers::SlotData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Method 'getFonts'
        QtMocHelpers::MethodData<QVariantList() const>(7, 2, QMC::AccessPublic, 0x80000000 | 8),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'availableFonts'
        QtMocHelpers::PropertyData<QVariantList>(9, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<FontManagerController, qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NeuralStudio::Blueprint::FontManagerController::staticMetaObject = { {
    QMetaObject::SuperData::link<UI::BaseManagerController::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>.metaTypes,
    nullptr
} };

void NeuralStudio::Blueprint::FontManagerController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FontManagerController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->availableFontsChanged(); break;
        case 1: _t->fontsChanged(); break;
        case 2: _t->scanFonts(); break;
        case 3: _t->createFontNode((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: { QVariantList _r = _t->getFonts();
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (FontManagerController::*)()>(_a, &FontManagerController::availableFontsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (FontManagerController::*)()>(_a, &FontManagerController::fontsChanged, 1))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->availableFonts(); break;
        default: break;
        }
    }
}

const QMetaObject *NeuralStudio::Blueprint::FontManagerController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NeuralStudio::Blueprint::FontManagerController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12NeuralStudio9Blueprint21FontManagerControllerE_t>.strings))
        return static_cast<void*>(this);
    return UI::BaseManagerController::qt_metacast(_clname);
}

int NeuralStudio::Blueprint::FontManagerController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
void NeuralStudio::Blueprint::FontManagerController::availableFontsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NeuralStudio::Blueprint::FontManagerController::fontsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
