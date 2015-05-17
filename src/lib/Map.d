class Map {
    int width;
    int length;

    int[2][] pawnLocations;

    this () {
        this.width = 1;
        this.length = 1;
    }

    this (int width, int length) {
        this.width = width;
        this.length = length;
    }
}
