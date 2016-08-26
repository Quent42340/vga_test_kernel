#-------------------------------------------------------------------------------
TARGET		= myos
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
AS			= nasm
CC			= i686-elf-gcc
CXX			= i686-elf-g++
LD			= $(CC)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
ASDIR		= asm
SRCDIR		= source
INCDIR		= include
CONFDIR		= conf
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
ASFLAGS		= -felf32
CFLAGS		= -ffreestanding -O2 -Wall -Wextra -std=gnu99
CXXFLAGS	= -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti -std=c++11
LDFLAGS		= -ffreestanding -O2 -nostdlib -lgcc

CFLAGS		+= -I$(INCDIR)
CXXFLAGS	+= -I$(INCDIR)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
ASFILES		= $(wildcard $(ASDIR)/*.s)
CFILES		= $(wildcard $(SRCDIR)/*c)
CPPFILES	= $(wildcard $(SRCDIR)/*cpp)
LDFILE		= $(CONFDIR)/linker.ld

OFILES		= $(ASFILES:.s=.o) $(CFILES:.c=.o) $(CPPFILES:.cpp=.o)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
all: $(TARGET).bin
#-------------------------------------------------------------------------------
	@echo "Done for $(notdir $<)"

#-------------------------------------------------------------------------------
$(TARGET).bin: $(OFILES) $(LDFILE)
#-------------------------------------------------------------------------------
	@echo "Linking..."
	@$(LD) -T $(LDFILE) -o $(TARGET).bin $(OFILES) $(LDFLAGS)

#-------------------------------------------------------------------------------
%.o: %.s
#-------------------------------------------------------------------------------
	@echo "=>" $(notdir $<)
	@$(AS) $(ASFLAGS) $< -o $@

#-------------------------------------------------------------------------------
%.o: %.c
#-------------------------------------------------------------------------------
	@echo "=>" $(notdir $<)
	@$(CC) $(CFLAGS) -c $< -o $@

#-------------------------------------------------------------------------------
%.o: %.cpp
#-------------------------------------------------------------------------------
	@echo "=>" $(notdir $<)
	@$(CXX) $(CXXFLAGS) -c $< -o $@

#-------------------------------------------------------------------------------
run:
#-------------------------------------------------------------------------------
	@echo "Running..."
	@qemu-system-i386 -kernel myos.bin

#-------------------------------------------------------------------------------
clean:
#-------------------------------------------------------------------------------
	@rm -f $(OFILES)

#-------------------------------------------------------------------------------
fclean: clean
#-------------------------------------------------------------------------------
	@rm -f $(TARGET).bin

#-------------------------------------------------------------------------------
re: fclean all
#-------------------------------------------------------------------------------

.PHONY: run clean fclean re
