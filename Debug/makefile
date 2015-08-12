TARGET=skelton

# GNU ARM Embedded Toolchain
CC=$(TOOLS_DIR)/arm-none-eabi-gcc
CXX=$(TOOLS_DIR)/arm-none-eabi-g++
LD=$(TOOLS_DIR)/arm-none-eabi-ld
AR=$(TOOLS_DIR)/arm-none-eabi-ar
AS=$(TOOLS_DIR)/arm-none-eabi-as
CP=$(TOOLS_DIR)/arm-none-eabi-objcopy
OD=$(TOOLS_DIR)/arm-none-eabi-objdump
NM=$(TOOLS_DIR)/arm-none-eabi-nm
SIZE=$(TOOLS_DIR)/arm-none-eabi-size
A2L=$(TOOLS_DIR)/arm-none-eabi-addr2line

# This is the directory containing the firmware package,
# the unzipped folder downloaded from here:
# http://www.st.com/web/en/catalog/tools/PF257904
STM_DIR=../../STM32F4_FW_v1.5.1

# This is where the source files are located,
# which are not in the current directory
# (the sources of the standard peripheral library, which we use)
# see also "info:/make/Selective Search" in Konqueror
STM_SRC = $(STM_DIR)/STM32F4xx_StdPeriph_Driver/src

# Tell make to look in that folder if it cannot find a source
# in the current directory
vpath %.c $(STM_SRC) ../src
vpath %.s ../src

# My source file
C_SRCS = main.c
C_SRCS += stm32f4xx_it.c
C_SRCS += newlib_stubs.c

# Contains initialisation code and must be compiled into
# our project. This file is in the current directory and
# was writen by ST.
C_SRCS += system_stm32f4xx.c
C_SRCS += stm32f429i_discovery.c

# These source files implement the functions we use.
# make finds them by searching the vpath defined above.
C_SRCS += stm32f4xx_rcc.c 
C_SRCS += stm32f4xx_gpio.c
C_SRCS += stm32f4xx_i2c.c
C_SRCS += stm32f4xx_dma.c
C_SRCS += stm32f4xx_syscfg.c
C_SRCS += stm32f4xx_exti.c
C_SRCS += stm32f4xx_usart.c
C_SRCS += misc.c

# Startup file written by ST
# The assembly code in this file is the first one to be
# executed. Normally you do not change this file.
A_SRCS += startup_stm32f429_439xx.s

# The header files we use are located here
INC_DIRS = $(STM_DIR)
INC_DIRS += $(STM_DIR)/CMSIS/Include
INC_DIRS += $(STM_DIR)/CMSIS/Device/ST/STM32F4xx/Include
INC_DIRS += $(STM_DIR)/STM32F4xx_StdPeriph_Driver/inc
INC_DIRS += ../inc

# directories to be searched for header files
INCLUDES = $(addprefix -I,$(INC_DIRS))

# #defines needed when working with the STM library
DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F429_439xx
# if you use the following option, you must implement the function 
#    assert_failed(uint8_t* file, uint32_t line)
# because it is conditionally used in the library
DEFS   += -DUSE_FULL_ASSERT

OBJS+=$(A_SRCS:%.s=objs/%.o)
OBJS+=$(C_SRCS:%.c=objs/%.o)
##OBJS = $(patsubst %.c,objs/%.o,$(notdir $(C_SRCS)))
##OBJS += $(patsubst %.s,objs/%.o,$(notdir $(A_SRCS)))

######################################################################
#                         SETUP TOOLS                                #
######################################################################

# This is the path to the toolchain
# (we don't put our toolchain on $PATH to keep the system clean)
TOOLS_DIR = /opt/toolchain/gcc-arm-none-eabi-4_9-2015q2/bin

###
# MCU FLAGS
MCFLAGS=-mcpu=cortex-m4 -mthumb -mlittle-endian \
-mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork
# COMPILE FLAGS
CFLAGS=-c $(MCFLAGS) $(DEFS) $(INCLUDES) -std=c99
CXXFLAGS=-c $(MCFLAGS) $(DEFS) $(INCLUDES) -std=c++11
CXXFLAGS+=-U__STRICT_ANSI__ # Undefine __STRICT_ANSI__ to compile Stream.cpp using c++11. This is a dirty hack!
# LINKER FLAGS
LDSCRIPT=../stm32f429_flash.ld
LDFLAGS =-T $(LDSCRIPT) $(MCFLAGS) --specs=nosys.specs $(INCLUDES_LIBS) $(LINK_LIBS)

.PHONY: release debug build clean
all: build
	
release: CFLAGS += -O2
release: CXXFLAGS += -O2
release: LDFLAGS += -O2
release: build

debug: CFLAGS += -g
debug: CXXFLAGS += -g
debug: LDFLAGS += -g
debug: build

build: $(TARGET).hex

$(TARGET).hex: $(TARGET).elf
	$(CP) -O ihex $< $@
	@echo "Objcopy from ELF to IHEX complete!\n"
	
$(TARGET).elf: $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $(TARGET).elf
	
objs/%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Compiled "$<"!\n"
	
objs/%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	@echo "Compiled "$<"!\n"
	
objs/%.o: %.s
	$(CC) $(CFLAGS) $< -o $@
	@echo "Assambled "$<"!\n"

clean:
	rm -rf $(OBJS) $(TARGET).elf $(TARGET).hex
