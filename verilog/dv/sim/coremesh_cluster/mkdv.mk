
MKDV_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR := $(dir $(MKDV_MK))
MKDV_TOOL ?= icarus

TOP_MODULE = coremesh_cluster_tb

MKDV_VL_SRCS += $(TEST_DIR)/coremesh_cluster_tb.sv

MKDV_PLUGINS += cocotb pybfms
PYBFMS_MODULES += generic_sram_bfms

MKDV_COCOTB_MODULE ?= coremesh_tests.test_base

include $(TEST_DIR)/../../common/defs_rules.mk

RULES := 1

include $(TEST_DIR)/../../common/defs_rules.mk
