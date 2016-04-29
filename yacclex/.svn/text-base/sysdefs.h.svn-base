#ifndef __SYS_DEF_H__
#define __SYS_DEF_H__
#include <stdint.h>

#define SLOT_BIT_MASK     0x3FFF
#define MODULE_BIT_MASK   0x3F
#define MODULE_FR_BIT_MASK   0x30
#define PORT_BIT_MASK     0xFFFFFF
#define MAX_STRING_LEN 32
#define DEFAULT_NORMAL_USER_NUMBER 4
#if 0
enum {
	OW_RST_OK,					/* ok */
	/*1-0x0f  error code for rcp result code */
	OW_RST_NO_MEM = 0x10,		/* malloc failed */
	OW_RST_RS_FULL = 0x11,		/* resource full */
	OW_RST_INVLD_PRM = 0x12,	/* invalid parameter */
	OW_RST_FILE_ERR = 0x13,		/* file operate error */
	OW_RST_INT_ERR = 0x14,		/* internal error */
	OW_RST_FPGA_DOWN_ERR = 0x15,	/* fpga download error */
	OW_RST_BOARD_TYPE_UNKNOWN = 0x16,	/* board type not supported */
	OW_RST_MOD_NOT_EXT = 0x17,
	OW_RST_INIT_CAM_ERR = 0x18,	/* init cam error */
	OW_RST_WRONG_MOD = 0x19,
	OW_RST_NOT_PERMIT = 0x20,
	OW_RST_RCP_AUTH_ERR = 0x21,
	OW_RST_FORBID_LOGIN = 0x22,
	OW_RST_USER_DISABLE = 0x23,

	OW_RST_MAX
};
#endif

enum {
	OW_RST_OK,					/* ok */
	OW_RST_RS_FULL = 1,			/* resource full */
	OW_RST_RULE_EXIST = 2,
	OW_RST_NOT_RULE_EXIST = 3,
	OW_RST_NO_MEM = 4,			/* malloc failed */
	OW_RST_INVLD_PRM = 5,		/* invalid parameter */
	OW_RST_FILE_ERR = 6,		/* file operate error */
	OW_RST_INT_ERR = 7,			/* internal error */
	OW_RST_FPGA_DOWN_ERR = 8,	/* fpga download error */
	OW_RST_BOARD_TYPE_UNKNOWN = 9,	/* board type not supported */
	OW_RST_MOD_NOT_EXT = 10,
	OW_RST_INIT_CAM_ERR = 11,	/* init cam error */
	OW_RST_WRONG_MOD = 12,
	OW_RST_NOT_PERMIT = 13,
	OW_RST_RCP_AUTH_ERR = 14,
	OW_RST_FORBID_LOGIN = 15,
	OW_RST_USER_DISABLE = 16,
	OW_RST_UD_NOT_EXIST = 17,
	OW_RST_AUTODETECT = 18,
	OW_RST_INITING = 19,
	OW_RST_UD_NOT_COMPLEX = 20,
	OW_RST_FLOAT_UD_RULE_APPLY = 21,
	OW_RST_NO_ACTIVE = 22,
	OW_RST_NO_ALLOC = 23,
	OW_RST_COMPLEX_UD_CLASH = 24,
	OW_RST_SNMP_IS_RUNNING = 25,
	OW_RST_SNMP_IS_NOT_RUNNING = 26,
	OW_RST_FTP_ERR = 27,
	OW_RST_SNMP_COMMUNITY_ERR = 28,
	OW_RST_UNREACHABLE = 29,
	OW_RST_NOT_FOUND = 30,

	OW_RST_MAX
};

struct smp_t {
	int slots;
	int modules;
	int ports;
};

/*fru type*/
enum {
	CPU,
	FB,
	RTM,
	AMC1,
	AMC2,
	AMC3,
	AMC4,
	FRU_MAX
};

struct board_info_t {
	int type;
	char version[MAX_STRING_LEN];
	char serial_num[MAX_STRING_LEN];
};

typedef struct {
	uint64_t add_str_num;
	uint64_t del_str_num;
	uint64_t cur_str_num;
	uint64_t rec_pkt_num;
	uint64_t netflow_num;
	uint64_t lock_num;
} stream_counter_t;

#endif
