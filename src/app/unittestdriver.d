version (unittest) {
    import std.stdio;

    void main() {
        writeln("All unit tests passed.");
    }
}
else {
    import gldemo;

    int main(string[] args) {
        return _main(args);
    }
}