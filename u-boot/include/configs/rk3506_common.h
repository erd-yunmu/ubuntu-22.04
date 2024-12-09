/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2024 Rockchip Electronics Co., Ltd
 *
 */

#ifndef __CONFIG_RK3506_COMMON_H
#define __CONFIG_RK3506_COMMON_H

#include "rockchip-common.h"

#define COUNTER_FREQUENCY		24000000
#define CONFIG_SYS_MALLOC_LEN		(16 << 20)
#define CONFIG_SYS_CBSIZE		1024
#define CONFIG_SYS_TEXT_BASE		0x00200000
#define CONFIG_SYS_INIT_SP_ADDR		0x00400000
#define CONFIG_SYS_LOAD_ADDR		0x00008000
#define CONFIG_SYS_BOOTM_LEN		(64 << 20)	/* 64M */
#define CONFIG_SYS_SDRAM_BASE		0
#define SDRAM_MAX_SIZE			0xc0000000
#define CONFIG_SYS_NONCACHED_MEMORY	(1 << 20)	/* 1 MiB */

/* SPL */
#define CONFIG_SPL_FRAMEWORK
#define CONFIG_SPL_TEXT_BASE		0x03f00000
#define CONFIG_SPL_MAX_SIZE		0x40000
#define CONFIG_SPL_BSS_START_ADDR	0x03fe0000
#define CONFIG_SPL_BSS_MAX_SIZE		0x20000
#define CONFIG_SPL_STACK		0x03fe0000

#define GICD_BASE			0xff581000
#define GICC_BASE			0xff582000

#define ATAGS_OFFSET			0x62000
#define ATAGS_SIZE			0x01000

/* MMC/SD IP block */
#define CONFIG_BOUNCE_BUFFER

#ifndef CONFIG_SPL_BUILD
/* usb mass storage */
#define CONFIG_USB_FUNCTION_MASS_STORAGE
#define CONFIG_ROCKUSB_G_DNL_PID	0x350f

#define CONFIG_LIB_HW_RAND
#define CONFIG_PREBOOT

/*
 *     fdt:  396K - 524K
 *   Image:  1M+32k - 16M
 *  zImage:  16M - 24M
 * ramdisk:  24M - ...
 */
#define ENV_MEM_LAYOUT_SETTINGS \
	"scriptaddr=0x00b00000\0"	\
	"pxefile_addr_r=0x00c00000\0"	\
	"fdt_addr_r=0x00063000\0"	\
	"kernel_addr_r=0x00108000\0"	\
	"kernel_addr_c=0x01100000\0"	\
	"ramdisk_addr_r=0x01800000\0"

#include <config_distro_bootcmd.h>

#define CONFIG_EXTRA_ENV_SETTINGS \
	ENV_MEM_LAYOUT_SETTINGS \
	"partitions=" PARTS_RKIMG \
	ROCKCHIP_DEVICE_SETTINGS \
	RKIMG_DET_BOOTDEV \
	BOOTENV

#undef RKIMG_BOOTCOMMAND
#ifdef CONFIG_FIT_SIGNATURE
#define RKIMG_BOOTCOMMAND		\
	"boot_fit;"
#else
#define RKIMG_BOOTCOMMAND		\
	"boot_fit;"			\
	"boot_android ${devtype} ${devnum};"
#endif

#endif
#endif
