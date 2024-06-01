# Target platforms supported by u-boot.
# debian/rules includes this Makefile snippet.

u-boot-rockchip_platforms += lubancat-4-rk3588s
lubancat-4-rk3588s_ddr := rk3588_ddr_lp4_1560MHz_lp5_2736MHz_v1.15.bin
lubancat-4-rk3588s_bl31 := rk3588_bl31_v1.44.elf
lubancat-4-rk3588s_pkg := lubancat-4

u-boot-rockchip_platforms += lubancat-5-rk3588
lubancat-5-rk3588_ddr := rk3588_ddr_lp4_1560MHz_lp5_2736MHz_v1.15.bin
lubancat-5-rk3588_bl31 := rk3588_bl31_v1.44.elf
lubancat-5-rk3588_pkg := lubancat-5
