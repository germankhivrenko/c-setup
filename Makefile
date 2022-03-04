CC=gcc
CFLAGS=-Wall -Wextra -Isrc -rdynamic -DNDEBUG $(OPTFLAGS)
LIBS=-ldl $(OPTLIBS)

SRC_DIR=./src
OBJ_DIR=./objs
BUILD_DIR=./build
TESTS_DIR=./tests

SOURCES=$(wildcard src/**/*.c src/*.c)
OBJECTS=$(SOURCES:%.c=%.o)

TEST_SOURCES=$(wildcard $(TESTS_DIR)/*.test.c)
TESTS=$(patsubst %.c,%,$(TEST_SOURCES))

SLIB_TARGET=$(BUILD_DIR)/my_lib.a
DLIB_TARGET=$(patsubst %.a,%.so,$(SLIB_TARGET))

dev: CFLAGS += -g
dev: target

target: build $(SLIB_TARGET) $(DLIB_TARGET)

$(SLIB_TARGET): CFLAGS += -fPIC
$(SLIB_TARGET): $(OBJECTS)
	ar rcs $@ $(OBJECTS)
	ranlib $@

$(DLIB_TARGET): $(OBJECTS)
	$(CC) -shared -o $@ $(OBJECTS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

$(TESTS_DIR)/%: $(TESTS_DIR)/%.c
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

.PHONY: tests
tests: OPTLIBS += $(SLIB_TARGET) $(DLIB_TARGET)
tests: $(TESTS) 
# sh ./tests/runtests.sh

build:
#	mkdir -p $(OBJ_DIR)
	mkdir -p $(BUILD_DIR)
	mkdir -p $(TESTS_DIR)

clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)
	rm $(OBJECTS)
	rm $(TESTS)

# todo: setup `bear make` (generates compile_commands.json)
