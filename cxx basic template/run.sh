#!/bin/bash

GL_FLAGS=$(pkg-config --cflags --libs gl)
GLEW_FLAGS=$(pkg-config --cflags --libs glew)
LIB_FLAGS="${GL_FLAGS} ${GLEW_FLAGS} -lglut"
COMPILER_FLAGS="-Wall -g -std=c++11 ${LIB_FLAGS}"

#CPLUSPLUS=g++
CPLUSPLUS=clang++

${CPLUSPLUS} gltest.cpp ${COMPILER_FLAGS} && ./a.out 
