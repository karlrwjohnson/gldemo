import std.array;
import std.conv;
import std.exception;
import std.stdio;
import std.typecons;

import derelict.opengl3.gl;
//import glew;
//import glsafe;
import glut;

/**
 * Whether a given ASCII-mappable key is being pressed.
 * The key of the associative array is the key on the keyboard.
 * See the pun?
 */
bool[ubyte] keysDown;
/**
 * Non-ASCII-mappable keys
 */
bool[int] specialKeysDown;

const string VSHADER_SRC = r"
    #version 130

    in vec2 vPosition;
    in vec3 vColor;

    out vec3 ffColor;

    void main() {
        gl_Position = vec4(vPosition, 0, 1);
        ffColor = vColor;
    }
";

const string FSHADER_SRC = r"
    #version 130

    in vec3 ffColor;
    out vec4 fColor;

    void main() {
        fColor = vec4(ffColor, 1);
    }
";

GLfloat[] TRI_POSITION_DATA = [
    0.0,0.0, 1.0,0.0, 0.5,1.0,
    0.0,0.0, -1.0,-0.0, -0.5,-1.0
];

GLfloat[] TRI_COLOR_DATA = [
    1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0,
    0.5,0.5,0.0, 0.0,0.5,0.5, 0.5,0.0,0.5
];

Exception checkGLErrors() {
    string[] errors;
    GLenum errorId;
    while((errorId = glGetError()) != GL_NO_ERROR) {
        switch (errorId) {
            case GL_INVALID_ENUM:
                errors ~= "GL_INVALID_ENUM";
                break;
            case GL_INVALID_VALUE:
                errors ~= "GL_INVALID_VALUE";
                break;
            case GL_INVALID_OPERATION:
                errors ~= "GL_INVALID_OPERATION";
                break;
            case GL_INVALID_FRAMEBUFFER_OPERATION:
                errors ~= "GL_INVALID_FRAMEBUFFER_OPERATION";
                break;
            case GL_OUT_OF_MEMORY:
                errors ~= "GL_OUT_OF_MEMORY";
            default:
                errors ~= "Unknown GL error " ~ to!string(errorId);
                break;
        }
    }

    if (errors.length == 0) {
        return null;
    } else {
        return new Exception("OpenGL call failed with errors: " ~ join(errors, " "));
    }
}

extern (C)
void onDisplay() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glDrawArrays(GL_TRIANGLES, 0, 6);

    glutSwapBuffers();

	checkGLErrors();
}

extern (C)
void onKeyDown (ubyte key, int x, int y) {
    keysDown[key] = true;

    if (key == 'q') {
        glutLeaveMainLoop();
    }
}

extern (C)
void onSpecialKeyDown (int key, int x, int y) {
    specialKeysDown[key] = true;

    if (key == GLUT_KEY_F4) {
        glutLeaveMainLoop();
    }
}

extern (C)
void onKeyUp (ubyte key, int x, int y) {
    keysDown.remove(key);
}

extern (C)
void onSpecialKeyUp (int key, int x, int y) {
    specialKeysDown.remove(key);
}

extern (C)
void onReshape (int width, int height) {
    glViewport(0, 0, width, height);
}

extern (C)
void onIdle () {
	checkGLErrors();
	//writeln("No errors.");
}

GLint initShader (string[GLint] sources) {
    GLint status;

    GLuint programId = glCreateProgram();

    foreach (type, source; sources) {
        GLuint shaderId = glCreateShader(type);

        const char[] sourceCopy = source.dup ~ "\0";
        const(char)* sourceCopyPtr = &sourceCopy[0];
        glShaderSource(shaderId, 1, &sourceCopyPtr, null);

        glCompileShader(shaderId);

        glGetShaderiv(shaderId, GL_COMPILE_STATUS, &status);
        if (status != GL_TRUE) {
            GLint buflen;
            glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &buflen);

            char[] msgBuffer = new char[buflen];
            glGetShaderInfoLog(shaderId, buflen, null, &msgBuffer[0]);

            throw new Exception("Error while compiling shader: " ~ msgBuffer.idup);
        }

        glAttachShader(programId, shaderId);
    }

    glLinkProgram(programId);

    glGetProgramiv(programId, GL_LINK_STATUS, &status);
    if (status != GL_TRUE) {
        GLint buflen;
        glGetProgramiv(programId, GL_INFO_LOG_LENGTH, &buflen);

        char[] msgBuffer = new char[buflen];
        glGetProgramInfoLog(programId, buflen, null, &msgBuffer[0]);
        throw new Exception("Error while linking shader: " ~ msgBuffer.idup);
    }

    glUseProgram(programId);

    return programId;
}

GLint initTris (GLint programId, Tuple!(GLfloat[], int)[string] attributes) {
    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    foreach (attribute, dataDesc; attributes) {
        char[] attribute_z = attribute ~ "\0".dup;
        GLuint attributeId = to!uint(glGetAttribLocation(programId, &attribute_z[0]));

        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER,
                             to!int(dataDesc[0].length) * GLfloat.sizeof,
                             to!(void*)(&dataDesc[0][0]),
                             GL_STATIC_DRAW);

		void* datastart = to!(void*)(&dataDesc[0][0]);

        glVertexAttribPointer(attributeId, dataDesc[1], GL_FLOAT, to!ubyte(GL_FALSE), 0, null);

        glEnableVertexAttribArray(attributeId);
    };

    return vao;
}

void init () {
    glClearColor(0.0, 0.0, 0.0, 0.0);

    onReshape(800, 600);

    GLint programId = initShader([
        GL_VERTEX_SHADER:   VSHADER_SRC,
        GL_FRAGMENT_SHADER: FSHADER_SRC
    ]);

    GLint vao = initTris(programId, [
        "vPosition": tuple(TRI_POSITION_DATA, 2),
        "vColor":    tuple(TRI_COLOR_DATA,    3),
    ]);


}

int main (string[] args) {
	writeln("hello");

	DerelictGL3.load();

    //glutInit(args.length, args);
    int argc = 0;
    glutInit(&argc, null);
    glutInitWindowPosition(0,0);
    glutInitWindowSize(800,600);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutCreateWindow("GL Test");

    //glewExperimental = GL_TRUE;

    //glewInit();

	DerelictGL3.reload();

    init();

    glutIdleFunc       (&onIdle);
    glutDisplayFunc    (&onDisplay);
    glutReshapeFunc    (&onReshape);
    glutKeyboardFunc   (&onKeyDown);
    glutSpecialFunc    (&onSpecialKeyDown);
    glutKeyboardUpFunc (&onKeyUp);
    glutSpecialUpFunc  (&onSpecialKeyUp);

    glutMainLoop();

    writeln("goodbye");
    return 0;
}
