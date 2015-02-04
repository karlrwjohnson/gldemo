import std_all;

import serialization;
import vectypes;



@Bean
class Mannequin {
    string model;

    @SerializeUsingProperty("transformMatrix_accessor")
    mat4 transformMatrix;

    bool isMirrored;
    Mannequin[] attachments;

   // package (jsontest)
    void transformMatrix_accessor (float[16] transformMatrix) @property {
        this.transformMatrix = mat4(transformMatrix);
    }
    //package (jsontest)
    float[16] transformMatrix_accessor () const @property {
        float[16] ret = this.transformMatrix.data.dup;
        return ret;
    }
}

unittest {
    import meta;
    describeType!Mannequin;

    auto m = new Mannequin();
    m.model = "MODEL";
    m.transformMatrix = mat4([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
    m.isMirrored = true;

    m.serialize.stringifyJSON.writeln;
}

unittest {
    //auto person = "data/person_model.json".readText.parseJSON.unpickle!Mannequin(false);

}