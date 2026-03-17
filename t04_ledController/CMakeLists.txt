cmake_minimum_required(VERSION 3.16)

project(t04_ledController VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appt04_ledController
    main.cpp
)

qt_add_qml_module(appt04_ledController
    URI t04_ledController
    VERSION 1.0
    QML_FILES
        Main.qml
)

set_target_properties(appt04_ledController PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appt04_ledController
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appt04_ledController
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
