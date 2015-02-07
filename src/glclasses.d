import std_all;

import derelict.opengl3.gl;

import boilerplate : checkGLErrors;

/*
Buffer Objects
Query Objects
Renderbuffer Objects
Sampler Objects
Texture Objects
Framebuffer Objects
Program Pipeline Objects
Transform Feedback Objects
Vertex Array Objects
*/

class GLObject {
    GLuint handle;
}

class GLBuffer : GLObject {
    this () {
        glGenBuffers(1, &this.handle);
        checkGLErrors();
    }

    ~this () {
        glDeleteBuffers(1, &this.handle);
        checkGLErrors();
    }

    void bind(GLenum target) {
        glBindBuffer(target, this.handle);
        checkGLErrors();
    }
}
/+
class GLProgram : GLObject {
    GLShader[GLenum] shaders;

    this () {
        handle = glCreateProgram();
        checkGLErrors();
    }

    ~this () {
        glDeleteProgram(this.handle);
        checkGLErrors();
    }

    void bind () {
        glUseProgram(this.handle);
        checkGLErrors();
    }

    private GLint getUniformLocation (string name, bool assertUniformDefined) {
        char[] nameZ = name.dup ~ "\0";
        GLint location = glGetUniformLocation(progId, &nameZ[0]);
        checkGLErrors();
        if (location < 0 && assertUniformDefined) {
            throw new Exception(format(
                "Uniform variable %s has not been assigned an ID; it " ~
                "probably doesn't exist in the program.", name));
        }
        else {
            return location;
        }
    }

    void setUniform (size_t Arity) (string name, vec!Arity value, bool assertUniformDefined = false)
        if (Arity == 2 || Arity == 3 || Arity == 4)
    {
        mixin("auto glUniform = glUniform" ~ Arity ~ "fv");
        glUniform(getUniformLocation(name), 1, value.ptr);
        checkGLErrors();
    }

    void setUniform (size_t Arity) (string name, mat!Arity value, bool assertUniformDefined = false)
        if (Arity == 2 || Arity == 3 || Arity == 4)
    {
        mixin("auto glUniformMatrix = glUniformMatrix" ~ Arity ~ "fv");
        glUniformMatrix(getUniformLocation(name), 1, value.ptr);
        checkGLErrors();
    }

    void attach (GLShader shader) {
        if (shader.type in shaders) {
            throw new Exception(format(
                "A shader of type %s is already attached",
                shader.type
            ));
        }
        glAttachShader(this.handle, shader.handle);
    }
}

class GLShader : GLObject {
    GLenum type;

    static enum GL_SHADER_TYPE {
        GL_VERTEX_SHADER: derelict.opengl3.constants.GL_VERTEX_SHADER,
        GL_FRAGMENT_SHADER: derelict.opengl3.constants.GL_FRAGMENT_SHADER,
        GL_GEOMETRY_SHADER: derelict.opengl3.constants.GL_GEOMETRY_SHADER
    };

    this (GL_SHADER_TYPE type, string source) {

        handle = glCreateShader(type);
        checkGLErrors();

        this.type = type;
        this.setSource(source);
    }

    unittest {
        bool glCreateShader_called = false;
        bool glDeleteShader_called = false;
        bool glShaderSource_called = false;
        bool 
        new GLShader
    }

    ~this () {
        glDeleteShader(this.handle);
        checkGLErrors();
    }


    private void setSource (string source) {
        GLint status;

        const char[] sourceZ = sformat(new char[source.length + 1], "%s\0", source);
        glShaderSource(this.handle, 1, &sourceZ[0], null);
        checkGLErrors();

        glCompileShader(this.handle);
        checkGLErrors();

        glGetShaderiv(this.handle, GL_COMPILE_STATUS, &status);
        checkGLErrors();
        if (status != GL_TRUE) {
            GLint buflen;
            glGetShaderiv(this.handle, GL_INFO_LOG_LENGTH, &buflen);
            checkGLErrors();

            char[] msgBuffer = new char[buflen];
            glGetShaderInfoLog(this.handle, buflen, null, &msgBuffer[0]);
            checkGLErrors();

            throw new Exception("Error while compiling shader: " ~ msgBuffer.idup);
        }
    }
}+/

//void draw (GLProgram shader)