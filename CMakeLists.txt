cmake_minimum_required(VERSION 3.6.0)

project(ducky-home
    VERSION 0.1
    DESCRIPTION "DuckyOS homescreen")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FindPkgConfig)
include(FeatureSummary)
include(GNUInstallDirs)

option(USE_SYSTEMD "Use systemd services" ON)

set(QT_MIN_VERSION "5.15.0")
find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Gui
    Qml
    Quick
    DBus
    WaylandCompositor
    LinguistTools)

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIPSTICK lipstick-qt5 REQUIRED IMPORTED_TARGET)
pkg_check_modules(MLITE5 mlite5 REQUIRED IMPORTED_TARGET)

add_subdirectory(src)

if(USE_SYSTEMD)
    execute_process(COMMAND ${PKG_CONFIG_EXECUTABLE}
		--variable=systemduserunitdir systemd
		OUTPUT_VARIABLE SYSTEMD_USER_UNIT_INSTALL_DIR)
	string(REGEX REPLACE "[ \t\n]+" "" SYSTEMD_USER_UNIT_INSTALL_DIR
		"${SYSTEMD_USER_UNIT_INSTALL_DIR}")
    install(FILES data/lipstick.service
        DESTINATION ${SYSTEMD_USER_UNIT_INSTALL_DIR})
endif()

# Translations
file(GLOB TS_FILES translations/*.ts)
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(lipstick translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lipstick-ducky-home-qt5/translations)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
