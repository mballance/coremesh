
COREMESH_VERILOG_DV_COMMONDIR := $(dir $(lastword $(MAKEFILE_LIST)))
COREMESH_DIR := $(abspath $(COREMESH_VERILOG_DV_COMMONDIR)/../../..)
PACKAGES_DIR := $(COREMESH_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python3 -m mkdv mkfile)

ifneq (1,$(RULES))

MKDV_PYTHONPATH += $(COREMESH_VERILOG_DV_COMMONDIR)/python
include $(PACKAGES_DIR)/fwrisc/verilog/dbg/defs_rules.mk
include $(COREMESH_DIR)/verilog/rtl/defs_rules.mk

include $(DV_MK)
else # Rules

include $(DV_MK)

endif

