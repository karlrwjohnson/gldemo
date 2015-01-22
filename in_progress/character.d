enum Attribute : ubyte {
    STRENGTH,
    DEXTERITY,
    CONSTITUTION,
    WISDOM,
    INTELLIGENCE,
    CHARISMA
}

class Character {

    @property
    string name;

    int level;
    float afloat;
    uint auint;

    int[Attribute.max + 1] attributes;

    mixin(
        [ __traits(allMembers, Attribute) ]
            .map!(`"
                int " ~ a.toLower ~ " () const @property {
                    return this.attributes[Attribute." ~ a ~ "];
                }
                void " ~ a.toLower ~ " (int value) @property {
                    this.attributes[Attribute." ~ a ~ "] = value;
                }
            "`)
            .join
    );

    unittest {
        Character c = new Character();

        c.strength     = 10;
        c.dexterity    = 11;
        c.constitution = 12;
        c.wisdom       = 13;
        c.intelligence = 14;
        c.charisma     = 15;

        assert(c.attributes[Attribute.STRENGTH]     == 10);
        assert(c.attributes[Attribute.DEXTERITY]    == 11);
        assert(c.attributes[Attribute.CONSTITUTION] == 12);
        assert(c.attributes[Attribute.WISDOM]       == 13);
        assert(c.attributes[Attribute.INTELLIGENCE] == 14);
        assert(c.attributes[Attribute.CHARISMA]     == 15);

        c.attributes[Attribute.STRENGTH]     = 20;
        c.attributes[Attribute.DEXTERITY]    = 21;
        c.attributes[Attribute.CONSTITUTION] = 22;
        c.attributes[Attribute.WISDOM]       = 23;
        c.attributes[Attribute.INTELLIGENCE] = 24;
        c.attributes[Attribute.CHARISMA]     = 25;

        assert(c.strength     == 20);
        assert(c.dexterity    == 21);
        assert(c.constitution == 22);
        assert(c.wisdom       == 23);
        assert(c.intelligence == 24);
        assert(c.charisma     == 25);
    }

}
