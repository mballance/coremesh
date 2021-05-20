'''
Created on May 12, 2021

@author: mballance
'''

import pybfms
from generic_sram_bfms.generic_sram_byte_en_target_bfm import GenericSramByteEnTargetBFM
from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
import cocotb

class TestBase(object):
    
    async def init(self):
        await pybfms.init()
        
        self.sram_bfm : GenericSramByteEnTargetBFM = pybfms.find_bfm(".*u_sram_bfm")
        
        for i in range(16):
            self.sram_bfm.write_nb(i+4*i, 0x6f, 0xF)

        await cocotb.triggers.Timer(1, "ms")

        return        
        sw_image = cocotb.plusargs["sw.image"]
        
        # TODO: load the software image
        print("Note: loading image " + sw_image)    
        with open(sw_image, "rb") as f:
            elffile = ELFFile(f)
        
            # Find the section that contains the data we need
            section = None
            for i in range(elffile.num_sections()):
                shdr = elffile._get_section_header(i)
                if shdr['sh_size'] != 0 and (shdr['sh_flags'] & 0x2):
                    section = elffile.get_section(i)
                    data = section.data()
                    addr = shdr['sh_addr']
                    
                    j = 0
                    while j < len(data):
                        word = (data[j+0] << (8*0))
                        word |= (data[j+1] << (8*1)) if j+1 < len(data) else 0
                        word |= (data[j+2] << (8*2)) if j+2 < len(data) else 0
                        word |= (data[j+3] << (8*3)) if j+3 < len(data) else 0
                        print("Write: " + hex(addr) + " " + hex(word))
                        self.sram_bfm.write_nb(int((addr & 0x3FFFFF)/4), word, 0xF)
                        addr += 4
                        j += 4        
        
    async def run(self):
        pass


@cocotb.test()
async def entry(dut):
    t = TestBase()
    await t.init()
    await t.run()
        
        
        