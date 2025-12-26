cmake_minimum_required(VERSION 3.10)
project(TennisAnalyzer VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Compiler options
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Include directories
include_directories(include)

# Library source files
set(LIB_SOURCES
    src/tennis_analyzer.cpp
)

# Create static library
add_library(tennis_analyzer STATIC ${LIB_SOURCES})

# Set output directory
set_target_properties(tennis_analyzer PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
)

# Install library
install(TARGETS tennis_analyzer
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

install(FILES include/tennis_analyzer.hpp
    DESTINATION include
)

# Example executable (optional)
option(BUILD_EXAMPLE "Build example program" ON)

if(BUILD_EXAMPLE)
    add_executable(tennis_analyzer_example
        example/main.cpp
    )
    
    target_link_libraries(tennis_analyzer_example tennis_analyzer)
    
    set_target_properties(tennis_analyzer_example PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
    
    install(TARGETS tennis_analyzer_example
        RUNTIME DESTINATION bin
    )
endif()

# Testing (optional)
enable_testing()
option(BUILD_TESTS "Build tests" OFF)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()

