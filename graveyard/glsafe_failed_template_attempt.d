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

/// Typedef to make wrapGl() (below) work.
alias glFunction_t(R, Args...) = extern(C) R function(Args);
alias glFunction_t(R) = extern(C) R function();

/**
 * OpenGL function call wrapper which checks glGetError() automatically. A
 * function is returned with a signature matching the given function. If the
 * call results in an error, an exception is thrown.
 *
 * Example:
 *     // Instead of this:
 *     GLint ret = glDoThing(arg1, arg2);
 *     handle_errors();
 *
 *     // Do this once:
 *     auto glDoThing_s = wrapGl!(GLint, arg1type, arg2type)(&glDoThing)
 *
 *     // Then do:
 *     goDoThing_s(arg1, arg2);
 *
 * @param         glFunction   The OpenGL function to wrap and return
 * @templateparam R            Return type of glFunction (deduced)
 * @templateparam Args...      Argument types to glFunction (deduced)
 * @return                     A function matching the signature of glFunction
 *                             which queries glGetError() before returning
 */
R delegate(Args) wrapGl(R, Args...)(glFunction_t!(R, Args) glFunction) {
    return (Args args) {

        static if (is(R == void)) {
            glFunction(args);

            Exception e = checkGLErrors();
            if (e !is null) {
                throw e;
            }
        } else {
            R ret = glFunction(args);

            Exception e = checkGLErrors();
            if (e !is null) {
                throw e;
            } else {
                return ret;
            }
        }
    };
}

/** ditto */
R delegate() wrapGl(R)(glFunction_t!(R) glFunction) {
    return () {

        static if (is(R == void)) {
            glFunction();

            Exception e = checkGLErrors();
            if (e !is null) {
                throw e;
            }
        } else {
            R ret = glFunction();

            Exception e = checkGLErrors();
            if (e !is null) {
                throw e;
            } else {
                return ret;
            }
        }
    };
}

// Pre-wrapped functions
// Generated from glcorearb.d, mostly from the following regular expressions:
// - For all non-comment lines, remove the parameter names from functions
//     :g/[^/]/ s/\([a-z*]\) [a-zA-Z_]*\([,)]\)/\1\2/
// - Turn each function declaration into a call to wrapGl()
//     :%s/^\([^/]*\) \([^(]*\)(\(.*\));$/auto \2_s = wrapGl!(\1, \3)(\&\2);

/* *********************************************************** */

// GL_VERSION_1_0

auto glCullFace_s = wrapGl!(void, GLenum)(&glCullFace);
auto glFrontFace_s = wrapGl!(void, GLenum)(&glFrontFace);
auto glHint_s = wrapGl!(void, GLenum, GLenum)(&glHint);
auto glLineWidth_s = wrapGl!(void, GLfloat)(&glLineWidth);
auto glPointSize_s = wrapGl!(void, GLfloat)(&glPointSize);
auto glPolygonMode_s = wrapGl!(void, GLenum, GLenum)(&glPolygonMode);
auto glScissor_s = wrapGl!(void, GLint, GLint, GLsizei, GLsizei)(&glScissor);
auto glTexParameterf_s = wrapGl!(void, GLenum, GLenum, GLfloat)(&glTexParameterf);
auto glTexParameterfv_s = wrapGl!(void, GLenum, GLenum, const(GLfloat)*)(&glTexParameterfv);
auto glTexParameteri_s = wrapGl!(void, GLenum, GLenum, GLint)(&glTexParameteri);
auto glTexParameteriv_s = wrapGl!(void, GLenum, GLenum, const(GLint)*)(&glTexParameteriv);
auto glTexImage1D_s = wrapGl!(void, GLenum, GLint, GLint, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*)(&glTexImage1D);
auto glTexImage2D_s = wrapGl!(void, GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*)(&glTexImage2D);
auto glDrawBuffer_s = wrapGl!(void, GLenum)(&glDrawBuffer);
auto glClear_s = wrapGl!(void, GLbitfield)(&glClear);
auto glClearColor_s = wrapGl!(void, GLfloat, GLfloat, GLfloat, GLfloat)(&glClearColor);
auto glClearStencil_s = wrapGl!(void, GLint)(&glClearStencil);
auto glClearDepth_s = wrapGl!(void, GLdouble)(&glClearDepth);
auto glStencilMask_s = wrapGl!(void, GLuint)(&glStencilMask);
auto glColorMask_s = wrapGl!(void, GLboolean, GLboolean, GLboolean, GLboolean)(&glColorMask);
auto glDepthMask_s = wrapGl!(void, GLboolean)(&glDepthMask);
auto glDisable_s = wrapGl!(void, GLenum)(&glDisable);
auto glEnable_s = wrapGl!(void, GLenum)(&glEnable);
auto glFinish_s = wrapGl!(void)(&glFinish);
auto glFlush_s = wrapGl!(void)(&glFlush);
auto glBlendFunc_s = wrapGl!(void, GLenum, GLenum)(&glBlendFunc);
auto glLogicOp_s = wrapGl!(void, GLenum)(&glLogicOp);
auto glStencilFunc_s = wrapGl!(void, GLenum, GLint, GLuint)(&glStencilFunc);
auto glStencilOp_s = wrapGl!(void, GLenum, GLenum, GLenum)(&glStencilOp);
auto glDepthFunc_s = wrapGl!(void, GLenum)(&glDepthFunc);
auto glPixelStoref_s = wrapGl!(void, GLenum, GLfloat)(&glPixelStoref);
auto glPixelStorei_s = wrapGl!(void, GLenum, GLint)(&glPixelStorei);
auto glReadBuffer_s = wrapGl!(void, GLenum)(&glReadBuffer);
auto glReadPixels_s = wrapGl!(void, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLvoid*)(&glReadPixels);
auto glGetBooleanv_s = wrapGl!(void, GLenum, GLboolean*)(&glGetBooleanv);
auto glGetDoublev_s = wrapGl!(void, GLenum, GLdouble*)(&glGetDoublev);
//auto glGetError_s = wrapGl!(GLenum, )(&glGetError); // Useless and overflows the stack
auto glGetFloatv_s = wrapGl!(void, GLenum, GLfloat*)(&glGetFloatv);
auto glGetIntegerv_s = wrapGl!(void, GLenum, GLint*)(&glGetIntegerv);
auto glGetString_s = wrapGl!(const(GLubyte)*, GLenum)(&glGetString);
auto glGetTexImage_s = wrapGl!(void, GLenum, GLint, GLenum, GLenum, GLvoid*)(&glGetTexImage);
auto glGetTexParameterfv_s = wrapGl!(void, GLenum, GLenum, GLfloat*)(&glGetTexParameterfv);
auto glGetTexParameteriv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetTexParameteriv);
auto glGetTexLevelParameterfv_s = wrapGl!(void, GLenum, GLint, GLenum, GLfloat*)(&glGetTexLevelParameterfv);
auto glGetTexLevelParameteriv_s = wrapGl!(void, GLenum, GLint, GLenum, GLint*)(&glGetTexLevelParameteriv);
auto glIsEnabled_s = wrapGl!(GLboolean, GLenum)(&glIsEnabled);
auto glDepthRange_s = wrapGl!(void, GLdouble, GLdouble)(&glDepthRange);
auto glViewport_s = wrapGl!(void, GLint, GLint, GLsizei, GLsizei)(&glViewport);


// GL_VERSION_1_1

auto glDrawArrays_s = wrapGl!(void, GLenum, GLint, GLsizei)(&glDrawArrays);
auto glDrawElements_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(GLvoid)*)(&glDrawElements);
auto glGetPointerv_s = wrapGl!(void, GLenum, GLvoid**)(&glGetPointerv);
auto glPolygonOffset_s = wrapGl!(void, GLfloat, GLfloat)(&glPolygonOffset);
auto glCopyTexImage1D_s = wrapGl!(void, GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLint)(&glCopyTexImage1D);
auto glCopyTexImage2D_s = wrapGl!(void, GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLsizei, GLint)(&glCopyTexImage2D);
auto glCopyTexSubImage1D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLint, GLsizei)(&glCopyTexSubImage1D);
auto glCopyTexSubImage2D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei)(&glCopyTexSubImage2D);
auto glTexSubImage1D_s = wrapGl!(void, GLenum, GLint, GLint, GLsizei, GLenum, GLenum, const(GLvoid)*)(&glTexSubImage1D);
auto glTexSubImage2D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, const(GLvoid)*)(&glTexSubImage2D);
auto glBindTexture_s = wrapGl!(void, GLenum, GLuint)(&glBindTexture);
auto glDeleteTextures_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteTextures);
auto glGenTextures_s = wrapGl!(void, GLsizei, GLuint*)(&glGenTextures);
auto glIsTexture_s = wrapGl!(GLboolean, GLuint)(&glIsTexture);


// GL_VERSION_1_2

auto glBlendColor_s = wrapGl!(void, GLfloat, GLfloat, GLfloat, GLfloat)(&glBlendColor);
auto glBlendEquation_s = wrapGl!(void, GLenum)(&glBlendEquation);
auto glDrawRangeElements_s = wrapGl!(void, GLenum, GLuint, GLuint, GLsizei, GLenum, const(GLvoid)*)(&glDrawRangeElements);
auto glTexImage3D_s = wrapGl!(void, GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, const(GLvoid)*)(&glTexImage3D);
auto glTexSubImage3D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, const(GLvoid)*)(&glTexSubImage3D);
auto glCopyTexSubImage3D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei)(&glCopyTexSubImage3D);


// GL_VERSION_1_3

