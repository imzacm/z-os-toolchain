TARGET ?= i686-elf
PREFIX ?= $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))/toolchain/prefix
SRC_DIR ?= $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))/toolchain/sources
BUILD_DIR ?= $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))/toolchain/build
