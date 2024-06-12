#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <exec/interrupts.h>
#include <exec/io.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>

#include <inline/exec.h>
#include <inline/timer.h>

#include <devices/timer.h>
#include <hardware/custom.h>

#include "utils.h"
#include "support/gcc8_c_support.h"

#define TIMER_DEVICE_NAME "timer.device"
#define RANDOM_NUMBER_MAX 100

// Define constants for LCG
#define MULTIPLIER 1103515245UL
#define INCREMENT 12345UL
#define MODULUS 0x7FFFFFFFUL

ULONG rand() {
    struct timerequest *timereq;

    struct MsgPort *timerport = CreateMsgPort();

    timereq = CreateIORequest(timerport, sizeof(struct timerequest));
    struct IORequest* ioreq = (struct IORequest*)timereq;
    if (OpenDevice(TIMERNAME, UNIT_MICROHZ, ioreq, 0)) {
        KPrintF("Unable to open timer device\n");
        return 0;
    }
    struct Device* TimerBase = ioreq->io_Device;

    struct EClockVal eclock;
    ReadEClock(&eclock);

    ULONG seed = eclock.ev_lo; // Using the lower part of EClock value as seed
    seed = (seed * MULTIPLIER + INCREMENT) & 0x7fffffff; // Simple LCG

    // Transform the seed to a random number
    int random_number = seed % 100; // For example, a random number between 0 and 99
    KPrintF("Random Number: %d\n", random_number);

    CloseDevice(ioreq);
    DeleteIORequest(ioreq);
    DeleteMsgPort(timerport);
    return 0;
}
