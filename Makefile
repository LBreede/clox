CC      = gcc
CFLAGS  = -Wall -Wextra -std=c11 -g -MMD -MP -Iinclude
SRC_DIR = src
OBJ_DIR = build
TARGET  = clox

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
DEPS = $(OBJS:.o=.d)

DEBUG_FLAGS ?= -DDEBUG_PRINT_CODE -DDEBUG_TRACE_EXECUTION
ifneq ($(RELEASE),)
  DEBUG_FLAGS :=
endif
ifneq ($(NO_DEBUG),)
  DEBUG_FLAGS :=
endif

CFLAGS += $(DEBUG_FLAGS)

ifneq ($(DEBUG_PRINT_CODE),)
  CFLAGS += -DDEBUG_PRINT_CODE
endif
ifneq ($(DEBUG_TRACE_EXECUTION),)
  CFLAGS += -DDEBUG_TRACE_EXECUTION
endif

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $@

-include $(DEPS)

.PHONY: clean run

clean:
	rm -rf $(OBJ_DIR) $(TARGET)

run: $(TARGET)
	./$(TARGET)
