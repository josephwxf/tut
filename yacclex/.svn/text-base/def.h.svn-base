#ifndef __DEF_H__
#define __DEF_H__

#include "sysdefs.h"

extern int g_ac2240_slot_mask;
extern int g_ac2820_slot_mask;

#define SLOT_NUMBER_PER_SYSTEM  14
#define OCTEN_NUMBER_PER_SLOT  1
#define ALL_SF_NUMBER 2
#define ALL_AC_NUMBER (SLOT_NUMBER_PER_SYSTEM - ALL_SF_NUMBER)
#define ALL_OCTEN_NUMBER (ALL_AC_NUMBER*2)
#define ALL_AC_SLOT_MASK 0x3ffc
#define ALL_OCTEN_MASK 1
#define ALL_AC2240_MASK g_ac2240_slot_mask
#define ALL_AC2820_MASK g_ac2820_slot_mask

#define DEFAULT_TIMEOUT_ZMQ_PROBE 500	/*500ms */
#define DEFAULT_TIMEOUT_ZMQ_MSG 2000	/*2s */

#define PROMPT(str)			"     " str
#define PROMPT2(prompt, format)		"     %-40s" format, prompt

#define MAX_CLI_CMD_LEN 1024
enum {
	HASH_MODE_SIP,
	HASH_MODE_DIP,
	HASH_MODE_SDIP,
	HASH_MODE_SDIP_SDPORT,
	HASH_MODE_SDIP_SDPORT_PROTO,
};

enum {
	DATA_DIRECTION_UP,
	DATA_DIRECTION_DOWN,
	MAX_DATA_DIRECTION
};

#endif
