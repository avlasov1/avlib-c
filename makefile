CC := arm-none-eabi-gcc
LD := arm-none-eabi-gcc
SIZE := arm-none-eabi-size
OBJCOPY := arm-none-eabi-objcopy

TARGET := avlib-c

BUILD_DIR := ./build

LINKER_SCRIPT := linker.ld
LD_FLAGS := -mcpu=cortex-m0 -mfloat-abi=soft -mthumb -Wl,-gc-sections --specs=nosys.specs
START_GROUP := -Wl,--start-group
END_GROUP := -Wl,--end-group

all: $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR):
	-mkdir -p $(BUILD_DIR)

ring-buffer:
	$(MAKE) -C ring-buffer

test:
	$(MAKE) -C test

OBJS := $(wildcard $(BUILD_DIR)/*.o)

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/$(TARGET).elf: ring-buffer test $(OBJS) $(LINKER_SCRIPT)
	$(LD) $(LD_FLAGS) $(START_GROUP) $(OBJS) $(END_GROUP) -o $@
	$(SIZE) $@




.PHONY: ring-buffer test clean
clean:
	rm -r $(BUILD_DIR)
