import std_all;

import serialization;
import vectypes;



@Bean
class Mannequin {

    @SerializeRequired
    string model;

    @SerializeUsingProperty!(this.staticTransform_accessor)
    mat4 staticTransform = Identity();

    @SerializeUsingProperty!(this.animatedTransform_accessor)
    mat4 animatedTransform = Identity();

    bool isMirrored;
    Mannequin[string] attachments;

    void staticTransform_accessor (float[16] staticTransform) @property {
        this.staticTransform = mat4(staticTransform);
    }
    float[16] staticTransform_accessor () const @property {
        float[16] ret = this.staticTransform.data.dup;
        return ret;
    }

    void animatedTransform_accessor (float[16] animatedTransform) @property {
        this.animatedTransform = mat4(animatedTransform);
    }
    float[16] animatedTransform_accessor () const @property {
        float[16] ret = this.animatedTransform.data.dup;
        return ret;
    }
}


unittest {
    auto person = "data/person_model.json".readText.parseJSON.deserialize!Mannequin;

    person.serialize.stringifyJSON.writeln;

}