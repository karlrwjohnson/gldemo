import std_all;

/**
 * Attribute indicating that a type is serializable. Currently ignored.
 */
struct Bean {};

/**
 * Attribute indicating that a member should be serialized through a property with the given name.
 */
struct SerializeUsingProperty { string propertyName; }

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
JSONValue serialize (T) (T value) {
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

        ret.array = value.array.map!(a => serialize(a)).array;
    }
    else static if (isAggregateType!T) {
        debug pragma(msg, "-- isAggregateType");

        JSONValue[string] properties;
        foreach (member; getProperties!T) {
            properties[member] = serialize(__traits(getMember, value, member));
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
T deserialize(T)(JSONValue json, bool requireAllFields = true) {
    debug pragma(msg, "deserializing type ", T);

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
            else static if (isNumeric!T) {
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
            else static if (isNumeric!T) {
                return json.integer.to!T;
            }
            else {
                throw new Exception(errorString);
            }
        case JSON_TYPE.FLOAT:
            static if (isFloatingPoint!T) {
                debug pragma(msg, " - isFloatingPoint");
                return json.floating.to!T;
            }
            else static if (isNumeric!T) {
                return json.integer.to!T;
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
                        __traits(getMember, ret, member) = deserialize!(typeof(__traits(getMember, ret, member)))(json[member], requireAllFields);
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

                return json.array.map!(a => deserialize!(ValueTypeStaticArray!T)(a, requireAllFields)).array.to!T;

            }
            else static if (isDynamicArray!T && !isSomeString!T) {
                debug pragma(msg, " - isArray && !isSomeString!T");
                debug pragma(msg, "      ", T);
                debug pragma(msg, "       -> ", ValueTypeDynamicArray!(T));

                return json.array.map!(a => deserialize!(ValueTypeDynamicArray!T)(a, requireAllFields)).array.to!T;

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

    JSONValue pickled = original.serialize;
    SampleBean deserialized = pickled.deserialize!SampleBean;

    recursiveAssertEqual!(SampleBean)(original, deserialized);
}