auto glActiveTexture_s = wrapGl!(void, GLenum)(&glActiveTexture);
auto glSampleCoverage_s = wrapGl!(void, GLfloat, GLboolean)(&glSampleCoverage);
auto glCompressedTexImage3D_s = wrapGl!(void, GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei, GLint, GLsizei, const(GLvoid)*)(&glCompressedTexImage3D);
auto glCompressedTexImage2D_s = wrapGl!(void, GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, const(GLvoid)*)(&glCompressedTexImage2D);
auto glCompressedTexImage1D_s = wrapGl!(void, GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, const(GLvoid)*)(&glCompressedTexImage1D);
auto glCompressedTexSubImage3D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, const(GLvoid)*)(&glCompressedTexSubImage3D);
auto glCompressedTexSubImage2D_s = wrapGl!(void, GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, const(GLvoid)*)(&glCompressedTexSubImage2D);
auto glCompressedTexSubImage1D_s = wrapGl!(void, GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, const(GLvoid)*)(&glCompressedTexSubImage1D);
auto glGetCompressedTexImage_s = wrapGl!(void, GLenum, GLint, GLvoid*)(&glGetCompressedTexImage);


// GL_VERSION_1_4

auto glBlendFuncSeparate_s = wrapGl!(void, GLenum, GLenum, GLenum, GLenum)(&glBlendFuncSeparate);
auto glMultiDrawArrays_s = wrapGl!(void, GLenum, const(GLint)*, const(GLsizei)*, GLsizei)(&glMultiDrawArrays);
auto glMultiDrawElements_s = wrapGl!(void, GLenum, const(GLsizei)*, GLenum, const(GLvoid)**, GLsizei)(&glMultiDrawElements);
auto glPointParameterf_s = wrapGl!(void, GLenum, GLfloat)(&glPointParameterf);
auto glPointParameterfv_s = wrapGl!(void, GLenum, const(GLfloat)*)(&glPointParameterfv);
auto glPointParameteri_s = wrapGl!(void, GLenum, GLint)(&glPointParameteri);
auto glPointParameteriv_s = wrapGl!(void, GLenum, const(GLint)*)(&glPointParameteriv);


// GL_VERSION_1_5

auto glGenQueries_s = wrapGl!(void, GLsizei, GLuint*)(&glGenQueries);
auto glDeleteQueries_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteQueries);
auto glIsQuery_s = wrapGl!(GLboolean, GLuint)(&glIsQuery);
auto glBeginQuery_s = wrapGl!(void, GLenum, GLuint)(&glBeginQuery);
auto glEndQuery_s = wrapGl!(void, GLenum)(&glEndQuery);
auto glGetQueryiv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetQueryiv);
auto glGetQueryObjectiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetQueryObjectiv);
auto glGetQueryObjectuiv_s = wrapGl!(void, GLuint, GLenum, GLuint*)(&glGetQueryObjectuiv);
auto glBindBuffer_s = wrapGl!(void, GLenum, GLuint)(&glBindBuffer);
auto glDeleteBuffers_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteBuffers);
auto glGenBuffers_s = wrapGl!(void, GLsizei, GLuint*)(&glGenBuffers);
auto glIsBuffer_s = wrapGl!(GLboolean, GLuint)(&glIsBuffer);
auto glBufferData_s = wrapGl!(void, GLenum, GLsizeiptr, const(GLvoid)*, GLenum)(&glBufferData);
auto glBufferSubData_s = wrapGl!(void, GLenum, GLintptr, GLsizeiptr, const(GLvoid)*)(&glBufferSubData);
auto glGetBufferSubData_s = wrapGl!(void, GLenum, GLintptr, GLsizeiptr, GLvoid*)(&glGetBufferSubData);
auto glMapBuffer_s = wrapGl!(GLvoid*, GLenum, GLenum)(&glMapBuffer);
auto glUnmapBuffer_s = wrapGl!(GLboolean, GLenum)(&glUnmapBuffer);
auto glGetBufferParameteriv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetBufferParameteriv);
auto glGetBufferPointerv_s = wrapGl!(void, GLenum, GLenum, GLvoid**)(&glGetBufferPointerv);


// GL_VERSION_2_0

auto glBlendEquationSeparate_s = wrapGl!(void, GLenum, GLenum)(&glBlendEquationSeparate);
auto glDrawBuffers_s = wrapGl!(void, GLsizei, const(GLenum)*)(&glDrawBuffers);
auto glStencilOpSeparate_s = wrapGl!(void, GLenum, GLenum, GLenum, GLenum)(&glStencilOpSeparate);
auto glStencilFuncSeparate_s = wrapGl!(void, GLenum, GLenum, GLint, GLuint)(&glStencilFuncSeparate);
auto glStencilMaskSeparate_s = wrapGl!(void, GLenum, GLuint)(&glStencilMaskSeparate);
auto glAttachShader_s = wrapGl!(void, GLuint, GLuint)(&glAttachShader);
auto glBindAttribLocation_s = wrapGl!(void, GLuint, GLuint, const(GLchar)*)(&glBindAttribLocation);
auto glCompileShader_s = wrapGl!(void, GLuint)(&glCompileShader);
auto glCreateProgram_s = wrapGl!(GLuint, )(&glCreateProgram);
auto glCreateShader_s = wrapGl!(GLuint, GLenum)(&glCreateShader);
auto glDeleteProgram_s = wrapGl!(void, GLuint)(&glDeleteProgram);
auto glDeleteShader_s = wrapGl!(void, GLuint)(&glDeleteShader);
auto glDetachShader_s = wrapGl!(void, GLuint, GLuint)(&glDetachShader);
auto glDisableVertexAttribArray_s = wrapGl!(void, GLuint)(&glDisableVertexAttribArray);
auto glEnableVertexAttribArray_s = wrapGl!(void, GLuint)(&glEnableVertexAttribArray);
auto glGetActiveAttrib_s = wrapGl!(void, GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*)(&glGetActiveAttrib);
auto glGetActiveUniform_s = wrapGl!(void, GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*)(&glGetActiveUniform);
auto glGetAttachedShaders_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLuint*)(&glGetAttachedShaders);
auto glGetAttribLocation_s = wrapGl!(GLint, GLuint, const(GLchar)*)(&glGetAttribLocation);
auto glGetProgramiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetProgramiv);
auto glGetProgramInfoLog_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetProgramInfoLog);
auto glGetShaderiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetShaderiv);
auto glGetShaderInfoLog_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetShaderInfoLog);
auto glGetShaderSource_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetShaderSource);
auto glGetUniformLocation_s = wrapGl!(GLint, GLuint, const(GLchar)*)(&glGetUniformLocation);
auto glGetUniformfv_s = wrapGl!(void, GLuint, GLint, GLfloat*)(&glGetUniformfv);
auto glGetUniformiv_s = wrapGl!(void, GLuint, GLint, GLint*)(&glGetUniformiv);
auto glGetVertexAttribdv_s = wrapGl!(void, GLuint, GLenum, GLdouble*)(&glGetVertexAttribdv);
auto glGetVertexAttribfv_s = wrapGl!(void, GLuint, GLenum, GLfloat*)(&glGetVertexAttribfv);
auto glGetVertexAttribiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetVertexAttribiv);
auto glGetVertexAttribPointerv_s = wrapGl!(void, GLuint, GLenum, GLvoid**)(&glGetVertexAttribPointerv);
auto glIsProgram_s = wrapGl!(GLboolean, GLuint)(&glIsProgram);
auto glIsShader_s = wrapGl!(GLboolean, GLuint)(&glIsShader);
auto glLinkProgram_s = wrapGl!(void, GLuint)(&glLinkProgram);
auto glShaderSource_s = wrapGl!(void, GLuint, GLsizei, const(GLchar)**, const(GLint)*)(&glShaderSource);
auto glUseProgram_s = wrapGl!(void, GLuint)(&glUseProgram);
auto glUniform1f_s = wrapGl!(void, GLint, GLfloat)(&glUniform1f);
auto glUniform2f_s = wrapGl!(void, GLint, GLfloat, GLfloat)(&glUniform2f);
auto glUniform3f_s = wrapGl!(void, GLint, GLfloat, GLfloat, GLfloat)(&glUniform3f);
auto glUniform4f_s = wrapGl!(void, GLint, GLfloat, GLfloat, GLfloat, GLfloat)(&glUniform4f);
auto glUniform1i_s = wrapGl!(void, GLint, GLint)(&glUniform1i);
auto glUniform2i_s = wrapGl!(void, GLint, GLint, GLint)(&glUniform2i);
auto glUniform3i_s = wrapGl!(void, GLint, GLint, GLint, GLint)(&glUniform3i);
auto glUniform4i_s = wrapGl!(void, GLint, GLint, GLint, GLint, GLint)(&glUniform4i);
auto glUniform1fv_s = wrapGl!(void, GLint, GLsizei, const(GLfloat)*)(&glUniform1fv);
auto glUniform2fv_s = wrapGl!(void, GLint, GLsizei, const(GLfloat)*)(&glUniform2fv);
auto glUniform3fv_s = wrapGl!(void, GLint, GLsizei, const(GLfloat)*)(&glUniform3fv);
auto glUniform4fv_s = wrapGl!(void, GLint, GLsizei, const(GLfloat)*)(&glUniform4fv);
auto glUniform1iv_s = wrapGl!(void, GLint, GLsizei, const(GLint)*)(&glUniform1iv);
auto glUniform2iv_s = wrapGl!(void, GLint, GLsizei, const(GLint)*)(&glUniform2iv);
auto glUniform3iv_s = wrapGl!(void, GLint, GLsizei, const(GLint)*)(&glUniform3iv);
auto glUniform4iv_s = wrapGl!(void, GLint, GLsizei, const(GLint)*)(&glUniform4iv);
auto glUniformMatrix2fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix2fv);
auto glUniformMatrix3fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix3fv);
auto glUniformMatrix4fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix4fv);
auto glValidateProgram_s = wrapGl!(void, GLuint)(&glValidateProgram);
auto glVertexAttrib1d_s = wrapGl!(void, GLuint, GLdouble)(&glVertexAttrib1d);
auto glVertexAttrib1dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttrib1dv);
auto glVertexAttrib1f_s = wrapGl!(void, GLuint, GLfloat)(&glVertexAttrib1f);
auto glVertexAttrib1fv_s = wrapGl!(void, GLuint, const(GLfloat)*)(&glVertexAttrib1fv);
auto glVertexAttrib1s_s = wrapGl!(void, GLuint, GLshort)(&glVertexAttrib1s);
auto glVertexAttrib1sv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttrib1sv);
auto glVertexAttrib2d_s = wrapGl!(void, GLuint, GLdouble, GLdouble)(&glVertexAttrib2d);
auto glVertexAttrib2dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttrib2dv);
auto glVertexAttrib2f_s = wrapGl!(void, GLuint, GLfloat, GLfloat)(&glVertexAttrib2f);
auto glVertexAttrib2fv_s = wrapGl!(void, GLuint, const(GLfloat)*)(&glVertexAttrib2fv);
auto glVertexAttrib2s_s = wrapGl!(void, GLuint, GLshort, GLshort)(&glVertexAttrib2s);
auto glVertexAttrib2sv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttrib2sv);
auto glVertexAttrib3d_s = wrapGl!(void, GLuint, GLdouble, GLdouble, GLdouble)(&glVertexAttrib3d);
auto glVertexAttrib3dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttrib3dv);
auto glVertexAttrib3f_s = wrapGl!(void, GLuint, GLfloat, GLfloat, GLfloat)(&glVertexAttrib3f);
auto glVertexAttrib3fv_s = wrapGl!(void, GLuint, const(GLfloat)*)(&glVertexAttrib3fv);
auto glVertexAttrib3s_s = wrapGl!(void, GLuint, GLshort, GLshort, GLshort)(&glVertexAttrib3s);
auto glVertexAttrib3sv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttrib3sv);
auto glVertexAttrib4Nbv_s = wrapGl!(void, GLuint, const(GLbyte)*)(&glVertexAttrib4Nbv);
auto glVertexAttrib4Niv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttrib4Niv);
auto glVertexAttrib4Nsv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttrib4Nsv);
auto glVertexAttrib4Nub_s = wrapGl!(void, GLuint, GLubyte, GLubyte, GLubyte, GLubyte)(&glVertexAttrib4Nub);
auto glVertexAttrib4Nubv_s = wrapGl!(void, GLuint, const(GLubyte)*)(&glVertexAttrib4Nubv);
auto glVertexAttrib4Nuiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttrib4Nuiv);
auto glVertexAttrib4Nusv_s = wrapGl!(void, GLuint, const(GLushort)*)(&glVertexAttrib4Nusv);
auto glVertexAttrib4bv_s = wrapGl!(void, GLuint, const(GLbyte)*)(&glVertexAttrib4bv);
auto glVertexAttrib4d_s = wrapGl!(void, GLuint, GLdouble, GLdouble, GLdouble, GLdouble)(&glVertexAttrib4d);
auto glVertexAttrib4dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttrib4dv);
auto glVertexAttrib4f_s = wrapGl!(void, GLuint, GLfloat, GLfloat, GLfloat, GLfloat)(&glVertexAttrib4f);
auto glVertexAttrib4fv_s = wrapGl!(void, GLuint, const(GLfloat)*)(&glVertexAttrib4fv);
auto glVertexAttrib4iv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttrib4iv);
auto glVertexAttrib4s_s = wrapGl!(void, GLuint, GLshort, GLshort, GLshort, GLshort)(&glVertexAttrib4s);
auto glVertexAttrib4sv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttrib4sv);
auto glVertexAttrib4ubv_s = wrapGl!(void, GLuint, const(GLubyte)*)(&glVertexAttrib4ubv);
auto glVertexAttrib4uiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttrib4uiv);
auto glVertexAttrib4usv_s = wrapGl!(void, GLuint, const(GLushort)*)(&glVertexAttrib4usv);
auto glVertexAttribPointer_s = wrapGl!(void, GLuint, GLint, GLenum, GLboolean, GLsizei, const(GLvoid)*)(&glVertexAttribPointer);


