cmake_minimum_required(VERSION 3.16)
project(app)
add_executable(app code.cpp)
target_include_directories(app PRIVATE mep/common)
target_link_libraries(app gpiod)

add_executable(reset reset.cpp)
target_include_directories(reset PRIVATE mep/common)
target_link_libraries(reset gpiod)
