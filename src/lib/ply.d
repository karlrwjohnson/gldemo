import std_all;

import derelict.opengl3.constants;
import derelict.opengl3.types;

alias gl_type_type = typeof(GL_INT);

enum GL_TYPE : gl_type_type {
    GL_BYTE           = derelict.opengl3.constants.GL_BYTE,
    GL_UNSIGNED_BYTE  = derelict.opengl3.constants.GL_UNSIGNED_BYTE,
    GL_SHORT          = derelict.opengl3.constants.GL_SHORT,
    GL_UNSIGNED_SHORT = derelict.opengl3.constants.GL_UNSIGNED_SHORT,
    GL_INT            = derelict.opengl3.constants.GL_INT,
    GL_UNSIGNED_INT   = derelict.opengl3.constants.GL_UNSIGNED_INT,
    GL_FLOAT          = derelict.opengl3.constants.GL_FLOAT,
    GL_DOUBLE         = derelict.opengl3.constants.GL_DOUBLE,
}

GL_TYPE plyToGlType (string tname) {
    switch (tname) {
        case "char"   : return GL_TYPE.GL_BYTE;
        case "uchar"  : return GL_TYPE.GL_UNSIGNED_BYTE;
        case "short"  : return GL_TYPE.GL_SHORT;
        case "ushort" : return GL_TYPE.GL_UNSIGNED_SHORT;
        case "int"    : return GL_TYPE.GL_INT;
        case "uint"   : return GL_TYPE.GL_UNSIGNED_INT;
        case "float"  : return GL_TYPE.GL_FLOAT;
        case "double" : return GL_TYPE.GL_DOUBLE;
        default : throw new Exception("\"" ~ tname ~ "\" is not a valid PLY type");
    }
}

size_t sizeOfGLType (GL_TYPE tid) {
    final switch (tid) {
        case GL_TYPE.GL_BYTE           : return GLbyte  .sizeof;
        case GL_TYPE.GL_UNSIGNED_BYTE  : return GLubyte .sizeof;
        case GL_TYPE.GL_SHORT          : return GLshort .sizeof;
        case GL_TYPE.GL_UNSIGNED_SHORT : return GLushort.sizeof;
        case GL_TYPE.GL_INT            : return GLint   .sizeof;
        case GL_TYPE.GL_UNSIGNED_INT   : return GLuint  .sizeof;
        case GL_TYPE.GL_FLOAT          : return GLfloat .sizeof;
        case GL_TYPE.GL_DOUBLE         : return GLdouble.sizeof;
    }
}

class PLYBuffer {
    string name;
    size_t rowCount;

    /*protected*/ public byte[] buffer;

    this (string name, size_t rowCount) {
        this.name     = name;
        this.rowCount = rowCount;
    }

    size_t bufferSize () const @property {
        return buffer.length;
    }

    protected void bufferSize (size_t newSize) @property {
        byte[] tmp = new byte[newSize];
        size_t sizeInCommon = min(tmp.length, buffer.length);
        tmp[0 .. sizeInCommon] = buffer[0 .. sizeInCommon];
        buffer = tmp;
    }

    abstract void loadRow (size_t rowIndex, string[] newRow);

    void* bufferPtr () const @property {
        return cast(void*)(&buffer[0]);
    }
}

/+class PLYGenericPropertyBuffer : PLYBuffer {

    public static struct GenericPropertyDescriptor {
        string  name;
        size_t  numValues;
        GL_TYPE type;
        GL_TYPE lengthType;
        size_t  columnOffset;

        /// Single-valued property constructor
        public this (string name, GL_TYPE type) {
            this.name      = name;
            this.numValues = 1;
            this.type      = type;
        }

        /// Multi-valued property constructor
        public this (string name, GL_TYPE type, GL_TYPE lengthType) {
            this.name       = name;
            this.numValues  = 0;         // still unknown
            this.type       = type;
            this.lengthType = lengthType;
        }
    }

    GenericPropertyDescriptor[]] properties;

    public this (string name, size_t rowCount, const GenericPropertyDescriptor[] properties) {
        super(name, rowCount);

        this.properties = properties.dup;

        this.bufferSize = 0;
    }


    private void initFromRow (string[] values) {
        // Calculate the total required size

        size_t columnOffset = 0;
        for (var i = 0; i < properties.length; i++) {
            if (properties[i].length == 1) {
                properties[i].columnOffset = columnOffset;
                columnOffset += sizeOfGLType(properties[i]
            }
        }
    }

    public void loadRow (size_t r, string[] values) {
        if (this.bufferSize == 0) {
            initFromRow(values);
        }
    }
}+/

