#ifndef __APPDEFS_H__
#define __APPDEFS_H__
#include <pthread.h>
#include <string.h>

#include "sysdefs.h"
#include "def.h"

#define SAVE_CONFIG_FILE_NAME_ADMIN "/home/admina/save_config"
#define PUBLIC_CONFIG_FILE_NAME_ADMIN "/home/admina/public_config"
#define PUBLIC_CONFIG_FILE_NAME_USER1 "/home/user1/public_config"
#define PUBLIC_CONFIG_FILE_NAME_USER2 "/home/user2/public_config"
#define PUBLIC_CONFIG_FILE_NAME_USER3 "/home/user3/public_config"
#define PUBLIC_CONFIG_FILE_NAME_USER4 "/home/user4/public_config"
#define SAVE_CONFIG_FILE_NAME_USER "/home/user%d/save_config.%d"
#define SAVE_CONFIG_FILE_NAME_MAINT "/home/maintenance/save_config.0"
#define SAVE_CONFIG_FILE_NAME_DEBUG "/home/debug/save_config.5"
#define SAVE_LOGINTOOL_FILE_NAME "/etc/logintool"

#define SYS_SLOT_ID_FILE "/var/slot_id"

#define APPADMIN_TMP_DIR "/usr/local/appadmin/tmp"

#define SNMP_STATUS_FILE "/var/log/snmp_status"
#define SNMP_CONF "/usr/local/ow3/bin/extend_service.conf"

#define INVALID_TABLE_NUMBER    (-1)

#define INVALID_FPGA_ID         (-1)
#define INVALID_CAM_ID          (-1)

#define MODULE_NUMBER_PER_BOARD 5
#define MODULE_NUMBER_PER_BOARD_MASK 0x3F

#define MODULE_REAR_NR          4
#define MODULE_REAR          4
#define MODULE_FRONT_NR  5

#define AC2240_XE_PORT_NUMBER   8
#define MAX_PORT_NUMBER         24

#define PORT_BIT_NUMBER         10
#define MAX_OUT_PORT            (1<<PORT_BIT_NUMBER)	//9bit port  512

#define BCM_UNIT0               (0)


#define AUTODETECT_DETECTING 0
#define AUTODETECT_SUCCESS 1
#define AUTODETECT_FAILED 2
#define AUTODETECT_SUSPEND 3

#define MAX_VENDOR_NAME_LEN 32
#define CAM_WORD_WIDTH          9

#define SHOW_CONFIG_FLAG 0
#define SAVE_CONFIG_FLAG 1

enum {
	TFTP_GET = 1,
	TFTP_PUT
};

typedef enum {
	BD_STATUS_BOARD_NOT_EXSIT = 0,
	BD_STATUS_CONFIG_SUCCEED = 1,
	BD_STATUS_CONFIG_AND_CONFIG_FAILED = 2,
	BD_STATUS_MAX
} board_status_t;

// be careful if you want to add board type
typedef enum {
	BOARD_TYPE_UNKNOWN,
	BOARD_TYPE_SF3600,
	BOARD_TYPE_AC2240,
	BOARD_TYPE_AC2820,
	BOARD_TYPE_MAX
} board_type_t;

enum {
	OW_KEY_MASK_PROTOCOL = 0x0002,
	OW_KEY_MASK_SIP = 0x0004,
	OW_KEY_MASK_SIP_MASK = 0x0008,
	OW_KEY_MASK_DIP = 0x0010,
	OW_KEY_MASK_DIP_MASK = 0x0020,
	OW_KEY_MASK_SPORT = 0x0040,
	OW_KEY_MASK_SPORT_MASK = 0x0080,
	OW_KEY_MASK_DPORT = 0x0100,
	OW_KEY_MASK_DPORT_MASK = 0x0200,
	OW_KEY_MASK_FIN = 0x00400,
	OW_KEY_MASK_SYN = 0x00800,
	OW_KEY_MASK_RST = 0x01000,
	OW_KEY_MASK_PSH = 0x02000,
	OW_KEY_MASK_ACK = 0x04000,
	OW_KEY_MASK_URG = 0x08000,
	OW_KEY_MASK_TCP_FLAG = 0x0fc00,
	OW_KEY_MASK_SIZE = 0x10000,
	OW_KEY_MASK_UD = 0x20000,
	OW_KEY_MASK_PROTOCOL_MASK = 0x40000,
	OW_KEY_MASK_FLOAT_UD = 0x80000
};

