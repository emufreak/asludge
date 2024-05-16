#define EXTRA_FRONT			1
#define EXTRA_FIXEDSIZE		2
#define EXTRA_NOSCALE		2	// Alternative name
#define EXTRA_NOZB			4
#define EXTRA_FIXTOSCREEN	8
#define EXTRA_NOLITE		16
#define EXTRA_NOREMOVE		32
#define EXTRA_RECTANGULAR	64

struct personaAnimation {
	struct loadedSpriteBank * theSprites;
	struct animFrame * frames;
	int numFrames;
};

struct animFrame {
	int frameNum, howMany;
	int noise;
};

struct personaAnimation * makeNullAnim ();