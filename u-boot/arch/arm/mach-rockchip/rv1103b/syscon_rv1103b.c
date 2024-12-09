/*
 * (C) Copyright 2024 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <syscon.h>
#include <asm/arch/clock.h>

static const struct udevice_id rv1103b_syscon_ids[] = {
	{ .compatible = "rockchip,rv1103b-grf", .data = ROCKCHIP_SYSCON_GRF },
	{ .compatible = "rockchip,rv1103b-ioc", .data = ROCKCHIP_SYSCON_IOC },
	{ }
};

U_BOOT_DRIVER(syscon_rv1103b) = {
	.name = "rv1103b_syscon",
	.id = UCLASS_SYSCON,
	.of_match = rv1103b_syscon_ids,
#if !CONFIG_IS_ENABLED(OF_PLATDATA)
	.bind = dm_scan_fdt_dev,
#endif
};