typedef struct {
	int wk_id;
	char ip[128];
	unsigned int timeout_count;
	board_status_t octen_status;
	board_type_t board_type;
	int module_id;

	pthread_rwlock_t rwlock;
	pthread_rwlockattr_t attr;
} octen_info_t;

typedef struct {
	int wk_id;
	char ip[128];
	unsigned int timeout_count;
	board_status_t board_status;
	board_type_t board_type;

	pthread_rwlock_t rwlock;
	pthread_rwlockattr_t attr;

	octen_info_t octen[OCTEN_NUMBER_PER_SLOT];
} slot_info_t;

typedef struct {
	slot_info_t slot[SLOT_NUMBER_PER_SYSTEM];
} slots_t;

typedef struct {
	int No;
	char *str;
} num_str_t;

static inline char *GetString(num_str_t * table, int No, int size)
{
	int i = 0;

	while ((i < size) && (table[i].str != NULL)) {
		if (table[i].No == No)
			return table[i].str;
		i++;
	}
	return "INVALID PARAMETER";

}

static inline int GetNo(num_str_t * table, char *str, int size)
{
	int i = 0;

	while (i < size) {
		if (!strcmp(table[i].str, str))
			return table[i].No;
		i++;
	}
	return INVALID_TABLE_NUMBER;

}

enum {
	CARD_TYPE_NONE,
	CARD_TYPE_IF1820,
	CARD_TYPE_BACK_IO,
	CARD_TYPE_UNKNOWN
};

enum {
	INTERFACE_TYPE_POS,
	INTERFACE_TYPE_GE,
	INTERFACE_TYPE_XGE,
	INTERFACE_TYPE_XGE_LAN,
	INTERFACE_TYPE_XGE_WLAN
};

enum {
	PORT_SPEED_1000M = 1000,
	PORT_SPEED_10000M = 10000
};

typedef struct __bcm_port_map {
	int board_type;				/* board type */
	int bcm_unit;
	int module_id;				/* module id */
	int port_number;			/* number of total ports */
	unsigned int port_mask;		/* total ports bit mask  */
	int port_map[32];			/* port map */
} bcm_port_map_t;

struct ow_time_t {
	unsigned long long last;
	unsigned long long now;
	unsigned long long inc;
};

struct ow_if_counter_t {
	int type;
	char *name_p;

	unsigned long long total;
	unsigned long long last;
	unsigned long long rate;
};

/* data struct for interface */
union ow_interface_config_t {
	struct {
		int stripPOSHeader;		//Strip POS Header Mode: 0:None, 1:PPP, 2:CHDLC, default 1. (int)
		int descramble;			//  0:no-scramble, 1:scramble, default 1. (int)
		int crc_type;			// 0:CRC16, 1:CRC32
		int rate;
		int oeo;
	} pos;

	struct {
		int auto_negotiation;
		int pause;
		int mirror_map;
	} ge;

};

union ow_interface_status_t {
	struct {
		int active_state;
		int link_state;
	};

};

union ow_interface_counter_t {
	struct ow_counter_t *framer_counter_p;

};

struct ow_interface_t {
	int id;
	int type;
	unsigned int speed;

	union ow_interface_config_t config;
	union ow_interface_status_t status;
	//struct ow_time_t framer_time;
	union ow_interface_counter_t counter;

	//struct ow_led_t leds[LED_NUMBER_PER_INTERFACE];
};

struct ow_device_t {
	int ability;
	struct ow_interface_t *interface_p;
	int interface_number;

	int present;
	int card_type;
	int status;
	bcm_port_map_t *bpmap;
};

struct ow_module_t {
	int id;

	unsigned int fpqa_address;
	unsigned int framer_address;
	unsigned int xgmii2xaui_address;
	unsigned int other_address;

	char *fpga_name;
	int search_mode;

	struct ow_device_t device;

	int fpga_id;
	int cam_id;

	int enabled;

	struct ow_time_t wx_time;

};

/* data structs for CAM */
struct ow_cam_reg_t {
	unsigned int address;
	unsigned char value[CAM_WORD_WIDTH];
};
struct ow_smp_t {
	unsigned int slot;
	unsigned int module;
	unsigned int port;
};
struct ow_counter_t {
	int type;
	char name[64];
	unsigned long long total;
	unsigned long long last;
	unsigned long long rate;
};

struct ow_module_counter_t {
	int module_id;
	int n_counter;
	struct ow_counter_t *counter;
};

struct ow_slot_counter_t {
	int slot_id;
	int n_module_counter;
	struct ow_module_counter_t *module_counter;
};

