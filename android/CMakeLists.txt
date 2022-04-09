cmake_minimum_required(VERSION 3.10.2)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 14)
set(PACKAGE_NAME tornadormmkv)
set(BUILD_DIR ./build)
set(RNLIB_DIR ${BUILD_DIR}/react-native-libs/jni/${ANDROID_ABI})

file (GLOB LIBFBJNI_INCLUDE_DIR "${BUILD_DIR}/fbjni-*-headers.jar")

add_subdirectory(../MMKV/Core core)

add_library(
        ${PACKAGE_NAME}
        SHARED
        ${NODEMODULES_DIR}/react-native/ReactCommon/jsi/jsi/jsi.cpp
        ${NODEMODULES_DIR}/react-native/ReactAndroid/src/main/java/com/facebook/react/turbomodule/core/jni/ReactCommon/CallInvokerHolder.cpp
        ../cpp/tornador-mmkv.cpp
        cpp-adapter.cpp
)

target_include_directories(
        ${PACKAGE_NAME}
        PRIVATE
        ../cpp
        ../MMKV/Core
        "${LIBFBJNI_INCLUDE_DIR}"
        "${NODEMODULES_DIR}/react-native/React"
        "${NODEMODULES_DIR}/react-native/React/Base"
        "${NODEMODULES_DIR}/react-native/ReactAndroid/src/main/jni"
        "${NODEMODULES_DIR}/react-native/ReactAndroid/src/main/java/com/facebook/react/turbomodule/core/jni/ReactCommon"
        "${NODEMODULES_DIR}/react-native/ReactCommon"
        "${NODEMODULES_DIR}/react-native/ReactCommon/jsi"
        "${NODEMODULES_DIR}/react-native/ReactCommon/callinvoker"
        "${NODEMODULES_DIR}/react-native/ReactCommon/turbomodule"
        "${NODEMODULES_DIR}/react-native/ReactCommon/turbomodule/core"
)

find_library(
        LOG
        log
)
find_library(
        JSI
        jsi
        PATHS ${RNLIB_DIR}
        NO_CMAKE_FIND_ROOT_PATH
)
find_library(
        FBJNI
        fbjni
        PATHS ${RNLIB_DIR}
        NO_CMAKE_FIND_ROOT_PATH
)

target_link_libraries(
        ${PACKAGE_NAME}
        core
        ${JSI}
        ${LOG}
        ${FBJNI}
)