// GL_VERSION_2_1

auto glUniformMatrix2x3fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix2x3fv);
auto glUniformMatrix3x2fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix3x2fv);
auto glUniformMatrix2x4fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix2x4fv);
auto glUniformMatrix4x2fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix4x2fv);
auto glUniformMatrix3x4fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix3x4fv);
auto glUniformMatrix4x3fv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glUniformMatrix4x3fv);


// GL_VERSION_3_0

/* OpenGL 3.0 also reuses entry points from these extensions: */
/* ARB_framebuffer_object*/
/* ARB_map_buffer_range*/
/*)*/
auto glColorMaski_s = wrapGl!(void, GLuint, GLboolean, GLboolean, GLboolean, GLboolean)(&glColorMaski);
auto glGetBooleani_v_s = wrapGl!(void, GLenum, GLuint, GLboolean*)(&glGetBooleani_v);
auto glGetIntegeri_v_s = wrapGl!(void, GLenum, GLuint, GLint*)(&glGetIntegeri_v);
auto glEnablei_s = wrapGl!(void, GLenum, GLuint)(&glEnablei);
auto glDisablei_s = wrapGl!(void, GLenum, GLuint)(&glDisablei);
auto glIsEnabledi_s = wrapGl!(GLboolean, GLenum, GLuint)(&glIsEnabledi);
auto glBeginTransformFeedback_s = wrapGl!(void, GLenum)(&glBeginTransformFeedback);
auto glEndTransformFeedback_s = wrapGl!(void)(&glEndTransformFeedback);
auto glBindBufferRange_s = wrapGl!(void, GLenum, GLuint, GLuint, GLintptr, GLsizeiptr)(&glBindBufferRange);
auto glBindBufferBase_s = wrapGl!(void, GLenum, GLuint, GLuint)(&glBindBufferBase);
auto glTransformFeedbackVaryings_s = wrapGl!(void, GLuint, GLsizei, const(GLchar)**, GLenum)(&glTransformFeedbackVaryings);
auto glGetTransformFeedbackVarying_s = wrapGl!(void, GLuint, GLuint, GLsizei, GLsizei*, GLsizei*, GLenum*, GLchar*)(&glGetTransformFeedbackVarying);
auto glClampColor_s = wrapGl!(void, GLenum, GLenum)(&glClampColor);
auto glBeginConditionalRender_s = wrapGl!(void, GLuint, GLenum)(&glBeginConditionalRender);
auto glEndConditionalRender_s = wrapGl!(void)(&glEndConditionalRender);
auto glVertexAttribIPointer_s = wrapGl!(void, GLuint, GLint, GLenum, GLsizei, const(GLvoid)*)(&glVertexAttribIPointer);
auto glGetVertexAttribIiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetVertexAttribIiv);
auto glGetVertexAttribIuiv_s = wrapGl!(void, GLuint, GLenum, GLuint*)(&glGetVertexAttribIuiv);
auto glVertexAttribI1i_s = wrapGl!(void, GLuint, GLint)(&glVertexAttribI1i);
auto glVertexAttribI2i_s = wrapGl!(void, GLuint, GLint, GLint)(&glVertexAttribI2i);
auto glVertexAttribI3i_s = wrapGl!(void, GLuint, GLint, GLint, GLint)(&glVertexAttribI3i);
auto glVertexAttribI4i_s = wrapGl!(void, GLuint, GLint, GLint, GLint, GLint)(&glVertexAttribI4i);
auto glVertexAttribI1ui_s = wrapGl!(void, GLuint, GLuint)(&glVertexAttribI1ui);
auto glVertexAttribI2ui_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glVertexAttribI2ui);
auto glVertexAttribI3ui_s = wrapGl!(void, GLuint, GLuint, GLuint, GLuint)(&glVertexAttribI3ui);
auto glVertexAttribI4ui_s = wrapGl!(void, GLuint, GLuint, GLuint, GLuint, GLuint)(&glVertexAttribI4ui);
auto glVertexAttribI1iv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttribI1iv);
auto glVertexAttribI2iv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttribI2iv);
auto glVertexAttribI3iv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttribI3iv);
auto glVertexAttribI4iv_s = wrapGl!(void, GLuint, const(GLint)*)(&glVertexAttribI4iv);
auto glVertexAttribI1uiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttribI1uiv);
auto glVertexAttribI2uiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttribI2uiv);
auto glVertexAttribI3uiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttribI3uiv);
auto glVertexAttribI4uiv_s = wrapGl!(void, GLuint, const(GLuint)*)(&glVertexAttribI4uiv);
auto glVertexAttribI4bv_s = wrapGl!(void, GLuint, const(GLbyte)*)(&glVertexAttribI4bv);
auto glVertexAttribI4sv_s = wrapGl!(void, GLuint, const(GLshort)*)(&glVertexAttribI4sv);
auto glVertexAttribI4ubv_s = wrapGl!(void, GLuint, const(GLubyte)*)(&glVertexAttribI4ubv);
auto glVertexAttribI4usv_s = wrapGl!(void, GLuint, const(GLushort)*)(&glVertexAttribI4usv);
auto glGetUniformuiv_s = wrapGl!(void, GLuint, GLint, GLuint*)(&glGetUniformuiv);
auto glBindFragDataLocation_s = wrapGl!(void, GLuint, GLuint, const(GLchar)*)(&glBindFragDataLocation);
auto glGetFragDataLocation_s = wrapGl!(GLint, GLuint, const(GLchar)*)(&glGetFragDataLocation);
auto glUniform1ui_s = wrapGl!(void, GLint, GLuint)(&glUniform1ui);
auto glUniform2ui_s = wrapGl!(void, GLint, GLuint, GLuint)(&glUniform2ui);
auto glUniform3ui_s = wrapGl!(void, GLint, GLuint, GLuint, GLuint)(&glUniform3ui);
auto glUniform4ui_s = wrapGl!(void, GLint, GLuint, GLuint, GLuint, GLuint)(&glUniform4ui);
auto glUniform1uiv_s = wrapGl!(void, GLint, GLsizei, const(GLuint)*)(&glUniform1uiv);
auto glUniform2uiv_s = wrapGl!(void, GLint, GLsizei, const(GLuint)*)(&glUniform2uiv);
auto glUniform3uiv_s = wrapGl!(void, GLint, GLsizei, const(GLuint)*)(&glUniform3uiv);
auto glUniform4uiv_s = wrapGl!(void, GLint, GLsizei, const(GLuint)*)(&glUniform4uiv);
auto glTexParameterIiv_s = wrapGl!(void, GLenum, GLenum, const(GLint)*)(&glTexParameterIiv);
auto glTexParameterIuiv_s = wrapGl!(void, GLenum, GLenum, const(GLuint)*)(&glTexParameterIuiv);
auto glGetTexParameterIiv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetTexParameterIiv);
auto glGetTexParameterIuiv_s = wrapGl!(void, GLenum, GLenum, GLuint*)(&glGetTexParameterIuiv);
auto glClearBufferiv_s = wrapGl!(void, GLenum, GLint, const(GLint)*)(&glClearBufferiv);
auto glClearBufferuiv_s = wrapGl!(void, GLenum, GLint, const(GLuint)*)(&glClearBufferuiv);
auto glClearBufferfv_s = wrapGl!(void, GLenum, GLint, const(GLfloat)*)(&glClearBufferfv);
auto glClearBufferfi_s = wrapGl!(void, GLenum, GLint, GLfloat, GLint)(&glClearBufferfi);
auto glGetStringi_s = wrapGl!(const(GLubyte)*, GLenum, GLuint)(&glGetStringi);


