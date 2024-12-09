/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _ROCKCHIP_PLAT_IRQ_H_
#define _ROCKCHIP_PLAT_IRQ_H_

#if defined(CONFIG_ROCKCHIP_RK3128)
#define GPIO0_PHYS			0x2007C000
#define GPIO1_PHYS			0x20080000
#define GPIO2_PHYS			0x20084000
#define GPIO3_PHYS			0x20088000

#define GIC_IRQS_NR			(4 * 32)
#define GPIO_IRQS_NR			(4 * 32)

#define GPIO_BANK_NUM			4
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			42
#define IRQ_TIMER1			61
#define IRQ_GPIO0			68
#define IRQ_GPIO1			69
#define IRQ_GPIO2			70
#define IRQ_GPIO3			71

#elif defined(CONFIG_ROCKCHIP_RK322X)
#define GPIO0_PHYS			0x11110000
#define GPIO1_PHYS			0x11120000
#define GPIO2_PHYS			0x11130000
#define GPIO3_PHYS			0x11140000

#define GIC_IRQS_NR			(4 * 32)
#define GPIO_IRQS_NR			(4 * 32)

#define GPIO_BANK_NUM			4
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			55
#define IRQ_TIMER1			76
#define IRQ_PWM				82
#define IRQ_GPIO0			83
#define IRQ_GPIO1			84
#define IRQ_GPIO2			85
#define IRQ_GPIO3			86

#elif defined(CONFIG_ROCKCHIP_RK3288)
#define GPIO0_PHYS			0xFF750000
#define GPIO1_PHYS			0xFF780000
#define GPIO2_PHYS			0xFF790000
#define GPIO3_PHYS			0xFF7A0000
#define GPIO4_PHYS			0xFF7B0000
#define GPIO5_PHYS			0xFF7C0000
#define GPIO6_PHYS			0xFF7D0000
#define GPIO7_PHYS			0xFF7E0000
#define GPIO8_PHYS			0xFF7F0000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(9 * 32)

#define GPIO_BANK_NUM			9
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			55
#define IRQ_TIMER1			99
#define IRQ_PWM				110
#define IRQ_GPIO0			113
#define IRQ_GPIO1			114
#define IRQ_GPIO2			115
#define IRQ_GPIO3			116
#define IRQ_GPIO4			117
#define IRQ_GPIO5			118
#define IRQ_GPIO6			119
#define IRQ_GPIO7			120
#define IRQ_GPIO8			121

#elif defined(CONFIG_ROCKCHIP_RK3328)
#define	GPIO0_PHYS			0xFF210000
#define	GPIO1_PHYS			0xFF220000
#define	GPIO2_PHYS			0xFF230000
#define	GPIO3_PHYS			0xFF240000

#define GIC_IRQS_NR			(4 * 32)
#define GPIO_IRQS_NR			(4 * 32)

#define GPIO_BANK_NUM			4
#define GPIO_BANK_PINS			32

#define IRQ_TIMER1			76
#define IRQ_PWM				82
#define IRQ_GPIO0			83
#define IRQ_GPIO1			84
#define IRQ_GPIO2			85
#define IRQ_GPIO3			86

#elif defined(CONFIG_ROCKCHIP_RK3368)
#define GPIO0_PHYS			0xFF750000
#define GPIO1_PHYS			0xFF780000
#define GPIO2_PHYS			0xFF790000
#define GPIO3_PHYS			0xFF7A0000

#define GIC_IRQS_NR                     (5 * 32)
#define GPIO_IRQS_NR                    (4 * 32)

#define GPIO_BANK_NUM			4
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			98
#define IRQ_TIMER1			99
#define IRQ_PWM				110
#define IRQ_GPIO0			113
#define IRQ_GPIO1			114
#define IRQ_GPIO2			115
#define IRQ_GPIO3			116

#elif defined(CONFIG_ROCKCHIP_RK3399)
#define GPIO0_PHYS			0xFF720000
#define GPIO1_PHYS			0xFF730000
#define GPIO2_PHYS			0xFF780000
#define GPIO3_PHYS			0xFF788000
#define GPIO4_PHYS			0xFF790000

#define IRQ_GPIO0			46
#define IRQ_GPIO1			47
#define IRQ_GPIO2			48
#define IRQ_GPIO3			49
#define IRQ_GPIO4			50
#define IRQ_PWM				93
#define IRQ_TIMER1			114	/* non-secure */

#define GIC_IRQS_NR			(6 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#elif defined(CONFIG_ROCKCHIP_PX30)
#define GPIO0_PHYS			0xff040000
#define GPIO1_PHYS			0xff250000
#define GPIO2_PHYS			0xff260000
#define GPIO3_PHYS			0xff270000

