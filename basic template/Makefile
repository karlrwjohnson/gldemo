
LIB_FLAGS = -lGL -lglut  -ldl

D_LINKER_FLAGS=$(shell bash -c 'for i in ${LIB_FLAGS}; do echo -L$${i}; done')

DERELICT_SOURCE_LOC = ../derelict
DERELICT_SOURCES = $(shell find ${DERELICT_SOURCE_LOC} -name \*.d)

D_COMPILER_FLAGS = -g -gs -gc

DC=dmd

gltest: gltest.d glut.d derelict.o
	${DC} $^ -I.. ${D_COMPILER_FLAGS} ${D_LINKER_FLAGS}

derelict.o: ${DERELICT_SOURCES}
	${DC} $^ -c -of$@

