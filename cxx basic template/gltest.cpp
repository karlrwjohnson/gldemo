#include "gltest.h"

using namespace std;

set<unsigned char> keysDown;
set<int> specialKeysDown;

void checkForGLErrors(string line, string srcFile, int lineNo) {
	list<string> errors;
	
	for (GLenum errorId = glGetError(); errorId != GL_NO_ERROR; errorId = glGetError()) {
		switch (errorId) {
			case GL_INVALID_ENUM:
				errors.push_back("GL_INVALID_ENUM");
				break;
			case GL_INVALID_VALUE:
				errors.push_back("GL_INVALID_VALUE");
				break;
			case GL_INVALID_OPERATION:
				errors.push_back("GL_INVALID_OPERATION");
				break;
			case GL_INVALID_FRAMEBUFFER_OPERATION:
				errors.push_back("GL_INVALID_FRAMEBUFFER_OPERATION");
				break;
			case GL_OUT_OF_MEMORY:
				errors.push_back("GL_OUT_OF_MEMORY");
			default:
				errors.push_back("Unkown GL error " + to_string(errorId));
				break;
		}
	}

	if (errors.size() > 0) {
		stringstream errorString;
		errorString << "Call to \"" << line
		            << "\" at " << srcFile << ":" << lineNo
		            << " failed with error(s):";
		for_each(errors.begin(), errors.end(), [&](string err) {
			errorString << " " << err;
		});
		throw runtime_error(errorString.str());
	}
}

#define CALL_GL(glFn, args...) \
		glFn (args); \
		checkForGLErrors ( #glFn "(" #args ")" , __FILE__, __LINE__)


string VSHADER_SRC = R"(
	#version 130

	in vec2 vPosition;
	in vec3 vColor;

	out vec3 ffColor;

	void main() {
		gl_Position = vec4(vPosition, 0, 1);
		ffColor = vColor;
	}
)";

string FSHADER_SRC = R"(
	#version 130

	in vec3 ffColor;
	out vec4 fColor;

	void main() {
		fColor = vec4(ffColor, 1);
	}
)";

vector<GLfloat> TRI_POSITION_DATA = {
	0.0,0.0, 1.0,0.0, 0.5,1.0,
	0.0,0.0, -1.0,-0.0, -0.5,-1.0
};

vector<GLfloat> TRI_COLOR_DATA = {
	1.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0,
	0.5,0.5,0.0, 0.0,0.5,0.5, 0.5,0.0,0.5
};