#define IRQ_GPIO0			35
#define IRQ_GPIO1			36
#define IRQ_GPIO2			37
#define IRQ_GPIO3			38
#define IRQ_PWM0			56
#define IRQ_PWM1			57
#define IRQ_TIMER0			62	/* non-secure */
#define IRQ_TIMER1			63	/* non-secure */

#define GIC_IRQS_NR			(4 * 32)
#define GPIO_IRQS_NR			(4 * 32)

#define GPIO_BANK_NUM			4
#define GPIO_BANK_PINS			32

#elif defined(CONFIG_ROCKCHIP_RK3308)
#define GPIO0_PHYS			0xff220000
#define GPIO1_PHYS			0xff230000
#define GPIO2_PHYS			0xff240000
#define GPIO3_PHYS			0xff250000
#define GPIO4_PHYS			0xff260000

#define IRQ_TIMER1			58	/* ch0 ns timer1 */
#define IRQ_GPIO0			72
#define IRQ_GPIO1			73
#define IRQ_GPIO2			74
#define IRQ_GPIO3			75
#define IRQ_GPIO4			76

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#elif defined(CONFIG_ROCKCHIP_RK1808)
#define GPIO0_PHYS			0xff4c0000
#define GPIO1_PHYS			0xff690000
#define GPIO2_PHYS			0xff6a0000
#define GPIO3_PHYS			0xff6b0000
#define GPIO4_PHYS			0xff6c0000

#define IRQ_GPIO0			35
#define IRQ_GPIO1			36
#define IRQ_GPIO2			37
#define IRQ_GPIO3			38
#define IRQ_GPIO4			114

#define IRQ_TIMER0			58
#define IRQ_TIMER1			59

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#elif defined(CONFIG_ROCKCHIP_RV1103B)
#define GPIO0_PHYS			0x20520000
#define GPIO1_PHYS			0x20d80000
#define GPIO2_PHYS			0x20840000

#define GIC_IRQS_NR			159
#define GPIO_IRQS_NR			(3 * 32)

#define GPIO_BANK_NUM			3
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			47
#define IRQ_TIMER1			65

#define IRQ_GPIO0			IRQ_GPIO0_0
#define IRQ_GPIO0_0			107
#define IRQ_GPIO0_1			108
#define IRQ_GPIO0_2			109
#define IRQ_GPIO0_3			110

#define IRQ_GPIO1			IRQ_GPIO1_0
#define IRQ_GPIO1_0			111
#define IRQ_GPIO1_1			112
#define IRQ_GPIO1_2			113
#define IRQ_GPIO1_3			114

#define IRQ_GPIO2			IRQ_GPIO2_0
#define IRQ_GPIO2_0			115
#define IRQ_GPIO2_1			116
#define IRQ_GPIO2_2			117
#define IRQ_GPIO2_3			118

#elif defined(CONFIG_ROCKCHIP_RV1106)
#define GPIO0_PHYS			0xff460000
#define GPIO1_PHYS			0xff620000
#define GPIO2_PHYS			0xff630000
#define GPIO3_PHYS			0xff640000
#define GPIO4_PHYS			0xff650000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			117
#define IRQ_TIMER1			57
#define IRQ_GPIO0			66
#define IRQ_GPIO1			67
#define IRQ_GPIO2			68
#define IRQ_GPIO3			69
#define IRQ_GPIO4			70

#elif defined(CONFIG_ROCKCHIP_RV1126)
#define GPIO0_PHYS			0xff460000
#define GPIO1_PHYS			0xff620000
#define GPIO2_PHYS			0xff630000
#define GPIO3_PHYS			0xff640000
#define GPIO4_PHYS			0xff650000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_USB_OTG			117
#define IRQ_TIMER1			57
#define IRQ_GPIO0			66
#define IRQ_GPIO1			67
#define IRQ_GPIO2			68
#define IRQ_GPIO3			69
#define IRQ_GPIO4			70

#elif defined(CONFIG_ROCKCHIP_RK3506)
#define GPIO0_PHYS			0xff940000
#define GPIO1_PHYS			0xff870000
#define GPIO2_PHYS			0xff1c0000
#define GPIO3_PHYS			0xff1d0000
#define GPIO4_PHYS			0xff1e0000

#define GIC_IRQS_NR			185
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			IRQ_TIMER0_0
#define IRQ_TIMER0_0			126
#define IRQ_TIMER0_1			127
#define IRQ_TIMER0_2			128
#define IRQ_TIMER0_3			129
#define IRQ_TIMER0_4			130
#define IRQ_TIMER0_5			131

#define IRQ_GPIO0			IRQ_GPIO0_0
#define IRQ_GPIO0_0			32
#define IRQ_GPIO0_1			33
#define IRQ_GPIO0_2			34
#define IRQ_GPIO0_3			35

#define IRQ_GPIO1			IRQ_GPIO1_0
#define IRQ_GPIO1_0			36
#define IRQ_GPIO1_1			37
#define IRQ_GPIO1_2			38
#define IRQ_GPIO1_3			39