class PLYNamedPropertyBuffer : PLYBuffer {

    public static struct PropertyDescriptor {
        string  name;
        GL_TYPE type;
        size_t  offset;
    }

    size_t rowSize;

    public PropertyDescriptor[] properties;

    size_t propertyIndices[string];

    this (string name, size_t rowCount, const PropertyDescriptor[] properties) {
        super(name, rowCount);

        this.properties = properties.dup;

        size_t offset = 0;
        foreach (i, property; properties) {
            this.properties[i].offset = offset;
            offset += sizeOfGLType(property.type);

            propertyIndices[property.name] = i;            
        }

        rowSize = offset;

        bufferSize = rowSize * rowCount;
    }

    T opIndexAssign (T) (T value, size_t rowIndex, string property) {
        if (property !in propertyIndices)
            throw new Exception("Property " ~ property ~ " is not defined for this buffer");

        return this[rowIndex, propertyIndices[property]] = value;
    }
    T opIndexAssign (T) (T value, size_t rowIndex, size_t property) {
        if (property < 0 || property >= properties.length) {
            throw new Exception("Property index " ~ property.to!string ~ " is out of range");
        }

        if (rowIndex < 0 || rowIndex >= rowCount) {
            throw new Exception("Row " ~ rowIndex.to!string ~ " is out of range");
        }

        auto bufferAddr = &buffer[rowSize * rowIndex + properties[property].offset];

        switch (properties[property].type) {
            case GL_TYPE.GL_BYTE           : *cast(GLbyte  *)bufferAddr = to!GLbyte  (value); break;
            case GL_TYPE.GL_UNSIGNED_BYTE  : *cast(GLubyte *)bufferAddr = to!GLubyte (value); break;
            case GL_TYPE.GL_SHORT          : *cast(GLshort *)bufferAddr = to!GLshort (value); break;
            case GL_TYPE.GL_UNSIGNED_SHORT : *cast(GLushort*)bufferAddr = to!GLushort(value); break;
            case GL_TYPE.GL_INT            : *cast(GLint   *)bufferAddr = to!GLint   (value); break;
            case GL_TYPE.GL_UNSIGNED_INT   : *cast(GLuint  *)bufferAddr = to!GLuint  (value); break;
            case GL_TYPE.GL_FLOAT          : *cast(GLfloat *)bufferAddr = to!GLfloat (value); break;
            case GL_TYPE.GL_DOUBLE         : *cast(GLdouble*)bufferAddr = to!GLdouble(value); break;
            default:
                throw new Exception("Cannot assign: Property " ~ properties[property].name ~
                    " (index " ~ property.to!string ~ ") has an unknown type id of " ~ properties[property].type.to!string);
        }

        return value;
    }

