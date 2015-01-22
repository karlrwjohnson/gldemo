class Map {
    int width;
    int length;

    int[2][] pawnLocations;

    this (int width, int length) {
        this.width = width;
        this.length = length;
    }

    static Map getSampleMap () {
        Map ret = new Map(8,8);
        ret.pawnLocations = [
            [0,0], [2,0], [4,0], [6,0],
            [1,1], [3,1], [5,1], [7,1],
            [0,2], [2,2], [4,2], [6,2],
            [1,5], [1,5], [1,5], [1,5],
            [0,6], [0,6], [0,6], [0,6],
            [1,7], [1,7], [1,7], [1,7],
        ];
        return ret;
    }
}
