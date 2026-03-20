cmake_minimum_required(VERSION 3.19)


project(mypin C CXX)


add_library(${PROJECT_NAME} STATIC 
    mypin.cpp
)

target_include_directories(${PROJECT_NAME} PUBLIC .)