
COREMESH_VERILOG_RTLDIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

ifeq (,$(findstring $(COREMESH_VERILOG_RTLDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(COREMESH_VERILOG_RTLDIR)

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
include $(PACKAGES_DIR)/fwrisc/verilog/rtl/defs_rules.mk
include $(PACKAGES_DIR)/fw-wishbone-interconnect/verilog/rtl/defs_rules.mk
include $(PACKAGES_DIR)/fw-wishbone-sram-ctrl/verilog/rtl/defs_rules.mk
MKDV_VL_SRCS += $(wildcard $(COREMESH_VERILOG_RTLDIR)/*.v)

endif

else # Rules

endif