// GL_VERSION_3_1

/* OpenGL 3.1 also reuses entry points from these extensions:*/
/* ARB_copy_buffer*/
/* ARB_uniform_buffer_object*/
auto glDrawArraysInstanced_s = wrapGl!(void, GLenum, GLint, GLsizei, GLsizei)(&glDrawArraysInstanced);
auto glDrawElementsInstanced_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLsizei)(&glDrawElementsInstanced);
auto glTexBuffer_s = wrapGl!(void, GLenum, GLenum, GLuint)(&glTexBuffer);
auto glPrimitiveRestartIndex_s = wrapGl!(void, GLuint)(&glPrimitiveRestartIndex);


// GL_VERSION_3_2

/* OpenGL 3.2 also reuses entry points from these extensions:*/
/* ARB_draw_elements_base_vertex*/
/* ARB_provoking_vertex*/
/* ARB_sync*/
/* ARB_texture_multisample*/
auto glGetInteger64i_v_s = wrapGl!(void, GLenum, GLuint, GLint64*)(&glGetInteger64i_v);
auto glGetBufferParameteri64v_s = wrapGl!(void, GLenum, GLenum, GLint64*)(&glGetBufferParameteri64v);
auto glFramebufferTexture_s = wrapGl!(void, GLenum, GLenum, GLuint, GLint)(&glFramebufferTexture);


// GL_VERSION_3_3

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
auto glVertexAttribDivisor_s = wrapGl!(void, GLuint, GLuint)(&glVertexAttribDivisor);


// GL_VERSION_4_0

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
auto glMinSampleShading_s = wrapGl!(void, GLfloat)(&glMinSampleShading);
auto glBlendEquationi_s = wrapGl!(void, GLuint, GLenum)(&glBlendEquationi);
auto glBlendEquationSeparatei_s = wrapGl!(void, GLuint, GLenum, GLenum)(&glBlendEquationSeparatei);
auto glBlendFunci_s = wrapGl!(void, GLuint, GLenum, GLenum)(&glBlendFunci);
auto glBlendFuncSeparatei_s = wrapGl!(void, GLuint, GLenum, GLenum, GLenum, GLenum)(&glBlendFuncSeparatei);


// GL_VERSION_4_1

/* OpenGL 4.1 reuses entry points from these extensions:*/
/* ARB_ES2_compatibility*/
/* ARB_get_program_binary*/
/* ARB_separate_shader_objects*/
/* ARB_shader_precision(no entry)*/
/* ARB_vertex_attrib_64bit*/
/* ARB_viewport_array*/

// GL_VERSION_4_2

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

// GL_VERSION_4_3

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

// GL_ARB_depth_buffer_float

// GL_ARB_framebuffer_object

auto glIsRenderbuffer_s = wrapGl!(GLboolean, GLuint)(&glIsRenderbuffer);
auto glBindRenderbuffer_s = wrapGl!(void, GLenum, GLuint)(&glBindRenderbuffer);
auto glDeleteRenderbuffers_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteRenderbuffers);
auto glGenRenderbuffers_s = wrapGl!(void, GLsizei, GLuint*)(&glGenRenderbuffers);
auto glRenderbufferStorage_s = wrapGl!(void, GLenum, GLenum, GLsizei, GLsizei)(&glRenderbufferStorage);
auto glGetRenderbufferParameteriv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetRenderbufferParameteriv);
auto glIsFramebuffer_s = wrapGl!(GLboolean, GLuint)(&glIsFramebuffer);
auto glBindFramebuffer_s = wrapGl!(void, GLenum, GLuint)(&glBindFramebuffer);
auto glDeleteFramebuffers_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteFramebuffers);
auto glGenFramebuffers_s = wrapGl!(void, GLsizei, GLuint*)(&glGenFramebuffers);
auto glCheckFramebufferStatus_s = wrapGl!(GLenum, GLenum)(&glCheckFramebufferStatus);
auto glFramebufferTexture1D_s = wrapGl!(void, GLenum, GLenum, GLenum, GLuint, GLint)(&glFramebufferTexture1D);
auto glFramebufferTexture2D_s = wrapGl!(void, GLenum, GLenum, GLenum, GLuint, GLint)(&glFramebufferTexture2D);
auto glFramebufferTexture3D_s = wrapGl!(void, GLenum, GLenum, GLenum, GLuint, GLint, GLint)(&glFramebufferTexture3D);
auto glFramebufferRenderbuffer_s = wrapGl!(void, GLenum, GLenum, GLenum, GLuint)(&glFramebufferRenderbuffer);
auto glGetFramebufferAttachmentParameteriv_s = wrapGl!(void, GLenum, GLenum, GLenum, GLint*)(&glGetFramebufferAttachmentParameteriv);
auto glGenerateMipmap_s = wrapGl!(void, GLenum)(&glGenerateMipmap);
auto glBlitFramebuffer_s = wrapGl!(void, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLbitfield, GLenum)(&glBlitFramebuffer);
auto glRenderbufferStorageMultisample_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei, GLsizei)(&glRenderbufferStorageMultisample);
auto glFramebufferTextureLayer_s = wrapGl!(void, GLenum, GLenum, GLuint, GLint, GLint)(&glFramebufferTextureLayer);


// GL_ARB_framebuffer_sRGB

// GL_ARB_half_float_vertex

// GL_ARB_map_buffer_range
auto glMapBufferRange_s = wrapGl!(GLvoid*, GLenum, GLintptr, GLsizeiptr, GLbitfield)(&glMapBufferRange);
auto glFlushMappedBufferRange_s = wrapGl!(void, GLenum, GLintptr, GLsizeiptr)(&glFlushMappedBufferRange);


// GL_ARB_texture_compression_rgtc

// GL_ARB_texture_rg

// GL_ARB_vertex_array_object

auto glBindVertexArray_s = wrapGl!(void, GLuint)(&glBindVertexArray);
auto glDeleteVertexArrays_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteVertexArrays);
auto glGenVertexArrays_s = wrapGl!(void, GLsizei, GLuint*)(&glGenVertexArrays);
auto glIsVertexArray_s = wrapGl!(GLboolean, GLuint)(&glIsVertexArray);


// GL_ARB_uniform_buffer_object

auto glGetUniformIndices_s = wrapGl!(void, GLuint, GLsizei, const(GLchar)**, GLuint*)(&glGetUniformIndices);
auto glGetActiveUniformsiv_s = wrapGl!(void, GLuint, GLsizei, const(GLuint)*, GLenum, GLint*)(&glGetActiveUniformsiv);
auto glGetActiveUniformName_s = wrapGl!(void, GLuint, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetActiveUniformName);
auto glGetUniformBlockIndex_s = wrapGl!(GLuint, GLuint, const(GLchar)*)(&glGetUniformBlockIndex);
auto glGetActiveUniformBlockiv_s = wrapGl!(void, GLuint, GLuint, GLenum, GLint*)(&glGetActiveUniformBlockiv);
auto glGetActiveUniformBlockName_s = wrapGl!(void, GLuint, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetActiveUniformBlockName);
auto glUniformBlockBinding_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glUniformBlockBinding);


// GL_ARB_copy_buffer

auto glCopyBufferSubData_s = wrapGl!(void, GLenum, GLenum, GLintptr, GLintptr, GLsizeiptr)(&glCopyBufferSubData);


// GL_ARB_depth_clamp

// GL_ARB_draw_elements_base_vertex

auto glDrawElementsBaseVertex_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLint)(&glDrawElementsBaseVertex);
auto glDrawRangeElementsBaseVertex_s = wrapGl!(void, GLenum, GLuint, GLuint, GLsizei, GLenum, const(GLvoid)*, GLint)(&glDrawRangeElementsBaseVertex);
auto glDrawElementsInstancedBaseVertex_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(GLvoid)*, GLsizei, GLint)(&glDrawElementsInstancedBaseVertex);
auto glMultiDrawElementsBaseVertex_s = wrapGl!(void, GLenum, const(GLsizei)*, GLenum, const(GLvoid)**, GLsizei, const(GLint)*)(&glMultiDrawElementsBaseVertex);


// GL_ARB_fragment_coord_conventions

// GL_ARB_provoking_vertex

auto glProvokingVertex_s = wrapGl!(void, GLenum)(&glProvokingVertex);


// GL_ARB_seamless_cube_map

// GL_ARB_sync

