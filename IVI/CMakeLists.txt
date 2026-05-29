cmake_minimum_required(VERSION 3.16)

project(IVI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appIVI
    main.cpp
)

qt_add_qml_module(appIVI
    URI IVI
    VERSION 1.0
    QML_FILES
        qml/components/Main.qml
        qml/components/WeatherCard.qml
        qml/components/MusicCard.qml
        qml/components/ClimateCard.qml
        qml/components/VoiceCard.qml
        qml/components/Sidebar.qml
        qml/components/GlassPanel.qml
        pages/MainPage.qml
        pages/MusicPage.qml
        pages/SettingsPage.qml
        pages/AppsPage.qml
        pages/HVACPage.qml
        QML_FILES qml/components/VoiceOverlay.qml
)

set_target_properties(appIVI PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appIVI
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appIVI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
