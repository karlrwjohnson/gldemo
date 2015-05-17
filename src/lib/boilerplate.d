import core.time;

import std.array;
import std.conv;
import std.datetime;
import std.exception;
import std.math;
import std.stdio;
import std.typecons;

import derelict.opengl3.gl;

import vectypes;

/// Vertex data for a cube
GLfloat[] CUBE_POSITION_DATA = [
	-1,-1,-1, +1,-1,-1, +1,-1,+1, -1,-1,-1, +1,-1,+1, -1,-1,+1, // bottom
	-1,-1,-1, -1,+1,-1, +1,+1,-1, -1,-1,-1, +1,+1,-1, +1,-1,-1, // basck
	-1,-1,-1, -1,-1,+1, -1,+1,+1, -1,-1,-1, -1,+1,+1, -1,+1,-1, // left
	+1,+1,+1, -1,+1,+1, -1,+1,-1, +1,+1,+1, -1,+1,-1, +1,+1,-1, // top
	+1,+1,+1, +1,-1,+1, -1,-1,+1, +1,+1,+1, -1,-1,+1, -1,+1,+1, // front
	+1,+1,+1, +1,+1,-1, +1,-1,-1, +1,+1,+1, +1,-1,-1, +1,-1,+1, // right
];

GLfloat[] CUBE_NORMAL_DATA = [
	 0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0,  0,-1, 0, // bottom
	 0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1,  0, 0,-1, // back
	-1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, // left
	 0,+1, 0,  0,+1, 0,  0,+1, 0,  0,+1, 0,  0,+1, 0,  0,+1, 0, // top
	 0, 0,+1,  0, 0,+1,  0, 0,+1,  0, 0,+1,  0, 0,+1,  0, 0,+1, // front
	+1, 0, 0, +1, 0, 0, +1, 0, 0, +1, 0, 0, +1, 0, 0, +1, 0, 0, // right
];

GLfloat[] CUBE_COLOR_DATA = [
	1,0,0, 1,0,0, 1,0,0, 1,.5,.5, 1,.5,.5, 1,.5,.5, // bottom = red
	0,1,0, 0,1,0, 0,1,0, .5,1,.5, .5,1,.5, .5,1,.5, // back = green
	0,0,1, 0,0,1, 0,0,1, .5,.5,1, .5,.5,1, .5,.5,1, // left = blue
	0,1,1, 0,1,1, 0,1,1, 0,.5,.5, 0,.5,.5, 0,.5,.5, // top = cyan
	1,0,1, 1,0,1, 1,0,1, .5,0,.5, .5,0,.5, .5,0,.5, // front = magenta
	1,1,0, 1,1,0, 1,1,0, .5,.5,0, .5,.5,0, .5,.5,0, // right = yellow
];

/// Query OpenGL for errors and throw an exception if there is one.
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
