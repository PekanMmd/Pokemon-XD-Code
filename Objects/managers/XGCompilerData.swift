enum XGCompilerConstants {
    static let dolphinIncludes = """
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;
typedef unsigned char bool;

#define true 1
#define false 0

#define VI_DISPLAY_PIX_SZ           2

#define VI_INTERLACE                0
#define VI_NON_INTERLACE            1
#define VI_PROGRESSIVE              2

#define VI_NTSC                     0
#define VI_PAL                      1
#define VI_MPAL                     2
#define VI_DEBUG                    3
#define VI_DEBUG_PAL                4
#define VI_EURGB60                  5

#define VI_TVMODE(FMT, INT)   ( ((FMT) << 2) + (INT) )

#define VI_MAX_WIDTH_NTSC           720
#define VI_MAX_HEIGHT_NTSC          480

typedef enum
{
    VI_TVMODE_NTSC_INT      = VI_TVMODE(VI_NTSC,        VI_INTERLACE),
    VI_TVMODE_NTSC_DS       = VI_TVMODE(VI_NTSC,        VI_NON_INTERLACE),
    VI_TVMODE_NTSC_PROG     = VI_TVMODE(VI_NTSC,        VI_PROGRESSIVE),

    VI_TVMODE_PAL_INT       = VI_TVMODE(VI_PAL,         VI_INTERLACE),
    VI_TVMODE_PAL_DS        = VI_TVMODE(VI_PAL,         VI_NON_INTERLACE),

    VI_TVMODE_EURGB60_INT   = VI_TVMODE(VI_EURGB60,     VI_INTERLACE),
    VI_TVMODE_EURGB60_DS    = VI_TVMODE(VI_EURGB60,     VI_NON_INTERLACE),

    VI_TVMODE_MPAL_INT      = VI_TVMODE(VI_MPAL,        VI_INTERLACE),
    VI_TVMODE_MPAL_DS       = VI_TVMODE(VI_MPAL,        VI_NON_INTERLACE),

    VI_TVMODE_DEBUG_INT     = VI_TVMODE(VI_DEBUG,       VI_INTERLACE),

    VI_TVMODE_DEBUG_PAL_INT = VI_TVMODE(VI_DEBUG_PAL,   VI_INTERLACE),
    VI_TVMODE_DEBUG_PAL_DS  = VI_TVMODE(VI_DEBUG_PAL,   VI_NON_INTERLACE)
} VITVMode;
    
typedef enum
{
    VI_XFBMODE_SF = 0,
    VI_XFBMODE_DF
} VIXFBMode;

typedef struct _GXRenderModeObj
{
    VITVMode          viTVmode;
    u16               fbWidth;   // no xscale from efb to xfb
    u16               efbHeight; // embedded frame buffer
    u16               xfbHeight; // external frame buffer, may yscale efb
    u16               viXOrigin;
    u16               viYOrigin;
    u16               viWidth;
    u16               viHeight;
    VIXFBMode         xFBmode;   // whether single-field or double-field in 
                                 // XFB.
    u8                field_rendering;    // rendering fields or frames?
    u8                aa;                 // antialiasing on?
    u8                sample_pattern[12][2]; // aa sample pattern
    u8                vfilter[7];         // vertical filter coefficients
} GXRenderModeObj;

void DCStoreRange(void* addr, u32 nBytes);

void VIInit();
void VIFlush();
void VISetBlack(bool black);
void VIConfigure(GXRenderModeObj* rm);
void VIConfigurePan(u16 PanPosX, u16 PanPosY, u16 PanSizeX, u16 PanSizeY);
void VIWaitForRetrace();
void VISetNextFrameBuffer(void *fb);

#define VIPadFrameBufferWidth(width) ((u16)(((u16)(width) + 15) & ~15))

void OSInit();
void *OSGetArenaHi();
void *OSGetArenaLo();
void OSSetArenaHi(void* newHi);
void OSSetArenaLo(void* newLo);
void OSReport(const char* text, ...);

#define OSRoundUp32B(x) (((u32)(x) + 32 - 1) & ~(32 - 1))
#define OSRoundDown32B(x) (((u32)(x)) & ~(32 - 1))

void DBInit();

void __init_registers();
void __init_hardware();
void __init_data();
void __init_user();
"""

    static var dolphinSymbols: String {
        guard game == .XD else {
			printg("This has not been implemented for Colosseum yet.")
			return ""
		}

		guard region == .US else {
			printg("This has not yet been implemented for this region:", region.name)
			return ""
		}

        return """
DCStoreRange = 0x800aaca0;

VIInit               = 0x800b8b30;
VIFlush              = 0x800ba044;
VISetBlack           = 0x800ba1e0;
VIConfigure          = 0x800b94a8;
VIConfigurePan       = 0x800b9cb0;
VIWaitForRetrace     = 0x800b8fe0;
VISetNextFrameBuffer = 0x800ba174;

OSInit       = 0x800a9838;
OSGetArenaHi = 0x800aa950;
OSGetArenaLo = 0x800aa958;
OSSetArenaHi = 0x800aa960;
OSSetArenaLo = 0x800aa968;
OSReport     = 0x800abc80;

DBInit = 0x800b2754;

__init_registers	= 0x800032b0;
__init_hardware	= 0x80003400;
__init_data	= 0x80003340;
__init_user	= 0x800b26c0;
"""

    }
}
