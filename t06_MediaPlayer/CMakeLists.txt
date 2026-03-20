cmake_minimum_required(VERSION 3.16)

project(t06_MediaPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appt06_MediaPlayer
    main.cpp
)

qt_add_qml_module(appt06_MediaPlayer
    URI t06_MediaPlayer
    VERSION 1.0
    QML_FILES
        Main.qml
)

set_target_properties(appt06_MediaPlayer PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appt06_MediaPlayer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appt06_MediaPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
