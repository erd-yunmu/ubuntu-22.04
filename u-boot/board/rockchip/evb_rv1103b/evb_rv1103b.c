/*
 * SPDX-License-Identifier:     GPL-2.0+
 *
 * (C) Copyright 2024 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <asm/io.h>
#include <dwc3-uboot.h>
#include <usb.h>

DECLARE_GLOBAL_DATA_PTR;

#define PERI_CRU_BASE			0x20000000
#define PERICRU_PERISOFTRST_CON06	0x0a18
#define GRF_SYS_BASE			0x20150000
#define GRF_SYS_USBPHY_CON0		0x0050
#define GRF_SYS_USBPHY_CON2		0x0058

#ifdef CONFIG_USB_DWC3
static struct dwc3_device dwc3_device_data = {
	.maximum_speed = USB_SPEED_HIGH,
	.base = 0x20b00000,
	.dr_mode = USB_DR_MODE_PERIPHERAL,
	.index = 0,
	.dis_u2_susphy_quirk = 1,
	.usb2_phyif_utmi_width = 16,
};

int usb_gadget_handle_interrupts(void)
{
	dwc3_uboot_handle_interrupt(0);
	return 0;
}

static void usb_reset_otg_controller(void)
{
	writel(0x02000200, PERI_CRU_BASE + PERICRU_PERISOFTRST_CON06);
	mdelay(1);
	writel(0x02000000, PERI_CRU_BASE + PERICRU_PERISOFTRST_CON06);
	mdelay(1);
}

int board_usb_init(int index, enum usb_init_type init)
{
	usb_reset_otg_controller();

	/* Resume usb2 phy to normal mode */
	writel(0x01ff0000, GRF_SYS_BASE + GRF_SYS_USBPHY_CON0);

	/* Select usb utmi bvalid from grf and set bvalid high */
	writel(0xc000c000, GRF_SYS_BASE + GRF_SYS_USBPHY_CON2);

	return dwc3_uboot_init(&dwc3_device_data);
}
#endif
