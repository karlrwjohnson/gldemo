import std_all;

enum BMPMagicValue : char[2] {
    WINDOWS_BITMAP    = "BM",
    OS2_BITMAP_ARRAY  = "BA",
    OS2_COLOR_ICON    = "CI",
    OS2_COLOR_POINTER = "CP",
    OS2_ICON          = "IC",
    OS2_POINTER       = "PT",
};

enum DIBHeaderSize : uint {
    BITMAPCOREHEADER = 12,
    BITMAPINFOHEADER = 40,
    BITMAPV4HEADER   = 108,
    BITMAPV5HEADER   = 124,
};

/**
 * The first 14 bytes of a bitmap file identify its type
 */
struct BMPFileHeader {
    align(1) {
        /*
         * The header field used to identify the BMP and DIB file.
         * The following entries are possible:
         *     BM – Windows 3.1x, 95, NT, ... etc.
         *     BA – OS/2 struct bitmap array
         *     CI – OS/2 struct color icon
         *     CP – OS/2 const color pointer
         *     IC – OS/2 struct icon
         *     PT – OS/2 pointer
         */
        char[2] magic = BMPMagicValue.WINDOWS_BITMAP;
        uint    fileSize;    /// Size of the entire file
        ushort  reserved1;   /// Ignore
        ushort  reserved2;   /// Ignore
        uint    dataOffset;  /// Offset of the pixel data (e.g. 54 = 0x36 for 24-bit bitmaps)
    }

    enum SIZE = 14;

    string toString() {
        return format(
            "magic:      %s\n" ~
            "fileSize:   %u / 0x%x\n" ~
            "reserved1:  %u / 0x%x\n" ~
            "reserved2:  %u / 0x%x\n" ~
            "dataOffset: %u / 0x%x\n",
            magic,
            fileSize  , fileSize,
            reserved1 , reserved1,
            reserved2 , reserved2,
            dataOffset, dataOffset);
    }
}

struct BitmapCoreHeader {
    uint   headerSize = DIBHeaderSize.BITMAPCOREHEADER;
                                   /// the size of this header (40 bytes)
    uint   imageWidthPx;           /// the bitmap width in pixels (signed integer)
    uint   imageHeightPx;          /// the bitmap height in pixels (signed integer)
    ushort numColorPlanes = 1;     /// the number of color planes must be 1
    ushort numBitsPerPixel;        /// the number of bits per pixel, which is the color depth of the image. Typical values are 1, 4, 8, 16, 24 and 32.
}

/**
 * Describes the bitmap file
 */
struct BitmapInfoHeader {
    uint   headerSize = DIBHeaderSize.BITMAPCOREHEADER;
                                   /// the size of this header (40 bytes)
    uint   imageWidthPx;           /// the bitmap width in pixels (signed integer)
    uint   imageHeightPx;          /// the bitmap height in pixels (signed integer)
    ushort numColorPlanes = 1;     /// the number of color planes must be 1
    ushort numBitsPerPixel;        /// the number of bits per pixel, which is the color depth of the image. Typical values are 1, 4, 8, 16, 24 and 32.
    uint   compressionMethod;      /// the compression method being used. See the next table for a list of possible values
    uint   imageDataSize;          /// the image size. This is the size of the raw bitmap data; a dummy 0 can be given for BI_RGB bitmaps.
    int    horizResolution;        /// the horizontal resolution of the image. (pixel per meter, signed integer)
    int    vertResolution;         /// the vertical resolution of the image. (pixel per meter, signed integer)
    uint   numColors;              /// the number of colors in the color palette, or 0 to default to 2n
    uint   numImportantColors = 0; /// the number of important colors used, or 0 when every color is important; generally ignored

    string toString() {
        return format(
            "headerSize:         %u / 0x%x\n" ~
            "imageWidthPx:       %u / 0x%x\n" ~
            "imageHeightPx:      %u / 0x%x\n" ~
            "numColorPlanes:     %u / 0x%x\n" ~
            "numBitsPerPixel:    %u / 0x%x\n" ~
            "compressionMethod:  %u / 0x%x\n" ~
            "imageDataSize:      %u / 0x%x\n" ~
            "horizResolution:    %u / 0x%x\n" ~
            "vertResolution:     %u / 0x%x\n" ~
            "numColors:          %u / 0x%x\n" ~
            "numImportantColors: %u / 0x%x\n",
            headerSize        , headerSize,
            imageWidthPx      , imageWidthPx,
            imageHeightPx     , imageHeightPx,
            numColorPlanes    , numColorPlanes,
            numBitsPerPixel   , numBitsPerPixel,
            compressionMethod , compressionMethod,
            imageDataSize     , imageDataSize,
            horizResolution   , horizResolution,
            vertResolution    , vertResolution,
            numColors         , numColors,
            numImportantColors, numImportantColors);
    }
}

class UnsupportedFileFormatException : Throwable {
    @safe pure nothrow
    this(string msg, string file = __FILE__,
            size_t line = __LINE__, Throwable next = null) {
        super(msg, file, line, next);
    }
}


