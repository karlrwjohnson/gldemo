import std.stdio;

import std.typetuple;

/// Native and external functions with the same signature.
/// ...except they don't, because "extern (C)" is apparently enough to make it
/// its own type!

extern (C) float doThing(int x);
extern (C) void glClear(uint mask);

extern (C) void noArgs();

float doThingNative(int x) {
    return 1.2;
}

/// Non-templated example

alias doThing_t = extern(C) float function(int);

float delegate(int) callFn (doThing_t glFunction) {
    return (int x) {
        return glFunction(x);
    };
}

/// Templated attempt

alias glFunction_t(R, Args) = extern(C) R function(Args);
alias glFunction_t(R, Args : TypeTuple!()) = extern(C) R function();

R delegate(Args) callGl(R, Args...)(glFunction_t!(R, Args) glFunction) {
    return (Args args) {
        return glFunction(args);
    };
}


/*R delegate() callGl(R)(glFunction_t!(R) glFunction) {
    return () {
        return glFunction();
    };
}*/


template callGl2 (alias fn) {
    typeof(&fn) callGl2 (typeof(&fn) glFunction) {
        return glFunction;
    }
}

typeof(&fn) callGl3 (alias fn) (typeof(&fn) glFunction) {
    return glFunction;
}

mixin template SafeGl (alias glFunctionName, R, Args...) {
    R longandunlikelyfunctionname (Args args) {
        static if (is(R == void)) {
            mixin(glFunctionName ~ "(args);");
            writeln("glGetError() would be called");
        } else {
            mixin("R ret = " ~ glFunctionName ~ "(args);");
            writeln("glGetError() would be called");
            return ret;
        }
    }

    mixin("auto " ~ glFunctionName ~ "_s = &longandunlikelyfunctionname;");
}


mixin SafeGl!("glClear", void, TypeTuple!uint);
mixin SafeGl!("noArgs", void);



void print(T, Args...)(T first, Args args) {
    writeln(first);
    static if (args.length)
        print(args);
}

void print_thru(Args...)(Args args) {
    static if (args.length)
        print(args);
}

/// Driver function

void main() {
    pragma(msg, typeof(&doThing));
    //pragma(msg, typeof(&doThingNative));
    //auto doThing_wrapped = callFn(&doThing);
    //auto doThing_wrapped = callFn(&doThingNative);

    // This works:
/*
    auto doThing2_wrapped = callGl!(float, int)(&doThing);
    writeln(doThing2_wrapped(7));
// */

    //writeln(callGl!(float, int)(&doThing)(7));

    // This works:
    callGl!(void, uint)(&glClear)(18);
    // This doesn't:
    //callGl(&glClear)(18);

    /*callGl!(void)(&noArgs)();*/

    /*print_thru(1, "asdf", 'z');
    print_thru("qwer");
    print_thru();*/

    callGl2!(glClear)(&glClear)(2);
    callGl3!(glClear)(&glClear)(3);

    noArgs_s();

    glClear_s(4);
}
