
LIBS = GL glut dl

D_COMPILER_FLAGS = -g -gs -gc
D_LINKER_FLAGS=$(shell bash -c 'for i in ${LIBS}; do echo -L-l$${i}; done')

DERELICT_SOURCES = $(shell find derelict/ -name \*.d)
PROJECT_SOURCES = $(shell find src/ -name \*.d)

D_SOURCES = ${PROJECT_SOURCES}

DC=dmd
#DC = gdc

# -of for dmd, -o for gdc
OUTPUT_FLAG = "-of"
#OUTPUT_FLAG = "-o"

derelict.o: ${DERELICT_SOURCES}
	${DC} $^ -c -of$@

gldemo: ${D_SOURCES} derelict.o
	${DC} $^ ${D_COMPILER_FLAGS} ${D_LINKER_FLAGS} ${OUTPUT_FLAG}$@

run: gldemo
	./gldemo

clean:
	rm gldemo
