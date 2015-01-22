import std.algorithm;
import std.array;
import std.conv;
import std.json;
import std.string : join;
import std.traits;
import std.typetuple;

/**
 * Whether a member of a type may be serialized.
 *
 * The raw list given by __traits!(allMembers) may include members which
 * cannot be passed to typeof(), such as abstract classes. Additionally,
 * method and property members (i.e. getter/setter methods) simply don't
 * make sense to serialze as they get their information externally.
 *
 * This macro function may be used to weed them out.
 */
bool isSerializableProperty (T, string member) () {
    return !(isAbstractClass!(__traits(getMember, T, member)) ||
             isCallable!(__traits(getMember, T, member))
    );
}

/**
 * Get a tuple of members attached to a class which are serializable.
 */
template getProperties (T) {
    // Add a layer of indirection around isSerializableProperty that Filter!() can accept.
    alias isSerializableProperty_alias (string member) = isSerializableProperty!(T, member);

    alias getProperties = Filter!(isSerializableProperty_alias, __traits(allMembers, T));
}

alias ValueTypeStaticArray(V : V[i], int i) = V;
alias ValueTypeDynamicArray(V : V[]) = V;

/**
 * Serialize a class to JSON.
 * 
 * All basic types are supported, as well as strings, both static and dynamic
 * arrays, and child objects.
 *
 * Structs have not been tested.
 *
 * ABSOLUTELY NO CYCLE DETECTION HAS BEEN IMPLEMENTED! FOR THE LOVE OF ALL
 * THAT IS GOOD AND PURE PLEASE DO NOT PASS AN OBJECT WITH A CYCLICAL
 * REFERENCE TO THIS FUNCTION!
 *
 * @param value  The object or value to serialize
 */
JSONValue pickle (T) (T value) {
    JSONValue ret;

    debug pragma(msg, ":: ", T);

    static if (isBoolean!T) {
        debug pragma(msg, "-- isBoolean");

        ret = value;
    }
    else static if (isIntegral!T) {
        debug pragma(msg, "-- isIntegral");

        static if (isSigned!T) {
            debug pragma(msg, "-- isSigned");

            ret.integer = value;
        }
        else static if (isUnsigned!T) {
            debug pragma(msg, "-- isUnsigned");

            ret.uinteger = value;
        }
    }
    else static if (isFloatingPoint!T) {
        debug pragma(msg, "-- isFloatingPoint");

        ret.floating = value;
    }
    else static if (isSomeString!T) {
        debug pragma(msg, "-- isSomeString");

        ret.str = value.idup;
    }
    else static if (isArray!T) {
        debug pragma(msg, "-- isArray");

        ret.array = value.array.map!(a => pickle(a)).array;
    }
    else static if (isAggregateType!T) {
        debug pragma(msg, "-- isAggregateType");

        JSONValue[string] properties;
        foreach (member; getProperties!T) {
            properties[member] = pickle(__traits(getMember, value, member));
        }

        ret.object = properties;
    }
    return ret;
}

/**
 * Deserialize an object from JSON
 *
 * @param json               The JSON tree to deserialize
 * @param requireAllFields   Consider it an error if some fields aren't present in the JSON object
 * @param T                  The type of object to convert to
 */
