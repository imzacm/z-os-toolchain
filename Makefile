include ./config.mk
include ./sources.mk

.PHONY: all clean cargo nasm clean-nasm binutils clean-binutils gcc clean-gcc xorriso clean-xorriso grub clean-grub

all: cargo nasm binutils gcc xorriso grub

clean:
	@rm -rf $(SRC_DIR) $(BUILD_DIR)

clean-nasm:
	@rm -rf $(SRC_DIR)/$(NASM_DIR_NAME) $(BUILD_DIR)/$(NASM_DIR_NAME)

clean-binutils:
	@rm -rf $(SRC_DIR)/$(BINUTILS_DIR_NAME) $(BUILD_DIR)/$(BINUTILS_DIR_NAME)

clean-gcc:
	@rm -rf $(SRC_DIR)/$(GCC_DIR_NAME) $(BUILD_DIR)/$(GCC_DIR_NAME)

clean-xorriso:
	@rm -rf $(SRC_DIR)/$(XORRISO_DIR_NAME) $(BUILD_DIR)/$(XORRISO_DIR_NAME)

clean-grub:
	@rm -rf $(SRC_DIR)/$(GRUB_DIR_NAME) $(BUILD_DIR)/$(GRUB_DIR_NAME)

cargo:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	@rustup update

nasm: $(PREFIX)/bin/nasm
	@$(PREFIX)/bin/nasm --version

binutils: $(PREFIX)/bin/$(TARGET)-ld
	@$(PREFIX)/bin/$(TARGET)-ld --version

gcc: $(PREFIX)/bin/$(TARGET)-gcc
	@$(PREFIX)/bin/$(TARGET)-gcc --version

xorriso: $(PREFIX)/bin/xorriso
	@$(PREFIX)/bin/xorriso --version

grub: $(PREFIX)/bin/grub-mkrescue
	@$(PREFIX)/bin/grub-mkrescue --version

$(PREFIX)/bin/nasm: $(BUILD_DIR)/$(NASM_DIR_NAME)
	@cd $(BUILD_DIR)/$(NASM_DIR_NAME) && \
	  make && make strip && make install

$(PREFIX)/bin/$(TARGET)-ld: $(BUILD_DIR)/$(BINUTILS_DIR_NAME)
	@cd $(BUILD_DIR)/$(BINUTILS_DIR_NAME) && \
	  make && make install

$(PREFIX)/bin/$(TARGET)-gcc: $(BUILD_DIR)/$(GCC_DIR_NAME)
	@cd $(BUILD_DIR)/$(GCC_DIR_NAME) && \
      make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc

$(PREFIX)/bin/xorriso: $(BUILD_DIR)/$(XORRISO_DIR_NAME)
	@cd $(BUILD_DIR)/$(XORRISO_DIR_NAME) && \
	  make && strip ./xorriso/xorriso && make install

$(PREFIX)/bin/grub-mkrescue: $(BUILD_DIR)/$(GRUB_DIR_NAME)
	@cd $(BUILD_DIR)/$(GRUB_DIR_NAME) && \
	  make && make install

$(BUILD_DIR)/$(NASM_DIR_NAME): $(BUILD_DIR) $(SRC_DIR)/$(NASM_DIR_NAME)
	@mkdir -p $@
	@cd $@ && \
	  $(SRC_DIR)/$(NASM_DIR_NAME)/configure --prefix="$(PREFIX)"

$(BUILD_DIR)/$(BINUTILS_DIR_NAME): $(BUILD_DIR) $(SRC_DIR)/$(BINUTILS_DIR_NAME)
	@mkdir -p $@
	@cd $@ && \
	  $(SRC_DIR)/$(BINUTILS_DIR_NAME)/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror

$(BUILD_DIR)/$(GCC_DIR_NAME): $(BUILD_DIR) $(SRC_DIR)/$(GCC_DIR_NAME)
	@mkdir -p $@
	@cd $@ && \
	  $(SRC_DIR)/$(GCC_DIR_NAME)/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c,c++ --without-headers

$(BUILD_DIR)/$(XORRISO_DIR_NAME): $(BUILD_DIR) $(SRC_DIR)/$(XORRISO_DIR_NAME)
	@mkdir -p $@
	@cd $@ && \
	  $(SRC_DIR)/$(XORRISO_DIR_NAME)/configure --prefix="$(PREFIX)"

$(BUILD_DIR)/$(GRUB_DIR_NAME): $(BUILD_DIR) $(SRC_SIR)/$(GRUB_DIR_NAME)
	@mkdir -p $@
	@cd $@ && \
	  $(SRC_DIR)/$(GRUB_DIR_NAME)/configure --disable-werror --prefix="$(PREFIX)" --target=$(TARGET) TARGET_CC=$(PREFIX)/bin/$(TARGET)-gcc TARGET_OBJCOPY=$(PREFIX)/bin/$(TARGET)-objcopy TARGET_STRIP=$(PREFIX)/bin/$(TARGET)-strip TARGET_NM=$(PREFIX)/bin/$(TARGET)-nm TARGET_RANLIB=$(PREFIX)/bin/$(TARGET)-ranlib

$(SRC_DIR)/$(NASM_DIR_NAME): $(SRC_DIR)
	@curl -s $(NASM_SRC_URL) | tar xJ -C $(SRC_DIR)

$(SRC_DIR)/$(BINUTILS_DIR_NAME): $(SRC_DIR)
	@curl -s $(BINUTILS_SRC_URL) | tar xJ -C $(SRC_DIR)

$(SRC_DIR)/$(GCC_DIR_NAME): $(SRC_DIR)
	@curl -s $(GCC_SRC_URL) | tar xJ -C $(SRC_DIR)

$(SRC_DIR)/$(XORRISO_DIR_NAME): $(SRC_DIR)
	@curl -s $(XORRISO_SRC_URL) | tar xz -C $(SRC_DIR)

$(SRC_SIR)/$(GRUB_DIR_NAME): $(SRC_DIR)
	@curl -s $(GRUB_SRC_URL) | tar xJ -C $(SRC_DIR)

$(BUILD_DIR):
	@mkdir -p $@

$(SRC_DIR):
	@mkdir -p $@
