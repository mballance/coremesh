
# Cluster organization

Each cluster contains:
- local memory used for IPC mailboxes
- local INTC
- local wide (cache line-width) memory crossbar
- DMA engine (?)
- L1 cache (?)

Expect to be able to:
- Send an interrupt to any chip/tile/core in the system
- Write to local memory for any chip/tile in the system

Each chip contains:
- N clusters

- NOC router connecting clusters

- chip-local SRAM memory

- Chip-local external interfaces
  - hyperram memory controller

  - SPI Flash controller
    - okay to have this on a wishbone interconnect, since it's low-speed
  
  - Peripheral devices
    - SPI controllers
    - UART (?)
    - Ethernet (?)

  - chip boot-control block
    - Controls the next chip in the boot chain

