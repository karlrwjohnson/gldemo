import std_all;

import jsontest;
import vectypes;

class Mannequin {
    string model;
    mat4 transformMatrix;
    //float[16] transformMatrix;
    bool isMirrored;
    Mannequin[] attachments;
}

unittest {
    import meta;
    describeType!Mannequin;
}

unittest {
    auto person = "data/person_model.json".readText.parseJSON.unpickle!Mannequin(false);

}