void loadBitmap (const ubyte[] fileData) {

    enforce(fileData.length >= BMPFileHeader.SIZE,
        format("A bitmap file cannot possibly fit in %d bytes", fileData.length));

    BMPFileHeader* header = cast(BMPFileHeader*) &fileData[0];

    enforce(fileData.length >= header.fileSize,
        format("Bitmap file reports that it is larger (%d bytes) than the " ~
            "size of the buffer it's stored in (%d bytes)",
            header.fileSize,
            fileData.length));

    switch(bmpHeader) {
        case WINDOWS_BITMAP:
            load_WINDOWS_BITMAP(fileData);
            break;
        case OS2_BITMAP_ARRAY:
        case OS2_COLOR_ICON:
        case OS2_COLOR_POINTER:
        case OS2_ICON:
        case OS2_POINTER:
            throw new UnsupportedFileFormatException(format(
                `Unsupported bitmap header type %s "%s"`,
                cast(BMPFileHeader) bmpHeader,
                bmpHeader
            ));
        default:
            throw new UnsupportedFileFormatException(format(
                `Unknown bitmap header type "%s"`,
                bmpHeader
            ));
    }
}

private void load_WINDOWS_BITMAP (const ubyte[] fileData) {
    uint headerSize = *(cast(uint*) &fileData[BMPFileHeader.SIZE]);

    enforce(fildData.length >= BMPFileHeader.SIZE + headerSize,
        format("

    switch(headerSize) {
        case BITMAPINFOHEADER:
            load_BITMAP_INFO_HEADER(fileDA
        case BITMAPCOREHEADER:
        case BITMAPV4HEADER:
        case BITMAPV5HEADER:
    }

}

auto bitmapHeaders(const ubyte[] fileData) {
    BMPFileHeader* bmpHeader = cast(BMPFileHeader*)(&fileData[0]);
    enforce((*bmpHeader).magic == "BM",
        format("File type \"%s\" is not supported", (*bmpHeader).magic));

    BMPDIBInfo* bmpInfo = cast(BMPDIBInfo*)(&fileData[14]);
    enforce((*bmpInfo).headerSize == 40,
        "Header size is not 40. Not sure how to handle this file type.");

    return Tuple!(BMPFileHeader, "file", BMPDIBInfo, "info")(*bmpHeader, *bmpInfo);
}

ubyte[3][][] bitmapPixels (const ubyte[] fileData) {
    auto headers = bitmapHeaders(fileData);

    ubyte[3][][] ret = minimallyInitializedArray!(ubyte[3][][])(headers.info.imageHeightPx, headers.info.imageWidthPx);
    uint i = 0;
    for (int y = headers.info.imageHeightPx - 1; y >= 0; y--) {
        for (uint x = 0; x < headers.info.imageWidthPx; x++) {
            ret[y][x][2] = fileData[headers.file.dataOffset + i++];
            ret[y][x][1] = fileData[headers.file.dataOffset + i++];
            ret[y][x][0] = fileData[headers.file.dataOffset + i++];
        }
        while (i % 4 != 0) {
            i++;
        }
    }

    return ret;
}

unittest {
    immutable ubyte[] fileData = {
        0x42, 0x4d,             // "BM"
        0x66, 0x00, 0x00, 0x00, // 102 bytes
        0x00, 0x00,             // reserved1
        0x00, 0x00,             // reserved2
        0x36, 0x00, 0x00, 0x00, // data begin @ byte 54

        0x28, 0x00, 0x00, 0x00, // 40 byte header
        0x03, 0x00, 0x00, 0x00, // 3 pixels wide
        0x04, 0x00, 0x00, 0x00, // 4 pixels high
        0x01, 0x00,             // 1 color plane
        0x18, 0x00,             // 24 bpp
        0x00, 0x00, 0x00, 0x00, // no compression
        0x30, 0x00, 0x00, 0x00, // 
        0x23, 0x2e, 0x00, 0x00, // horiz resolution = 11811 ppm
        0x23, 0x2e, 0x00, 0x00, // vert resolution = 11811 ppm
        0x00, 0x00, 0x00, 0x00, // 0 colors = no palette
        0x00, 0x00, 0x00, 0x00, // 0 important colors

        0x00, 0x00, 0x00, // black
        0x80, 0x80, 0x80, // gray
        0xff, 0xff, 0xff, // white
        0x00, 0x00, 0x00, // (padding)
        0x00, 0x00, 0x80, // dark red
        0x00, 0x80, 0x00, // dark green
        0x80, 0x00, 0x00, // dark blue
        0x00, 0x00, 0x00, // (padding)
        0xff, 0x00, 0xff, // magenta
        0x00, 0xff, 0xff, // yellow
        0xff, 0xff, 0x00, // cyan
        0x00, 0x00, 0x00, // (padding)
        0x00, 0x00, 0xff, // red
        0x00, 0xff, 0x00, // green
        0xff, 0x00, 0x00, // blue
        0x00, 0x00, 0x00  // padding
    }

    auto header = 

}