void onDisplay() {
	CALL_GL(glClear, GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glDrawArrays(GL_TRIANGLES, 0, 6);

	glutSwapBuffers();
}

void onKeyDown (unsigned char key, int x, int y) {
	keysDown.insert(key);

	if (key == 'q') {
		exit(0);
	}
}

void onSpecialKeyDown (int key, int x, int y) {
	specialKeysDown.insert(key);

	if (key == GLUT_KEY_F4) {
		exit(0);
	}
}

void onKeyUp (unsigned char key, int x, int y) {
	keysDown.erase(key);
}

void onSpecialKeyUp (int key, int x, int y) {
	specialKeysDown.erase(key);
}

void onReshape (int width, int height) {
	CALL_GL(glViewport, 0, 0, width, height);
}

void onIdle () {
}

GLint initShader (list<pair<GLuint, string>> sources) {
	GLint status;

	GLuint programId = CALL_GL(glCreateProgram);

	for_each(sources.begin(), sources.end(), [&](pair<GLuint, string> source){
		GLuint shaderId = CALL_GL(glCreateShader, source.first);

		auto shaderSrcPtr = source.second.c_str();
		CALL_GL(glShaderSource, shaderId, 1, &shaderSrcPtr, NULL);

		CALL_GL(glCompileShader, shaderId);

		CALL_GL(glGetShaderiv, shaderId, GL_COMPILE_STATUS, &status);
		if (status != GL_TRUE) {
			GLint buflen;
			CALL_GL(glGetShaderiv, shaderId, GL_INFO_LOG_LENGTH, &buflen);

			unique_ptr<vector<GLchar>> msgBuffer(new vector<GLchar>(buflen));
			CALL_GL(glGetShaderInfoLog, shaderId, buflen, NULL, msgBuffer->data());

			stringstream errorMsg;
			errorMsg << "Error while compiling shader: " << msgBuffer->data();
			throw runtime_error(errorMsg.str());
		}

		CALL_GL(glAttachShader, programId, shaderId);
	});

	CALL_GL(glLinkProgram, programId);

	CALL_GL(glGetProgramiv, programId, GL_LINK_STATUS, &status);
	if (status != GL_TRUE) {
		GLint buflen;
		CALL_GL(glGetProgramiv, programId, GL_INFO_LOG_LENGTH, &buflen);

		unique_ptr<vector<GLchar>> msgBuffer(new vector<GLchar>(buflen));
		CALL_GL(glGetProgramInfoLog, programId, buflen, NULL, msgBuffer->data());
		throw runtime_error(msgBuffer->data());
	}

	CALL_GL(glUseProgram, programId);

	return programId;
}

struct VertexData {
	string name;
	GLint elementsPerVertex;
	GLfloat* dataPtr;
	GLint dataCount;
	GLsizeiptr dataSize;

	VertexData (string name, GLint elementsPerVertex, vector<GLfloat>& data):
		name(name),
		elementsPerVertex(elementsPerVertex),
		dataPtr(data.data()),
		dataCount(data.size()),
		dataSize(data.size() * sizeof(GLfloat))
	{ }
};

GLint initTris (GLint programId, list<VertexData> attributes) {
	GLuint vao;
	CALL_GL(glGenVertexArrays, 1, &vao);
	CALL_GL(glBindVertexArray, vao);

	for_each(attributes.begin(), attributes.end(), [&](VertexData attribute) {
		GLuint vbo;
		CALL_GL(glGenBuffers, 1, &vbo);
		CALL_GL(glBindBuffer, GL_ARRAY_BUFFER, vbo);
		CALL_GL(glBufferData, GL_ARRAY_BUFFER, attribute.dataSize * sizeof(GLfloat),
				attribute.dataPtr, GL_STATIC_DRAW);

		GLint attributeId = CALL_GL(glGetAttribLocation, programId, attribute.name.c_str());
		cout << "Location of " << attribute.name << " is " << attributeId << endl;
		CALL_GL(glVertexAttribPointer, attributeId, attribute.elementsPerVertex, GL_FLOAT, GL_FALSE, 0, 0);

		CALL_GL(glEnableVertexAttribArray, attributeId);
	});

	return vao;
}

void init () {
	CALL_GL(glClearColor, 0.0, 0.0, 0.0, 0.0);

	onReshape(800, 600);

	GLint programId = initShader({
		{ GL_VERTEX_SHADER,   VSHADER_SRC },
		{ GL_FRAGMENT_SHADER, FSHADER_SRC }
	});

	GLint vao = initTris(programId, {
		{ "vPosition", 2, TRI_POSITION_DATA },
		{ "vColor",    3, TRI_COLOR_DATA }
	});
}

int main (int argc, char* argv[]) {
	glutInit(&argc, argv);
	glutInitWindowPosition(0,0);
	glutInitWindowSize(800,600);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
	glutCreateWindow("GL Test");

	glewExperimental = GL_TRUE;

	glewInit();
	init();

	glutIdleFunc       (onIdle);
	glutDisplayFunc    (onDisplay);
	glutReshapeFunc    (onReshape);
	glutKeyboardFunc   (onKeyDown);
	glutSpecialFunc    (onSpecialKeyDown);
	glutKeyboardUpFunc (onKeyUp);
	glutSpecialUpFunc  (onSpecialKeyUp);

	glutMainLoop();
	return 0;
}
