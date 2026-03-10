cmake_minimum_required(VERSION 3.16)

project(t03_netman VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick DBus)

qt_standard_project_setup(REQUIRES 6.8)


qt_add_executable(appt03_netman
    main.cpp
)
target_include_directories(appt03_netman PRIVATE 
    controllers/wifi
    controllers/bt
)

qt_add_qml_module(appt03_netman
    URI t03_netman
    QML_FILES
        Main.qml
        pages/WifiPage.qml
        pages/BtPage.qml
        components/TabEnableButton.qml
        components/DeviceElement.qml
    SOURCES
        controllers/wifi/wificontroller.cpp
        controllers/wifi/wificontroller.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appt03_netman PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appt03_netman
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appt03_netman
    PRIVATE Qt6::Quick Qt6::DBus
)

include(GNUInstallDirs)
install(TARGETS appt03_netman
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
