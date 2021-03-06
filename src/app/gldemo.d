import core.time;

import derelict.opengl3.gl;

import std_all;

import boilerplate;
import glut;
import mannequin;
import mouse;
import ply;
import serialization;
import stl;
import vectypes;
import Map : Map;

/*
    Things I'd like to abstract out:
    - Shader program
    - Setting uniforms (depends on shader program ID)
    - The camera (depends on uniforms)
    - Light sources (depends on uniforms)
    - 

    * Derelict should REALLY be compiled into its own library to save time on the change/compile/test cycle.

    Classes:
        Program <- shader

        Model
        - render()
        - bind (i.e. to program)
        ( need api of model )


*/

const string VSHADER_SRC = r"
    #version 130

    uniform mat4 perspective;
    uniform mat4 cameraLoc;
    uniform mat4 modelTransform;

    in vec3 vPosition;
    in vec3 vNormal;
    in vec3 vColor;
    in vec2 vTexCoord;

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

const string FSHADER_SRC = r"
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

///// GLOBALS -- as much as I hate to use them.

GLint programId;

TickDuration lastFrame;

GLfloat cameraDist = 10;
GLfloat cameraLat = -45 * PI/180;
GLfloat cameraLon = 45f * PI/180;

GLfloat cameraRadialSpeed = PI; // 180deg/sec

GLfloat lightDist = 5;
GLfloat lightLat = -45f * PI/180;
GLfloat lightLon = -45f * PI/180;

GLfloat mannequinMutatorValue = 0;

struct Mesh {
    GLint vaoId;
    GLint dataLength;

    void bind () {
        glBindVertexArray(vaoId);
    }
};

Mesh[string] meshes;

Mannequin[string] mannequins;

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

MouseState currentMouse;
MouseState prevMouse;

Map map;

///// END GLOBALS /////

void drawMannequin (Mannequin m, mat4 baseTransform = Identity()) {
    mat4 modelTransform = baseTransform * m.staticTransform * m.animatedTransform;
    setUniformMatrix(programId, "modelTransform", modelTransform);

    if (!(m.model in meshes)) {
        meshes[m.model] = loadPlyMesh(programId, "models/" ~ m.model);
    }

    meshes[m.model].bind();
    glDrawElements(GL_TRIANGLES, meshes[m.model].dataLength, GL_UNSIGNED_INT, null);

    foreach (child; m.attachments) {
        drawMannequin(child, modelTransform);
    }
}

extern (C)
void onDisplay() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    vec3 midpoint = vec3(map.width - 1, map.length - 1, 0) / 2f;

    glBindVertexArray(meshes["floor"].vaoId);
    for (int x = 0; x < map.width; x++) {
        for (int y = 0; y < map.length; y++) {
            setUniformMatrix(programId, "modelTransform", Translate(vec3(x, y, 0) - midpoint));
            glDrawArrays(GL_TRIANGLES, 0, meshes["floor"].dataLength);
        }
    }

    //glBindVertexArray(meshes["pawn"].vaoId);
    foreach (i, coord; map.pawnLocations) {
        //setUniformMatrix(programId, "modelTransform", Translate(vec3(coord[0], coord[1], 0) - midpoint));
        //glDrawArrays(GL_TRIANGLES, 0, meshes["pawn"].dataLength);
            drawMannequin(mannequins["person"], Translate(vec3(coord[0],coord[1],0) - midpoint));

    }

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
void onMouseButton (int button, int state, int x, int y) {
    currentMouse.x = x;
    currentMouse.y = y;
    currentMouse[button] = state;
}

extern (C)
void onMouseMove (int x, int y) {
    currentMouse.x = x;
    currentMouse.y = y;
}

extern (C)
void onReshape (int width, int height) {
    glViewport(0, 0, width, height);
}

