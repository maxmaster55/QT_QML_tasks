cmake_minimum_required(VERSION 3.16)

project(t01_gallery VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appt01_gallery
    main.cpp
)

qt_add_qml_module(appt01_gallery
    URI t01_gallery
    VERSION 1.0
    QML_FILES
        Main.qml
        Splash.qml
        RESOURCES resources.qrc
        SOURCES systeminfo.h systeminfo.cpp
        QML_FILES SliderPage.qml
        QML_FILES HomePage.qml
        QML_FILES AboutPage.qml
)

set_target_properties(appt01_gallery PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appt01_gallery
    PRIVATE Qt6::Quick 
)

include(GNUInstallDirs)
install(TARGETS appt01_gallery
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
