/* SPDX-License-Identifier:     GPL-2.0 */
/*
 * Copyright (C) 2023 Rockchip Electronics Co., Ltd
 */

#ifndef _PHY_ROCKCHIP_NANENG_COMBPHY_H
#define _PHY_ROCKCHIP_NANENG_COMBPHY_H

#if CONFIG_IS_ENABLED(PHY_ROCKCHIP_NANENG_COMBOPHY)
int rockchip_combphy_usb3_uboot_init(fdt_addr_t phy_addr);
#else
int rockchip_combphy_usb3_uboot_init(fdt_addr_t phy_addr)
{
	return -ENOTSUPP;
}
#endif

#endif /* _PHY_ROCKCHIP_NANENG_COMBPHY_H */