extern (C)
void onIdle () {
	checkGLErrors();

	TickDuration thisFrame = Clock.currAppTick();
	double timeElapsed = to!double(thisFrame.length - lastFrame.length) / TickDuration.ticksPerSec;
	lastFrame = thisFrame;

	if (GLUT_KEY_LEFT in specialKeysDown) {
		cameraLon -= timeElapsed * cameraRadialSpeed;
		updateCamera();
	}
	if (GLUT_KEY_RIGHT in specialKeysDown) {
		cameraLon += timeElapsed * cameraRadialSpeed;
		updateCamera();
	}
	if (GLUT_KEY_UP in specialKeysDown) {
		cameraLat = fmax(-PI_2, cameraLat - timeElapsed * cameraRadialSpeed);
		updateCamera();
	}
	if (GLUT_KEY_DOWN in specialKeysDown) {
		cameraLat = fmin(PI_2, cameraLat + timeElapsed * cameraRadialSpeed);
		updateCamera();
	}

	if ('a' in keysDown) {
		lightLon -= timeElapsed * cameraRadialSpeed;
		updateLight();
	}
	if ('d' in keysDown) {
		lightLon += timeElapsed * cameraRadialSpeed;
		updateLight();
	}
	if ('w' in keysDown) {
        lightLat = fmin(PI_2, lightLat + timeElapsed * cameraRadialSpeed);
		updateLight();
	}
	if ('s' in keysDown) {
        lightLat = fmax(-PI_2, lightLat - timeElapsed * cameraRadialSpeed);
		updateLight();
	}
    if ('r' in keysDown) {
        cameraDist /= exp2(timeElapsed);
        updateCamera();
    }
    if ('f' in keysDown) {
        cameraDist *= exp2(timeElapsed);
        updateCamera();
    }

    if ('i' in keysDown) {
        mannequinMutatorValue += timeElapsed;
        updateMannequin();
    }
    if ('k' in keysDown) {
        mannequinMutatorValue -= timeElapsed;
        updateMannequin();
    }

    if (currentMouse.left && (currentMouse.x != prevMouse.x || currentMouse.y != prevMouse.y)) {
        // drag
    }

    prevMouse = currentMouse;
}

void updateCamera() {
	mat4 cameraLoc =  Translate(vec3(0, cameraDist, 0)) * RotateX(cameraLat) * RotateZ(cameraLon);
	setUniformMatrix(programId, "cameraLoc", cameraLoc, true);
}

void updateLight() {
	vec4 lightLoc = RotateZ(lightLon) * RotateX(lightLat) * vec4(0, lightDist, 0, 1);
	setUniformVector(programId, "lightLoc", lightLoc, true);
}

void updateMannequin() {
    auto m = mannequins["person"];

    auto rotXPlus = RotateX(mannequinMutatorValue);
    auto rotXMinus = RotateX(-mannequinMutatorValue);
    auto identity = Identity();

    m.attachments["shoulderleft"].animatedTransform = rotXPlus;
    m.attachments["shoulderright"].animatedTransform = rotXMinus;
    m.attachments["hipleft"].animatedTransform = rotXMinus;
    m.attachments["hipright"].animatedTransform = rotXPlus;
    if (mannequinMutatorValue > 0) {
        m.attachments["shoulderleft"].attachments["elbow"].animatedTransform = rotXPlus;
        m.attachments["shoulderright"].attachments["elbow"].animatedTransform = identity;
        m.attachments["hipleft"].attachments["knee"].animatedTransform = rotXMinus;
        m.attachments["hipright"].attachments["knee"].animatedTransform = rotXMinus;
    }
    else {
        m.attachments["shoulderleft"].attachments["elbow"].animatedTransform = identity;
        m.attachments["shoulderright"].attachments["elbow"].animatedTransform = rotXMinus;
        m.attachments["hipleft"].attachments["knee"].animatedTransform = rotXPlus;
        m.attachments["hipright"].attachments["knee"].animatedTransform = rotXPlus;
    }
}

void setUniformMatrix(size_t A)(GLint progId, string name, mat!A value, bool ignoreUndefinedAttrs = false) {
    char[] nameZ = name.dup ~ "\0";
    GLint location = glGetUniformLocation(progId, &nameZ[0]);
    if (location < 0) {
        if (ignoreUndefinedAttrs) {
            return;
        }
        else {
            throw new Exception("Uniform variable " ~ name ~ " has not been assigned an ID; it probably doesn't exist in the program.");
        }
    }
    debug writeln("setting uniform ", name, " (@ ", location, ") =\n", value);
    mixin("glUniformMatrix" ~ to!string(A) ~ "fv(location, 1, GL_TRUE, value.ptr);");
    glutPostRedisplay();
}

