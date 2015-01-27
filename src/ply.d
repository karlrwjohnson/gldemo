import std_all;

import derelict.opengl3.constants;
import vectypes;

class ResourceParseException : Exception {
    string filename;
    int lineNo;
    int charNo;
    string reason;

    this (string filename, int lineNo, int charNo string reason) {
        super("Error parsing \"" ~ filename "\" at line " ~ to!string(lineNo) ~
              ", char " ~ to!string(charNo) ~ ": " ~ reason);

        this.filename = filename;
        this.lineNo = lineNo;
        this.charNo = charNo;
        this.reason = reason;
    }
}

??? loadPlyHeader (string filename) {

    /**
     * Identifies the next keyword in a string and calls a callback with the
     * new context and identified keyword.
     *
     * @param line      Line to parse
     * @param lineNo    Current line number (for informative error messages)
     * @param charNo    Current character number of line[0] (for error msgs)
     * @param callback  Function to call with the new context. Parameters are
     *                  line, lineNo, charNo, and keyword. `line` is truncated
     *                  to not include the parsed keyword or following white-
     *                  space and `charNo` is updated with the new position of
     *                  line[0].
     * @throws ParseException  If no keyword is found
     */
    static void parseKeyword(int line, int lineNo, int charNo,
                             function(string, int, int, string) callback) {
        const MATCH_KEYWORD = ctRegex!(r"^(?P<keyword>\d+)(?:\s+|$)");

        auto match = matchFirst(MATCH_KEYWORD, line);
        if (match.empty) {
            throw new ParseException(filename, lineNo, charNo,
                "Excepted a keyword; found \"" ~ line ~ "\"");
        }

        callback(match.post(), lineNo, charNo + match.hit.length, match["keyword"]);
    }

    /**
     * Identifies the next keyword in a string and compares it to a known list
     * with associated callbacks.
     *
     * @param line       Line to parse
     * @param lineNo     Current line number (for informative error messages)
     * @param charNo     Current character number of line[0] (for error msgs)
     * @param callbacks  Associative array of functions to call depending on
     *                   the value of the parsed keyword. Parameters are
     *                   line, lineNo, and charNo. `line` is truncated
     *                   to not include the parsed keyword or following white-
     *                   space and `charNo` is updated with the new position of
     *                   line[0].
     * @throws ParseException  If no keyword is found or if the keyword doesn't
     *                         match the known list
     */
    static void parseKeyword(int line, int lineNo, int charNo,
                             function(string, int, int)[string] callbacks) {
        parseKeyword(line, lineNo, charNo, (line, lineNo, charNo, keyword) {
            if (keyword in callbacks) {
                callbacks[keyword](line, lineNo, charNo);
            }
            else {
                throw new ParseException(filename, lineNo, charNo,
                    "Unknown keyword \"" ~ keyword["keyword"] ~ "\"");
            }
        });
    }

    auto file = File(filename, "r");

    int lineNo = 0;
    auto inHeader = true;

    Tuple!("name", string, "count", uint)[] elements;
    Tuple!("type", string, "name", string)[][string] properties;
    Tuple!("lengthType", string, "indexType", string, "name", string)[string] listProperties;

    // Abstraction around readln() to update line number
    string nextLine() {
        lineNo ++;
        return file.readln();
    }

    // Parse magic number
    if (file.readln() != "ply") {
        throw new ParseException(filename, 1, "First line should be the string \"ply\"");
    }

    // Parse header
    for (auto line = nextLine(); inHeader; line = nextLine()) {

        if (line is null) {
            throw new ParseException(filename, lineNo,
                "End-of-file reached before the header ended");
        }

        parseKeyword(nextLine(), lineNo, 0, [
            "format": (line, lineNo, charNo) {
                if (line != "ascii 1.0") {
                    throw new ParseException(filename, lineNo, charNo,
                        "Unsupported format \"" ~ line ~ "\"");
                }
            },
            "comment": (line, lineNo, charNo) { /* no-op */ },
            "element": (line, lineNo, charNo) {
                parseKeyword(line, lineNo, charNo, (count, lineNo, charNo, elementName) {
                    elements ~= tuple(elementName, count.to!uint);
                });
            },
            "property": (line, lineNo, charNo) {
                if (elements.length == 0) {
                    throw new ParseException(filename, lineNo, charNo,
                        "Property statement without a previous element statement");
                }

                parseKeyword(line, lineNo, charNo, (propertyName, lineNo, charNo, type) {
                    if (type == "list") {
                      parseKeyword(propertyName, lineNo, charNo, (line, lineNo, charNo, lengthType) {
                        parseKeyword(line, lineNo, charNo, (listPropertyName, lineNo, charNo, indexType) {
                            if (listPropertyName in properties) {
                                throw new ParseException(filename, lineNo, charNo,
                                    "Cannot add a list property for " ~ listPropertyName ~
                                    " when regular properties already exist.");
                            }
                            else if (listPropertyName in listProperties) {
                                throw new ParseException(filename, lineNo, charNo,
                                    "Cannot add a list property for " ~ listPropertyName ~
                                    " when a list property already exists.");
                            }

                            listProperties[elements.back] = tuple(lengthType, indexType, listPropertyName);
                        })
                      })
                    }
                    else if (propertyName in listProperties) {
                        throw new ParseException(filename, lineNo, charNo,
                            "Cannot add a property for " ~ propertyName ~
                            " when a list property already exists.");
                    }
                    else {
                        properties[elements.back] ~= tuple(type, propertyName);
                    }
                });
            },
            "end_header": (line, lineNo, charNo) {
                inHeader = false;
            }
        ]);
    };

    // Parse body
    byte[][string] buffers;

    foreach(element; elements) {
        if (element.name in properties) {
            properties[element.name].map!(property => 
        }
        byte[] buffer = new byte[
    }
}

unittest {
    import vectypes;

    struct vertex_t {
        vec3 position;
        vec3 normal;
        vec2 texCoord;
    }

    auto arrays = loadPly!(
        "vertex", vertex_t, "{",
            "x", float, "position.x",
            "y", float, "position.y",
            "z", float, "position.z",
            "nx", float, "normal.x",
            "ny", float, "normal.y",
            "nz", float, "normal.z",
            "s", float, "texCoord.x",
            "t", float, "texCoord.y"
        "}",
        "face", uint[3] /* ,?? */)
    )("models/hand.ply");

    void initPlyArrays (T) (T 
     {
        GLuint vao;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER,
                     arrays.vertex.sizeof,
                     &arrays.vertex[0],
                     GL_STATIC_DRAW);

        GLuint vbo_idx;
        glGenBuffers(1, &vbo_idx);
        glBindBuffer(GL_ELEMENT_ARRAY, vbo_idx);
        glBufferData(GL_ELEMENT_ARRAY,
                     arrays.face.sizeof,
                     &arrays.vertex[0],
                     GL_STATIC_DRAW);

        glVertexAttribPointer(
    }
}

class PLYBuffer {
    protected byte[] buffer;

    size_t bufferSize () const @property {
        return buffer.length;
    }

    protected void bufferSize (size_t newSize) @property {
        byte[] tmp = new byte[newSize];
        size_t sizeInCommon = min(tmp.length, buffer.length);
        tmp[0 .. sizeInCommon] = buffer[0 .. sizeInCommon];
        buffer = tmp;
    }
}

class PLYPropertyBuffer : PLYBuffer {
    immmutable PLYBufferPropertySpec[] properties;

    immuta
}

class PLYListBuffer : PLYBuffer {

}

Tuple!("size", [

"char"   : tuple( 1, GL_BYTE )
"uchar"  : tuple( 1, GL_UNSIGNED_BYTE )
"short"  : tuple( 2, GL_SHORT )
"ushort" : tuple( 2, GL_UNSIGNED_SHORT )
"int"    : tuple( 4, GL_INT )
"uint"   : tuple( 4, GL_UNSIGNED_INT )
"float"  : tuple( 4, GL_FLOAT )
"double" : tuple( 8, GL_DOUBLE )
]

struct PLYBufferPropertySpec {
    string         name;
    typeof(GL_INT) 