T unpickle(T)(JSONValue json, bool requireAllFields = true) {
    debug pragma(msg, "unpickling type ", T);

    // Error string that gets thrown
    string errorString = "Cannot convert JSON type " ~ json.type.to!string ~ " to target type " ~ T.stringof;

    final switch (json.type) {
        case JSON_TYPE.STRING:
            static if (isSomeString!T) {
                debug pragma(msg, " - isSomeString");
                return json.str.to!T;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.INTEGER:
            static if (isIntegral!T && isSigned!T) {
                debug pragma(msg, " - isIntegral && isSigned");
                return json.integer.to!T;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.UINTEGER:
            static if (isIntegral!T && isUnsigned!T) {
                debug pragma(msg, " - isIntegral && isUnsigned");
                return json.uinteger.to!T;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.FLOAT:
            static if (isFloatingPoint!T) {
                debug pragma(msg, " - isFloatingPoint");
                return json.floating.to!T;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.TRUE:
            static if (isBoolean!T) {
                debug pragma(msg, " - isBoolean");
                return true;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.FALSE:
            static if (isBoolean!T) {
                debug pragma(msg, " - isBoolean");
                return false;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.NULL:
            static if (isAggregateType!T) {
                debug pragma(msg, " - isAggregateType");
                return null;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.OBJECT:
            static if (isAggregateType!T) {
                debug pragma(msg, " - isAggregateType");
                T ret = new T();
                foreach (string member; getProperties!T) {
                    debug pragma(msg, "   * ", member);
                    if (member in json) {
                        __traits(getMember, ret, member) = unpickle!(typeof(__traits(getMember, ret, member)))(json[member], requireAllFields);
                    }
                    else if (requireAllFields) {
                        throw new Exception("Required member \"" ~ member ~ "\" missing in JSON object");
                    }
                }
                return ret;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.ARRAY:
            static if (isStaticArray!T && !isSomeString!T) {
                debug pragma(msg, " - isArray && !isSomeString!T");
                debug pragma(msg, "      ", T);
                debug pragma(msg, "       -> ", ValueTypeStaticArray!(T));

                return json.array.map!(a => unpickle!(ValueTypeStaticArray!T)(a, requireAllFields)).array.to!T;

            }
            else static if (isDynamicArray!T && !isSomeString!T) {
                debug pragma(msg, " - isArray && !isSomeString!T");
                debug pragma(msg, "      ", T);
                debug pragma(msg, "       -> ", ValueTypeDynamicArray!(T));

                return json.array.map!(a => unpickle!(ValueTypeDynamicArray!T)(a, requireAllFields)).array.to!T;

            }
            else {
                throw new Exception(errorString);
            }
    }
}

/// JSON tree serializer. Completely unnecessary, but serves as an example of how to use JSONValue
string stringifyJSON(JSONValue json, string indent = "") {
    final switch (json.type) {
        case JSON_TYPE.STRING:
            return `"` ~ json.str ~ `"`;
            break;
        case JSON_TYPE.INTEGER:
            return to!string(json.integer);
            break;
        case JSON_TYPE.UINTEGER:
            return to!string(json.uinteger);
            break;
        case JSON_TYPE.FLOAT:
            return to!string(json.floating);
            break;
        case JSON_TYPE.OBJECT:
            string ret = "{\n";
            string newIndent = indent ~ "  ";
            foreach (string key, JSONValue value; json) {
                ret ~= newIndent ~ key ~ " : " ~ stringifyJSON(value, newIndent) ~ ",\n";
            }
            ret ~= indent ~ "}";
            return ret;
        case JSON_TYPE.ARRAY:
            string ret = "[\n";
            string newIndent = indent ~ "  ";
            foreach (size_t key, JSONValue value; json) {
                ret ~= newIndent ~ stringifyJSON(value, newIndent) ~ ",\n";
            }
            ret ~= indent ~ "]";
            return ret;
        case JSON_TYPE.TRUE:
            return "true";
            break;
        case JSON_TYPE.FALSE:
            return "false";
            break;
        case JSON_TYPE.NULL:
            return "null";
            break;
    }
}


version(unittest) {
    class SampleChildBean {
        int myProperty;
    }

    class SampleBean {

        bool    myFalse;
        bool    myTrue;
        byte    myByte;
        ubyte   myUbyte;
        short   myShort;
        ushort  myUshort;
        int     myInt;
        uint    myUint;
        long    myLong;
        ulong   myUlong;
        float   myFloat;
        double  myDouble;
        //char    myChar;
        //wchar   myWchar;
        //dchar   myDchar;

        string  myString;

        int[4]  myStaticArray;
        int[]   myDynamicArray;
        char[]  myDynamicCharArray;

        SampleChildBean myChildObject;
        SampleChildBean[] myChildObjectArray;
    }

    void recursiveAssertEqual (T) (T lhs, T rhs, string propertyName = "") {
        import std.stdio;

        debug writeln(propertyName, " : ", T.stringof);
        static if (isAggregateType!T) {
            foreach (property; getProperties!T) {
                recursiveAssertEqual!(
                    typeof(__traits(getMember, T, property))
                )(
                    __traits(getMember, lhs, property),
                    __traits(getMember, rhs, property),
                    propertyName ~ "." ~ property  
                );
            }
        }
        else static if (isDynamicArray!T && !isSomeString!T) {
            assert(lhs.length == rhs.length);
            for (int i = 0; i < lhs.length; i++) {
                recursiveAssertEqual!(
                    ValueTypeDynamicArray!T
                )(
                    lhs[i],
                    rhs[i],
                    propertyName ~ "[" ~ i.to!string ~ "]"
                );
            }
        }
        else {
            if (lhs != rhs) {
                writeln("Property ", propertyName, " is not equal! Assertion will fail.");
            }
            assert(lhs == rhs);
        }
    }
}

unittest {

    auto original = new SampleBean();
    original.myFalse  = false;
    original.myTrue   = true;
    original.myByte   = byte.max;
    original.myUbyte  = ubyte.max;
    original.myShort  = short.max;
    original.myUshort = ushort.max;
    original.myInt    = int.max;
    original.myUint   = uint.max;
    original.myLong   = long.max;
    original.myUlong  = ulong.max;
    original.myFloat  = 3.14159;
    original.myDouble = 525600.25;
    original.myString = "Hello World!";

    original.myStaticArray      = [1,2,3,4];
    original.myDynamicArray     = [5,6,7,8,9];
    original.myDynamicCharArray = "Goodbye Moon".dup;

    original.myChildObject = new SampleChildBean();
    original.myChildObject.myProperty = 7;

    original.myChildObjectArray = [ new SampleChildBean(), new SampleChildBean(), new SampleChildBean() ];
    original.myChildObjectArray[0].myProperty = 17;
    original.myChildObjectArray[1].myProperty = 18;
    original.myChildObjectArray[2].myProperty = 19;

    JSONValue pickled = original.pickle;
    SampleBean unpickled = pickled.unpickle!SampleBean;

    recursiveAssertEqual!(SampleBean)(original, unpickled);
}

version(unittest) {
    /// Utility method I wrote while writing this. It recursively prints out everything it can to describe a given class.
    static void describeType (T, string indent = "") () {

        pragma(msg, indent, T.stringof);

        if (isAggregateType    !T) pragma(msg, indent, "  isAggregateType"   );
        if (isArray            !T) pragma(msg, indent, "  isArray"           );
        if (isAssociativeArray !T) pragma(msg, indent, "  isAssociativeArray");
        if (isBasicType        !T) pragma(msg, indent, "  isBasicType"       );
        if (isBoolean          !T) pragma(msg, indent, "  isBoolean"         );
        if (isBuiltinType      !T) pragma(msg, indent, "  isBuiltinType"     );
        if (isCallable         !T) pragma(msg, indent, "  isCallable"        );
        if (isDelegate         !T) pragma(msg, indent, "  isDelegate"        );
        if (isDynamicArray     !T) pragma(msg, indent, "  isDynamicArray"    );
        if (isExpressionTuple  !T) pragma(msg, indent, "  isExpressionTuple" );
        if (isFloatingPoint    !T) pragma(msg, indent, "  isFloatingPoint"   );
        if (isFunctionPointer  !T) pragma(msg, indent, "  isFunctionPointer" );
        if (isIterable         !T) pragma(msg, indent, "  isIterable"        );
        if (isMutable          !T) pragma(msg, indent, "  isMutable"         );
        if (isNarrowString     !T) pragma(msg, indent, "  isNarrowString"    );
        if (isNumeric          !T) pragma(msg, indent, "  isNumeric"         );
        if (isPointer          !T) pragma(msg, indent, "  isPointer"         );
        if (isScalarType       !T) pragma(msg, indent, "  isScalarType"      );
        if (isSigned           !T) pragma(msg, indent, "  isSigned"          );
        if (isSomeChar         !T) pragma(msg, indent, "  isSomeChar"        );
        if (isSomeFunction     !T) pragma(msg, indent, "  isSomeFunction"    );
        if (isSomeString       !T) pragma(msg, indent, "  isSomeString"      );
        if (isTypeTuple        !T) pragma(msg, indent, "  isTypeTuple"       );

        if (__traits(isAbstractClass   , T)) pragma(msg, indent, "  isAbstractClass"   );
        if (__traits(isAbstractFunction, T)) pragma(msg, indent, "  isAbstractFunction");
        if (__traits(isArithmetic      , T)) pragma(msg, indent, "  isArithmetic"      );
        if (__traits(isAssociativeArray, T)) pragma(msg, indent, "  isAssociativeArray");
        if (__traits(isFinalClass      , T)) pragma(msg, indent, "  isFinalClass"      );
        if (__traits(isFinalFunction   , T)) pragma(msg, indent, "  isFinalFunction"   );
        if (__traits(isFloating        , T)) pragma(msg, indent, "  isFloating"        );
        if (__traits(isIntegral        , T)) pragma(msg, indent, "  isIntegral"        );
        if (__traits(isLazy            , T)) pragma(msg, indent, "  isLazy"            );
        if (__traits(isOut             , T)) pragma(msg, indent, "  isOut"             );
        if (__traits(isOverrideFunction, T)) pragma(msg, indent, "  isOverrideFunction");
        if (__traits(isRef             , T)) pragma(msg, indent, "  isRef"             );
        if (__traits(isScalar          , T)) pragma(msg, indent, "  isScalar"          );
        if (__traits(isStaticArray     , T)) pragma(msg, indent, "  isStaticArray"     );
        if (__traits(isStaticFunction  , T)) pragma(msg, indent, "  isStaticFunction"  );
        if (__traits(isUnsigned        , T)) pragma(msg, indent, "  isUnsigned"        );
        if (__traits(isVirtualFunction , T)) pragma(msg, indent, "  isVirtualFunction" );
        if (__traits(isVirtualMethod   , T)) pragma(msg, indent, "  isVirtualMethod"   );

        static if (isAggregateType!T) {
            foreach (member; __traits(allMembers, T)) {
                pragma(msg, indent, " + ", member);
                static if (!__traits(isAbstractClass, __traits(getMember, T, member))) {
                    describeType!(typeof(__traits(getMember, T, member)), indent ~ "   ");
                }
                else {
                    if (__traits(isAbstractClass   , __traits(getMember, T, member))) pragma(msg, indent, "     isAbstractClass"   );
                    if (__traits(isAbstractFunction, __traits(getMember, T, member))) pragma(msg, indent, "     isAbstractFunction");
                    if (__traits(isArithmetic      , __traits(getMember, T, member))) pragma(msg, indent, "     isArithmetic"      );
                    if (__traits(isAssociativeArray, __traits(getMember, T, member))) pragma(msg, indent, "     isAssociativeArray");
                    if (__traits(isFinalClass      , __traits(getMember, T, member))) pragma(msg, indent, "     isFinalClass"      );
                    if (__traits(isFinalFunction   , __traits(getMember, T, member))) pragma(msg, indent, "     isFinalFunction"   );
                    if (__traits(isFloating        , __traits(getMember, T, member))) pragma(msg, indent, "     isFloating"        );
                    if (__traits(isIntegral        , __traits(getMember, T, member))) pragma(msg, indent, "     isIntegral"        );
                    if (__traits(isLazy            , __traits(getMember, T, member))) pragma(msg, indent, "     isLazy"            );
                    if (__traits(isOut             , __traits(getMember, T, member))) pragma(msg, indent, "     isOut"             );
                    if (__traits(isOverrideFunction, __traits(getMember, T, member))) pragma(msg, indent, "     isOverrideFunction");
                    if (__traits(isRef             , __traits(getMember, T, member))) pragma(msg, indent, "     isRef"             );
                    if (__traits(isScalar          , __traits(getMember, T, member))) pragma(msg, indent, "     isScalar"          );
                    if (__traits(isStaticArray     , __traits(getMember, T, member))) pragma(msg, indent, "     isStaticArray"     );
                    if (__traits(isStaticFunction  , __traits(getMember, T, member))) pragma(msg, indent, "     isStaticFunction"  );
                    if (__traits(isUnsigned        , __traits(getMember, T, member))) pragma(msg, indent, "     isUnsigned"        );
                    if (__traits(isVirtualFunction , __traits(getMember, T, member))) pragma(msg, indent, "     isVirtualFunction" );
                    if (__traits(isVirtualMethod   , __traits(getMember, T, member))) pragma(msg, indent, "     isVirtualMethod"   );
                }          
            }
        }
    }
}

version(unittest) {
    void main() {
        import std.stdio;
        writeln("unit tests passed");
    }
}