auto glFenceSync_s = wrapGl!(GLsync, GLenum, GLbitfield)(&glFenceSync);
auto glIsSync_s = wrapGl!(GLboolean, GLsync)(&glIsSync);
auto glDeleteSync_s = wrapGl!(void, GLsync)(&glDeleteSync);
auto glClientWaitSync_s = wrapGl!(GLenum, GLsync, GLbitfield, GLuint64)(&glClientWaitSync);
auto glWaitSync_s = wrapGl!(void, GLsync, GLbitfield, GLuint64)(&glWaitSync);
auto glGetInteger64v_s = wrapGl!(void, GLenum, GLint64*)(&glGetInteger64v);
auto glGetSynciv_s = wrapGl!(void, GLsync, GLenum, GLsizei, GLsizei*, GLint*)(&glGetSynciv);


// GL_ARB_texture_multisample

auto glTexImage2DMultisample_s = wrapGl!(void, GLenum, GLsizei, GLint, GLsizei, GLsizei, GLboolean)(&glTexImage2DMultisample);
auto glTexImage3DMultisample_s = wrapGl!(void, GLenum, GLsizei, GLint, GLsizei, GLsizei, GLsizei, GLboolean)(&glTexImage3DMultisample);
auto glGetMultisamplefv_s = wrapGl!(void, GLenum, GLuint, GLfloat*)(&glGetMultisamplefv);
auto glSampleMaski_s = wrapGl!(void, GLuint, GLbitfield)(&glSampleMaski);


// GL_ARB_vertex_array_bgra

// GL_ARB_draw_buffers_blend

auto glBlendEquationiARB_s = wrapGl!(void, GLuint, GLenum)(&glBlendEquationiARB);
auto glBlendEquationSeparateiARB_s = wrapGl!(void, GLuint, GLenum, GLenum)(&glBlendEquationSeparateiARB);
auto glBlendFunciARB_s = wrapGl!(void, GLuint, GLenum, GLenum)(&glBlendFunciARB);
auto glBlendFuncSeparateiARB_s = wrapGl!(void, GLuint, GLenum, GLenum, GLenum, GLenum)(&glBlendFuncSeparateiARB);


// GL_ARB_sample_shading

auto glMinSampleShadingARB_s = wrapGl!(void, GLfloat)(&glMinSampleShadingARB);


// GL_ARB_texture_cube_map_array

// GL_ARB_texture_gather

// GL_ARB_texture_query_lod

// GL_ARB_shading_language_include

auto glNamedStringARB_s = wrapGl!(void, GLenum, GLint, const(GLchar)*, GLint, const(GLchar)*)(&glNamedStringARB);
auto glDeleteNamedStringARB_s = wrapGl!(void, GLint, const(GLchar)*)(&glDeleteNamedStringARB);
auto glCompileShaderIncludeARB_s = wrapGl!(void, GLuint, GLsizei, const(GLchar*)*, const(GLint)*)(&glCompileShaderIncludeARB);
auto glIsNamedStringARB_s = wrapGl!(GLboolean, GLint, const(GLchar)*)(&glIsNamedStringARB);
auto glGetNamedStringARB_s = wrapGl!(void, GLint, const(GLchar)*, GLsizei, GLint*, GLchar*)(&glGetNamedStringARB);
auto glGetNamedStringivARB_s = wrapGl!(void, GLint, const(GLchar)*, GLenum, GLint*)(&glGetNamedStringivARB);


// GL_ARB_texture_compression_bptc

// GL_ARB_blend_func_extended

auto glBindFragDataLocationIndexed_s = wrapGl!(void, GLuint, GLuint, GLuint, const(GLchar)*)(&glBindFragDataLocationIndexed);
auto glGetFragDataIndex_s = wrapGl!(GLint, GLuint, const(GLchar)*)(&glGetFragDataIndex);


// GL_ARB_explicit_attrib_location

// GL_ARB_occlusion_query2

// GL_ARB_sampler_objects

auto glGenSamplers_s = wrapGl!(void, GLsizei, GLuint*)(&glGenSamplers);
auto glDeleteSamplers_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteSamplers);
auto glIsSampler_s = wrapGl!(GLboolean, GLuint)(&glIsSampler);
auto glBindSampler_s = wrapGl!(void, GLuint, GLuint)(&glBindSampler);
auto glSamplerParameteri_s = wrapGl!(void, GLuint, GLenum, GLint)(&glSamplerParameteri);
auto glSamplerParameteriv_s = wrapGl!(void, GLuint, GLenum, const(GLint)*)(&glSamplerParameteriv);
auto glSamplerParameterf_s = wrapGl!(void, GLuint, GLenum, GLfloat)(&glSamplerParameterf);
auto glSamplerParameterfv_s = wrapGl!(void, GLuint, GLenum, const(GLfloat)*)(&glSamplerParameterfv);
auto glSamplerParameterIiv_s = wrapGl!(void, GLuint, GLenum, const(GLint)*)(&glSamplerParameterIiv);
auto glSamplerParameterIuiv_s = wrapGl!(void, GLuint, GLenum, const(GLuint)*)(&glSamplerParameterIuiv);
auto glGetSamplerParameteriv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetSamplerParameteriv);
auto glGetSamplerParameterIiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetSamplerParameterIiv);
auto glGetSamplerParameterfv_s = wrapGl!(void, GLuint, GLenum, GLfloat*)(&glGetSamplerParameterfv);
auto glGetSamplerParameterIuiv_s = wrapGl!(void, GLuint, GLenum, GLuint*)(&glGetSamplerParameterIuiv);


// GL_ARB_shader_bit_encoding

// GL_ARB_texture_rgb10_a2ui

// GL_ARB_texture_swizzle

// GL_ARB_timer_query

auto glQueryCounter_s = wrapGl!(void, GLuint, GLenum)(&glQueryCounter);
auto glGetQueryObjecti64v_s = wrapGl!(void, GLuint, GLenum, GLint64*)(&glGetQueryObjecti64v);
auto glGetQueryObjectui64v_s = wrapGl!(void, GLuint, GLenum, GLuint64*)(&glGetQueryObjectui64v);


// GL_ARB_vertex_type_2_10_10_10_rev

auto glVertexP2ui_s = wrapGl!(void, GLenum, GLuint)(&glVertexP2ui);
auto glVertexP2uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glVertexP2uiv);
auto glVertexP3ui_s = wrapGl!(void, GLenum, GLuint)(&glVertexP3ui);
auto glVertexP3uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glVertexP3uiv);
auto glVertexP4ui_s = wrapGl!(void, GLenum, GLuint)(&glVertexP4ui);
auto glVertexP4uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glVertexP4uiv);
auto glTexCoordP1ui_s = wrapGl!(void, GLenum, GLuint)(&glTexCoordP1ui);
auto glTexCoordP1uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glTexCoordP1uiv);
auto glTexCoordP2ui_s = wrapGl!(void, GLenum, GLuint)(&glTexCoordP2ui);
auto glTexCoordP2uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glTexCoordP2uiv);
auto glTexCoordP3ui_s = wrapGl!(void, GLenum, GLuint)(&glTexCoordP3ui);
auto glTexCoordP3uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glTexCoordP3uiv);
auto glTexCoordP4ui_s = wrapGl!(void, GLenum, GLuint)(&glTexCoordP4ui);
auto glTexCoordP4uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glTexCoordP4uiv);
auto glMultiTexCoordP1ui_s = wrapGl!(void, GLenum, GLenum, GLuint)(&glMultiTexCoordP1ui);
auto glMultiTexCoordP1uiv_s = wrapGl!(void, GLenum, GLenum, const(GLuint)*)(&glMultiTexCoordP1uiv);
auto glMultiTexCoordP2ui_s = wrapGl!(void, GLenum, GLenum, GLuint)(&glMultiTexCoordP2ui);
auto glMultiTexCoordP2uiv_s = wrapGl!(void, GLenum, GLenum, const(GLuint)*)(&glMultiTexCoordP2uiv);
auto glMultiTexCoordP3ui_s = wrapGl!(void, GLenum, GLenum, GLuint)(&glMultiTexCoordP3ui);
auto glMultiTexCoordP3uiv_s = wrapGl!(void, GLenum, GLenum, const(GLuint)*)(&glMultiTexCoordP3uiv);
auto glMultiTexCoordP4ui_s = wrapGl!(void, GLenum, GLenum, GLuint)(&glMultiTexCoordP4ui);
auto glMultiTexCoordP4uiv_s = wrapGl!(void, GLenum, GLenum, const(GLuint)*)(&glMultiTexCoordP4uiv);
auto glNormalP3ui_s = wrapGl!(void, GLenum, GLuint)(&glNormalP3ui);
auto glNormalP3uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glNormalP3uiv);
auto glColorP3ui_s = wrapGl!(void, GLenum, GLuint)(&glColorP3ui);
auto glColorP3uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glColorP3uiv);
auto glColorP4ui_s = wrapGl!(void, GLenum, GLuint)(&glColorP4ui);
auto glColorP4uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glColorP4uiv);
auto glSecondaryColorP3ui_s = wrapGl!(void, GLenum, GLuint)(&glSecondaryColorP3ui);
auto glSecondaryColorP3uiv_s = wrapGl!(void, GLenum, const(GLuint)*)(&glSecondaryColorP3uiv);
auto glVertexAttribP1ui_s = wrapGl!(void, GLuint, GLenum, GLboolean, GLuint)(&glVertexAttribP1ui);
auto glVertexAttribP1uiv_s = wrapGl!(void, GLuint, GLenum, GLboolean, const(GLuint)*)(&glVertexAttribP1uiv);
auto glVertexAttribP2ui_s = wrapGl!(void, GLuint, GLenum, GLboolean, GLuint)(&glVertexAttribP2ui);
auto glVertexAttribP2uiv_s = wrapGl!(void, GLuint, GLenum, GLboolean, const(GLuint)*)(&glVertexAttribP2uiv);
auto glVertexAttribP3ui_s = wrapGl!(void, GLuint, GLenum, GLboolean, GLuint)(&glVertexAttribP3ui);
auto glVertexAttribP3uiv_s = wrapGl!(void, GLuint, GLenum, GLboolean, const(GLuint)*)(&glVertexAttribP3uiv);
auto glVertexAttribP4ui_s = wrapGl!(void, GLuint, GLenum, GLboolean, GLuint)(&glVertexAttribP4ui);
auto glVertexAttribP4uiv_s = wrapGl!(void, GLuint, GLenum, GLboolean, const(GLuint)*)(&glVertexAttribP4uiv);


