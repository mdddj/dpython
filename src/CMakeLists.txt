# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(dpython_library VERSION 0.0.1 LANGUAGES C)

add_library(dpython SHARED
  "dpython.c"
)

set_target_properties(dpython PROPERTIES
  PUBLIC_HEADER dpython.h
  OUTPUT_NAME "dpython"
)

target_compile_definitions(dpython PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(dpython PRIVATE "-Wl,-z,max-page-size=16384")
endif()
