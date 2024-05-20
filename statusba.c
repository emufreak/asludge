#include "statusba.h"

struct statusStuff mainStatus;
struct statusStuff * nowStatus = & mainStatus;

void positionStatus (int x, int y) {
	nowStatus -> statusX = x;
	nowStatus -> statusY = y;
}