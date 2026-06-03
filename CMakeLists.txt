cmake_minimum_required(VERSION 3.30.1)
project(qtquick3d-transform-gizmo)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_PREFIX_PATH "D:/Qt/6.9.3/msvc2022_64")


set(QT_MODULES_LIST
        Core Gui Widgets Quick Qml Quick3D Sql Quick3DAssetImport QuickControls2
)

find_package(Qt6 COMPONENTS
        ${QT_MODULES_LIST}
        REQUIRED)

list(TRANSFORM QT_MODULES_LIST PREPEND "Qt::" OUTPUT_VARIABLE QT_MODULES_LIST_WITH_PREFIX)

set(QRC_FILES
        qml.qrc
)

set(CPP_FILES
        main.cpp

)


add_executable(${PROJECT_NAME}
        ${CPP_FILES}
        ${QRC_FILES}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
        ${QT_MODULES_LIST_WITH_PREFIX}
)


if (WIN32 AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(DEBUG_SUFFIX)
    if (MSVC AND CMAKE_BUILD_TYPE MATCHES "Debug")
        set(DEBUG_SUFFIX "d")
    endif ()
    set(QT_INSTALL_PATH "${CMAKE_PREFIX_PATH}")
    if (NOT EXISTS "${QT_INSTALL_PATH}/bin")
        set(QT_INSTALL_PATH "${QT_INSTALL_PATH}/..")
        if (NOT EXISTS "${QT_INSTALL_PATH}/bin")
            set(QT_INSTALL_PATH "${QT_INSTALL_PATH}/..")
        endif ()
    endif ()
    if (EXISTS "${QT_INSTALL_PATH}/plugins/platforms/qwindows${DEBUG_SUFFIX}.dll")
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E make_directory
                "$<TARGET_FILE_DIR:${PROJECT_NAME}>/plugins/platforms/")
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${QT_INSTALL_PATH}/plugins/platforms/qwindows${DEBUG_SUFFIX}.dll"
                "$<TARGET_FILE_DIR:${PROJECT_NAME}>/plugins/platforms/")
    endif ()
    foreach (QT_LIB ${QT_MODULES_LIST})
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${QT_INSTALL_PATH}/bin/Qt6${QT_LIB}${DEBUG_SUFFIX}.dll"
                "$<TARGET_FILE_DIR:${PROJECT_NAME}>")
    endforeach (QT_LIB)

    find_program(WINDEPLOYQT_EXECUTABLE
            NAMES windeployqt
            HINTS "${QT_INSTALL_PATH}/bin")
    if (WINDEPLOYQT_EXECUTABLE)
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND "${WINDEPLOYQT_EXECUTABLE}"
                --no-translations
                --qmldir "${CMAKE_CURRENT_SOURCE_DIR}/"
                "$<TARGET_FILE:${PROJECT_NAME}>"
                COMMENT "Deploying Qt runtime + QML modules via windeployqt")
    else ()
        message(WARNING "windeployqt not found under '${QT_INSTALL_PATH}/bin'. QML modules (QtQuick/Controls/Layouts) may fail to load at runtime.")
    endif ()


    # 设置调试工作目录
    set_target_properties(${PROJECT_NAME} PROPERTIES
            VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )

endif ()