void setUniformVector(size_t B)(GLint progId, string name, vec!B value, bool ignoreUndefinedAttrs = false) {
    char[] nameZ = name.dup ~ "\0";
    GLint location = glGetUniformLocation(progId, &nameZ[0]);
    if (location < 0) {
        if (ignoreUndefinedAttrs) {
            return;
        }
        else {
            throw new Exception("Uniform variable " ~ name ~ " has not been assigned an ID; it probably doesn't exist in the program.");
        }
    }
    debug writeln("setting uniform ", name, " (@ ", location, ") =\n", value);
    mixin("glUniform" ~ to!string(B) ~ "fv(location, 1, value.ptr);");
    glutPostRedisplay();
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

GLint initTris (GLint programId, Tuple!(GLfloat[], int)[string] attributes, bool ignoreUndefinedAttrs = false) {
    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    foreach (attribute, dataDesc; attributes) {
        char[] attribute_z = attribute ~ "\0".dup;
        GLint attributeId = glGetAttribLocation(programId, &attribute_z[0]);
        debug writeln("The position of attribute " ~ attribute ~ " is " ~ attributeId);
        if (attributeId < 0) {
            if (ignoreUndefinedAttrs) {
                debug writeln("Attribute " ~ attribute ~ " has not been assigned an ID. It probably doesn't exist in the shader program.");
                continue;
            }
            else {
                throw new Exception("Attribute " ~ attribute ~ " has not been assigned an ID. It probably doesn't exist in the shader program.");
            }
        }

        GLuint vbo;
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER,
                     to!int(dataDesc[0].length) * GLfloat.sizeof,
                     to!(void*)(&dataDesc[0][0]),
                     GL_STATIC_DRAW);

        glVertexAttribPointer(to!uint(attributeId), dataDesc[1], GL_FLOAT, to!ubyte(GL_FALSE), 0, null);

        glEnableVertexAttribArray(to!uint(attributeId));
    };

    return vao;
}

GLint initTris2(int T) (GLint programId, vec!T[][string] attributes, bool ignoreUndefinedAttrs = false) {

	// Vertex Array Object to relate the multiple buffers together
	GLuint vao;
	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);

	foreach (attribute, data; attributes) {
		char[] attributeZ = attribute ~ "\0".dup;
		GLuint attributeId = to!uint(glGetAttribLocation(programId, &attributeZ[0]));
        debug writeln("The position of attribute " ~ attribute ~ " is " ~ attributeId);
        if (attributeId < 0) {
            if (ignoreUndefinedAttrs) {
                debug writeln("Attribute " ~ attribute ~ " has not been assigned an ID. It probably doesn't exist in the shader program.");
                continue;
            }
            else {
                throw new Exception("Attribute " ~ attribute ~ " has not been assigned an ID. It probably doesn't exist in the shader program.");
            }
        }

		// Vertex Buffer Object
		GLuint vbo;
		glGenBuffers(1, &vbo);
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER,
		             data.length * T * GLfloat.sizeof,
                     data[0].ptr,
                     GL_STATIC_DRAW);

        debug {
            GLfloat* ptr = data[0].ptr;
            size_t length = data.length * T * GLfloat.sizeof;
            writeln("Loading array of size (bytes) ", length);
            GLfloat* end = ptr + data.length * T;
            for(GLfloat* p = ptr; p < end; p++) {
                write(to!string(*p), "\t");
                if ((p - ptr) % 3 == 2) {
                    writeln();
                }
            }
        }

        glVertexAttribPointer(to!uint(attributeId), T, GL_FLOAT, to!ubyte(GL_FALSE), 0, null);

        glEnableVertexAttribArray(to!uint(attributeId));

	}

	return vao;
}

Mesh loadStlMesh(GLint programId, string filename) {
    auto data = loadStl(filename);

    GLint vao = initTris2(programId, [
        "vPosition": data[0],
        "vNormal":   data[1]
    ], true);

    return Mesh(vao, to!GLint(data[0].length) * 3);
}