// GL_ARB_draw_indirect

auto glDrawArraysIndirect_s = wrapGl!(void, GLenum, const(GLvoid)*)(&glDrawArraysIndirect);
auto glDrawElementsIndirect_s = wrapGl!(void, GLenum, GLenum, const(GLvoid)*)(&glDrawElementsIndirect);


// GL_ARB_gpu_shader5

// GL_ARB_gpu_shader_fp64

auto glUniform1d_s = wrapGl!(void, GLint, GLdouble)(&glUniform1d);
auto glUniform2d_s = wrapGl!(void, GLint, GLdouble, GLdouble)(&glUniform2d);
auto glUniform3d_s = wrapGl!(void, GLint, GLdouble, GLdouble, GLdouble)(&glUniform3d);
auto glUniform4d_s = wrapGl!(void, GLint, GLdouble, GLdouble, GLdouble, GLdouble)(&glUniform4d);
auto glUniform1dv_s = wrapGl!(void, GLint, GLsizei, const(GLdouble)*)(&glUniform1dv);
auto glUniform2dv_s = wrapGl!(void, GLint, GLsizei, const(GLdouble)*)(&glUniform2dv);
auto glUniform3dv_s = wrapGl!(void, GLint, GLsizei, const(GLdouble)*)(&glUniform3dv);
auto glUniform4dv_s = wrapGl!(void, GLint, GLsizei, const(GLdouble)*)(&glUniform4dv);
auto glUniformMatrix2dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix2dv);
auto glUniformMatrix3dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix3dv);
auto glUniformMatrix4dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix4dv);
auto glUniformMatrix2x3dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix2x3dv);
auto glUniformMatrix2x4dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix2x4dv);
auto glUniformMatrix3x2dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix3x2dv);
auto glUniformMatrix3x4dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix3x4dv);
auto glUniformMatrix4x2dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix4x2dv);
auto glUniformMatrix4x3dv_s = wrapGl!(void, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glUniformMatrix4x3dv);
auto glGetUniformdv_s = wrapGl!(void, GLuint, GLint, GLdouble*)(&glGetUniformdv);


// GL_ARB_shader_subroutine

auto glGetSubroutineUniformLocation_s = wrapGl!(GLint, GLuint, GLenum, const(GLchar)*)(&glGetSubroutineUniformLocation);
auto glGetSubroutineIndex_s = wrapGl!(GLuint, GLuint, GLenum, const(GLchar)*)(&glGetSubroutineIndex);
auto glGetActiveSubroutineUniformiv_s = wrapGl!(void, GLuint, GLenum, GLuint, GLenum, GLint*)(&glGetActiveSubroutineUniformiv);
auto glGetActiveSubroutineUniformName_s = wrapGl!(void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetActiveSubroutineUniformName);
auto glGetActiveSubroutineName_s = wrapGl!(void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetActiveSubroutineName);
auto glUniformSubroutinesuiv_s = wrapGl!(void, GLenum, GLsizei, const(GLuint)*)(&glUniformSubroutinesuiv);
auto glGetUniformSubroutineuiv_s = wrapGl!(void, GLenum, GLint, GLuint*)(&glGetUniformSubroutineuiv);
auto glGetProgramStageiv_s = wrapGl!(void, GLuint, GLenum, GLenum, GLint*)(&glGetProgramStageiv);


// GL_ARB_tessellation_shader

auto glPatchParameteri_s = wrapGl!(void, GLenum, GLint)(&glPatchParameteri);
auto glPatchParameterfv_s = wrapGl!(void, GLenum, const(GLfloat)*)(&glPatchParameterfv);


// GL_ARB_texture_buffer_object_rgb32

// GL_ARB_transform_feedback2

auto glBindTransformFeedback_s = wrapGl!(void, GLenum, GLuint)(&glBindTransformFeedback);
auto glDeleteTransformFeedbacks_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteTransformFeedbacks);
auto glGenTransformFeedbacks_s = wrapGl!(void, GLsizei, GLuint*)(&glGenTransformFeedbacks);
auto glIsTransformFeedback_s = wrapGl!(GLboolean, GLuint)(&glIsTransformFeedback);
auto glPauseTransformFeedback_s = wrapGl!(void)(&glPauseTransformFeedback);
auto glResumeTransformFeedback_s = wrapGl!(void)(&glResumeTransformFeedback);
auto glDrawTransformFeedback_s = wrapGl!(void, GLenum, GLuint)(&glDrawTransformFeedback);


// GL_ARB_transform_feedback3

auto glDrawTransformFeedbackStream_s = wrapGl!(void, GLenum, GLuint, GLuint)(&glDrawTransformFeedbackStream);
auto glBeginQueryIndexed_s = wrapGl!(void, GLenum, GLuint, GLuint)(&glBeginQueryIndexed);
auto glEndQueryIndexed_s = wrapGl!(void, GLenum, GLuint)(&glEndQueryIndexed);
auto glGetQueryIndexediv_s = wrapGl!(void, GLenum, GLuint, GLenum, GLint*)(&glGetQueryIndexediv);


// GL_ARB_ES2_compatibility

auto glReleaseShaderCompiler_s = wrapGl!(void)(&glReleaseShaderCompiler);
auto glShaderBinary_s = wrapGl!(void, GLsizei, const(GLuint)*, GLenum, const(GLvoid)*, GLsizei)(&glShaderBinary);
auto glGetShaderPrecisionFormat_s = wrapGl!(void, GLenum, GLenum, GLint*, GLint*)(&glGetShaderPrecisionFormat);
auto glDepthRangef_s = wrapGl!(void, GLfloat, GLfloat)(&glDepthRangef);
auto glClearDepthf_s = wrapGl!(void, GLfloat)(&glClearDepthf);


// GL_ARB_get_program_binary

auto glGetProgramBinary_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLenum*, GLvoid*)(&glGetProgramBinary);
auto glProgramBinary_s = wrapGl!(void, GLuint, GLenum, const(GLvoid)*, GLsizei)(&glProgramBinary);
auto glProgramParameteri_s = wrapGl!(void, GLuint, GLenum, GLint)(&glProgramParameteri);


// GL_ARB_separate_shader_objects

auto glUseProgramStages_s = wrapGl!(void, GLuint, GLbitfield, GLuint)(&glUseProgramStages);
auto glActiveShaderProgram_s = wrapGl!(void, GLuint, GLuint)(&glActiveShaderProgram);
auto glCreateShaderProgramv_s = wrapGl!(GLuint, GLenum, GLsizei, const(GLchar)**)(&glCreateShaderProgramv);
auto glBindProgramPipeline_s = wrapGl!(void, GLuint)(&glBindProgramPipeline);
auto glDeleteProgramPipelines_s = wrapGl!(void, GLsizei, const(GLuint)*)(&glDeleteProgramPipelines);
auto glGenProgramPipelines_s = wrapGl!(void, GLsizei, GLuint*)(&glGenProgramPipelines);
auto glIsProgramPipeline_s = wrapGl!(GLboolean, GLuint)(&glIsProgramPipeline);
auto glGetProgramPipelineiv_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetProgramPipelineiv);
auto glProgramUniform1i_s = wrapGl!(void, GLuint, GLint, GLint)(&glProgramUniform1i);
auto glProgramUniform1iv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLint)*)(&glProgramUniform1iv);
auto glProgramUniform1f_s = wrapGl!(void, GLuint, GLint, GLfloat)(&glProgramUniform1f);
auto glProgramUniform1fv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLfloat)*)(&glProgramUniform1fv);
auto glProgramUniform1d_s = wrapGl!(void, GLuint, GLint, GLdouble)(&glProgramUniform1d);
auto glProgramUniform1dv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLdouble)*)(&glProgramUniform1dv);
auto glProgramUniform1ui_s = wrapGl!(void, GLuint, GLint, GLuint)(&glProgramUniform1ui);
auto glProgramUniform1uiv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLuint)*)(&glProgramUniform1uiv);
auto glProgramUniform2i_s = wrapGl!(void, GLuint, GLint, GLint, GLint)(&glProgramUniform2i);
auto glProgramUniform2iv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLint)*)(&glProgramUniform2iv);
auto glProgramUniform2f_s = wrapGl!(void, GLuint, GLint, GLfloat, GLfloat)(&glProgramUniform2f);
auto glProgramUniform2fv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLfloat)*)(&glProgramUniform2fv);
auto glProgramUniform2d_s = wrapGl!(void, GLuint, GLint, GLdouble, GLdouble)(&glProgramUniform2d);
auto glProgramUniform2dv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLdouble)*)(&glProgramUniform2dv);
auto glProgramUniform2ui_s = wrapGl!(void, GLuint, GLint, GLuint, GLuint)(&glProgramUniform2ui);
auto glProgramUniform2uiv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLuint)*)(&glProgramUniform2uiv);
auto glProgramUniform3i_s = wrapGl!(void, GLuint, GLint, GLint, GLint, GLint)(&glProgramUniform3i);
auto glProgramUniform3iv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLint)*)(&glProgramUniform3iv);
auto glProgramUniform3f_s = wrapGl!(void, GLuint, GLint, GLfloat, GLfloat, GLfloat)(&glProgramUniform3f);
auto glProgramUniform3fv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLfloat)*)(&glProgramUniform3fv);
auto glProgramUniform3d_s = wrapGl!(void, GLuint, GLint, GLdouble, GLdouble, GLdouble)(&glProgramUniform3d);
auto glProgramUniform3dv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLdouble)*)(&glProgramUniform3dv);
auto glProgramUniform3ui_s = wrapGl!(void, GLuint, GLint, GLuint, GLuint, GLuint)(&glProgramUniform3ui);
auto glProgramUniform3uiv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLuint)*)(&glProgramUniform3uiv);
auto glProgramUniform4i_s = wrapGl!(void, GLuint, GLint, GLint, GLint, GLint, GLint)(&glProgramUniform4i);
auto glProgramUniform4iv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLint)*)(&glProgramUniform4iv);
auto glProgramUniform4f_s = wrapGl!(void, GLuint, GLint, GLfloat, GLfloat, GLfloat, GLfloat)(&glProgramUniform4f);
auto glProgramUniform4fv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLfloat)*)(&glProgramUniform4fv);
auto glProgramUniform4d_s = wrapGl!(void, GLuint, GLint, GLdouble, GLdouble, GLdouble, GLdouble)(&glProgramUniform4d);
auto glProgramUniform4dv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLdouble)*)(&glProgramUniform4dv);
auto glProgramUniform4ui_s = wrapGl!(void, GLuint, GLint, GLuint, GLuint, GLuint, GLuint)(&glProgramUniform4ui);
auto glProgramUniform4uiv_s = wrapGl!(void, GLuint, GLint, GLsizei, const(GLuint)*)(&glProgramUniform4uiv);
auto glProgramUniformMatrix2fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix2fv);
auto glProgramUniformMatrix3fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix3fv);
auto glProgramUniformMatrix4fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix4fv);
auto glProgramUniformMatrix2dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix2dv);
auto glProgramUniformMatrix3dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix3dv);
auto glProgramUniformMatrix4dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix4dv);
auto glProgramUniformMatrix2x3fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix2x3fv);
auto glProgramUniformMatrix3x2fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix3x2fv);
auto glProgramUniformMatrix2x4fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix2x4fv);
auto glProgramUniformMatrix4x2fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix4x2fv);
auto glProgramUniformMatrix3x4fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix3x4fv);
auto glProgramUniformMatrix4x3fv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLfloat)*)(&glProgramUniformMatrix4x3fv);
auto glProgramUniformMatrix2x3dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix2x3dv);
auto glProgramUniformMatrix3x2dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix3x2dv);
auto glProgramUniformMatrix2x4dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix2x4dv);
auto glProgramUniformMatrix4x2dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix4x2dv);
auto glProgramUniformMatrix3x4dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix3x4dv);
auto glProgramUniformMatrix4x3dv_s = wrapGl!(void, GLuint, GLint, GLsizei, GLboolean, const(GLdouble)*)(&glProgramUniformMatrix4x3dv);
auto glValidateProgramPipeline_s = wrapGl!(void, GLuint)(&glValidateProgramPipeline);
auto glGetProgramPipelineInfoLog_s = wrapGl!(void, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetProgramPipelineInfoLog);


