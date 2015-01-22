module ShaderProgram;

import std_all;

import derelict.opengl3.gl;

class ShaderProgram {

    bool initialized = false;

    GLuint programId;

    public this (string[GLint] sources) {
        GLint status;

        programId = glCreateProgram();

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

    this (const string[GLint] sources) {
        foreach (type, source; sources) {
            this.sources[type] = source;
        }
    }

    void setSource (GLint type, string source) {
        this.sources[type] = source;
    }

    string getSource (GLint type) {
        return this.sources[type];
    }

    void bind() {
    }

    void setActive() {
        assertInitialized(true);

        glUseProgram(programId);
    }

    void init (string[GLint] sources) {
        assertInitialized(false);

    }
}

GLint initShader (string[GLint] sources) {
}