    T opIndex (T) (size_t rowIndex, string property) {
        if (property !in propertyIndices)
            throw new Exception("Property " ~ property ~ " is not defined for this buffer");

        return this.opIndex!T(rowIndex, propertyIndices[property]);
    }
    T opIndex (T) (size_t rowIndex, size_t property) {
        if (property < 0 || property >= properties.length) {
            throw new Exception("Property index " ~ property.to!string ~ " is out of range");
        }

        if (rowIndex < 0 || rowIndex >= rowCount) {
            throw new Exception("Row " ~ rowIndex.to!string ~ " is out of range");
        }

        auto bufferAddr = &buffer[rowSize * rowIndex + properties[property].offset];

        switch (properties[property].type) {
            case GL_TYPE.GL_BYTE           : return to!T( *cast(GLbyte  *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_BYTE  : return to!T( *cast(GLubyte *)bufferAddr );
            case GL_TYPE.GL_SHORT          : return to!T( *cast(GLshort *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_SHORT : return to!T( *cast(GLushort*)bufferAddr );
            case GL_TYPE.GL_INT            : return to!T( *cast(GLint   *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_INT   : return to!T( *cast(GLuint  *)bufferAddr );
            case GL_TYPE.GL_FLOAT          : return to!T( *cast(GLfloat *)bufferAddr );
            case GL_TYPE.GL_DOUBLE         : return to!T( *cast(GLdouble*)bufferAddr );
            default:
                throw new Exception("Cannot retrieve: Property " ~ properties[property].name ~
                    " (index " ~ property.to!string ~ ") has an unknown type id of " ~ properties[property].type.to!string);
        }
    }

    override void loadRow (size_t rowIndex, string[] newRow) {
        if (newRow.length != properties.length) {
            for (size_t i = 0; i < newRow.length; i++) {
                writefln("%d: \"%s\"", i, newRow);
            }
            throw new Exception("Row had " ~ newRow.length.to!string ~ " entries, but " ~
                properties.length.to!string ~ " were expected. (Found \"" ~ newRow.to!string ~ "\")");
        }

        for (size_t i = 0; i < newRow.length; i++) {
            this[rowIndex, i] = newRow[i];
        }
    }
}

class PLYListPropertyBuffer : PLYBuffer {

    public static struct PropertyListDescriptor {
        string  name;
        GL_TYPE type;
        GL_TYPE lengthType;
    }

    PropertyListDescriptor property;

    size_t colCount = 0;
    size_t rowSize;

    this (string name, size_t rowCount, const PropertyListDescriptor[] properties) {
        super(name, rowCount);

        if (properties.length != 1) {
            throw new Exception("Expected exactly 1 property list; got " ~ properties.length.to!string);
        }
        property = properties[0];

    }

    T opIndexAssign (T) (T value, size_t rowIndex, size_t property) {
        if (property < 0 || property >= colCount) {
            throw new Exception("Property index " ~ property.to!string ~ " is out of range");
        }

        if (rowIndex < 0 || rowIndex >= rowCount) {
            throw new Exception("Row " ~ rowIndex.to!string ~ " is out of range");
        }

        auto bufferAddr = &buffer[rowSize * rowIndex + sizeOfGLType(this.property.type) * property];

        switch (this.property.type) {
            case GL_TYPE.GL_BYTE           : *cast(GLbyte  *)bufferAddr = to!GLbyte  (value); break;
            case GL_TYPE.GL_UNSIGNED_BYTE  : *cast(GLubyte *)bufferAddr = to!GLubyte (value); break;
            case GL_TYPE.GL_SHORT          : *cast(GLshort *)bufferAddr = to!GLshort (value); break;
            case GL_TYPE.GL_UNSIGNED_SHORT : *cast(GLushort*)bufferAddr = to!GLushort(value); break;
            case GL_TYPE.GL_INT            : *cast(GLint   *)bufferAddr = to!GLint   (value); break;
            case GL_TYPE.GL_UNSIGNED_INT   : *cast(GLuint  *)bufferAddr = to!GLuint  (value); break;
            case GL_TYPE.GL_FLOAT          : *cast(GLfloat *)bufferAddr = to!GLfloat (value); break;
            case GL_TYPE.GL_DOUBLE         : *cast(GLdouble*)bufferAddr = to!GLdouble(value); break;
            default:
                throw new Exception("Cannot assign: Property has an unknown type id of " ~ this.property.type.to!string);
        }

        return value;
    }

    T opIndex (T) (size_t rowIndex, size_t property) {
        if (property < 0 || property >= colCount) {
            throw new Exception("Property index " ~ property.to!string ~ " is out of range");
        }

        if (rowIndex < 0 || rowIndex >= rowCount) {
            throw new Exception("Row " ~ rowIndex.to!string ~ " is out of range");
        }

        auto bufferAddr = &buffer[rowSize * rowIndex + sizeOfGLType(this.property.type) * property];

        switch (this.property.type) {
            case GL_TYPE.GL_BYTE           : return to!T( *cast(GLbyte  *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_BYTE  : return to!T( *cast(GLubyte *)bufferAddr );
            case GL_TYPE.GL_SHORT          : return to!T( *cast(GLshort *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_SHORT : return to!T( *cast(GLushort*)bufferAddr );
            case GL_TYPE.GL_INT            : return to!T( *cast(GLint   *)bufferAddr );
            case GL_TYPE.GL_UNSIGNED_INT   : return to!T( *cast(GLuint  *)bufferAddr );
            case GL_TYPE.GL_FLOAT          : return to!T( *cast(GLfloat *)bufferAddr );
            case GL_TYPE.GL_DOUBLE         : return to!T( *cast(GLdouble*)bufferAddr );
            default:
                throw new Exception("Cannot assign: Property has an unknown type id of " ~ this.property.type.to!string);
        }
    }

    override void loadRow (size_t rowIndex, string[] newRow) {

        // If this is the first row, allocate the buffer
        if (colCount == 0) {
            colCount = to!size_t(newRow[0]);

            rowSize = sizeOfGLType(this.property.type) * colCount;
            bufferSize = rowSize * rowCount;
        }
        else if (colCount != to!size_t(newRow[0])) {
            throw new Exception("Property list length mismatch. The first entry had " ~
                colCount.to!string ~ " items, but this row has " ~ newRow[0] ~
                ". (Found " ~ newRow.to!string ~ ")");
        }

        for (size_t i = 1; i < newRow.length; i++) {
            this[rowIndex, i - 1] = newRow[i];
        }
    }
}



PLYBuffer[] loadPLY (FileClass = File) (string filename) {

    // Regex Constants
    const STR_MATCH_TYPE     = `(char|uchar|short|ushort|int|uint|float|double)`;
    auto MATCH_MAGIC_NUMBER  = regex(`^ply$`);
    auto MATCH_FORMAT        = regex(`^format\s+(?P<encoding>\S+)\s+(?P<version>\S+)$`);
    auto MATCH_COMMENT       = regex(`^comment\s+.*$`);
    auto MATCH_ELEMENT       = regex(`^element\s+(?P<name>\S+)\s+(?P<count>\d+)$`);
    auto MATCH_PROPERTY_LIST = regex(`^property\s+list\s+(?P<lengthType>`
                                         ~ STR_MATCH_TYPE ~ `)\s+(?P<type>`
                                         ~ STR_MATCH_TYPE ~ `)\s+(?P<name>\S+)$`);
    auto MATCH_PROPERTY      = regex(`^property\s+(?P<type>`
                                         ~ STR_MATCH_TYPE ~ `)\s+(?P<name>\S+)$`);
    auto MATCH_END_HEADER    = regex(`^end_header\s*$$`);
    auto MATCH_WHITESPACE    = regex(`\s+`);

    // Variables
    auto file = new FileClass(filename, "r");

    string elementName = "";
    size_t rowCount;
    PLYNamedPropertyBuffer.PropertyDescriptor[] properties;
    PLYListPropertyBuffer.PropertyListDescriptor[] listProperties;

    // Return value
    PLYBuffer[] buffers;

    // Verify magic number
    {
        auto line = file.readln;
        if (line.strip.matchFirst(MATCH_MAGIC_NUMBER).empty) {
            throw new Exception("PLY file lacks a magic number. Found \"" ~ line ~ "\"", filename, 1);
        }
    }

    // Verify format header
    {
        auto line  = file.readln;
        auto match = line.strip.matchFirst(MATCH_FORMAT);
        if (match.empty) {
            throw new Exception("PLY file lacks a valid format specification. Found \"" ~ line ~ "\"", filename, 2);
        }
        else if (match["encoding"] != "ascii") {
            throw new Exception("Unsupported PLY format; only ascii is supported. Found \"" ~ line ~ "\"", filename, 2);
        }
        else if (match["version"] != "1.0") {
            throw new Exception("Unsupported PLY version; only 1.0 is supported. Found \"" ~ line ~ "\"", filename, 2);
        }
    }

    // Helper function: package the current element as a buffer and append it to
    // the list
    void finishElement() {
        if (elementName != "") {
            if (properties.length > 0) {
                buffers ~= new PLYNamedPropertyBuffer(elementName, rowCount, properties);
            }
            else {
                buffers ~= new PLYListPropertyBuffer(elementName, rowCount, listProperties);
            }

            elementName = "";
            properties = [];
            listProperties = [];
        }
    }

    for (auto i = 3, line = file.readln.strip; line != null; line = file.readln.strip, i++) {

        Captures!string match;
        bool matches (T) (T regex) {
            match = line.matchFirst(regex);
            return cast(bool) match;
        }

        if (matches(MATCH_COMMENT)) {
            continue;
        }
        else if (matches(MATCH_ELEMENT)) {
            finishElement();
            elementName = match["name"];
            rowCount    = match["count"].to!size_t;
        }
        else if (matches(MATCH_PROPERTY_LIST)) {
            if (listProperties.length > 0) {
                throw new Exception("Having multiple list properties isn't supported.", filename, i);
            }
            if (listProperties.length > 0) {
                throw new Exception("An element cannot include both list properties and named properties", filename, i);
            }
            listProperties ~= PLYListPropertyBuffer.PropertyListDescriptor(match["name"], plyToGlType(match["type"]), plyToGlType(match["lengthType"]));
        }
        else if (matches(MATCH_PROPERTY)) {
            if (listProperties.length > 0) {
                throw new Exception("An element cannot include both list properties and named properties", filename, i);
            }
            properties ~= PLYNamedPropertyBuffer.PropertyDescriptor(match["name"], plyToGlType(match["type"]));
        }
        else if (matches(MATCH_END_HEADER)) {
            finishElement();
            break;
        }
        else {
            throw new Exception("Syntax error while parsing PLY file. Found \"" ~ line ~ "\"", filename, i);
        }
    }

    // load data...
    for (auto line = file.readln.strip, bufferRow = 0, bufferIdx = 0; line != null; line = file.readln.strip, bufferRow++) {
        if (bufferRow >= buffers[bufferIdx].rowCount) {
            bufferRow = 0;
            bufferIdx++;
        }

        buffers[bufferIdx].loadRow(bufferRow, line.split(MATCH_WHITESPACE));
    }

    return buffers;
}

unittest {
    /*
     +z    Fig. 1 - The cube described in testFile
      ^
      |  6 #===========# 7
      |   /|          /|
         / |         / |     _
      4 #===========# 5|     /| +y
        |  |        |  |    /
        |  |        |  |   /
        |2 +--------|--# 3
        | /         | /
        |/          |/
      0 #===========# 1  --> +x
    */

    enum testFile = r"ply
format ascii 1.0
comment Test Cube
element vertex 8
property float x
property float y
property float z
element vertex_indices 12
property list uchar uint vertex_indices
end_header
-1 -1 -1
-1 -1  1
-1  1 -1
-1  1  1
 1 -1 -1
 1 -1  1
 1  1 -1
 1  1  1
3 0 2 3
3 0 3 1
3 4 5 7
3 4 7 6
3 0 1 5
3 0 5 4
3 2 6 7
3 2 7 3
3 0 4 6
3 0 6 2
3 1 3 7
3 1 7 5
";

    static struct MockFile (string fileContents) {

        size_t testFileIndex = 0;

        public this (string filename, string mode) { };

        public string readln() {
            if (testFileIndex >= fileContents.length) {
                return null;
            }

            auto oldPtr = testFileIndex;

            // Scan for the next newline
            for (; fileContents[testFileIndex] != '\n' && testFileIndex <= fileContents.length; testFileIndex++) { }
            testFileIndex++;

            return fileContents[oldPtr .. testFileIndex];
        }

    }

    auto buffers = loadPLY!(MockFile!testFile)("mock file");

    assert(buffers.length == 2);
    assert(cast(PLYNamedPropertyBuffer) buffers[0]);
    assert(cast(PLYListPropertyBuffer)  buffers[1]);

    PLYNamedPropertyBuffer vertex         = cast(PLYNamedPropertyBuffer) buffers[0];
    PLYListPropertyBuffer  vertex_indices = cast(PLYListPropertyBuffer)  buffers[1];

    assert(vertex.name == "vertex");
    assert(vertex.rowCount == 8);

    assert(vertex_indices.name == "vertex_indices");
    assert(vertex_indices.rowCount == 12);

    assert(vertex.opIndex!float(0, "x") == -1);
    assert(vertex.opIndex!float(0, "y") == -1);
    assert(vertex.opIndex!float(0, "z") == -1);
    assert(vertex.opIndex!float(1, "x") == -1);
    assert(vertex.opIndex!float(1, "y") == -1);
    assert(vertex.opIndex!float(1, "z") ==  1);
    assert(vertex.opIndex!float(2, "x") == -1);
    assert(vertex.opIndex!float(2, "y") ==  1);
    assert(vertex.opIndex!float(2, "z") == -1);
    assert(vertex.opIndex!float(7, "x") ==  1);
    assert(vertex.opIndex!float(7, "y") ==  1);
    assert(vertex.opIndex!float(7, "z") ==  1);

    assert(vertex_indices.opIndex!uint( 0, 0) == 0);
    assert(vertex_indices.opIndex!uint( 0, 1) == 2);
    assert(vertex_indices.opIndex!uint( 0, 2) == 3);
    assert(vertex_indices.opIndex!uint( 1, 0) == 0);
    assert(vertex_indices.opIndex!uint( 1, 1) == 3);
    assert(vertex_indices.opIndex!uint( 1, 2) == 1);
    assert(vertex_indices.opIndex!uint(11, 0) == 1);
    assert(vertex_indices.opIndex!uint(11, 1) == 7);
    assert(vertex_indices.opIndex!uint(11, 2) == 5);
}