// GL_ARB_vertex_attrib_64bit

auto glVertexAttribL1d_s = wrapGl!(void, GLuint, GLdouble)(&glVertexAttribL1d);
auto glVertexAttribL2d_s = wrapGl!(void, GLuint, GLdouble, GLdouble)(&glVertexAttribL2d);
auto glVertexAttribL3d_s = wrapGl!(void, GLuint, GLdouble, GLdouble, GLdouble)(&glVertexAttribL3d);
auto glVertexAttribL4d_s = wrapGl!(void, GLuint, GLdouble, GLdouble, GLdouble, GLdouble)(&glVertexAttribL4d);
auto glVertexAttribL1dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttribL1dv);
auto glVertexAttribL2dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttribL2dv);
auto glVertexAttribL3dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttribL3dv);
auto glVertexAttribL4dv_s = wrapGl!(void, GLuint, const(GLdouble)*)(&glVertexAttribL4dv);
auto glVertexAttribLPointer_s = wrapGl!(void, GLuint, GLint, GLenum, GLsizei, const(GLvoid)*)(&glVertexAttribLPointer);
auto glGetVertexAttribLdv_s = wrapGl!(void, GLuint, GLenum, GLdouble*)(&glGetVertexAttribLdv);


// GL_ARB_viewport_array

auto glViewportArrayv_s = wrapGl!(void, GLuint, GLsizei, const(GLfloat)*)(&glViewportArrayv);
auto glViewportIndexedf_s = wrapGl!(void, GLuint, GLfloat, GLfloat, GLfloat, GLfloat)(&glViewportIndexedf);
auto glViewportIndexedfv_s = wrapGl!(void, GLuint, const(GLfloat)*)(&glViewportIndexedfv);
auto glScissorArrayv_s = wrapGl!(void, GLuint, GLsizei, const(GLint)*)(&glScissorArrayv);
auto glScissorIndexed_s = wrapGl!(void, GLuint, GLint, GLint, GLsizei, GLsizei)(&glScissorIndexed);
auto glScissorIndexedv_s = wrapGl!(void, GLuint, const(GLint)*)(&glScissorIndexedv);
auto glDepthRangeArrayv_s = wrapGl!(void, GLuint, GLsizei, const(GLdouble)*)(&glDepthRangeArrayv);
auto glDepthRangeIndexed_s = wrapGl!(void, GLuint, GLdouble, GLdouble)(&glDepthRangeIndexed);
auto glGetFloati_v_s = wrapGl!(void, GLenum, GLuint, GLfloat*)(&glGetFloati_v);
auto glGetDoublei_v_s = wrapGl!(void, GLenum, GLuint, GLdouble*)(&glGetDoublei_v);


// GL_ARB_cl_event

auto glCreateSyncFromCLeventARB_s = wrapGl!(GLsync, _cl_context*, _cl_event*, GLbitfield)(&glCreateSyncFromCLeventARB);


// GL_ARB_debug_output

auto glDebugMessageControlARB_s = wrapGl!(void, GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean)(&glDebugMessageControlARB);
auto glDebugMessageInsertARB_s = wrapGl!(void, GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*)(&glDebugMessageInsertARB);
auto glDebugMessageCallbackARB_s = wrapGl!(void, GLDEBUGPROCARB, const(GLvoid)*)(&glDebugMessageCallbackARB);
auto glGetDebugMessageLogARB_s = wrapGl!(GLuint, GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*)(&glGetDebugMessageLogARB);


// GL_ARB_robustness

auto glGetGraphicsResetStatusARB_s = wrapGl!(GLenum, )(&glGetGraphicsResetStatusARB);
auto glGetnTexImageARB_s = wrapGl!(void, GLenum, GLint, GLenum, GLenum, GLsizei, GLvoid*)(&glGetnTexImageARB);
auto glReadnPixelsARB_s = wrapGl!(void, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, GLsizei, GLvoid*)(&glReadnPixelsARB);
auto glGetnCompressedTexImageARB_s = wrapGl!(void, GLenum, GLint, GLsizei, GLvoid*)(&glGetnCompressedTexImageARB);
auto glGetnUniformfvARB_s = wrapGl!(void, GLuint, GLint, GLsizei, GLfloat*)(&glGetnUniformfvARB);
auto glGetnUniformivARB_s = wrapGl!(void, GLuint, GLint, GLsizei, GLint*)(&glGetnUniformivARB);
auto glGetnUniformuivARB_s = wrapGl!(void, GLuint, GLint, GLsizei, GLuint*)(&glGetnUniformuivARB);
auto glGetnUniformdvARB_s = wrapGl!(void, GLuint, GLint, GLsizei, GLdouble*)(&glGetnUniformdvARB);


// GL_ARB_shader_stencil_export

// GL_ARB_base_instance

auto glDrawArraysInstancedBaseInstance_s = wrapGl!(void, GLenum, GLint, GLsizei, GLsizei, GLuint)(&glDrawArraysInstancedBaseInstance);
auto glDrawElementsInstancedBaseInstance_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(void)*, GLsizei, GLuint)(&glDrawElementsInstancedBaseInstance);
auto glDrawElementsInstancedBaseVertexBaseInstance_s = wrapGl!(void, GLenum, GLsizei, GLenum, const(void)*, GLsizei, GLint, GLuint)(&glDrawElementsInstancedBaseVertexBaseInstance);


// GL_ARB_shading_language_420pack

// GL_ARB_transform_feedback_instanced

auto glDrawTransformFeedbackInstanced_s = wrapGl!(void, GLenum, GLuint, GLsizei)(&glDrawTransformFeedbackInstanced);
auto glDrawTransformFeedbackStreamInstanced_s = wrapGl!(void, GLenum, GLuint, GLuint, GLsizei)(&glDrawTransformFeedbackStreamInstanced);


// GL_ARB_compressed_texture_pixel_storage

// GL_ARB_conservative_depth

// GL_ARB_internalformat_query

auto glGetInternalformativ_s = wrapGl!(void, GLenum, GLenum, GLenum, GLsizei, GLint*)(&glGetInternalformativ);


// GL_ARB_map_buffer_alignment

// GL_ARB_shader_atomic_counters

auto glGetActiveAtomicCounterBufferiv_s = wrapGl!(void, GLuint, GLuint, GLenum, GLint*)(&glGetActiveAtomicCounterBufferiv);


// GL_ARB_shader_image_load_store

auto glBindImageTexture_s = wrapGl!(void, GLuint, GLuint, GLint, GLboolean, GLint, GLenum, GLenum)(&glBindImageTexture);
auto glMemoryBarrier_s = wrapGl!(void, GLbitfield)(&glMemoryBarrier);


// GL_ARB_shading_language_packing

// GL_ARB_texture_storage

auto glTexStorage1D_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei)(&glTexStorage1D);
auto glTexStorage2D_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei, GLsizei)(&glTexStorage2D);
auto glTexStorage3D_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei)(&glTexStorage3D);
auto glTextureStorage1DEXT_s = wrapGl!(void, GLuint, GLenum, GLsizei, GLenum, GLsizei)(&glTextureStorage1DEXT);
auto glTextureStorage2DEXT_s = wrapGl!(void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei)(&glTextureStorage2DEXT);
auto glTextureStorage3DEXT_s = wrapGl!(void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei)(&glTextureStorage3DEXT);