#define IRQ_GPIO2			IRQ_GPIO2_0
#define IRQ_GPIO2_0			40
#define IRQ_GPIO2_1			41
#define IRQ_GPIO2_2			42
#define IRQ_GPIO2_3			43

#define IRQ_GPIO3			IRQ_GPIO3_0
#define IRQ_GPIO3_0			44
#define IRQ_GPIO3_1			45
#define IRQ_GPIO3_2			46
#define IRQ_GPIO3_3			47

#define IRQ_GPIO4			IRQ_GPIO4_0
#define IRQ_GPIO4_0			48
#define IRQ_GPIO4_1			49
#define IRQ_GPIO4_2			50
#define IRQ_GPIO4_3			51

#elif defined(CONFIG_ROCKCHIP_RK3528)
#define GPIO0_PHYS			0xff610000
#define GPIO1_PHYS			0xffaf0000
#define GPIO2_PHYS			0xffb00000
#define GPIO3_PHYS			0xffb10000
#define GPIO4_PHYS			0xffb20000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			63
#define IRQ_GPIO0			103
#define IRQ_GPIO1			105
#define IRQ_GPIO2			107
#define IRQ_GPIO3			108
#define IRQ_GPIO4			110

#elif defined(CONFIG_ROCKCHIP_RK3562)
#define GPIO0_PHYS			0xff260000
#define GPIO1_PHYS			0xff620000
#define GPIO2_PHYS			0xff630000
#define GPIO3_PHYS			0xffac0000
#define GPIO4_PHYS			0xffad0000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			77
#define IRQ_GPIO0			32
#define IRQ_GPIO1			34
#define IRQ_GPIO2			36
#define IRQ_GPIO3			38
#define IRQ_GPIO4			40

#elif defined(CONFIG_ROCKCHIP_RK3568)
#define GPIO0_PHYS			0xfdd60000
#define GPIO1_PHYS			0xfe740000
#define GPIO2_PHYS			0xfe750000
#define GPIO3_PHYS			0xfe760000
#define GPIO4_PHYS			0xfe770000

#define GIC_IRQS_NR			(5 * 32)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			141
#define IRQ_GPIO0			65
#define IRQ_GPIO1			66
#define IRQ_GPIO2			67
#define IRQ_GPIO3			68
#define IRQ_GPIO4			69

#elif defined(CONFIG_ROCKCHIP_RK3576)
#define GPIO0_PHYS			0x27320000
#define GPIO1_PHYS			0x2ae10000
#define GPIO2_PHYS			0x2ae20000
#define GPIO3_PHYS			0x2ae30000
#define GPIO4_PHYS			0x2ae40000

#define GIC_IRQS_NR			(420)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			77

#define IRQ_GPIO0			IRQ_GPIO0_0
#define IRQ_GPIO0_0			185
#define IRQ_GPIO0_1			186
#define IRQ_GPIO0_2			187
#define IRQ_GPIO0_3			188

#define IRQ_GPIO1			IRQ_GPIO1_0
#define IRQ_GPIO1_0			189
#define IRQ_GPIO1_1			190
#define IRQ_GPIO1_2			191
#define IRQ_GPIO1_3			192

#define IRQ_GPIO2			IRQ_GPIO2_0
#define IRQ_GPIO2_0			193
#define IRQ_GPIO2_1			194
#define IRQ_GPIO2_2			195
#define IRQ_GPIO2_3			196

#define IRQ_GPIO3			IRQ_GPIO3_0
#define IRQ_GPIO3_0			197
#define IRQ_GPIO3_1			198
#define IRQ_GPIO3_2			199
#define IRQ_GPIO3_3			200

#define IRQ_GPIO4			IRQ_GPIO4_0
#define IRQ_GPIO4_0			201
#define IRQ_GPIO4_1			202
#define IRQ_GPIO4_2			203
#define IRQ_GPIO4_3			204

#elif defined(CONFIG_ROCKCHIP_RK3588)
#define GPIO0_PHYS			0xfd8a0000
#define GPIO1_PHYS			0xfec20000
#define GPIO2_PHYS			0xfec30000
#define GPIO3_PHYS			0xfec40000
#define GPIO4_PHYS			0xfec50000

#define GIC_IRQS_NR			(455)
#define GPIO_IRQS_NR			(5 * 32)

#define GPIO_BANK_NUM			5
#define GPIO_BANK_PINS			32

#define IRQ_TIMER0			321
#define IRQ_GPIO0			309
#define IRQ_GPIO1			310
#define IRQ_GPIO2			311
#define IRQ_GPIO3			312
#define IRQ_GPIO4			313
#else
"Missing define RIQ relative things"
#endif

#endif /* _ROCKCHIP_PLAT_IRQ_H_ */
