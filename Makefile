
DC=dmd
#DC=gdc
#DC=ldc2

# External library dependencies
LIBS = GL glut dl

LIB_FLAGS = $(shell bash -c 'for i in ${LIBS}; do echo -L-l$${i}; done')

D_UNITTEST_FLAGS = -unittest

DERELICT_SOURCES = $(shell find derelict/ -name \*.d)
PROJECT_SOURCES = $(shell find src/ -name \*.d)

D_SOURCES = ${PROJECT_SOURCES}

OUTPUT_DIR = bin

ifeq (${DC}, dmd)
	D_COMPILER_FLAGS = -g -gs -gc
	OUTPUT_FLAG = -od${OUTPUT_DIR} "-of"
endif
ifeq (${DC}, gdc)
	D_COMPILER_FLAGS = -g
	OUTPUT_FLAG = -od${OUTPUT_DIR} "-o"
endif
ifeq (${DC}, ldc2)
	D_COMPILER_FLAGS = -g -singleobj
	OUTPUT_FLAG = -od${OUTPUT_DIR} "-of"
endif

${OUTPUT_DIR}/gldemo: ${D_SOURCES} ${OUTPUT_DIR}/derelict.o
	mkdir -p ${OUTPUT_DIR}
	${DC} $^ ${D_COMPILER_FLAGS} ${LIB_FLAGS} ${OUTPUT_FLAG}$@

${OUTPUT_DIR}/unittests: ${D_SOURCES} ${OUTPUT_DIR}/derelict.o
	mkdir -p ${OUTPUT_DIR}
	${DC} $^ ${D_UNITTEST_FLAGS} ${D_COMPILER_FLAGS} ${LIB_FLAGS} ${OUTPUT_FLAG}$@

${OUTPUT_DIR}/derelict.o: ${DERELICT_SOURCES}
	mkdir -p ${OUTPUT_DIR}
	${DC} $^ ${D_COMPILER_FLAGS} -c ${OUTPUT_FLAG}$@

run: ${OUTPUT_DIR}/gldemo
	${OUTPUT_DIR}/gldemo

rununittests: ${OUTPUT_DIR}/unittests
	${OUTPUT_DIR}/unittests

valgrind: ${OUTPUT_DIR}/gldemo
	valgrind ${OUTPUT_DIR}/gldemo

valgrindunittests: ${OUTPUT_DIR}/unittests
	valgrind ${OUTPUT_DIR}/unittests

clean:
	rm -r bin
