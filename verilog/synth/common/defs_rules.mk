
COREMESH_VERILOG_SYNTH_COMMONDIR := $(dir $(lastword $(MAKEFILE_LIST)))
COREMESH_DIR := $(abspath $(COREMESH_VERILOG_SYNTH_COMMONDIR)/../../..)
PACKAGES_DIR := $(COREMESH_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

include $(COREMESH_DIR)/verilog/rtl/defs_rules.mk
include $(DV_MK)
else # Rules

include $(DV_MK)

endif
