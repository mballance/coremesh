MKDV_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
SYNTH_DIR := $(dir $(MKDV_MK))
MKDV_TOOL ?= openlane

TOP_MODULE = coremesh_cluster_sram

QUARTUS_FAMILY ?= "Cyclone V"
QUARTUS_DEVICE ?= 5CGXFC7C7F23C8

#QUARTUS_FAMILY ?= "Cyclone 10 LP"
#QUARTUS_DEVICE ?= 10CL025YE144A7G
SDC_FILE=$(SYNTH_DIR)/$(TOP_MODULE).sdc

include $(SYNTH_DIR)/../common/defs_rules.mk

RULES := 1

include $(SYNTH_DIR)/../common/defs_rules.mk


