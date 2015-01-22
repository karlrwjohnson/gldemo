module TextRenderer;

import std_all;

import vectypes;

class TextRenderer {

    static const string VSHADER_SRC = r"
        #version 130

        uniform ivec2 screenSize;

        uniform vec2 anchorPosition;
        uniform vec2 surfaceDimensions;

        uniform vec2 textAlign;

        in vec2 vPosition;
        in vec4 vColor;

        out vec4 ffColor;

        void main() {
            vec2 screenPosition = (vPosition - textAlign) * surfaceDimensions + anchorPosition;
            gl_Position = screenPosition / screenSize * 2 + 1;

            ffColor = vColor;
        }
    ";

    static const string FSHADER_SRC = r"
        #version 130

        in vec3 ffColor;
        out vec4 fColor;

        void main() {
            fColor = ffColor;
        }
    ";

    static immutable vec2[] points = [
        vec2(0f,0f), vec2(0f,1f), vec2(1f,1f),
        vec2(0f,0f), vec2(1f,1f), vec2(1f,0f),
    ];

    static void init () {
        // Inifialize the gl shader, VAO and VBO
    };

    static void renderText (string text
}

interface Model {
    public bool supportsNormals();

}

class STLFileModel : Model {
    private string _filename;

    private vec3[]

    public string filename() @property {
        return _filename;
    }

    public void filename(string _) @property {
        import stl;

        _filename = _;
    }
}

class Renderer {
}

class MyRenderer {
    static const string VSHADER_SRC = r"
        #version 130

        uniform mat4 perspective;
        uniform mat4 cameraLoc;
        uniform mat4 modelTransform;

        in vec3 vPosition;
        in vec3 vNormal;
        in vec3 vColor;

        out vec3 ffPosition;
        out vec3 ffNormal;
        out vec3 ffColor;

        void main() {
            vec4 position_temp = perspective * cameraLoc * modelTransform * vec4(vPosition, 1);
            gl_Position = position_temp / position_temp.w;

            ffPosition = (vec4(vPosition, 1)).xyz;
            ffNormal = (vec4(vNormal, 1)).xyz;
            ffColor = vec3(1,1,1); //vColor;
        }
    ";

    static const string FSHADER_SRC = r"
        #version 130

        uniform mat4 modelTransform;

        uniform vec4 lightLoc;

        uniform vec3 lightColor;
        uniform vec3 ambientColor;

        in vec3 ffPosition;
        in vec3 ffNormal;
        in vec3 ffColor;
        out vec4 fColor;

        void main() {
            vec3 worldPosition = (modelTransform * vec4(ffPosition, 1)).xyz;
            vec3 worldNormal = normalize((modelTransform * vec4(ffNormal, 0)).xyz);
            vec3 toLight = lightLoc.xyz - worldPosition;
            vec3 light = lightColor * max(0, dot(normalize(toLight), worldNormal)) / dot(toLight, toLight);
            fColor = vec4(ffColor * (light + ambientColor), 1);
            
        }
    ";
}