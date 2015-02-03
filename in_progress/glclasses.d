import std_all;

import derelict.opengl3.gl;

import boilerplate : checkGLErrors;

class GLObject {
    GLuint handle;
}

class GLBuffer
       (glGenBuffers    = glGenBuffers,
        glDeleteBuffers = glDeleteBuffers,
        glBindBuffer    = glBindBuffer,
        checkGLErrors   = checkGLErrors
       ) : GLObject {
    this () {
        glGenBuffers(1, &this.handle);
        checkGLErrors();
    }

    ~this () {
        glDeleteBuffers(1, &this.handle);
        checkGLErrors();
    }

    override void bind(GLenum target) {
        glBindBuffer(target, this.handle);
        checkGLErrors();
    }
}

class GLProgram
       (glCreateProgram = glCreateProgram,
        glDeleteProgram = glDeleteProgram,
        glUseProgram    = glUseProgram,
        checkGLErrors   = checkGLErrors
       ) : GLObject {
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

    void setUniform (size_t Arity) (string name, vec!Arity value, bool assertUniformDefined = false)
        if (Arity == 1 || Arity == 2 || Arity == 3 || Arity == 4)
    {
        char[] nameZ = name.dup ~ "\0";
        GLint location = glGetUniformLocation(progId, &nameZ[0]);
        checkGLErrors();
        if (location < 0) {
            if (assertUniformDefined) {
                throw new Exception(format(
                    "Uniform variable %s has not been assigned an ID; it " ~
                    "probably doesn't exist in the program.", name));
            }
            else {
                return;
            }
        }
        mixin(format("glUniform%dfv(location, 1, value.ptr);", Arity));
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

unittest {
    alias GLProg = GLProgram!(
}

class GLShader
       (glCreateShader  = glCreateShader,
        glDeleteShader  = glDeleteShader,
        glShaderSource  = glShaderSource,
        glCompileShader = glCompileShader,
        glShaderiv      = glShaderiv,
        checkGLErrors   = checkGLErrors
       ) : GLObject {
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
}

//void draw (GLProgram shader)