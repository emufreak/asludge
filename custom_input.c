#include <devices/keyboard.h>
#include <exec/io.h>
#include <exec/execbase.h>
#include <hardware/custom.h>
#include <proto/exec.h>
#include "support/gcc8_c_support.h"
#include "custom_input.h"
#include "graphics.h"
#include "sludger.h"

extern struct inputType input;
extern struct ExecBase *SysBase;
static void CsiCheckKeys();

UWORD counterx_old = 0;
UWORD countery_old = 0;

void CsiCheckInput() {
    volatile struct Custom *custom = (struct Custom*)0xdff000;
    UWORD value = custom->joy0dat;
    UBYTE countery_new = (UBYTE) (custom->joy0dat >> 8);
    UBYTE counterx_new = (UBYTE) (custom->joy0dat & 0xffff);

    if(counterx_new)
    {
        WORD counterx_diff = counterx_new - counterx_old;

        if(counterx_diff > 127) {
            input.justMoved = TRUE;
            counterx_diff -= 256;
        } else if (counterx_diff < -128) {
            counterx_diff += 256;
            input.justMoved = TRUE;
        } else if (counterx_diff) {
            input.justMoved = TRUE;
        }

        input.mouseX += counterx_diff;

        if( input.mouseX > (int) winWidth) {
            input.mouseX = winWidth;
        }
        else if(input.mouseX < 0) {
            input.mouseX = 0;
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        counterx_old = counterx_new;
    }

    if(countery_new)
    {
        WORD countery_diff = countery_new - countery_old;

        if(countery_diff > 127) {
            input.justMoved = TRUE;
            countery_diff -= 256;
        } else if (countery_diff < -128) {
            input.justMoved = TRUE;
            countery_diff += 256;
        } else if (countery_diff) {
            input.justMoved = TRUE;
        }

        input.mouseY += countery_diff;

        if( input.mouseY > (int) winHeight) {
            input.mouseY = winHeight;
        }
        else if(input.mouseY < 0) {
            input.mouseY = 0;
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        countery_old = countery_new;
    }

    input.leftRelease = FALSE;
    input.rightRelease = FALSE;

    if(input.leftClick && ((*(volatile UBYTE*)0xbfe001)&64))
    {
        input.leftClick = FALSE;
        input.leftRelease = TRUE;
    }

    if(input.rightClick && ((*(volatile UWORD*)0xdff016)&(1<<10)))
    {
        input.rightClick = FALSE;
        input.rightRelease = TRUE;
    }

    if(input.justMoved) {
        KPrintF("CsiCheckInput: MouseX = %ld\n", input.mouseX);
        KPrintF("CsiCheckInput: MouseY = %ld\n", input.mouseY);
    }

    if(!((*(volatile UBYTE*)0xbfe001)&64)) {
        input.leftClick = TRUE;
    }
    if(!((*(volatile UWORD*)0xdff016)&(1<<10)) ) {
        input.rightClick = TRUE;
    }

    CsiCheckKeys();
}

/* ---- The keyboard ----------------------------------------------------------------------------------------------------------- */

/* The system stays alive under the engine, so keyboard.device keeps reading the keyboard (reading the CIA ourselves would take
   keys from it). Once a pass the engine asks it for the matrix of keys that are down (KBD_READMATRIX: one bit per raw key code)
   and queues the keys that went down since the last pass; a key that is pressed and let go within one pass (20 ms) is missed.
   handleInput gives the oldest key in the queue to the script's onKeyboard handler, by name: the character (a US keyboard's, in
   lower case) or "ESCAPE", "ENTER", "F1" and so on, as OpenSLUDGE does. */

#define CSIKEYQUEUE 8

static struct MsgPort *CsiKeyPort = NULL;
static struct IOStdReq *CsiKeyRequest = NULL;
static UBYTE CsiMatrix[16] = {0}, CsiMatrixBefore[16] = {0};
static UBYTE CsiKeyQueue[CSIKEYQUEUE];
static int CsiKeysQueued = 0;

/* The names of the raw key codes, by code; NULL: the key has no name and does nothing. */
static const char * const CsiKeyNames[0x68] = {
  "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "\\", NULL, "0",
  "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", NULL, "1", "2", "3",
  "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", NULL, NULL, "4", "5", "6",
  NULL, "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", NULL, ".", "7", "8", "9",
  " ", "BACKSPACE", "TAB", "ENTER", "ENTER", "ESCAPE", "DELETE", NULL, NULL, NULL, "-", NULL, "UP", "DOWN", "RIGHT", "LEFT",
  "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", NULL, NULL, "/", "*", "+", "HELP",
  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
};

void CsiOpenKeyboard() {
  CsiKeyPort = CreateMsgPort();
  if( CsiKeyPort) {
    CsiKeyRequest = (struct IOStdReq *) CreateIORequest( CsiKeyPort, sizeof(struct IOStdReq));
  }
  if( !CsiKeyRequest || OpenDevice( "keyboard.device", 0, (struct IORequest *) CsiKeyRequest, 0)) {
    KPrintF("CsiOpenKeyboard: Cannot open keyboard.device, the keyboard stays dead\n");
    if( CsiKeyRequest) DeleteIORequest( (struct IORequest *) CsiKeyRequest);
    if( CsiKeyPort) DeleteMsgPort( CsiKeyPort);
    CsiKeyRequest = NULL;
    CsiKeyPort = NULL;
  }
}

void CsiCloseKeyboard() {
  if( !CsiKeyRequest) return;
  CloseDevice( (struct IORequest *) CsiKeyRequest);
  DeleteIORequest( (struct IORequest *) CsiKeyRequest);
  DeleteMsgPort( CsiKeyPort);
  CsiKeyRequest = NULL;
  CsiKeyPort = NULL;
}

static BOOL CsiReadMatrix() {
  CsiKeyRequest->io_Command = KBD_READMATRIX;
  CsiKeyRequest->io_Data = CsiMatrix;
  CsiKeyRequest->io_Length = SysBase->LibNode.lib_Version >= 36 ? 16 : 13;
  return DoIO( (struct IORequest *) CsiKeyRequest) == 0;
}

static void CsiQueueKey( int code) {
  if( code < 0x68 && CsiKeyNames[code] && CsiKeysQueued < CSIKEYQUEUE) {
    CsiKeyQueue[CsiKeysQueued++] = code;
  }
}

/* To find the keys that went down since the last pass, and queue them. */
static void CsiCheckKeys() {
  if( !CsiKeyRequest || !CsiReadMatrix()) return;
  for(int byte=0; byte<16; byte++) {
    UBYTE pressed = CsiMatrix[byte] & ~CsiMatrixBefore[byte];
    for(int bit=0; pressed; bit++, pressed >>= 1) {
      if( pressed & 1) CsiQueueKey( byte * 8 + bit);
    }
    CsiMatrixBefore[byte] = CsiMatrix[byte];
  }
}

/* The name of the oldest key that was pressed and not given out yet, or NULL. */
const char *CsiNextKeyName() {
  if( CsiKeysQueued == 0) return NULL;
  const char *name = CsiKeyNames[CsiKeyQueue[0]];
  for(int i=1; i<CsiKeysQueued; i++) CsiKeyQueue[i - 1] = CsiKeyQueue[i];
  CsiKeysQueued--;
  return name;
}