struct smp_common_t {
	int port_id;
	int port_valid_flag;
	int port_insert_flag;
};

struct sm_common_t {
	int slot_id;
	int module_id;
};

struct ow_port_counter_t {
	struct smp_common_t smp_common;
	int n_counter;
	struct ow_counter_t *counter;
};

struct ow_board_counter_t {
	struct sm_common_t sm_common;
	int n_port_counter;
	struct ow_port_counter_t *port_counter;
};

struct slot_counter_t {
	int n_board_counter;
	struct ow_board_counter_t *board_counter;
};

struct ow_port_status_t {
	struct smp_common_t smp_common;
	int link;
	int speed;
	int duplex;
	int autoneg;
	int pause;
	int max_frame;
	int stripPOSHeader;
	int descramble;
	int crc_type;
	int mode;
	int autodetect_enable;
	int autodetect_result;
	int oc192_type;
};

struct ow_module_status_t {
	struct sm_common_t sm_common;
	int n_port_status;
	struct ow_port_status_t *port_status;
};

struct slot_status_t {
	int n_module_status;
	struct ow_module_status_t *module_status;
};

struct ow_port_sfp_t {
	struct smp_common_t smp_common;
	int port_type;
	char vendor_name[MAX_VENDOR_NAME_LEN + 1];
	int temperature;
	int temperature_flag;		/*1: N/A */
	double tx_power;
	int tx_power_flag;			/*1: N/A */
	double tx_dbm;
	double rx_power;
	int rx_power_flag;			/*1: N/A */
	double rx_dbm;
};

struct ow_module_sfp_t {
	struct sm_common_t sm_common;
	int n_port_sfp;
	struct ow_port_sfp_t *port_sfp;
};

struct ow_slot_sfp_t {
	int n_module_sfp;
	struct ow_module_sfp_t *module_sfp;
};

/* don't change the sequence */
enum {
	ID_AMC1 = 0,
	ID_AMC2 = 1,
	ID_AMC3 = 2,
	ID_AMC4 = 3,
	ID_CAM = 4,
	ID_CYCLONE2 = 5,
	FPGA_NUM
};
enum {
	LOGIN_MODE_SSH = 1,
	LOGIN_MODE_TELNET = 2,
	LOGIN_MODE_CONSOLE = 3,
	LOGIN_MODE_FTP = 4,
	LOGIN_MODE_TFTP = 5,
	LOGIN_MODE_RCP = 6,
	LOGIN_MODE_SNMP = 7,
	LOGIN_MODE_SYSLOG = 8,
	LOGIN_MODE_OTHERS = 9
};

enum {
	SNMP_START = 1,
	SNMP_RESTART = 2,
	SNMP_STOP = 3,
	SNMP_RESTORE = 4,
};

enum {
	SNMP_SER = 0,
	SNMP_SYSNAME = 1,
	SNMP_SYSCONTACT = 2,
	SNMP_SYSLOCATION = 3,
	SNMP_ROCOMMUNITY1 = 4,
	SNMP_ROCOMMUNITY2 = 5,
	SNMP_ROCOMMUNITY3 = 6,
	SNMP_ROCOMMUNITY4 = 7,
	SNMP_ROCOMMUNITY5 = 8,
	SNMP_ROCOMMUNITY6 = 9,
	SNMP_RWCOMMUNITY1 = 10,
	SNMP_RWCOMMUNITY2 = 11,
	SNMP_RWCOMMUNITY3 = 12,
	SNMP_RWCOMMUNITY4 = 13,
	SNMP_RWCOMMUNITY5 = 14,
	SNMP_RWCOMMUNITY6 = 15,
	SNMP_TRAP_VERSION = 16,
	SNMP_USERNAME = 17,
	SNMP_AUTH_TYPE = 18,
	SNMP_AUTH_PASSWD = 19,
	SNMP_PRIV_TYPE = 20,
	SNMP_PRIV_PASSWD = 21,
	SNMP_ACCESS = 22,
	SNMP_TRAP_IP = 23,
	SNMP_MIBINFO_TYPE = 24,
	SNMP_TRAP_LOG = 25,
	SNMP_NUM = 26,
};

#define SNMP_ADD_ROCOMMUNITY 100
#define SNMP_DEL_ROCOMMUNITY 101
#define SNMP_ADD_RWCOMMUNITY 102
#define SNMP_DEL_RWCOMMUNITY 103

enum
{
	CLI_CLI,
	CLI_SNMP,
};
#endif
