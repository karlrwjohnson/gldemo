/**
 * Wrapper functions for OpenGL which calls glGetError() before returning.
 * If an error was generated, an exception is thrown.
 */
module glsafe;

import std.array;
import std.conv;
import std.exception;
import std.typecons;
import std.typetuple;

import glcorearb;

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

    mixin template WrapGlFunction (alias functionName, R, Args...) {
    R _wrappedGlFunction_temp (Args args) {
        static if (is(R == void)) {
            mixin(functionName ~ "(args);");
            checkGLErrors();
        } else {
            mixin("R ret = " ~ functionName ~ "(args);");
            checkGLErrors();
            return ret;
        }
    }

    mixin("auto " ~ functionName ~ "_s = &_wrappedGlFunction_temp;");
}

// Pre-wrapped functions
// Generated from glcorearb.d, mostly from the following regular expressions:
// - For all non-comment lines, remove the parameter names from functions
//     :g/[^/]/ s/\([a-z*]\) [a-zA-Z_]*\([,)]\)/\1\2/
// - Turn each function declaration into a call to wrapGl()
//     :%s/^\([^/]*\) \([^(]*\)(\(.*\));$/auto \2_s = wrapGl!(\1, \3)(\&\2);

/* *********************************************************** */

// GL_VERSION_1_0
version (GL_VERSION_1_0) {
    mixin WrapGlFunction!("glCullFace", void, GLenum);
    mixin WrapGlFunction!("glFrontFace", void, GLenum);
    mixin WrapGlFunction!("glHint", void, GLenum, GLenum);
    mixin WrapGlFunction!("glLineWidth", void, GLfloat);
    mixin WrapGlFunction!("glPointSize", void, GLfloat);
    mixin WrapGlFunction!("glPolygonMode", void, GLenum, GLenum);
    mixin WrapGlFunction!("glScissor", void, GLint, GLint, GLsizei, GLsizei);
    mixin WrapGlFunction!("glTexParameterf", void, GLenum, GLenum, GLfloat);
    mixin WrapGlFunction!("glTexParameterfv", void, GLenum, GLenum, const(GLfloat)*);
    mixin WrapGlFunction!("glTexParameteri", void, GLenum, GLenum, GLint);
    mixin WrapGlFunction!("glTexParameteriv", void, GLenum, GLenum, const(GLint)*);
    mixin WrapGlFunction!("glTexImage1D", void, GLenum, GLint, GLint, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glTexImage2D", void, GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glDrawBuffer", void, GLenum);
    mixin WrapGlFunction!("glClear", void, GLbitfield);
    mixin WrapGlFunction!("glClearColor", void, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glClearStencil", void, GLint);
    mixin WrapGlFunction!("glClearDepth", void, GLdouble);
    mixin WrapGlFunction!("glStencilMask", void, GLuint);
    mixin WrapGlFunction!("glColorMask", void, GLboolean, GLboolean, GLboolean, GLboolean);
    mixin WrapGlFunction!("glDepthMask", void, GLboolean);
    mixin WrapGlFunction!("glDisable", void, GLenum);
    mixin WrapGlFunction!("glEnable", void, GLenum);
    mixin WrapGlFunction!("glFinish", void);
    mixin WrapGlFunction!("glFlush", void);
    mixin WrapGlFunction!("glBlendFunc", void, GLenum, GLenum);
    mixin WrapGlFunction!("glLogicOp", void, GLenum);
    mixin WrapGlFunction!("glStencilFunc", void, GLenum, GLint, GLuint);
    mixin WrapGlFunction!("glStencilOp", void, GLenum, GLenum, GLenum);
    mixin WrapGlFunction!("glDepthFunc", void, GLenum);
    mixin WrapGlFunction!("glPixelStoref", void, GLenum, GLfloat);
    mixin WrapGlFunction!("glPixelStorei", void, GLenum, GLint);
    mixin WrapGlFunction!("glReadBuffer", void, GLenum);
    mixin WrapGlFunction!("glReadPixels", void, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLvoid*);
    mixin WrapGlFunction!("glGetBooleanv", void, GLenum, GLboolean*);
    mixin WrapGlFunction!("glGetDoublev", void, GLenum, GLdouble*);
//auto glGetError_s = wrapGl!(GLenum, )(&glGetError); // Useless and overflows the stack
    mixin WrapGlFunction!("glGetFloatv", void, GLenum, GLfloat*);
    mixin WrapGlFunction!("glGetIntegerv", void, GLenum, GLint*);
    mixin WrapGlFunction!("glGetString", const(GLubyte)*, GLenum);
    mixin WrapGlFunction!("glGetTexImage", void, GLenum, GLint, GLenum, GLenum, GLvoid*);
    mixin WrapGlFunction!("glGetTexParameterfv", void, GLenum, GLenum, GLfloat*);
    mixin WrapGlFunction!("glGetTexParameteriv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGetTexLevelParameterfv", void, GLenum, GLint, GLenum, GLfloat*);
    mixin WrapGlFunction!("glGetTexLevelParameteriv", void, GLenum, GLint, GLenum, GLint*);
    mixin WrapGlFunction!("glIsEnabled", GLboolean, GLenum);
    mixin WrapGlFunction!("glDepthRange", void, GLdouble, GLdouble);
    mixin WrapGlFunction!("glViewport", void, GLint, GLint, GLsizei, GLsizei);
}

// GL_VERSION_1_1
version (GL_VERSION_1_1) {
    mixin WrapGlFunction!("glDrawArrays", void, GLenum, GLint, GLsizei);
    mixin WrapGlFunction!("glDrawElements", void, GLenum, GLsizei, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glGetPointerv", void, GLenum, GLvoid**);
    mixin WrapGlFunction!("glPolygonOffset", void, GLfloat, GLfloat);
    mixin WrapGlFunction!("glCopyTexImage1D", void, GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLint);
    mixin WrapGlFunction!("glCopyTexImage2D", void, GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLsizei, GLint);
    mixin WrapGlFunction!("glCopyTexSubImage1D", void, GLenum, GLint, GLint, GLint, GLint, GLsizei);
    mixin WrapGlFunction!("glCopyTexSubImage2D", void, GLenum, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei);
    mixin WrapGlFunction!("glTexSubImage1D", void, GLenum, GLint, GLint, GLsizei, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glTexSubImage2D", void, GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glBindTexture", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDeleteTextures", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenTextures", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glIsTexture", GLboolean, GLuint);
}

// GL_VERSION_1_2
version (GL_VERSION_1_2) {
    mixin WrapGlFunction!("glBlendColor", void, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glBlendEquation", void, GLenum);
    mixin WrapGlFunction!("glDrawRangeElements", void, GLenum, GLuint, GLuint, GLsizei, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glTexImage3D", void, GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glTexSubImage3D", void, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glCopyTexSubImage3D", void, GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei);
}

// GL_VERSION_1_3
version (GL_VERSION_1_3) {
    mixin WrapGlFunction!("glActiveTexture", void, GLenum);
    mixin WrapGlFunction!("glSampleCoverage", void, GLfloat, GLboolean);
    mixin WrapGlFunction!("glCompressedTexImage3D", void, GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei, GLint, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glCompressedTexImage2D", void, GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glCompressedTexImage1D", void, GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glCompressedTexSubImage3D", void, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glCompressedTexSubImage2D", void, GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glCompressedTexSubImage1D", void, GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glGetCompressedTexImage", void, GLenum, GLint, GLvoid*);
}

// GL_VERSION_1_4
version (GL_VERSION_1_4) {
    mixin WrapGlFunction!("glBlendFuncSeparate", void, GLenum, GLenum, GLenum, GLenum);
    mixin WrapGlFunction!("glMultiDrawArrays", void, GLenum, const(GLint)*, const(GLsizei)*, GLsizei);
    mixin WrapGlFunction!("glMultiDrawElements", void, GLenum, const(GLsizei)*, GLenum, const(GLvoid)**, GLsizei);
    mixin WrapGlFunction!("glPointParameterf", void, GLenum, GLfloat);
    mixin WrapGlFunction!("glPointParameterfv", void, GLenum, const(GLfloat)*);
    mixin WrapGlFunction!("glPointParameteri", void, GLenum, GLint);
    mixin WrapGlFunction!("glPointParameteriv", void, GLenum, const(GLint)*);
}

// GL_VERSION_1_5
version (GL_VERSION_1_5) {
    mixin WrapGlFunction!("glGenQueries", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glDeleteQueries", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glIsQuery", GLboolean, GLuint);
    mixin WrapGlFunction!("glBeginQuery", void, GLenum, GLuint);
    mixin WrapGlFunction!("glEndQuery", void, GLenum);
    mixin WrapGlFunction!("glGetQueryiv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGetQueryObjectiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetQueryObjectuiv", void, GLuint, GLenum, GLuint*);
    mixin WrapGlFunction!("glBindBuffer", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDeleteBuffers", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenBuffers", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glIsBuffer", GLboolean, GLuint);
    mixin WrapGlFunction!("glBufferData", void, GLenum, GLsizeiptr, const(GLvoid)*, GLenum);
    mixin WrapGlFunction!("glBufferSubData", void, GLenum, GLintptr, GLsizeiptr, const(GLvoid)*);
    mixin WrapGlFunction!("glGetBufferSubData", void, GLenum, GLintptr, GLsizeiptr, GLvoid*);
    mixin WrapGlFunction!("glMapBuffer", GLvoid*, GLenum, GLenum);
    mixin WrapGlFunction!("glUnmapBuffer", GLboolean, GLenum);
    mixin WrapGlFunction!("glGetBufferParameteriv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGetBufferPointerv", void, GLenum, GLenum, GLvoid**);
}

// GL_VERSION_2_0
version (GL_VERSION_2_0) {
    mixin WrapGlFunction!("glBlendEquationSeparate", void, GLenum, GLenum);
    mixin WrapGlFunction!("glDrawBuffers", void, GLsizei, const(GLenum)*);
    mixin WrapGlFunction!("glStencilOpSeparate", void, GLenum, GLenum, GLenum, GLenum);
    mixin WrapGlFunction!("glStencilFuncSeparate", void, GLenum, GLenum, GLint, GLuint);
    mixin WrapGlFunction!("glStencilMaskSeparate", void, GLenum, GLuint);
    mixin WrapGlFunction!("glAttachShader", void, GLuint, GLuint);
    mixin WrapGlFunction!("glBindAttribLocation", void, GLuint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glCompileShader", void, GLuint);
    mixin WrapGlFunction!("glCreateProgram", GLuint, );
    mixin WrapGlFunction!("glCreateShader", GLuint, GLenum);
    mixin WrapGlFunction!("glDeleteProgram", void, GLuint);
    mixin WrapGlFunction!("glDeleteShader", void, GLuint);
    mixin WrapGlFunction!("glDetachShader", void, GLuint, GLuint);
    mixin WrapGlFunction!("glDisableVertexAttribArray", void, GLuint);
    mixin WrapGlFunction!("glEnableVertexAttribArray", void, GLuint);
    mixin WrapGlFunction!("glGetActiveAttrib", void, GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
    mixin WrapGlFunction!("glGetActiveUniform", void, GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
    mixin WrapGlFunction!("glGetAttachedShaders", void, GLuint, GLsizei, GLsizei*, GLuint*);
    mixin WrapGlFunction!("glGetAttribLocation", GLint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glGetProgramiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetProgramInfoLog", void, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetShaderiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetShaderInfoLog", void, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetShaderSource", void, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetUniformLocation", GLint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glGetUniformfv", void, GLuint, GLint, GLfloat*);
    mixin WrapGlFunction!("glGetUniformiv", void, GLuint, GLint, GLint*);
    mixin WrapGlFunction!("glGetVertexAttribdv", void, GLuint, GLenum, GLdouble*);
    mixin WrapGlFunction!("glGetVertexAttribfv", void, GLuint, GLenum, GLfloat*);
    mixin WrapGlFunction!("glGetVertexAttribiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetVertexAttribPointerv", void, GLuint, GLenum, GLvoid**);
    mixin WrapGlFunction!("glIsProgram", GLboolean, GLuint);
    mixin WrapGlFunction!("glIsShader", GLboolean, GLuint);
    mixin WrapGlFunction!("glLinkProgram", void, GLuint);
    mixin WrapGlFunction!("glShaderSource", void, GLuint, GLsizei, const(GLchar)**, const(GLint)*);
    mixin WrapGlFunction!("glUseProgram", void, GLuint);
    mixin WrapGlFunction!("glUniform1f", void, GLint, GLfloat);
    mixin WrapGlFunction!("glUniform2f", void, GLint, GLfloat, GLfloat);
    mixin WrapGlFunction!("glUniform3f", void, GLint, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glUniform4f", void, GLint, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glUniform1i", void, GLint, GLint);
    mixin WrapGlFunction!("glUniform2i", void, GLint, GLint, GLint);
    mixin WrapGlFunction!("glUniform3i", void, GLint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glUniform4i", void, GLint, GLint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glUniform1fv", void, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glUniform2fv", void, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glUniform3fv", void, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glUniform4fv", void, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glUniform1iv", void, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glUniform2iv", void, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glUniform3iv", void, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glUniform4iv", void, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glUniformMatrix2fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix3fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix4fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glValidateProgram", void, GLuint);
    mixin WrapGlFunction!("glVertexAttrib1d", void, GLuint, GLdouble);
    mixin WrapGlFunction!("glVertexAttrib1dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttrib1f", void, GLuint, GLfloat);
    mixin WrapGlFunction!("glVertexAttrib1fv", void, GLuint, const(GLfloat)*);
    mixin WrapGlFunction!("glVertexAttrib1s", void, GLuint, GLshort);
    mixin WrapGlFunction!("glVertexAttrib1sv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttrib2d", void, GLuint, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttrib2dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttrib2f", void, GLuint, GLfloat, GLfloat);
    mixin WrapGlFunction!("glVertexAttrib2fv", void, GLuint, const(GLfloat)*);
    mixin WrapGlFunction!("glVertexAttrib2s", void, GLuint, GLshort, GLshort);
    mixin WrapGlFunction!("glVertexAttrib2sv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttrib3d", void, GLuint, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttrib3dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttrib3f", void, GLuint, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glVertexAttrib3fv", void, GLuint, const(GLfloat)*);
    mixin WrapGlFunction!("glVertexAttrib3s", void, GLuint, GLshort, GLshort, GLshort);
    mixin WrapGlFunction!("glVertexAttrib3sv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttrib4Nbv", void, GLuint, const(GLbyte)*);
    mixin WrapGlFunction!("glVertexAttrib4Niv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttrib4Nsv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttrib4Nub", void, GLuint, GLubyte, GLubyte, GLubyte, GLubyte);
    mixin WrapGlFunction!("glVertexAttrib4Nubv", void, GLuint, const(GLubyte)*);
    mixin WrapGlFunction!("glVertexAttrib4Nuiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttrib4Nusv", void, GLuint, const(GLushort)*);
    mixin WrapGlFunction!("glVertexAttrib4bv", void, GLuint, const(GLbyte)*);
    mixin WrapGlFunction!("glVertexAttrib4d", void, GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttrib4dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttrib4f", void, GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glVertexAttrib4fv", void, GLuint, const(GLfloat)*);
    mixin WrapGlFunction!("glVertexAttrib4iv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttrib4s", void, GLuint, GLshort, GLshort, GLshort, GLshort);
    mixin WrapGlFunction!("glVertexAttrib4sv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttrib4ubv", void, GLuint, const(GLubyte)*);
    mixin WrapGlFunction!("glVertexAttrib4uiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttrib4usv", void, GLuint, const(GLushort)*);
    mixin WrapGlFunction!("glVertexAttribPointer", void, GLuint, GLint, GLenum, GLboolean, GLsizei, const(GLvoid)*);
}

// GL_VERSION_2_1
version (GL_VERSION_2_1) {
    mixin WrapGlFunction!("glUniformMatrix2x3fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix3x2fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix2x4fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix4x2fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix3x4fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glUniformMatrix4x3fv", void, GLint, GLsizei, GLboolean, const(GLfloat)*);
}

// GL_VERSION_3_0
version (GL_VERSION_3_0) {
/* OpenGL 3.0 also reuses entry points from these extensions: */
/* ARB_framebuffer_object*/
/* ARB_map_buffer_range*/
/*)*/
    mixin WrapGlFunction!("glColorMaski", void, GLuint, GLboolean, GLboolean, GLboolean, GLboolean);
    mixin WrapGlFunction!("glGetBooleani_v", void, GLenum, GLuint, GLboolean*);
    mixin WrapGlFunction!("glGetIntegeri_v", void, GLenum, GLuint, GLint*);
    mixin WrapGlFunction!("glEnablei", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDisablei", void, GLenum, GLuint);
    mixin WrapGlFunction!("glIsEnabledi", GLboolean, GLenum, GLuint);
    mixin WrapGlFunction!("glBeginTransformFeedback", void, GLenum);
    mixin WrapGlFunction!("glEndTransformFeedback", void);
    mixin WrapGlFunction!("glBindBufferRange", void, GLenum, GLuint, GLuint, GLintptr, GLsizeiptr);
    mixin WrapGlFunction!("glBindBufferBase", void, GLenum, GLuint, GLuint);
    mixin WrapGlFunction!("glTransformFeedbackVaryings", void, GLuint, GLsizei, const(GLchar)**, GLenum);
    mixin WrapGlFunction!("glGetTransformFeedbackVarying", void, GLuint, GLuint, GLsizei, GLsizei*, GLsizei*, GLenum*, GLchar*);
    mixin WrapGlFunction!("glClampColor", void, GLenum, GLenum);
    mixin WrapGlFunction!("glBeginConditionalRender", void, GLuint, GLenum);
    mixin WrapGlFunction!("glEndConditionalRender", void);
    mixin WrapGlFunction!("glVertexAttribIPointer", void, GLuint, GLint, GLenum, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glGetVertexAttribIiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetVertexAttribIuiv", void, GLuint, GLenum, GLuint*);
    mixin WrapGlFunction!("glVertexAttribI1i", void, GLuint, GLint);
    mixin WrapGlFunction!("glVertexAttribI2i", void, GLuint, GLint, GLint);
    mixin WrapGlFunction!("glVertexAttribI3i", void, GLuint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glVertexAttribI4i", void, GLuint, GLint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glVertexAttribI1ui", void, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexAttribI2ui", void, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexAttribI3ui", void, GLuint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexAttribI4ui", void, GLuint, GLuint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexAttribI1iv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttribI2iv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttribI3iv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttribI4iv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glVertexAttribI1uiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribI2uiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribI3uiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribI4uiv", void, GLuint, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribI4bv", void, GLuint, const(GLbyte)*);
    mixin WrapGlFunction!("glVertexAttribI4sv", void, GLuint, const(GLshort)*);
    mixin WrapGlFunction!("glVertexAttribI4ubv", void, GLuint, const(GLubyte)*);
    mixin WrapGlFunction!("glVertexAttribI4usv", void, GLuint, const(GLushort)*);
    mixin WrapGlFunction!("glGetUniformuiv", void, GLuint, GLint, GLuint*);
    mixin WrapGlFunction!("glBindFragDataLocation", void, GLuint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glGetFragDataLocation", GLint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glUniform1ui", void, GLint, GLuint);
    mixin WrapGlFunction!("glUniform2ui", void, GLint, GLuint, GLuint);
    mixin WrapGlFunction!("glUniform3ui", void, GLint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glUniform4ui", void, GLint, GLuint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glUniform1uiv", void, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glUniform2uiv", void, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glUniform3uiv", void, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glUniform4uiv", void, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glTexParameterIiv", void, GLenum, GLenum, const(GLint)*);
    mixin WrapGlFunction!("glTexParameterIuiv", void, GLenum, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glGetTexParameterIiv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGetTexParameterIuiv", void, GLenum, GLenum, GLuint*);
    mixin WrapGlFunction!("glClearBufferiv", void, GLenum, GLint, const(GLint)*);
    mixin WrapGlFunction!("glClearBufferuiv", void, GLenum, GLint, const(GLuint)*);
    mixin WrapGlFunction!("glClearBufferfv", void, GLenum, GLint, const(GLfloat)*);
    mixin WrapGlFunction!("glClearBufferfi", void, GLenum, GLint, GLfloat, GLint);
    mixin WrapGlFunction!("glGetStringi", const(GLubyte)*, GLenum, GLuint);
}

// GL_VERSION_3_1
version (GL_VERSION_3_1) {
/* OpenGL 3.1 also reuses entry points from these extensions:*/
/* ARB_copy_buffer*/
/* ARB_uniform_buffer_object*/
    mixin WrapGlFunction!("glDrawArraysInstanced", void, GLenum, GLint, GLsizei, GLsizei);
    mixin WrapGlFunction!("glDrawElementsInstanced", void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLsizei);
    mixin WrapGlFunction!("glTexBuffer", void, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glPrimitiveRestartIndex", void, GLuint);
}

// GL_VERSION_3_2
version (GL_VERSION_3_2) {
/* OpenGL 3.2 also reuses entry points from these extensions:*/
/* ARB_draw_elements_base_vertex*/
/* ARB_provoking_vertex*/
/* ARB_sync*/
/* ARB_texture_multisample*/
    mixin WrapGlFunction!("glGetInteger64i_v", void, GLenum, GLuint, GLint64*);
    mixin WrapGlFunction!("glGetBufferParameteri64v", void, GLenum, GLenum, GLint64*);
    mixin WrapGlFunction!("glFramebufferTexture", void, GLenum, GLenum, GLuint, GLint);
}

// GL_VERSION_3_3
version (GL_VERSION_3_3) {
/* OpenGL 3.3 also reuses entry points from these extensions:*/
/* ARB_blend_func_extended*/
/* ARB_sampler_objects*/
/*, but it has none*/
/* ARB_occlusion_query2(no entry)*/
/* ARB_shader_bit_encoding(no entry)*/
/* ARB_texture_rgb10_a2ui(no entry)*/
/* ARB_texture_swizzle(no entry)*/
/* ARB_timer_query*/
/* ARB_vertex_type_2_10_10_10_rev*/
    mixin WrapGlFunction!("glVertexAttribDivisor", void, GLuint, GLuint);
}

// GL_VERSION_4_0
version (GL_VERSION_4_0) {
/* OpenGL 4.0 also reuses entry points from these extensions:*/
/* ARB_texture_query_lod(no entry)*/
/* ARB_draw_indirect*/
/* ARB_gpu_shader5(no entry)*/
/* ARB_gpu_shader_fp64*/
/* ARB_shader_subroutine*/
/* ARB_tessellation_shader*/
/* ARB_texture_buffer_object_rgb32(no entry)*/
/* ARB_texture_cube_map_array(no entry)*/
/* ARB_texture_gather(no entry)*/
/* ARB_transform_feedback2*/
/* ARB_transform_feedback3*/
    mixin WrapGlFunction!("glMinSampleShading", void, GLfloat);
    mixin WrapGlFunction!("glBlendEquationi", void, GLuint, GLenum);
    mixin WrapGlFunction!("glBlendEquationSeparatei", void, GLuint, GLenum, GLenum);
    mixin WrapGlFunction!("glBlendFunci", void, GLuint, GLenum, GLenum);
    mixin WrapGlFunction!("glBlendFuncSeparatei", void, GLuint, GLenum, GLenum, GLenum, GLenum);
}
// GL_VERSION_4_1
version (GL_VERSION_4_1) {
/* OpenGL 4.1 reuses entry points from these extensions:*/
/* ARB_ES2_compatibility*/
/* ARB_get_program_binary*/
/* ARB_separate_shader_objects*/
/* ARB_shader_precision(no entry)*/
/* ARB_vertex_attrib_64bit*/
/* ARB_viewport_array*/
}
// GL_VERSION_4_2
version (GL_VERSION_4_2) {
/* OpenGL 4.2 reuses entry points from these extensions:*/
/* ARB_base_instance*/
/* ARB_shading_language_420pack(no entry)*/
/* ARB_transform_feedback_instanced*/
/* ARB_compressed_texture_pixel_storage(no entry)*/
/* ARB_conservative_depth(no entry)*/
/* ARB_internalformat_query*/
/* ARB_map_buffer_alignment(no entry)*/
/* ARB_shader_atomic_counters*/
/* ARB_shader_image_load_store*/
/* ARB_shading_language_packing(no entry)*/
/* ARB_texture_storage*/
}
// GL_VERSION_4_3
version (GL_VERSION_4_3) {
/* OpenGL 4.3 reuses entry points from these extensions:*/
/* ARB_arrays_of_arrays(no entry, GLSL only)*/
/* ARB_fragment_layer_viewport(no entry, GLSL only)*/
/* ARB_shader_image_size(no entry, GLSL only)*/
/* ARB_ES3_compatibility(no entry)*/
/* ARB_clear_buffer_object*/
/* ARB_compute_shader*/
/* ARB_copy_image*/
/* KHR_debug(includes ARB_debug_output commands promoted to KHR without)*/
/* ARB_explicit_uniform_location(no entry)*/
/* ARB_framebuffer_no_attachments*/
/* ARB_internalformat_query2*/
/* ARB_invalidate_subdata*/
/* ARB_multi_draw_indirect*/
/* ARB_program_interface_query*/
/* ARB_robust_buffer_access_behavior(no entry)*/
/* ARB_shader_storage_buffer_object*/
/* ARB_stencil_texturing(no entry)*/
/* ARB_texture_buffer_range*/
/* ARB_texture_query_levels(no entry)*/
/* ARB_texture_storage_multisample*/
/* ARB_texture_view*/
/* ARB_vertex_attrib_binding*/
}
// GL_ARB_depth_buffer_float

// GL_ARB_framebuffer_object
version (GL_ARB_framebuffer_object) {
    mixin WrapGlFunction!("glIsRenderbuffer", GLboolean, GLuint);
    mixin WrapGlFunction!("glBindRenderbuffer", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDeleteRenderbuffers", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenRenderbuffers", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glRenderbufferStorage", void, GLenum, GLenum, GLsizei, GLsizei);
    mixin WrapGlFunction!("glGetRenderbufferParameteriv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glIsFramebuffer", GLboolean, GLuint);
    mixin WrapGlFunction!("glBindFramebuffer", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDeleteFramebuffers", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenFramebuffers", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glCheckFramebufferStatus", GLenum, GLenum);
    mixin WrapGlFunction!("glFramebufferTexture1D", void, GLenum, GLenum, GLenum, GLuint, GLint);
    mixin WrapGlFunction!("glFramebufferTexture2D", void, GLenum, GLenum, GLenum, GLuint, GLint);
    mixin WrapGlFunction!("glFramebufferTexture3D", void, GLenum, GLenum, GLenum, GLuint, GLint, GLint);
    mixin WrapGlFunction!("glFramebufferRenderbuffer", void, GLenum, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glGetFramebufferAttachmentParameteriv", void, GLenum, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGenerateMipmap", void, GLenum);
    mixin WrapGlFunction!("glBlitFramebuffer", void, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLbitfield, GLenum);
    mixin WrapGlFunction!("glRenderbufferStorageMultisample", void, GLenum, GLsizei, GLenum, GLsizei, GLsizei);
    mixin WrapGlFunction!("glFramebufferTextureLayer", void, GLenum, GLenum, GLuint, GLint, GLint);
}

// GL_ARB_framebuffer_sRGB

// GL_ARB_half_float_vertex

// GL_ARB_map_buffer_range
version (GL_ARB_map_buffer_range) {
    mixin WrapGlFunction!("glMapBufferRange", GLvoid*, GLenum, GLintptr, GLsizeiptr, GLbitfield);
    mixin WrapGlFunction!("glFlushMappedBufferRange", void, GLenum, GLintptr, GLsizeiptr);
}

// GL_ARB_texture_compression_rgtc

// GL_ARB_texture_rg

// GL_ARB_vertex_array_object
version (GL_ARB_vertex_array_object) {
    mixin WrapGlFunction!("glBindVertexArray", void, GLuint);
    mixin WrapGlFunction!("glDeleteVertexArrays", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenVertexArrays", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glIsVertexArray", GLboolean, GLuint);
}

// GL_ARB_uniform_buffer_object
version (GL_ARB_uniform_buffer_object) {
    mixin WrapGlFunction!("glGetUniformIndices", void, GLuint, GLsizei, const(GLchar)**, GLuint*);
    mixin WrapGlFunction!("glGetActiveUniformsiv", void, GLuint, GLsizei, const(GLuint)*, GLenum, GLint*);
    mixin WrapGlFunction!("glGetActiveUniformName", void, GLuint, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetUniformBlockIndex", GLuint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glGetActiveUniformBlockiv", void, GLuint, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetActiveUniformBlockName", void, GLuint, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glUniformBlockBinding", void, GLuint, GLuint, GLuint);
}

// GL_ARB_copy_buffer
version (GL_ARB_copy_buffer) {
    mixin WrapGlFunction!("glCopyBufferSubData", void, GLenum, GLenum, GLintptr, GLintptr, GLsizeiptr);
}

// GL_ARB_depth_clamp

// GL_ARB_draw_elements_base_vertex
version (GL_ARB_draw_elements_base_vertex) {
    mixin WrapGlFunction!("glDrawElementsBaseVertex", void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLint);
    mixin WrapGlFunction!("glDrawRangeElementsBaseVertex", void, GLenum, GLuint, GLuint, GLsizei, GLenum, const(GLvoid)*, GLint);
    mixin WrapGlFunction!("glDrawElementsInstancedBaseVertex", void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLsizei, GLint);
    mixin WrapGlFunction!("glMultiDrawElementsBaseVertex", void, GLenum, const(GLsizei)*, GLenum, const(GLvoid)**, GLsizei, const(GLint)*);
}

// GL_ARB_fragment_coord_conventions

// GL_ARB_provoking_vertex
version (GL_ARB_provoking_vertex) {
    mixin WrapGlFunction!("glProvokingVertex", void, GLenum);
}

// GL_ARB_seamless_cube_map

// GL_ARB_sync
version (GL_ARB_sync) {
    mixin WrapGlFunction!("glFenceSync", GLsync, GLenum, GLbitfield);
    mixin WrapGlFunction!("glIsSync", GLboolean, GLsync);
    mixin WrapGlFunction!("glDeleteSync", void, GLsync);
    mixin WrapGlFunction!("glClientWaitSync", GLenum, GLsync, GLbitfield, GLuint64);
    mixin WrapGlFunction!("glWaitSync", void, GLsync, GLbitfield, GLuint64);
    mixin WrapGlFunction!("glGetInteger64v", void, GLenum, GLint64*);
    mixin WrapGlFunction!("glGetSynciv", void, GLsync, GLenum, GLsizei, GLsizei*, GLint*);
}

// GL_ARB_texture_multisample
version (GL_ARB_texture_multisample) {
    mixin WrapGlFunction!("glTexImage2DMultisample", void, GLenum, GLsizei, GLint, GLsizei, GLsizei, GLboolean);
    mixin WrapGlFunction!("glTexImage3DMultisample", void, GLenum, GLsizei, GLint, GLsizei, GLsizei, GLsizei, GLboolean);
    mixin WrapGlFunction!("glGetMultisamplefv", void, GLenum, GLuint, GLfloat*);
    mixin WrapGlFunction!("glSampleMaski", void, GLuint, GLbitfield);
}

// GL_ARB_vertex_array_bgra

// GL_ARB_draw_buffers_blend
version (GL_ARB_draw_buffers_blend) {
    mixin WrapGlFunction!("glBlendEquationiARB", void, GLuint, GLenum);
    mixin WrapGlFunction!("glBlendEquationSeparateiARB", void, GLuint, GLenum, GLenum);
    mixin WrapGlFunction!("glBlendFunciARB", void, GLuint, GLenum, GLenum);
    mixin WrapGlFunction!("glBlendFuncSeparateiARB", void, GLuint, GLenum, GLenum, GLenum, GLenum);
}

// GL_ARB_sample_shading
version (GL_ARB_sample_shading) {
    mixin WrapGlFunction!("glMinSampleShadingARB", void, GLfloat);
}

// GL_ARB_texture_cube_map_array

// GL_ARB_texture_gather

// GL_ARB_texture_query_lod

// GL_ARB_shading_language_include
version (GL_ARB_shading_language_include) {
    mixin WrapGlFunction!("glNamedStringARB", void, GLenum, GLint, const(GLchar)*, GLint, const(GLchar)*);
    mixin WrapGlFunction!("glDeleteNamedStringARB", void, GLint, const(GLchar)*);
    mixin WrapGlFunction!("glCompileShaderIncludeARB", void, GLuint, GLsizei, const(GLchar*)*, const(GLint)*);
    mixin WrapGlFunction!("glIsNamedStringARB", GLboolean, GLint, const(GLchar)*);
    mixin WrapGlFunction!("glGetNamedStringARB", void, GLint, const(GLchar)*, GLsizei, GLint*, GLchar*);
    mixin WrapGlFunction!("glGetNamedStringivARB", void, GLint, const(GLchar)*, GLenum, GLint*);
}

// GL_ARB_texture_compression_bptc

// GL_ARB_blend_func_extended
version (GL_ARB_blend_func_extended) {
    mixin WrapGlFunction!("glBindFragDataLocationIndexed", void, GLuint, GLuint, GLuint, const(GLchar)*);
    mixin WrapGlFunction!("glGetFragDataIndex", GLint, GLuint, const(GLchar)*);
}

// GL_ARB_explicit_attrib_location

// GL_ARB_occlusion_query2

// GL_ARB_sampler_objects
version (GL_ARB_sampler_objects) {
    mixin WrapGlFunction!("glGenSamplers", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glDeleteSamplers", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glIsSampler", GLboolean, GLuint);
    mixin WrapGlFunction!("glBindSampler", void, GLuint, GLuint);
    mixin WrapGlFunction!("glSamplerParameteri", void, GLuint, GLenum, GLint);
    mixin WrapGlFunction!("glSamplerParameteriv", void, GLuint, GLenum, const(GLint)*);
    mixin WrapGlFunction!("glSamplerParameterf", void, GLuint, GLenum, GLfloat);
    mixin WrapGlFunction!("glSamplerParameterfv", void, GLuint, GLenum, const(GLfloat)*);
    mixin WrapGlFunction!("glSamplerParameterIiv", void, GLuint, GLenum, const(GLint)*);
    mixin WrapGlFunction!("glSamplerParameterIuiv", void, GLuint, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glGetSamplerParameteriv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetSamplerParameterIiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetSamplerParameterfv", void, GLuint, GLenum, GLfloat*);
    mixin WrapGlFunction!("glGetSamplerParameterIuiv", void, GLuint, GLenum, GLuint*);
}

// GL_ARB_shader_bit_encoding

// GL_ARB_texture_rgb10_a2ui

// GL_ARB_texture_swizzle

// GL_ARB_timer_query
version (GL_ARB_timer_query) {
    mixin WrapGlFunction!("glQueryCounter", void, GLuint, GLenum);
    mixin WrapGlFunction!("glGetQueryObjecti64v", void, GLuint, GLenum, GLint64*);
    mixin WrapGlFunction!("glGetQueryObjectui64v", void, GLuint, GLenum, GLuint64*);
}

// GL_ARB_vertex_type_2_10_10_10_rev
version (GL_ARB_vertex_type_2_10_10_10_rev) {
    mixin WrapGlFunction!("glVertexP2ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexP2uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glVertexP3ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexP3uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glVertexP4ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexP4uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glTexCoordP1ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glTexCoordP1uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glTexCoordP2ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glTexCoordP2uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glTexCoordP3ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glTexCoordP3uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glTexCoordP4ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glTexCoordP4uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glMultiTexCoordP1ui", void, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glMultiTexCoordP1uiv", void, GLenum, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glMultiTexCoordP2ui", void, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glMultiTexCoordP2uiv", void, GLenum, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glMultiTexCoordP3ui", void, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glMultiTexCoordP3uiv", void, GLenum, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glMultiTexCoordP4ui", void, GLenum, GLenum, GLuint);
    mixin WrapGlFunction!("glMultiTexCoordP4uiv", void, GLenum, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glNormalP3ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glNormalP3uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glColorP3ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glColorP3uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glColorP4ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glColorP4uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glSecondaryColorP3ui", void, GLenum, GLuint);
    mixin WrapGlFunction!("glSecondaryColorP3uiv", void, GLenum, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribP1ui", void, GLuint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexAttribP1uiv", void, GLuint, GLenum, GLboolean, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribP2ui", void, GLuint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexAttribP2uiv", void, GLuint, GLenum, GLboolean, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribP3ui", void, GLuint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexAttribP3uiv", void, GLuint, GLenum, GLboolean, const(GLuint)*);
    mixin WrapGlFunction!("glVertexAttribP4ui", void, GLuint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexAttribP4uiv", void, GLuint, GLenum, GLboolean, const(GLuint)*);
}

// GL_ARB_draw_indirect
version (GL_ARB_draw_indirect) {
    mixin WrapGlFunction!("glDrawArraysIndirect", void, GLenum, const(GLvoid)*);
    mixin WrapGlFunction!("glDrawElementsIndirect", void, GLenum, GLenum, const(GLvoid)*);
}

// GL_ARB_gpu_shader5

// GL_ARB_gpu_shader_fp64
version (GL_ARB_gpu_shader_fp64) {
	mixin WrapGlFunction!("glUniform1d", void, GLint, GLdouble);
    mixin WrapGlFunction!("glUniform2d", void, GLint, GLdouble, GLdouble);
    mixin WrapGlFunction!("glUniform3d", void, GLint, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glUniform4d", void, GLint, GLdouble, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glUniform1dv", void, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glUniform2dv", void, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glUniform3dv", void, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glUniform4dv", void, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix2dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix3dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix4dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix2x3dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix2x4dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix3x2dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix3x4dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix4x2dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glUniformMatrix4x3dv", void, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glGetUniformdv", void, GLuint, GLint, GLdouble*);
}

// GL_ARB_shader_subroutine
version (GL_ARB_shader_subroutine) {
    mixin WrapGlFunction!("glGetSubroutineUniformLocation", GLint, GLuint, GLenum, const(GLchar)*);
    mixin WrapGlFunction!("glGetSubroutineIndex", GLuint, GLuint, GLenum, const(GLchar)*);
    mixin WrapGlFunction!("glGetActiveSubroutineUniformiv", void, GLuint, GLenum, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glGetActiveSubroutineUniformName", void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetActiveSubroutineName", void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glUniformSubroutinesuiv", void, GLenum, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGetUniformSubroutineuiv", void, GLenum, GLint, GLuint*);
    mixin WrapGlFunction!("glGetProgramStageiv", void, GLuint, GLenum, GLenum, GLint*);
}

// GL_ARB_tessellation_shader
version (GL_ARB_tessellation_shader) {
    mixin WrapGlFunction!("glPatchParameteri", void, GLenum, GLint);
    mixin WrapGlFunction!("glPatchParameterfv", void, GLenum, const(GLfloat)*);
}

// GL_ARB_texture_buffer_object_rgb32

// GL_ARB_transform_feedback2
version (GL_ARB_transform_feedback2) {
    mixin WrapGlFunction!("glBindTransformFeedback", void, GLenum, GLuint);
    mixin WrapGlFunction!("glDeleteTransformFeedbacks", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenTransformFeedbacks", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glIsTransformFeedback", GLboolean, GLuint);
    mixin WrapGlFunction!("glPauseTransformFeedback", void);
    mixin WrapGlFunction!("glResumeTransformFeedback", void);
    mixin WrapGlFunction!("glDrawTransformFeedback", void, GLenum, GLuint);
}

// GL_ARB_transform_feedback3
version (GL_ARB_transform_feedback3) {
    mixin WrapGlFunction!("glDrawTransformFeedbackStream", void, GLenum, GLuint, GLuint);
    mixin WrapGlFunction!("glBeginQueryIndexed", void, GLenum, GLuint, GLuint);
    mixin WrapGlFunction!("glEndQueryIndexed", void, GLenum, GLuint);
    mixin WrapGlFunction!("glGetQueryIndexediv", void, GLenum, GLuint, GLenum, GLint*);
}

// GL_ARB_ES2_compatibility
version (GL_ARB_ES2_compatibility) {
    mixin WrapGlFunction!("glReleaseShaderCompiler", void);
    mixin WrapGlFunction!("glShaderBinary", void, GLsizei, const(GLuint)*, GLenum, const(GLvoid)*, GLsizei);
    mixin WrapGlFunction!("glGetShaderPrecisionFormat", void, GLenum, GLenum, GLint*, GLint*);
    mixin WrapGlFunction!("glDepthRangef", void, GLfloat, GLfloat);
    mixin WrapGlFunction!("glClearDepthf", void, GLfloat);
}

// GL_ARB_get_program_binary
version (GL_ARB_get_program_binary) {
    mixin WrapGlFunction!("glGetProgramBinary", void, GLuint, GLsizei, GLsizei*, GLenum*, GLvoid*);
    mixin WrapGlFunction!("glProgramBinary", void, GLuint, GLenum, const(GLvoid)*, GLsizei);
    mixin WrapGlFunction!("glProgramParameteri", void, GLuint, GLenum, GLint);
}

// GL_ARB_separate_shader_objects
version (GL_ARB_separate_shader_objects) {
    mixin WrapGlFunction!("glUseProgramStages", void, GLuint, GLbitfield, GLuint);
    mixin WrapGlFunction!("glActiveShaderProgram", void, GLuint, GLuint);
    mixin WrapGlFunction!("glCreateShaderProgramv", GLuint, GLenum, GLsizei, const(GLchar)**);
    mixin WrapGlFunction!("glBindProgramPipeline", void, GLuint);
    mixin WrapGlFunction!("glDeleteProgramPipelines", void, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glGenProgramPipelines", void, GLsizei, GLuint*);
    mixin WrapGlFunction!("glIsProgramPipeline", GLboolean, GLuint);
    mixin WrapGlFunction!("glGetProgramPipelineiv", void, GLuint, GLenum, GLint*);
    mixin WrapGlFunction!("glProgramUniform1i", void, GLuint, GLint, GLint);
    mixin WrapGlFunction!("glProgramUniform1iv", void, GLuint, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glProgramUniform1f", void, GLuint, GLint, GLfloat);
    mixin WrapGlFunction!("glProgramUniform1fv", void, GLuint, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniform1d", void, GLuint, GLint, GLdouble);
    mixin WrapGlFunction!("glProgramUniform1dv", void, GLuint, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniform1ui", void, GLuint, GLint, GLuint);
    mixin WrapGlFunction!("glProgramUniform1uiv", void, GLuint, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glProgramUniform2i", void, GLuint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glProgramUniform2iv", void, GLuint, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glProgramUniform2f", void, GLuint, GLint, GLfloat, GLfloat);
    mixin WrapGlFunction!("glProgramUniform2fv", void, GLuint, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniform2d", void, GLuint, GLint, GLdouble, GLdouble);
    mixin WrapGlFunction!("glProgramUniform2dv", void, GLuint, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniform2ui", void, GLuint, GLint, GLuint, GLuint);
    mixin WrapGlFunction!("glProgramUniform2uiv", void, GLuint, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glProgramUniform3i", void, GLuint, GLint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glProgramUniform3iv", void, GLuint, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glProgramUniform3f", void, GLuint, GLint, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glProgramUniform3fv", void, GLuint, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniform3d", void, GLuint, GLint, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glProgramUniform3dv", void, GLuint, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniform3ui", void, GLuint, GLint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glProgramUniform3uiv", void, GLuint, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glProgramUniform4i", void, GLuint, GLint, GLint, GLint, GLint, GLint);
    mixin WrapGlFunction!("glProgramUniform4iv", void, GLuint, GLint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glProgramUniform4f", void, GLuint, GLint, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glProgramUniform4fv", void, GLuint, GLint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniform4d", void, GLuint, GLint, GLdouble, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glProgramUniform4dv", void, GLuint, GLint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniform4ui", void, GLuint, GLint, GLuint, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glProgramUniform4uiv", void, GLuint, GLint, GLsizei, const(GLuint)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2x3fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3x2fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2x4fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4x2fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3x4fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4x3fv", void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2x3dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3x2dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix2x4dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4x2dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix3x4dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glProgramUniformMatrix4x3dv", void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*);
    mixin WrapGlFunction!("glValidateProgramPipeline", void, GLuint);
    mixin WrapGlFunction!("glGetProgramPipelineInfoLog", void, GLuint, GLsizei, GLsizei*, GLchar*);
}

// GL_ARB_vertex_attrib_64bit
version (GL_ARB_vertex_attrib_64bit) {
    mixin WrapGlFunction!("glVertexAttribL1d", void, GLuint, GLdouble);
    mixin WrapGlFunction!("glVertexAttribL2d", void, GLuint, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttribL3d", void, GLuint, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttribL4d", void, GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
    mixin WrapGlFunction!("glVertexAttribL1dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttribL2dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttribL3dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttribL4dv", void, GLuint, const(GLdouble)*);
    mixin WrapGlFunction!("glVertexAttribLPointer", void, GLuint, GLint, GLenum, GLsizei, const(GLvoid)*);
    mixin WrapGlFunction!("glGetVertexAttribLdv", void, GLuint, GLenum, GLdouble*);
}

// GL_ARB_viewport_array
version (GL_ARB_viewport_array) {
    mixin WrapGlFunction!("glViewportArrayv", void, GLuint, GLsizei, const(GLfloat)*);
    mixin WrapGlFunction!("glViewportIndexedf", void, GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
    mixin WrapGlFunction!("glViewportIndexedfv", void, GLuint, const(GLfloat)*);
    mixin WrapGlFunction!("glScissorArrayv", void, GLuint, GLsizei, const(GLint)*);
    mixin WrapGlFunction!("glScissorIndexed", void, GLuint, GLint, GLint, GLsizei, GLsizei);
    mixin WrapGlFunction!("glScissorIndexedv", void, GLuint, const(GLint)*);
    mixin WrapGlFunction!("glDepthRangeArrayv", void, GLuint, GLsizei, const(GLdouble)*);
    mixin WrapGlFunction!("glDepthRangeIndexed", void, GLuint, GLdouble, GLdouble);
    mixin WrapGlFunction!("glGetFloati_v", void, GLenum, GLuint, GLfloat*);
    mixin WrapGlFunction!("glGetDoublei_v", void, GLenum, GLuint, GLdouble*);
}

// GL_ARB_cl_event
version (GL_ARB_cl_event) {
    mixin WrapGlFunction!("glCreateSyncFromCLeventARB", GLsync, _cl_context*, _cl_event*, GLbitfield);
}

// GL_ARB_debug_output
version (GL_ARB_debug_output) {
    mixin WrapGlFunction!("glDebugMessageControlARB", void, GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean);
    mixin WrapGlFunction!("glDebugMessageInsertARB", void, GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*);
    mixin WrapGlFunction!("glDebugMessageCallbackARB", void, GLDEBUGPROCARB, const(GLvoid)*);
    mixin WrapGlFunction!("glGetDebugMessageLogARB", GLuint, GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*);
}

// GL_ARB_robustness
version (GL_ARB_robustness) {
    mixin WrapGlFunction!("glGetGraphicsResetStatusARB", GLenum, );
    mixin WrapGlFunction!("glGetnTexImageARB", void, GLenum, GLint, GLenum, GLenum, GLsizei, GLvoid*);
    mixin WrapGlFunction!("glReadnPixelsARB", void, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLsizei, GLvoid*);
    mixin WrapGlFunction!("glGetnCompressedTexImageARB", void, GLenum, GLint, GLsizei, GLvoid*);
    mixin WrapGlFunction!("glGetnUniformfvARB", void, GLuint, GLint, GLsizei, GLfloat*);
    mixin WrapGlFunction!("glGetnUniformivARB", void, GLuint, GLint, GLsizei, GLint*);
    mixin WrapGlFunction!("glGetnUniformuivARB", void, GLuint, GLint, GLsizei, GLuint*);
    mixin WrapGlFunction!("glGetnUniformdvARB", void, GLuint, GLint, GLsizei, GLdouble*);
}

// GL_ARB_shader_stencil_export

// GL_ARB_base_instance
version (GL_ARB_base_instance) {
    mixin WrapGlFunction!("glDrawArraysInstancedBaseInstance", void, GLenum, GLint, GLsizei, GLsizei, GLuint);
    mixin WrapGlFunction!("glDrawElementsInstancedBaseInstance", void, GLenum, GLsizei, GLenum, const(void)*, GLsizei, GLuint);
    mixin WrapGlFunction!("glDrawElementsInstancedBaseVertexBaseInstance", void, GLenum, GLsizei, GLenum, const(void)*, GLsizei, GLint, GLuint);
}

// GL_ARB_shading_language_420pack

// GL_ARB_transform_feedback_instanced
version (GL_ARB_transform_feedback_instanced) {
    mixin WrapGlFunction!("glDrawTransformFeedbackInstanced", void, GLenum, GLuint, GLsizei);
    mixin WrapGlFunction!("glDrawTransformFeedbackStreamInstanced", void, GLenum, GLuint, GLuint, GLsizei);
}

// GL_ARB_compressed_texture_pixel_storage

// GL_ARB_conservative_depth

// GL_ARB_internalformat_query
version (GL_ARB_internalformat_query) {
    mixin WrapGlFunction!("glGetInternalformativ", void, GLenum, GLenum, GLenum, GLsizei, GLint*);
}

// GL_ARB_map_buffer_alignment

// GL_ARB_shader_atomic_counters
version (GL_ARB_shader_atomic_counters) {
    mixin WrapGlFunction!("glGetActiveAtomicCounterBufferiv", void, GLuint, GLuint, GLenum, GLint*);
}

// GL_ARB_shader_image_load_store
version (GL_ARB_shader_image_load_store) {
    mixin WrapGlFunction!("glBindImageTexture", void, GLuint, GLuint, GLint, GLboolean, GLint, GLenum, GLenum);
    mixin WrapGlFunction!("glMemoryBarrier", void, GLbitfield);
}

// GL_ARB_shading_language_packing

// GL_ARB_texture_storage
version (GL_ARB_texture_storage) {
    mixin WrapGlFunction!("glTexStorage1D", void, GLenum, GLsizei, GLenum, GLsizei);
    mixin WrapGlFunction!("glTexStorage2D", void, GLenum, GLsizei, GLenum, GLsizei, GLsizei);
    mixin WrapGlFunction!("glTexStorage3D", void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei);
    mixin WrapGlFunction!("glTextureStorage1DEXT", void, GLuint, GLenum, GLsizei, GLenum, GLsizei);
    mixin WrapGlFunction!("glTextureStorage2DEXT", void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei);
    mixin WrapGlFunction!("glTextureStorage3DEXT", void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei);
}

// GL_KHR_texture_compression_astc_ldr

// GL_KHR_debug
version (GL_KHR_debug) {
    mixin WrapGlFunction!("glDebugMessageControl", void, GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean);
    mixin WrapGlFunction!("glDebugMessageInsert", void, GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*);
    mixin WrapGlFunction!("glDebugMessageCallback", void, GLDEBUGPROC, const(void)*);
    mixin WrapGlFunction!("glGetDebugMessageLog", GLuint, GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glPushDebugGroup", void, GLenum, GLuint, GLsizei, const(GLchar)*);
    mixin WrapGlFunction!("glPopDebugGroup", void);
    mixin WrapGlFunction!("glObjectLabel", void, GLenum, GLuint, GLsizei, const(GLchar)*);
    mixin WrapGlFunction!("glGetObjectLabel", void, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glObjectPtrLabel", void, const(void)*, GLsizei, const(GLchar)*);
    mixin WrapGlFunction!("glGetObjectPtrLabel", void, const(void)*, GLsizei, GLsizei*, GLchar*);
}

// GL_ARB_arrays_of_arrays

// GL_ARB_clear_buffer_object
version (GL_ARB_clear_buffer_object) {	
	mixin WrapGlFunction!("glClearBufferData", void, GLenum, GLenum, GLenum, GLenum, const(void)*);
    mixin WrapGlFunction!("glClearBufferSubData", void, GLenum, GLenum, GLintptr, GLsizeiptr, GLenum, GLenum, const(void)*);
    mixin WrapGlFunction!("glClearNamedBufferDataEXT", void, GLuint, GLenum, GLenum, GLenum, const(void)*);
    mixin WrapGlFunction!("glClearNamedBufferSubDataEXT", void, GLuint, GLenum, GLenum, GLenum, GLsizeiptr, GLsizeiptr, const(void)*);
}

// GL_ARB_compute_shader
version (GL_ARB_compute_shader) {
    mixin WrapGlFunction!("glDispatchCompute", void, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glDispatchComputeIndirect", void, GLintptr);
}

// GL_ARB_copy_image
version (GL_ARB_copy_image) {
    mixin WrapGlFunction!("glCopyImageSubData", void, GLuint, GLenum, GLint, GLint, GLint, GLint, GLuint, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei);
}

// GL_ARB_texture_view
version (GL_ARB_texture_view) {
    mixin WrapGlFunction!("glTextureView", void, GLuint, GLenum, GLuint, GLenum, GLuint, GLuint, GLuint, GLuint);
}

// GL_ARB_vertex_attrib_binding
version (GL_ARB_vertex_attrib_binding) {
    mixin WrapGlFunction!("glBindVertexBuffer", void, GLuint, GLuint, GLintptr, GLsizei);
    mixin WrapGlFunction!("glVertexAttribFormat", void, GLuint, GLint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexAttribIFormat", void, GLuint, GLint, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexAttribLFormat", void, GLuint, GLint, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexAttribBinding", void, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexBindingDivisor", void, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexArrayBindVertexBufferEXT", void, GLuint, GLuint, GLuint, GLintptr, GLsizei);
    mixin WrapGlFunction!("glVertexArrayVertexAttribFormatEXT", void, GLuint, GLuint, GLint, GLenum, GLboolean, GLuint);
    mixin WrapGlFunction!("glVertexArrayVertexAttribIFormatEXT", void, GLuint, GLuint, GLint, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexArrayVertexAttribLFormatEXT", void, GLuint, GLuint, GLint, GLenum, GLuint);
    mixin WrapGlFunction!("glVertexArrayVertexAttribBindingEXT", void, GLuint, GLuint, GLuint);
    mixin WrapGlFunction!("glVertexArrayVertexBindingDivisorEXT", void, GLuint, GLuint, GLuint);
}

// GL_ARB_robustness_isolation

// GL_ARB_ES3_compatibility

// GL_ARB_explicit_uniform_location

// GL_ARB_fragment_layer_viewport

// GL_ARB_framebuffer_no_attachments
version (GL_ARB_framebuffer_no_attachments) {
    mixin WrapGlFunction!("glFramebufferParameteri", void, GLenum, GLenum, GLint);
    mixin WrapGlFunction!("glGetFramebufferParameteriv", void, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glNamedFramebufferParameteriEXT", void, GLuint, GLenum, GLint);
    mixin WrapGlFunction!("glGetNamedFramebufferParameterivEXT", void, GLuint, GLenum, GLint*);
}

// GL_ARB_internalformat_query2
version (GL_ARB_internalformat_query2) {
    mixin WrapGlFunction!("glGetInternalformati64v", void, GLenum, GLenum, GLenum, GLsizei, GLint64*);
}

// GL_ARB_invalidate_subdata
version (GL_ARB_invalidate_subdata) {
    mixin WrapGlFunction!("glInvalidateTexSubImage", void, GLuint, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei);
    mixin WrapGlFunction!("glInvalidateTexImage", void, GLuint, GLint);
    mixin WrapGlFunction!("glInvalidateBufferSubData", void, GLuint, GLintptr, GLsizeiptr);
    mixin WrapGlFunction!("glInvalidateBufferData", void, GLuint);
    mixin WrapGlFunction!("glInvalidateFramebuffer", void, GLenum, GLsizei, const(GLenum)*);
    mixin WrapGlFunction!("glInvalidateSubFramebuffer", void, GLenum, GLsizei, const(GLenum)*, GLint, GLint, GLsizei, GLsizei);
}

// GL_ARB_multi_draw_indirect
version (GL_ARB_multi_draw_indirect) {
    mixin WrapGlFunction!("glMultiDrawArraysIndirect", void, GLenum, const(void)*, GLsizei, GLsizei);
    mixin WrapGlFunction!("glMultiDrawElementsIndirect", void, GLenum, GLenum, const(void)*, GLsizei, GLsizei);
}

// GL_ARB_program_interface_query
version (GL_ARB_program_interface_query) {
    mixin WrapGlFunction!("glGetProgramInterfaceiv", void, GLuint, GLenum, GLenum, GLint*);
    mixin WrapGlFunction!("glGetProgramResourceIndex", GLuint, GLuint, GLenum, const(GLchar)*);
    mixin WrapGlFunction!("glGetProgramResourceName", void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*);
    mixin WrapGlFunction!("glGetProgramResourceiv", void, GLuint, GLenum, GLuint, GLsizei, const(GLenum)*, GLsizei, GLsizei*, GLint*);
    mixin WrapGlFunction!("glGetProgramResourceLocation", GLint, GLuint, GLenum, const(GLchar)*);
    mixin WrapGlFunction!("glGetProgramResourceLocationIndex", GLint, GLuint, GLenum, const(GLchar)*);
}

// GL_ARB_robust_buffer_access_behavior

// GL_ARB_shader_image_size

// GL_ARB_shader_storage_buffer_object
version (GL_ARB_shader_storage_buffer_object) {
    mixin WrapGlFunction!("glShaderStorageBlockBinding", void, GLuint, GLuint, GLuint);
}

// GL_ARB_stencil_texturing

// GL_ARB_texture_buffer_range
version (GL_ARB_texture_buffer_range) {
    mixin WrapGlFunction!("glTexBufferRange", void, GLenum, GLenum, GLuint, GLintptr, GLsizeiptr);
    mixin WrapGlFunction!("glTextureBufferRangeEXT", void, GLuint, GLenum, GLenum, GLuint, GLintptr, GLsizeiptr);
}

// GL_ARB_texture_query_levels

// GL_ARB_texture_storage_multisample
version (GL_ARB_texture_storage_multisample) {
    mixin WrapGlFunction!("glTexStorage2DMultisample", void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLboolean);
    mixin WrapGlFunction!("glTexStorage3DMultisample", void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei, GLboolean);
    mixin WrapGlFunction!("glTextureStorage2DMultisampleEXT", void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLboolean);
    mixin WrapGlFunction!("glTextureStorage3DMultisampleEXT", void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei, GLboolean);
}

