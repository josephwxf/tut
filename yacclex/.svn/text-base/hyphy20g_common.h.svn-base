/* vi:set ts=4 sw=4: */
#ifndef _HYPHY_20G_COMMON_H_
#define _HYPHY_20G_COMMON_H_

//#include <asm/semaphore.h>
#define HW_ERR_BASE            (-100)
#define HW_SUCCESS             0
#define HW_FAILURE             (HW_ERR_BASE - 0)
#define HW_ERR_NULL_PTR_PASSED (HW_ERR_BASE - 1)
#define HW_ERR_OPEN_FILE       (HW_ERR_BASE - 2)

#define RXFramersOK                0
#define RXOctetsOK                 1
#define RXFrames                   2
#define RXOctets                   3
#define RXUnicastFramesOK          4
#define RXBroadcastFramesOK        5
#define RXMulticastFramesOK        6
#define RXTaggedFramesOK           7
#define RXMACPAUSEControlFramesOK  8
#define RXMACControlFramesOK       9
#define RXFCSError                 10
#define Reserved                   11
#define RXSymbolError              12
#define RXFramesLostDueToIntMACErr 13
#define RXInRangeLengthError       14
#define RXLongLengthError          15
#define RXLongLengthCRCError       16
#define RXShortLengthError         17
#define RXShortLengthCRCError      18
#define RXFrames64OCtets           19
#define RXFrames65to127Octets      20
#define RXFrames128to255Octets     21
#define RXFrames256to511Octets     22
#define RXFrames512to1023Octets    23
#define RXFrames1024to1518Octets   24
#define RXFrames1519toMaxSize      25
#define RXStationAddressFiltered   26
#define RXVariable                 27
#define RXFrames1519to1522Octets   28
#define RXFrames1523to1548Octets   29
#define RXFrames1549to2000Octets   30
#define RXFrames2001to2500Octets   31
#define RXFrames2510toMaxSize      32
#define TXFramesOK                 33
#define TXOctetsOK                 34
#define TXOctets                   35
#define TXTaggedFramesOK           36
#define TXMACPAUSEControlFramesOK  37
#define TXFCSError                 38
#define TXShortLengthError         39
#define TXLongLengthError          40
#define TXSystemError              41
#define TXMACError                 42
#define TXFrames1523toMaxSize      43
#define TXMACControlFramesOK       44
#define TXUnicastFramesOK          45
#define TXBroadcastFramesOK        46
#define TXMulticastFramesOK        47
#define TXUnicastFramesAttempted   48
#define TXBroadcastFramesAttempted 49
#define TXMulticastFramesAttempted 50
#define TXFrames64Octets           51
#define TXFrames65to127Octets      52
#define TXFrames128to255Octets     53
#define TXFrames256to511Octets     54
#define TXFrames512to1023Octets    55
#define TXFrames1024to1518Octets   56
#define TXFrames1519toMaxSize      57
#define TXVariable                 58
#define RXFrames1523toMaxSize      59
#define TXFrames1519to1522Octets   60
#define TXFrames1523to1548Octets   61
#define TXFrames1549to2000Octets   62
#define TXFrames2001to2500Octets   63
#define TXFrames2510toMaxSize      64

#define LAN_WAN_CNT_NUM       65

#define XG_MODE_POS           0
#define XG_MODE_LAN           1
#define XG_MODE_WAN           2
#define XG_MODE_MAX           3
#define XG_MODE_DEFAULT       XG_MODE_POS

#define PIF_MODE_XAUI         0
#define PIF_MODE_EXAUI        1
#define PIF_MODE_DEFAULT      PIF_MODE_EXAUI

#define PIF_LPBK_DISABLE      0
#define PIF_LPBK_ENABLE       1

#define CRC_MODE_16           0
#define CRC_MODE_32           1
#define CRC_MODE_DEFAULT      CRC_MODE_32

#define STRIP_HEAD_NONE       0
#define STRIP_HEAD_PPP        1
#define STRIP_HEAD_CHDLC      2
#define STRIP_HEAD_CUSTOM     3
#define STRIP_HEAD_DEFAULT    STRIP_HEAD_PPP

#define SCRAMBLE_MODE_DISABLE 0
#define SCRAMBLE_MODE_ENABLE  1
#define INTERFACE_MODE_SHUTDOWN 0
#define INTERFACE_MODE_NO_SHUT  1
#define SCRAMBLE_MODE_DEFAULT SCRAMBLE_MODE_ENABLE

#define DIRECTION_RX 0
#define DIRECTION_TX 1

#define TIME_MODE_LOCAL     0
#define TIME_MODE_RECOVERED 1

#define STRIP_CRC_DISABLE     0
#define STRIP_CRC_ENABLE      1
#define STRIP_CRC_DEFAULT     STRIP_CRC_ENABLE

#define CPB_LPBK_DISABLE      0
#define CPB_LPBK_ENABLE       1
#define CPB_LPBK_DEFAULT      CPB_LPBK_DISABLE

#define CROSS_DISABLE         0
#define CROSS_ENABLE          1

#define OC192_TYPE_PPP 0
#define OC192_TYPE_CHDLC 1

#define HYPHY20G_DEV_NAME "hyphy20g_drv"
#define HYPHY20G_MONITOR_DEV_NAME "hyphy20g_monitor"

typedef uint32_t Hyphy20gRegAddr_t;
typedef uint32_t Hyphy20gRegValue_t;
typedef int32_t HwErrorNo_t;

