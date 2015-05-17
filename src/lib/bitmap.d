import std.exception;
//import std.format;
import std.string;
import std.array;
import std.stdio;
import std.file;
import std.typecons;
import std.random;
import std.conv;

struct BMPFileHeader {
    align(1) {
        /* The header field used to identify the BMP and DIB file.
           The following entries are possible:
              BM – Windows 3.1x, 95, NT, ... etc.
              BA – OS/2 struct bitmap array
              CI – OS/2 struct color icon
              CP – OS/2 const color pointer
              IC – OS/2 struct icon
              PT – OS/2 pointer
         */
        char[2] magic = "BM";
        uint    fileSize;
        ushort  reserved1;
        ushort  reserved2;
        uint    dataOffset;
    }

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

struct BMPInfoHeader {
    uint   headerSize = 40;        // the size of this header (40 bytes)
    uint   imageWidthPx;           // the bitmap width in pixels (signed integer)
    uint   imageHeightPx;          // the bitmap height in pixels (signed integer)
    ushort numColorPlanes = 1;     // the number of color planes must be 1
    ushort numBitsPerPixel;        // the number of bits per pixel, which is the color depth of the image. Typical values are 1, 4, 8, 16, 24 and 32.
    uint   compressionMethod;      // the compression method being used. See the next table for a list of possible values
    uint   imageDataSize;          // the image size. This is the size of the raw bitmap data; a dummy 0 can be given for BI_RGB bitmaps.
    int    horizResolution;        // the horizontal resolution of the image. (pixel per meter, signed integer)
    int    vertResolution;         // the vertical resolution of the image. (pixel per meter, signed integer)
    uint   numColors;              // the number of colors in the color palette, or 0 to default to 2n
    uint   numImportantColors = 0; // the number of important colors used, or 0 when every color is important; generally ignored

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

auto bitmapHeaders(ubyte[] fileData) {
    BMPFileHeader* bmpHeader = cast(BMPFileHeader*)(&fileData[0]);
    enforce((*bmpHeader).magic == "BM",
        format("File type \"%s\" is not supported", (*bmpHeader).magic));

    BMPInfoHeader* bmpInfo = cast(BMPInfoHeader*)(&fileData[14]);
    enforce((*bmpInfo).headerSize == 40,
        "Header size is not 40. Not sure how to handle this file type.");

    return Tuple!(BMPFileHeader, "file", BMPInfoHeader, "info")(*bmpHeader, *bmpInfo);
}

ubyte[3][][] bitmapPixels (ubyte[] fileData) {
    auto headers = bitmapHeaders(fileData);

    ubyte[3][][] ret = minimallyInitializedArray!(ubyte[3][][])(headers.info.imageHeightPx, headers.info.imageWidthPx);
    writefln("ret.length = %u", ret.length);
    writefln("ret[0].length = %u", ret[0].length);
    writefln("ret[0][0].length = %u", ret[0][0].length);
    writefln("fileData.length = %u", fileData.length);
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

void printBitmap (ubyte[3][][] pixels) {
    string termReset () {
        return "\033[0m";
    }
    ubyte dither24bit8bit (ubyte bit24) {
        ubyte quotient = bit24 * 6 / 256;
        ubyte remainder = bit24 * 6 % 256;
        ubyte threshold = to!ubyte(uniform(0, 256));
        if (remainder > threshold) {
            quotient++;
        }
        if (quotient >= 5) {
            quotient = 5;
        }
        return quotient;
    }
    string termColorFG (ubyte[3] rgb) {
        auto r = dither24bit8bit(rgb[0]);
        auto g = dither24bit8bit(rgb[1]);
        auto b = dither24bit8bit(rgb[2]);
        return format("\033[38;5;%um", 16 + 36*r + 6*g + b);
    }
    string termColorBG (ubyte[3] rgb) {
        auto r = dither24bit8bit(rgb[0]);
        auto g = dither24bit8bit(rgb[1]);
        auto b = dither24bit8bit(rgb[2]);
        return format("\033[48;5;%um", 16 + 36*r + 6*g + b);
    }
    enum wchar FULL_BLOCK = '█';
    enum wchar LOWER_HALF = '▄';
    enum wchar UPPER_HALF = '▀';

    write(termReset());
    for (uint y = 0; y < pixels.length; y += 2) {
        for (uint x = 0; x < pixels[y].length; x++) {
            if (y < pixels.length - 1) {
                write(termColorBG(pixels[y+1][x]));
            }
            write(termColorFG(pixels[y][x]));
            write(UPPER_HALF);
        }
        write(termReset());
        writeln();
    }
}

//void main (string[] args) {
//    enforce(args.length >= 2, "Must specify a filename");
//    writefln("Opening \"%s\"...", args[1]);
//    auto bitmap = cast(ubyte[]) read(args[1]);

//    auto headers = bitmapHeaders(bitmap);
//    writeln(headers.file.toString);
//    writeln(headers.info.toString);

//    auto pixels = bitmapPixels(bitmap);
//    printBitmap(pixels);
//}