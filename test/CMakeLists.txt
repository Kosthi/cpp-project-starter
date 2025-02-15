find_package(GTest REQUIRED)
if (GTEST_FOUND)
    message(STATUS "GTest found: ${GTEST_LIBRARIES}")
else ()
    message(FATAL_ERROR "GTest not found!")
endif ()

include(GoogleTest)

include_directories(${PROJECT_SOURCE_DIR}/src/)

file(GLOB_RECURSE ALL_SRC *.cpp)

foreach (F ${ALL_SRC})
    get_filename_component(prjName ${F} NAME_WE)
    message(STATUS "Build ${prjName} according to ${F}")
    add_executable(${prjName} ${F})
    target_link_libraries(${prjName} GTest::gtest_main fmt math)
    add_test(NAME ${prjName} COMMAND ${prjName})
endforeach (F)