// GL_KHR_texture_compression_astc_ldr

// GL_KHR_debug

auto glDebugMessageControl_s = wrapGl!(void, GLenum, GLenum, GLenum, GLsizei, const(GLuint)*, GLboolean)(&glDebugMessageControl);
auto glDebugMessageInsert_s = wrapGl!(void, GLenum, GLenum, GLuint, GLenum, GLsizei, const(GLchar)*)(&glDebugMessageInsert);
auto glDebugMessageCallback_s = wrapGl!(void, GLDEBUGPROC, const(void)*)(&glDebugMessageCallback);
auto glGetDebugMessageLog_s = wrapGl!(GLuint, GLuint, GLsizei, GLenum*, GLenum*, GLuint*, GLenum*, GLsizei*, GLchar*)(&glGetDebugMessageLog);
auto glPushDebugGroup_s = wrapGl!(void, GLenum, GLuint, GLsizei, const(GLchar)*)(&glPushDebugGroup);
auto glPopDebugGroup_s = wrapGl!(void)(&glPopDebugGroup);
auto glObjectLabel_s = wrapGl!(void, GLenum, GLuint, GLsizei, const(GLchar)*)(&glObjectLabel);
auto glGetObjectLabel_s = wrapGl!(void, GLenum, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetObjectLabel);
auto glObjectPtrLabel_s = wrapGl!(void, const(void)*, GLsizei, const(GLchar)*)(&glObjectPtrLabel);
auto glGetObjectPtrLabel_s = wrapGl!(void, const(void)*, GLsizei, GLsizei*, GLchar*)(&glGetObjectPtrLabel);


// GL_ARB_arrays_of_arrays

// GL_ARB_clear_buffer_object

auto glClearBufferData_s = wrapGl!(void, GLenum, GLenum, GLenum, GLenum, const(void)*)(&glClearBufferData);
auto glClearBufferSubData_s = wrapGl!(void, GLenum, GLenum, GLintptr, GLsizeiptr, GLenum, GLenum, const(void)*)(&glClearBufferSubData);
auto glClearNamedBufferDataEXT_s = wrapGl!(void, GLuint, GLenum, GLenum, GLenum, const(void)*)(&glClearNamedBufferDataEXT);
auto glClearNamedBufferSubDataEXT_s = wrapGl!(void, GLuint, GLenum, GLenum, GLenum, GLsizeiptr, GLsizeiptr, const(void)*)(&glClearNamedBufferSubDataEXT);


// GL_ARB_compute_shader

auto glDispatchCompute_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glDispatchCompute);
auto glDispatchComputeIndirect_s = wrapGl!(void, GLintptr)(&glDispatchComputeIndirect);


// GL_ARB_copy_image

auto glCopyImageSubData_s = wrapGl!(void, GLuint, GLenum, GLint, GLint, GLint, GLint, GLuint, GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei)(&glCopyImageSubData);


// GL_ARB_texture_view

auto glTextureView_s = wrapGl!(void, GLuint, GLenum, GLuint, GLenum, GLuint, GLuint, GLuint, GLuint)(&glTextureView);


// GL_ARB_vertex_attrib_binding

auto glBindVertexBuffer_s = wrapGl!(void, GLuint, GLuint, GLintptr, GLsizei)(&glBindVertexBuffer);
auto glVertexAttribFormat_s = wrapGl!(void, GLuint, GLint, GLenum, GLboolean, GLuint)(&glVertexAttribFormat);
auto glVertexAttribIFormat_s = wrapGl!(void, GLuint, GLint, GLenum, GLuint)(&glVertexAttribIFormat);
auto glVertexAttribLFormat_s = wrapGl!(void, GLuint, GLint, GLenum, GLuint)(&glVertexAttribLFormat);
auto glVertexAttribBinding_s = wrapGl!(void, GLuint, GLuint)(&glVertexAttribBinding);
auto glVertexBindingDivisor_s = wrapGl!(void, GLuint, GLuint)(&glVertexBindingDivisor);
auto glVertexArrayBindVertexBufferEXT_s = wrapGl!(void, GLuint, GLuint, GLuint, GLintptr, GLsizei)(&glVertexArrayBindVertexBufferEXT);
auto glVertexArrayVertexAttribFormatEXT_s = wrapGl!(void, GLuint, GLuint, GLint, GLenum, GLboolean, GLuint)(&glVertexArrayVertexAttribFormatEXT);
auto glVertexArrayVertexAttribIFormatEXT_s = wrapGl!(void, GLuint, GLuint, GLint, GLenum, GLuint)(&glVertexArrayVertexAttribIFormatEXT);
auto glVertexArrayVertexAttribLFormatEXT_s = wrapGl!(void, GLuint, GLuint, GLint, GLenum, GLuint)(&glVertexArrayVertexAttribLFormatEXT);
auto glVertexArrayVertexAttribBindingEXT_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glVertexArrayVertexAttribBindingEXT);
auto glVertexArrayVertexBindingDivisorEXT_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glVertexArrayVertexBindingDivisorEXT);


// GL_ARB_robustness_isolation

// GL_ARB_ES3_compatibility

// GL_ARB_explicit_uniform_location

// GL_ARB_fragment_layer_viewport

// GL_ARB_framebuffer_no_attachments

auto glFramebufferParameteri_s = wrapGl!(void, GLenum, GLenum, GLint)(&glFramebufferParameteri);
auto glGetFramebufferParameteriv_s = wrapGl!(void, GLenum, GLenum, GLint*)(&glGetFramebufferParameteriv);
auto glNamedFramebufferParameteriEXT_s = wrapGl!(void, GLuint, GLenum, GLint)(&glNamedFramebufferParameteriEXT);
auto glGetNamedFramebufferParameterivEXT_s = wrapGl!(void, GLuint, GLenum, GLint*)(&glGetNamedFramebufferParameterivEXT);


// GL_ARB_internalformat_query2

auto glGetInternalformati64v_s = wrapGl!(void, GLenum, GLenum, GLenum, GLsizei, GLint64*)(&glGetInternalformati64v);


// GL_ARB_invalidate_subdata

auto glInvalidateTexSubImage_s = wrapGl!(void, GLuint, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei)(&glInvalidateTexSubImage);
auto glInvalidateTexImage_s = wrapGl!(void, GLuint, GLint)(&glInvalidateTexImage);
auto glInvalidateBufferSubData_s = wrapGl!(void, GLuint, GLintptr, GLsizeiptr)(&glInvalidateBufferSubData);
auto glInvalidateBufferData_s = wrapGl!(void, GLuint)(&glInvalidateBufferData);
auto glInvalidateFramebuffer_s = wrapGl!(void, GLenum, GLsizei, const(GLenum)*)(&glInvalidateFramebuffer);
auto glInvalidateSubFramebuffer_s = wrapGl!(void, GLenum, GLsizei, const(GLenum)*, GLint, GLint, GLsizei, GLsizei)(&glInvalidateSubFramebuffer);


// GL_ARB_multi_draw_indirect

auto glMultiDrawArraysIndirect_s = wrapGl!(void, GLenum, const(void)*, GLsizei, GLsizei)(&glMultiDrawArraysIndirect);
auto glMultiDrawElementsIndirect_s = wrapGl!(void, GLenum, GLenum, const(void)*, GLsizei, GLsizei)(&glMultiDrawElementsIndirect);


// GL_ARB_program_interface_query

auto glGetProgramInterfaceiv_s = wrapGl!(void, GLuint, GLenum, GLenum, GLint*)(&glGetProgramInterfaceiv);
auto glGetProgramResourceIndex_s = wrapGl!(GLuint, GLuint, GLenum, const(GLchar)*)(&glGetProgramResourceIndex);
auto glGetProgramResourceName_s = wrapGl!(void, GLuint, GLenum, GLuint, GLsizei, GLsizei*, GLchar*)(&glGetProgramResourceName);
auto glGetProgramResourceiv_s = wrapGl!(void, GLuint, GLenum, GLuint, GLsizei, const(GLenum)*, GLsizei, GLsizei*, GLint*)(&glGetProgramResourceiv);
auto glGetProgramResourceLocation_s = wrapGl!(GLint, GLuint, GLenum, const(GLchar)*)(&glGetProgramResourceLocation);
auto glGetProgramResourceLocationIndex_s = wrapGl!(GLint, GLuint, GLenum, const(GLchar)*)(&glGetProgramResourceLocationIndex);


// GL_ARB_robust_buffer_access_behavior

// GL_ARB_shader_image_size

// GL_ARB_shader_storage_buffer_object

auto glShaderStorageBlockBinding_s = wrapGl!(void, GLuint, GLuint, GLuint)(&glShaderStorageBlockBinding);


// GL_ARB_stencil_texturing

// GL_ARB_texture_buffer_range

auto glTexBufferRange_s = wrapGl!(void, GLenum, GLenum, GLuint, GLintptr, GLsizeiptr)(&glTexBufferRange);
auto glTextureBufferRangeEXT_s = wrapGl!(void, GLuint, GLenum, GLenum, GLuint, GLintptr, GLsizeiptr)(&glTextureBufferRangeEXT);


// GL_ARB_texture_query_levels

// GL_ARB_texture_storage_multisample

auto glTexStorage2DMultisample_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLboolean)(&glTexStorage2DMultisample);
auto glTexStorage3DMultisample_s = wrapGl!(void, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei, GLboolean)(&glTexStorage3DMultisample);
auto glTextureStorage2DMultisampleEXT_s = wrapGl!(void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLboolean)(&glTextureStorage2DMultisampleEXT);
auto glTextureStorage3DMultisampleEXT_s = wrapGl!(void, GLuint, GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei, GLboolean)(&glTextureStorage3DMultisampleEXT);


