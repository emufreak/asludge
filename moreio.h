char * encodeFilename (char * nameIn);
FLOAT FLOATSwap( FLOAT f );
int get2bytes (BPTR fp);
ULONG get4bytes (BPTR fp);
FLOAT getFloat (BPTR fp);
short getSigned (BPTR fp);
void put2bytes (int numtoput, BPTR fp);
void put4bytes (ULONG i, BPTR fp);
void putFloat (FLOAT f, BPTR fp);
void putSigned (short f, BPTR fp);
char * readString (BPTR fp);
short shortSwap( short s );
void writeString (char * s, BPTR fp);