typedef struct {
	uint64_t txByteCnt;
	uint64_t txFrmCnt;
	uint64_t txErrFrmCnt;
	uint64_t txCmfFrmCnt;
	uint64_t txIdleFrmCnt;

	uint64_t rxByteCnt;
	uint64_t rxCtrlFrmCnt;
	uint64_t rxFrmCnt;
	uint64_t rxIdleFrmCnt;

	uint64_t rxChecAbrt;
	uint64_t rxThecMinfl;
	uint64_t rxEhecMaxfl;
	uint64_t rxEcorrCnt;
	uint64_t rxDropFrmCnt;
	uint64_t rxExiFltDrop;
} HwHyphy20gGfpCnt_t;

typedef struct {
	uint64_t cnt[LAN_WAN_CNT_NUM];
} HwHyphy20gLanWanCnt_t;

/* ioctl */
#define HW_HYPHY20G_IOCTL_BASE			(100)
#define HW_HYPHY20G_GET_REG				(HW_HYPHY20G_IOCTL_BASE + 1)
typedef struct {
	int device_id;
	Hyphy20gRegAddr_t Addr;
	Hyphy20gRegValue_t *p_Value;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gGetReg_t;
#define HW_HYPHY20G_SET_REG            	(HW_HYPHY20G_IOCTL_BASE + 2)
typedef struct {
	int device_id;
	Hyphy20gRegAddr_t Addr;
	Hyphy20gRegValue_t Value;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetReg_t;
#define HW_HYPHY20G_GET_REG_BIT        	(HW_HYPHY20G_IOCTL_BASE + 3)
typedef struct {
	int device_id;
	Hyphy20gRegAddr_t Addr;
	Hyphy20gRegValue_t *p_Value;
	Hyphy20gRegValue_t Bit;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gGetRegBit_t;
#define HW_HYPHY20G_SET_REG_BIT        	(HW_HYPHY20G_IOCTL_BASE + 4)
typedef struct {
	int device_id;
	Hyphy20gRegAddr_t Addr;
	Hyphy20gRegValue_t Value;
	Hyphy20gRegValue_t Bit;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetRegBit_t;
#define HW_HYPHY20G_GET_STATUS         	(HW_HYPHY20G_IOCTL_BASE + 5)
typedef struct {
	int device_id;
	int interface;				// 0 or 1
	int *mode;
	int *crc_mode;
	int *scramble_mode;
	int *xaui_mode;
	int *strip_head_mode;
	int *strip_crc;
	int *link;
	int *TohStatus;
	int *PohPtrStatusRx;
	int *PohPtrStatusTx;
	int *PohStatus;
	int *hdlc_fcs_0;
	int *hdlc_fcs_1;
	int *UCHEC_ABORT_I0_0;
	int *UCHEC_ABORT_I0_1;
	int *module_id;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gGetStatus_t;
#define HW_HYPHY20G_XFI_SERDES_LPBK    	(HW_HYPHY20G_IOCTL_BASE + 6)
typedef struct {
	int device_id;
	int interface;				// 0 or 1
	int loopback;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gXFISerdesLpbk_t;
#define HW_HYPHY20G_PIF_SERDES_LPBK    	(HW_HYPHY20G_IOCTL_BASE + 8)
typedef struct {
	int device_id;
	int interface;
	int loopback;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gPIFSerdesLpbk_t;
#define HW_HYPHY20G_GET_CNT			   	(HW_HYPHY20G_IOCTL_BASE + 9)
typedef struct {
	int device_id;
	int interface;				// 0 or 1
	/* type=1:only gfp/pos; type=2: only lan/wan; else both */
	int type;
	int *mode;
	HwHyphy20gGfpCnt_t *gfp_cnt;
	HwHyphy20gLanWanCnt_t *lan_wan_cnt;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gGetCnt_t;
#define HW_HYPHY20G_CLR_CNT				(HW_HYPHY20G_IOCTL_BASE + 10)
typedef struct {
	int device_id;
	int interface;
	/* type=1:only gfp/pos; type=2: only lan/wan; else both */
	int type;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gClrCnt_t;
//#define HW_HYPHY20G_GET_MODE          (HW_HYPHY20G_IOCTL_BASE + 11)
//typedef struct {
//  int device_id;
//  int *mode;
//    HwErrorNo_t        *p_ErrorNo;
//} HwHyphy20gGetMode_t;
#define HW_HYPHY20G_SET_MODE			(HW_HYPHY20G_IOCTL_BASE + 12)
typedef struct {
	int device_id;
	int interface;				// 预留，但是暂不支持两个端口模式不同
	int mode;
	int xaui_mode;
	int crc_mode;
	int strip_crc_mode;
	int scramble_mode;
	int strip_head_mode;
	int tmmode;
	uint8_t ud[4];
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetMode_t;
#define HW_HYPHY20G_SET_CRC_MODE			(HW_HYPHY20G_IOCTL_BASE + 13)
typedef struct {
	int device_id;
	int interface;
	int crc_mode;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetCRCMode_t;
#define HW_HYPHY20G_SET_POS_HEADER			(HW_HYPHY20G_IOCTL_BASE + 14)
typedef struct {
	int device_id;
	int interface;
	/* type=1:PPP;type=2:HDLC;else UserDefine */
	int type;
	/* only used when type=3 */
	uint8_t ud[2];
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetPOSHeader_t;
#define HW_HYPHY20G_SET_SCRAMBLE_MODE		(HW_HYPHY20G_IOCTL_BASE + 15)
typedef struct {
	int device_id;
	int interface;
	int scramble_mode;
	int direction;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gSetScrambleMode_t;
#define HW_HYPHY20G_GET_XAUI_STATUS         (HW_HYPHY20G_IOCTL_BASE + 16)
typedef struct {
	int device_id;
	int interface;
	int *top_level_status;
	int *xaui_status;
	int *lane_status;
	int *txxg_status;
	int *rxxg_status;
	HwErrorNo_t *p_ErrorNo;
} HwHyphy20gGetXauiStatus_t;

#endif
/* end of file */
