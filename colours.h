// Simple colour conversion routines to deal with 16-bit graphics

//unsigned short int makeColour (byte r, byte g, byte b);

unsigned short redValue (unsigned short c) { return (c >> 11) << 3; }
unsigned short greenValue (unsigned short c) { return ((c >> 5) & 63) << 2; }
unsigned short blueValue (unsigned short c) { return (c & 31) << 3; }

unsigned short makeGrey (unsigned short int r) {
	return ((r >> 3) << 11) | ((r >> 2) << 5) | (r >> 3);
}

unsigned short makeColour (unsigned short int r, unsigned short int g, unsigned short int b) {
	return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3);
}