Mesh loadPlyMesh (GLint programId, string filename) {
    const char *V_POSITION_STR = "vPosition\0";
    const char *V_NORMAL_STR   = "vNormal\0";
    const char *V_TEXCOORD_STR = "vTexCoord\0";

    auto data = loadPLY(filename);
    auto vertex         = cast(PLYNamedPropertyBuffer)(data[0]);
    auto vertex_indices = cast(PLYListPropertyBuffer )(data[1]);

    GLuint vao;
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);

    GLuint vbos[2];
    glGenBuffers(vbos.length, &vbos[0]);

    glBindBuffer(GL_ARRAY_BUFFER,         vbos[0]);
    glBufferData(GL_ARRAY_BUFFER,
                 data[0].bufferSize,
                 data[0].bufferPtr,
                 GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbos[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                 data[1].bufferSize,
                 data[1].bufferPtr,
                 GL_STATIC_DRAW);

    glUseProgram(programId);
    auto vPosition_loc = glGetAttribLocation(programId, V_POSITION_STR);
    auto vNormal_loc   = glGetAttribLocation(programId, V_NORMAL_STR);
    auto vTexCoord_loc = glGetAttribLocation(programId, V_TEXCOORD_STR);

    if (vPosition_loc >= 0) {
        glVertexAttribPointer(to!uint(vPosition_loc),
                              3,
                              GL_FLOAT,
                              0,
                              cast(int)(vertex.rowSize),
                              cast(void*)(vertex.properties[0].offset));
        glEnableVertexAttribArray(to!uint(vPosition_loc));
    }
    if (vNormal_loc >= 0) {
        glVertexAttribPointer(to!uint(vNormal_loc),
                              3,
                              GL_FLOAT,
                              0,
                              cast(int)(vertex.rowSize),
                              cast(void*)(vertex.properties[3].offset));
        glEnableVertexAttribArray(to!uint(vNormal_loc));
    }
    if (vTexCoord_loc >= 0) {
        glVertexAttribPointer(to!uint(vTexCoord_loc),
                              3,
                              GL_FLOAT,
                              0,
                              cast(int)(vertex.rowSize),
                              cast(void*)(vertex.properties[7].offset));
        glEnableVertexAttribArray(to!uint(vTexCoord_loc));
    }

    // still kludgey
    writefln("Number of points in the PLY file calculated to be %d", vertex_indices.bufferSize / vertex_indices.rowSize * 3);
    return Mesh(vao, to!GLint(vertex_indices.bufferSize / vertex_indices.rowSize * 3));
}

void init () {
    glClearColor(0.0, 0.0, 0.0, 0.0);

    glEnable(GL_DEPTH_TEST);

    onReshape(800, 600);

    programId = initShader([
        GL_VERTEX_SHADER:   VSHADER_SRC,
        GL_FRAGMENT_SHADER: FSHADER_SRC
    ]);

    meshes["cube"] = Mesh(
        initTris(programId, [
            "vPosition": tuple(CUBE_POSITION_DATA, 3),
            "vNormal":   tuple(CUBE_NORMAL_DATA,   3),
            "vColor":    tuple(CUBE_COLOR_DATA,    3),
        ], true),
        to!GLint(CUBE_POSITION_DATA.length)
    );
    meshes["pawn"] = loadStlMesh(programId, "models/pawn.stl");
    meshes["floor"] = loadStlMesh(programId, "models/floor.stl");
    meshes["fullwall"] = loadStlMesh(programId, "models/fullwall.stl");
    meshes["halfwall"] = loadStlMesh(programId, "models/halfwall.stl");
    meshes["hand"] = loadPlyMesh(programId, "models/hand.ply");
    meshes["head"] = loadPlyMesh(programId, "models/head.ply");

    mannequins["person"] = "data/person_model.json".readText.deserialize!Mannequin;


	mat4 perspective = Perspective( 45, 800.0/600.0, .001, 100 ) * RotateX!"deg"(90);

	setUniformMatrix(programId, "perspective", perspective);

    setUniformVector(programId, "ambientColor", vec3(.1f, .1f, .1f), true);
    setUniformVector(programId, "lightColor", vec3(2f, 2f, 2f), true);

	updateCamera();
    updateLight();
}

int _main (string[] args) {

    // Initialize basic OpenGL functionality
	DerelictGL3.load();

    // Initialize GLUT
    //glutInit(args.length, args);
    int argc = 0;
    glutInit               (&argc, null);  // "No GLUT, there were no arguments"
    glutInitWindowPosition (0,0);
    glutInitWindowSize     (800,600);
    glutInitDisplayMode    (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutCreateWindow       ("GL Test");

    glutIdleFunc           (&onIdle);
    glutDisplayFunc        (&onDisplay);
    glutReshapeFunc        (&onReshape);
    glutKeyboardFunc       (&onKeyDown);
    glutSpecialFunc        (&onSpecialKeyDown);
    glutKeyboardUpFunc     (&onKeyUp);
    glutSpecialUpFunc      (&onSpecialKeyUp);
    glutMouseFunc          (&onMouseButton);
    glutMotionFunc         (&onMouseMove);
    glutPassiveMotionFunc  (&onMouseMove);

    // Load OpenGL 3+ functionality
	DerelictGL3.reload();

    map = "data/checkerboard.json".readText.parseJSON.deserialize!Map;

    // Our OpenGL initialization
    init();

    // GLUT black hole event loop
    glutMainLoop();

    return 0;
}
