module gl;

alias GLenum        = uint;
alias GLbitfield    = uint;
alias GLuint        = uint;
alias GLint         = int;
alias GLsizei       = int;
alias GLboolean     = ubyte;
alias GLbyte        = byte;
alias GLshort       = short;
alias GLubyte       = ubyte;
alias GLushort      = ushort;
alias GLulong       = ulong;
alias GLfloat       = float;
alias GLclampf      = float;
alias GLdouble      = double;
alias GLclampd      = double;
alias GLvoid        = void;
alias GLint64EXT    = int64_t;
alias GLuint64EXT   = uint64_t;
alias GLint64       = GLint64EXT;
alias GLuint64      = GLuint64EXT;
alias GLchar        = char;

extern (C) GLenum glGetError();

extern (C) void glAttachShader (programId, shaderId);
extern (C) void glBindBuffer (GL_ARRAY_BUFFER, vbo);
extern (C) void glBindVertexArray (vao);
extern (C) void glBufferData (GL_ARRAY_BUFFER, attribute.dataSize * sizeof(GLfloat),
extern (C) void glClearColor (0.0, 0.0, 0.0, 0.0);
extern (C) void glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
extern (C) void glCompileShader (shaderId);
extern (C) void glEnableVertexAttribArray (attributeId);
extern (C) void glGenBuffers (1, &vbo);
extern (C) void glGenVertexArrays (1, &vao);
extern (C) void glGetProgramInfoLog (programId, buflen, NULL, msgBuffer->data());
extern (C) void glGetProgramiv (programId, GL_INFO_LOG_LENGTH, &buflen);
extern (C) void glGetProgramiv (programId, GL_LINK_STATUS, &status);
extern (C) void glGetShaderInfoLog (shaderId, buflen, NULL, msgBuffer->data());
extern (C) void glGetShaderiv (shaderId, GL_COMPILE_STATUS, &status);
extern (C) void glGetShaderiv (shaderId, GL_INFO_LOG_LENGTH, &buflen);
extern (C) void glLinkProgram (programId);
extern (C) void glShaderSource (shaderId, 1, &shaderSrcPtr, NULL);
extern (C) void glUseProgram (programId);
extern (C) void glVertexAttribPointer (attributeId, attribute.elementsPerVertex, GL_FLOAT, GL_FALSE, 0, 0);
extern (C) void glViewport (0, 0, width, height);
extern (C) GLint glGetAttribLocation (programId, attribute.name.c_str());
extern (C) GLuint glCreateProgram);
extern (C) GLuint glCreateShader (source.first);

