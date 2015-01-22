import vectypes;

/*
    What is necessary to describe a map?
     - Dimensions -- length and width, maybe height
     - Stuff on it -- floors, walls, barriers, spawn points (maybe?)

    How do I load this stuff in? From a text file.
    How is this text file generated?
     - If by hand --> That's a lot of manual labor at n^2 or n^3 efficiency
     - If by computer --> Do I need to make an editor? I don't want to make an editor.

    Side note: Can I make a JSON importer?
        Maybe D already has one.
        Does D have reflection? Annotations? Is there a way I can deserialize JSON directly into "D beans"?

*/

abstract interface Entity {
}
/+
class Barrier : Entity {
    uint x;
    uint y;

}

class ThinWall : Barrier {
    /**
     * Whether the wall extends along the x or y axis
     *
     *             Top view:
     *    +y ^
     *       |      YAXIS
     *       +      +      + (x+1,y+1)
     *       |      #
     *       |      #
     *       +      +======+ XAXIS
     *       | (x,y)     (x+1,y)
     *       |
     *       +------+-------+-> +x
     */
    enum Orientation {
        XAXIS,
        YAXIS
    }

    uint x;
    uint y;
    uint z;
    Orientation orientation;

}


class Map {

    uint _width;
    uint _length;
    uint _height;

    Entity[] entities;

    public this (uint width, uint length, uint height) {
        this._width = width;
        this._length = length;
        this._height = height;
    }

    uint width  () const @property { return this._width;  }
    uint length () const @property { return this._length; }
    uint height () const @property { return this._height; }

    Board makeBoard () {
        Board ret = new Board(width, length, height);

        return ret;
    }

    unittest {
        auto map = new Map(3,5,7);
        auto board = map.makeBoard();
        assert(board.width == 3);
        assert(board.length == 5);
        assert(board.height == 7);
    }
}

class Board {

    uint _width;
    uint _length;
    uint _height;

    public this (uint width, uint length, uint height) {
        this._width = width;
        this._length = length;
        this._height = height;
    }

    uint width  () const @property { return this._width;  }
    uint length () const @property { return this._length; }
    uint height () const @property { return this._height; }
}

version(unittest) {
    import std.stdio;
    void main () {
        writeln("unittests succeeded");
    }
}

+/

class Board {
    uint width;
    uint length;

    public this (uint width = 8; uint length = 8) {

    }
}

class Entity {
    int x;
    int y;
    int z;

    public this (int x, int y, int z) {
    }
}

class PawnEntity : Entity {

}

class Model {
    // Filename, arrays, shader program or shader fragmant? Uniforms
}