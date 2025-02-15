message(STATUS "This is CMAKE_CURRENT_SOURCE_DIR dir " ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

file(GLOB_RECURSE ALL_SRC *.cpp *.c)
set(MAIN_SRC ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)
message(STATUS "MAIN SRC: " ${MAIN_SRC})

foreach (F ${ALL_SRC})
    if (NOT ${F} STREQUAL ${MAIN_SRC})
        set(LIB_SRC ${LIB_SRC} ${F})
        message(STATUS "Use " ${F})
    endif ()
endforeach (F)

find_package(fmt REQUIRED)

add_library(math STATIC ${LIB_SRC})

add_executable(cpp_project_starter main.cpp)

target_link_libraries(cpp_project_starter math fmt)
