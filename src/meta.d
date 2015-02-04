import std_all;

/// Utility method I wrote while writing this. It recursively prints out everything it can to describe a given class.
static void describeType (T, string indent = "") () {

    pragma(msg, indent, "+ ", T.stringof);

    static if (isAggregateType    !T) pragma(msg, indent, "  - isAggregateType"   );
    static if (isArray            !T) pragma(msg, indent, "  - isArray"           );
    static if (isAssociativeArray !T) pragma(msg, indent, "  - isAssociativeArray");
    static if (isBasicType        !T) pragma(msg, indent, "  - isBasicType"       );
    static if (isBoolean          !T) pragma(msg, indent, "  - isBoolean"         );
    static if (isBuiltinType      !T) pragma(msg, indent, "  - isBuiltinType"     );
    static if (isCallable         !T) pragma(msg, indent, "  - isCallable"        );
    static if (isDelegate         !T) pragma(msg, indent, "  - isDelegate"        );
    static if (isDynamicArray     !T) pragma(msg, indent, "  - isDynamicArray"    );
    static if (isExpressionTuple  !T) pragma(msg, indent, "  - isExpressionTuple" );
    static if (isFloatingPoint    !T) pragma(msg, indent, "  - isFloatingPoint"   );
    static if (isFunctionPointer  !T) pragma(msg, indent, "  - isFunctionPointer" );
    static if (isIterable         !T) pragma(msg, indent, "  - isIterable"        );
    static if (isMutable          !T) pragma(msg, indent, "  - isMutable"         );
    static if (isNarrowString     !T) pragma(msg, indent, "  - isNarrowString"    );
    static if (isNumeric          !T) pragma(msg, indent, "  - isNumeric"         );
    static if (isPointer          !T) pragma(msg, indent, "  - isPointer"         );
    static if (isScalarType       !T) pragma(msg, indent, "  - isScalarType"      );
    static if (isSigned           !T) pragma(msg, indent, "  - isSigned"          );
    static if (isSomeChar         !T) pragma(msg, indent, "  - isSomeChar"        );
    static if (isSomeFunction     !T) pragma(msg, indent, "  - isSomeFunction"    );
    static if (isSomeString       !T) pragma(msg, indent, "  - isSomeString"      );
    static if (isTypeTuple        !T) pragma(msg, indent, "  - isTypeTuple"       );

    static if (__traits(isAbstractClass   , T)) pragma(msg, indent, "  - isAbstractClass"   );
    static if (__traits(isAbstractFunction, T)) pragma(msg, indent, "  - isAbstractFunction");
    static if (__traits(isArithmetic      , T)) pragma(msg, indent, "  - isArithmetic"      );
    static if (__traits(isAssociativeArray, T)) pragma(msg, indent, "  - isAssociativeArray");
    static if (__traits(isFinalClass      , T)) pragma(msg, indent, "  - isFinalClass"      );
    static if (__traits(isFinalFunction   , T)) pragma(msg, indent, "  - isFinalFunction"   );
    static if (__traits(isFloating        , T)) pragma(msg, indent, "  - isFloating"        );
    static if (__traits(isIntegral        , T)) pragma(msg, indent, "  - isIntegral"        );
    static if (__traits(isLazy            , T)) pragma(msg, indent, "  - isLazy"            );
    static if (__traits(isOut             , T)) pragma(msg, indent, "  - isOut"             );
    static if (__traits(isOverrideFunction, T)) pragma(msg, indent, "  - isOverrideFunction");
    static if (__traits(isRef             , T)) pragma(msg, indent, "  - isRef"             );
    static if (__traits(isScalar          , T)) pragma(msg, indent, "  - isScalar"          );
    static if (__traits(isStaticArray     , T)) pragma(msg, indent, "  - isStaticArray"     );
    static if (__traits(isStaticFunction  , T)) pragma(msg, indent, "  - isStaticFunction"  );
    static if (__traits(isUnsigned        , T)) pragma(msg, indent, "  - isUnsigned"        );
    static if (__traits(isVirtualFunction , T)) pragma(msg, indent, "  - isVirtualFunction" );
    static if (__traits(isVirtualMethod   , T)) pragma(msg, indent, "  - isVirtualMethod"   );

    static if (isAggregateType!T) {
        foreach (member; __traits(allMembers, T)) {
            pragma(msg, indent, "  * ", member);

            foreach (attribute; __traits(getAttributes, __traits(getMember, T, member))) {
                pragma(msg, indent, "    @ ", attribute);
            }

            //static if (__traits(getOverloads, T, ))

            //foreach (overload; __traits(getOverloads, T, member)) {

                static if (!__traits(isAbstractClass, __traits(getMember, T, member))) {
                    describeType!(typeof(__traits(getMember, T, member)), indent ~ "    ");
                }
                else {
                    static if (__traits(isAbstractClass   , __traits(getMember, T, member))) pragma(msg, indent, "    ! isAbstractClass"   );
                    static if (__traits(isAbstractFunction, __traits(getMember, T, member))) pragma(msg, indent, "    ! isAbstractFunction");
                    static if (__traits(isArithmetic      , __traits(getMember, T, member))) pragma(msg, indent, "    ! isArithmetic"      );
                    static if (__traits(isAssociativeArray, __traits(getMember, T, member))) pragma(msg, indent, "    ! isAssociativeArray");
                    static if (__traits(isFinalClass      , __traits(getMember, T, member))) pragma(msg, indent, "    ! isFinalClass"      );
                    static if (__traits(isFinalFunction   , __traits(getMember, T, member))) pragma(msg, indent, "    ! isFinalFunction"   );
                    static if (__traits(isFloating        , __traits(getMember, T, member))) pragma(msg, indent, "    ! isFloating"        );
                    static if (__traits(isIntegral        , __traits(getMember, T, member))) pragma(msg, indent, "    ! isIntegral"        );
                    static if (__traits(isLazy            , __traits(getMember, T, member))) pragma(msg, indent, "    ! isLazy"            );
                    static if (__traits(isOut             , __traits(getMember, T, member))) pragma(msg, indent, "    ! isOut"             );
                    static if (__traits(isOverrideFunction, __traits(getMember, T, member))) pragma(msg, indent, "    ! isOverrideFunction");
                    static if (__traits(isRef             , __traits(getMember, T, member))) pragma(msg, indent, "    ! isRef"             );
                    static if (__traits(isScalar          , __traits(getMember, T, member))) pragma(msg, indent, "    ! isScalar"          );
                    static if (__traits(isStaticArray     , __traits(getMember, T, member))) pragma(msg, indent, "    ! isStaticArray"     );
                    static if (__traits(isStaticFunction  , __traits(getMember, T, member))) pragma(msg, indent, "    ! isStaticFunction"  );
                    static if (__traits(isUnsigned        , __traits(getMember, T, member))) pragma(msg, indent, "    ! isUnsigned"        );
                    static if (__traits(isVirtualFunction , __traits(getMember, T, member))) pragma(msg, indent, "    ! isVirtualFunction" );
                    static if (__traits(isVirtualMethod   , __traits(getMember, T, member))) pragma(msg, indent, "    ! isVirtualMethod"   );
                }
            //}
        }
    }
}
