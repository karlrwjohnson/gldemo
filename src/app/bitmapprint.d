import std.getopt;

import bitmap;
import std_all;

/**
 * Prints bitmap data to a terminal using ANSI color codes and the unicode
 * half-height block character. As each terminal character corresponds to two
 * pixels, this can produce quite large images.
 * 
 * @param pixels Image data 
 */
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

void main (string[] args) {
	auto opts = getopt(args);
	if (opts.helpWanted) {
		defaultGetoptPrinter(
			"Renders some 24-bit bitmaps on an ANSI-compatible terminal",
			opts.options
		);
	}

    enforce(args.length >= 2, "Must specify a filename");
    writefln("Opening \"%s\"...", args[1]);
    auto bitmap = cast(ubyte[]) read(args[1]);

    writeln(getBitmapFileHeader(bitmap).toString);
    writeln(getBitmapInfo(bitmap).toString);

    auto pixels = bitmapPixels(bitmap);
    printBitmap(pixels);
}