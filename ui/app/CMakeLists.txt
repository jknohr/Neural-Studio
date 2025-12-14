# Neural Studio UI - App Module
# Qt 6.10 QML Application Window

set(QML_FILES
    MainWindow.qml
    CornerButton.qml
    SlidingPanel.qml
    MaterialIcon.qml
)

qt_add_qml_module(neural-studio-app
    URI NeuralStudio.App
    VERSION 1.0
    QML_FILES ${QML_FILES}
)
