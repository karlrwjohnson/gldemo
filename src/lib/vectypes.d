import std.array;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.traits;

alias GLfloat = float;
alias vec2 = vec!2;
alias vec3 = vec!3;
alias vec4 = vec!4;
alias mat2 = mat!2;
alias mat3 = mat!3;
alias mat4 = mat!4;

/// Property mixin for aliasing single elements of vectors as letter attributes, e.g. vec3.x, vec3.y, etc.
mixin template TVecAccessor(Type, string Symbol, string Variable) {
	mixin(format(
		"%s %s () const @property { return %s; }",
		fullyQualifiedName!(Type),
		Symbol,
		Variable
	));

	mixin(format(
		"void %s (%s value) @property { %s = value; }",
		Symbol,
		fullyQualifiedName!(Type),
		Variable
	));
}

/**
 * Property mixin for aliasing pairs of elements of a vector as 2-element sub-vectors.
 * E.g. vec3.xz returns a vec2 consisting of the vec3's 0th and 2nd elements as the vec2's 0th and 1st elements
 * This imitates multiple-element properties of vectors in GLSL.
 */
mixin template TVecMultiAccessor2(Type, string Symbol, string Variable, size_t i, size_t j) {
	static const string sType = chompPrefix(fullyQualifiedName!(Type), moduleName!(Type) ~ ".");

	mixin(format(
		"%s %s () const @property {
			return %s ( %s[%d], %s[%d] );
		}",
		sType, Symbol,
		sType,
		Variable, i,
		Variable, j
	));
	mixin(format(
		"void %s (%s value) @property {
			%s[%u] = value[0];
			%s[%u] = value[1];
		}",
		Symbol, sType,
		Variable, i,
		Variable, j
	));
}

/**
 * Property mixin for aliasing three elements of a vector as 3-element sub-vectors.
 * (See TVecMultiAccessor2 for more information)
 */
mixin template TVecMultiAccessor3(Type, string Symbol, string Variable, size_t i, size_t j, size_t k) {
	static const string sType = chompPrefix(fullyQualifiedName!(Type), moduleName!(Type));

	mixin(format(
		"%s %s () const @property {
			return %s ( %s[%d], %s[%d], %s[%d] );
		}",
		sType, Symbol,
		sType,
		Variable, i,
		Variable, j,
		Variable, k
	));
	mixin(format(
		"void %s (%s value) @property {
			%s[%u] = value[0];
			%s[%u] = value[1];
			%s[%u] = value[2];
		}",
		Symbol, sType,
		Variable, i,
		Variable, j,
		Variable, k
	));
}

/**
 * Property mixin for aliasing four elements of a vector as 4-element sub-vectors.
 * (See TVecMultiAccessor2 for more information)
 */
mixin template TVecMultiAccessor4(Type, string Symbol, string Variable, size_t i, size_t j, size_t k, size_t l) {
	static const string sType = chompPrefix(fullyQualifiedName!(Type), moduleName!(Type));

	mixin(format(
		"%s %s () const @property {
			return %s ( %s[%d], %s[%d], %s[%d], %s[%d] );
		}",
		sType, Symbol,
		sType,
		Variable, i,
		Variable, j,
		Variable, k,
		Variable, l
	));
	mixin(format(
		"void %s (%s value) @property {
			%s[%u] = value[0];
			%s[%u] = value[1];
			%s[%u] = value[2];
			%s[%u] = value[3];
		}",
		Symbol, sType,
		Variable, i,
		Variable, j,
		Variable, k,
		Variable, l
	));
}

struct vec (size_t Arity) {
	GLfloat[Arity] data = array(0f.repeat.take(Arity));

	this (in GLfloat[Arity] data...) {
		this.data[] = data[];
	}

	// Single-variable accessors

	mixin TVecAccessor!(GLfloat, "x", "data[0]");
	mixin TVecAccessor!(GLfloat, "y", "data[1]");
	static if (Arity >= 3)
		mixin TVecAccessor!(GLfloat, "z", "data[2]");
	static if (Arity >= 4)
		mixin TVecAccessor!(GLfloat, "w", "data[3]");
	
	mixin TVecMultiAccessor2!(vec!2, "xy", "data", 0, 1);
	mixin TVecMultiAccessor2!(vec!2, "yx", "data", 1, 0);

	// Multiple--variable accessors

	static if (Arity >= 3) {
		mixin TVecMultiAccessor2!(vec!2, "yz", "data", 1, 2);
		mixin TVecMultiAccessor2!(vec!2, "xz", "data", 0, 2);
		mixin TVecMultiAccessor2!(vec!2, "zy", "data", 2, 1);
		mixin TVecMultiAccessor2!(vec!2, "zx", "data", 2, 0);

		mixin TVecMultiAccessor3!(vec!3, "xyz", "data", 0, 1, 2);
		mixin TVecMultiAccessor3!(vec!3, "yzx", "data", 1, 2, 0);
		mixin TVecMultiAccessor3!(vec!3, "zxy", "data", 2, 0, 1);
		mixin TVecMultiAccessor3!(vec!3, "zyx", "data", 2, 1, 0);
		mixin TVecMultiAccessor3!(vec!3, "yxz", "data", 1, 0, 2);
		mixin TVecMultiAccessor3!(vec!3, "xzy", "data", 0, 2, 1);
	}
	static if (Arity >= 4) {
		mixin TVecMultiAccessor2!(vec!2, "xw", "data", 0, 3);
		mixin TVecMultiAccessor2!(vec!2, "yw", "data", 1, 3);
		mixin TVecMultiAccessor2!(vec!2, "zw", "data", 2, 3);
		mixin TVecMultiAccessor2!(vec!2, "wx", "data", 3, 0);
		mixin TVecMultiAccessor2!(vec!2, "wy", "data", 3, 1);
		mixin TVecMultiAccessor2!(vec!2, "wz", "data", 3, 2);

		mixin TVecMultiAccessor3!(vec!3, "xyw", "data", 0, 1, 3);
		mixin TVecMultiAccessor3!(vec!3, "xzw", "data", 0, 2, 3);
		mixin TVecMultiAccessor3!(vec!3, "yzw", "data", 1, 2, 3);

		mixin TVecMultiAccessor3!(vec!3, "ywx", "data", 1, 3, 0);
		mixin TVecMultiAccessor3!(vec!3, "zwx", "data", 2, 3, 0);
		mixin TVecMultiAccessor3!(vec!3, "zwy", "data", 2, 3, 1);

		mixin TVecMultiAccessor3!(vec!3, "wxy", "data", 3, 0, 1);
		mixin TVecMultiAccessor3!(vec!3, "wxz", "data", 3, 0, 2);
		mixin TVecMultiAccessor3!(vec!3, "wyz", "data", 3, 1, 2);

		mixin TVecMultiAccessor3!(vec!3, "wyx", "data", 3, 1, 0);
		mixin TVecMultiAccessor3!(vec!3, "wzx", "data", 3, 2, 0);
		mixin TVecMultiAccessor3!(vec!3, "wzy", "data", 3, 2, 1);
		                                                       
		mixin TVecMultiAccessor3!(vec!3, "xwy", "data", 0, 3, 1);
		mixin TVecMultiAccessor3!(vec!3, "xwz", "data", 0, 3, 2);
		mixin TVecMultiAccessor3!(vec!3, "ywz", "data", 1, 3, 2);
                                                               
		mixin TVecMultiAccessor3!(vec!3, "yxw", "data", 1, 0, 3);
		mixin TVecMultiAccessor3!(vec!3, "zxw", "data", 2, 0, 3);
		mixin TVecMultiAccessor3!(vec!3, "zyw", "data", 2, 1, 3);
		
		mixin TVecMultiAccessor4!(vec!4, "xyzw", "data", 0, 1, 2, 3);
	}



	// Operators
	
	vec!Arity opBinary(string op)(in vec!(Arity) rhs)
		if ((op == "+") || (op == "-"))
	{
		GLfloat temp[Arity];
		mixin("temp[] = data[] " ~ op ~ " rhs.data[];");
		return vec!Arity(temp);
	}

	vec!Arity opUnary(string op)()
		if ((op == "-") || (op == "+"))
	{
		GLfloat temp[Arity];
		mixin("temp[] = " ~ op ~ " data[];");
		return vec!Arity(temp);
	}

	vec!Arity opBinary(string op)(in GLfloat rhs)
	{
		GLfloat temp[Arity];
		mixin("temp[] = data[] " ~ op ~ " rhs;");
		return vec!Arity(temp);
	}

	/** Dot product **/
	GLfloat opBinary(string op)(in vec!(Arity) rhs)
		if (op == "*")
	{
		GLfloat products[Arity];
		GLfloat ret = 0;
		products[] = data[] * rhs.data[];
		foreach (product; products) {
			ret += product;
		}
		return ret;
	}

	/** Cross product **/
	static if (Arity == 3) {
		vec!Arity opBinary(string op)(in vec!(Arity) rhs)
			if (op == "^^")
		{
			return vec!Arity(
				this.y * rhs.z - rhs.y * this.z,
				this.z * rhs.x - rhs.z * this.x,
				this.x * rhs.y - rhs.x * this.y
			);
		}
	}
	static if (Arity == 4) {
		vec!Arity opBinary(string op)(in vec!(Arity) rhs)
			if (op == "^^")
		{
			return vec!Arity(
				this.y * rhs.z - rhs.y * this.z,
				this.z * rhs.x - rhs.z * this.x,
				this.x * rhs.y - rhs.x * this.y,
				0
			);
		}
	}
	
	bool opEquals()(auto ref const vec!(Arity) rhs) {
		return data[] == rhs.data[];
	}
	
	bool opEquals()(auto ref const GLfloat[Arity] rhs) {
		return data[] == rhs[];
	}

	GLfloat opIndex(size_t index) {
		return this.data[index];
	}

	GLfloat opIndexAssign(GLfloat value, size_t index) {
		return this.data[index] = value;
	}

	GLfloat opIndexOpAssign(string op)(GLfloat value, size_t index) {
		mixin ("return this.data[index] " ~ op ~ "= value;");
	}

	// Compose a vector by concatenating two other vectors together
	// It's commented out because it didn't work, but I want to try again later.
	/*vec!(Arity + RArity) opBinary(string op, RArity)(in vec!RArity rhs)
		if (op == "~")
	{
		GLfloat temp[Arity + RArity];
		temp[0..Arity] = data[];
		temp[Arity..Arity+RArity] = rhs;
		return vec!Arity(temp);
	}*/

	//vec!Arity opCast(T : vec!Arity)()
	
	GLfloat* ptr() @property {
		return &data[0];
	}

	size_t size() @property {
		return Arity * Arity * GLfloat.sizeof;
	}

	string toString() {
		string ret = "vec!(" ~ to!string(Arity) ~ ")[ ";
		foreach (i; data)
			ret ~= to!string(i) ~ " ";
		return ret ~ "]";
	}

	vec!Arity norm() {
		return this / sqrt(this * this);
	}
}

/// Vectors may be initialized using and compared to a vanilla data
unittest {
	vec3 a = vec3([1,2,3]);
	vec3 b = [1,2,3];
	vec3 c = vec3(1,2,3);
	assert(a == b);
	assert(a == c);
	assert(a == [1,2,3]);
}

/// Vectors may be subscripted by index or by letter identifier
unittest {
	vec4 myvec;

	myvec[0] = 3;
	myvec[1] = 2;
	myvec[2] = 5;
	myvec[3] = 7;

	assert(myvec.x == 3);
	assert(myvec.y == 2);
	assert(myvec.z == 5);
	assert(myvec.w == 7);

	myvec.x = 17;
	myvec.y = 18;
	myvec.z = 20;
	myvec.w = 13;

	assert(myvec[0] == 17);
	assert(myvec[1] == 18);
	assert(myvec[2] == 20);
	assert(myvec[3] == 13);
}

/**
 * Sub-vectors may be accessed by every permutation of [xyzw]{3}, assuming the
 * original vector has that many elements.
 * (Only one 4-element permutation, xyzw, is supported so far however.)
 */
unittest {
	auto a = vec4(24,25,26,27);
	assert(a.xy == vec2(24,25));
	assert(a.zwx == vec3(26,27,24));
	assert(a.xyzw == a);

	a.yz = a.zy;
	assert(a == vec4(24,26,25,27));
}

/// Vectors may be added and subtracted.
unittest {
	auto a = vec2(2,3);
	auto b = vec2(4,5);
	auto sum = a + b;
	auto diff = b - a;

	assert(sum == vec2([6,8]));
	assert(diff == [2,2]);
}

/// Vectors support dot products through the "*" operator
unittest {
	auto a = vec3(1,2,3);
	auto b = vec3(4,-5,6);
	assert(a * b == 4*1 - 2*5 + 3*6);
}

/// vec3 and vec4 support cross products through the "^^" (exponentiation) operator
unittest {
	{
		auto i = vec3(1,0,0);
		auto j = vec3(0,1,0);
		auto k = vec3(0,0,1);
		assert(i ^^ j == k);
		assert(j ^^ k == i);
		assert(k ^^ i == j);
	}
	{
		auto i = vec4(1,0,0,0);
		auto j = vec4(0,1,0,0);
		auto k = vec4(0,0,1,0);
		assert(i ^^ j == k);
		assert(j ^^ k == i);
		assert(k ^^ i == j);
	}
}

/// Vectors may be negated.
unittest {
	auto i = vec3(3,2,1);
	assert(-i == vec3(-3,-2,-1));
}

/// Row-major matrices
struct mat(size_t Arity) {
	GLfloat[Arity*Arity] data = array(0f.repeat().take(Arity*Arity));

	/// Construct with a constant value along the diagonal
	this (in GLfloat diagonalValue) {
		for (size_t i = 0; i < Arity * Arity; i += Arity + 1) {
			this.data[i] = diagonalValue;
		}
	}

	/// Construct with a vector to diagonalize
	this (in GLfloat[Arity] diagonal...) {
		for (size_t i = 0, j = 0; j < Arity; i += Arity + 1, j++) {
			this.data[i] = diagonal[j];
		}
	}

	this (in vec!Arity diagonal) {
		this(diagonal.data);
	}

	this (in GLfloat[Arity*Arity] data...) {
		this.data[] = data;
	}
	this (in GLfloat[Arity][Arity] rows...) {
		for (size_t i = 0; i < Arity; i++) {
			this.data[i*Arity .. (i+1)*Arity] = rows[i][];
		}
	}
	this (in vec!Arity[Arity] rows...) {
		for (size_t i = 0; i < Arity; i++) {
			this.data[i*Arity .. (i+1)*Arity] = rows[i].data[];
		}
	}

	bool opEquals()(auto ref const mat!Arity rhs) {
		return data[] == rhs.data[];
	}
	
	bool opEquals()(auto ref const GLfloat[Arity*Arity] rhs) {
		return data[] == rhs[];
	}
	
	bool opEquals()(auto ref const GLfloat[Arity][Arity] rhs) {
		return this == mat!Arity(rhs);
	}
	
	bool opEquals()(auto ref const vec!Arity[Arity] rhs) {
		return this == mat!Arity(rhs);
	}

	inout vec!Arity opIndex(size_t row) inout {
		GLfloat[Arity] temp = data[row*Arity .. (row+1)*Arity];
		return vec!Arity(temp);
	}

	inout GLfloat opIndex(size_t row, size_t column) inout {
		return data[row*Arity + column];
	}

	vec!Arity opIndexAssign(vec!Arity vector, size_t row) {
		data[row*Arity .. (row+1)*Arity] = vector.data;
		return vector;
	}
	
	GLfloat[Arity] opIndexAssign(GLfloat[Arity] vector, size_t row) {
		data[row*Arity .. (row+1)*Arity] = vector[];
		return vector;
	}

	GLfloat opIndexAssign(GLfloat value, size_t row, size_t column) {
		return data[row*Arity + column] = value;
	}
	
	GLfloat opIndexOpAssign(string op)(GLfloat value, size_t row, size_t column) {
		mixin("data[row*Arity + column] " ~ op ~ "value'");
	}
	
	GLfloat* ptr() @property {
		return &data[0];
	}

	size_t size() @property {
		return Arity * Arity * GLfloat.sizeof;
	}
	
	mat!Arity opBinary(string op)(in mat!Arity rhs)
		if ((op == "+") || (op == "-"))
	{
		GLfloat temp[Arity];
		mixin("temp[] = data[] " ~ op ~ " rhs.data[];");
		return mat!Arity(temp);
	}

	mat!Arity opUnary(string op)()
		if ((op == "-") || (op == "+"))
	{
		GLfloat temp[Arity];
		mixin("temp[] = " ~ op ~ " data[];");
		return mat!Arity(temp);
	}

	vec!Arity opBinary(string op)(in vec!Arity rhs)
		if (op == "*")
	{
		vec!Arity temp;
		for (size_t i = 0; i < Arity; i++) {
			temp[i] = this[i] * rhs;
		}
		return temp;
	}

	vec!Arity opBinaryRight(string op)(in vec!Arity lhs)
		if (op == "*")
	{
		vec!Arity temp;
		for (size_t c = 0; c < Arity; c++) {
			for (size_t r = 0; r < Arity; r++) {
				temp[c] += lhs[r] * this[r,c];
			}
		}

	}

	mat!Arity opBinary(string op)(in mat!Arity rhs)
		if (op == "*")
	{
		mat!Arity temp;
		for (size_t r = 0; r < Arity; r++) {
			for (size_t c = 0; c < Arity; c++) {
				for (size_t i = 0; i < Arity; i++) {
					temp.data[r * Arity + c] += this[r,i] * rhs[i,c];
				}
			}
		}
		return temp;
	}

	string toString() {
		string ret = "mat!(" ~ to!string(Arity) ~ ")[ ";
		for (size_t r = 0; r < Arity; r++) {
			for (size_t c = 0; c < Arity; c++) {
				ret ~= to!string(data[r * Arity + c]) ~ " ";
			}
			ret ~= "]\n       [ ";
		}
		return chomp(ret, "\n       [ ");
	}

/*	/// Matrix inverse implemented with the bitwise negation operator
	mat!Arity opUnary(string op)()
		if (op == "~")
	{

	}*/

	mat!Arity transpose() {
		mat!Arity temp;
		for (size_t r = 0; r < Arity; r++) {
			for (size_t c = 0; c < Arity; c++) {
				temp.data[r * Arity + c] = this.data[c * Arity + r];
			}
		}
		return temp;
	}

};

/**
 * Matrices may be constructed by 1D or 2D datas or as an data of vec!Arity structs.
 * Matrices may be compared to other matrices or any of these initializers.
 */
unittest {
	mat3 a = [ 1,2,3, 4,5,6, 7,8,9 ];
	mat3 b = [ [1,2,3], [4,5,6], [7,8,9] ];
	mat3 c = [ vec3(1,2,3), vec3(4,5,6), vec3(7,8,9) ];
	assert(a == b);
	assert(a == c);
	assert(a == [ 1,2,3, 4,5,6, 7,8,9 ]);
	assert(a == [ [1,2,3], [4,5,6], [7,8,9] ]);
	assert(a == [ vec3(1,2,3), vec3(4,5,6), vec3(7,8,9) ]);
}

/**
 * Matrices may be constructed using scalars or vectors which define the diagonal.
 * This is useful for creating the identiy matrix I = mat!N(1) or diagonalizing vectors.
 * The empty constructor, however, produces a zeroed matrix.
 */
unittest {
	assert(mat2()  == [ [0,0], [0,0] ]);
	assert(mat2(5) == [ [5,0], [0,5] ]);
	assert(mat3(1,2,3)   == [ [1,0,0], [0,2,0], [0,0,3] ]);
	assert(mat3([1,2,3]) == [ [1,0,0], [0,2,0], [0,0,3] ]);
}

/**
 * Elements may be accessed by column or (column, row).
 * Columns may be assigned by bare data or by a vec!Arity struct.
 */
unittest {
	mat3 a = [ 1,2,3, 4,5,6, 7,8,9 ];

	a[1] = [10,11,12];
	a[2] = vec3(20,21,22);
	assert(a[1] == [10,11,12]);
	assert(a[2] == vec3(20,21,22));

	assert(a[0,1] == 2);
	a[0,2] = 17;
	assert(a[0,2] == 17);
}

/// Transpose
unittest {
	assert(mat2([[1,2],[3,4]]).transpose == mat2([[1,3],[2,4]]));
}

mat4 Identity () {
	static const IDENTITY = mat4(1,0,0,0,
	                             0,1,0,0,
	                             0,0,1,0,
	                             0,0,0,1);
	return IDENTITY;
}

mat4 Translate (size_t N) (vec!N delta)
	if (N >= 3)
{
	return mat4(1,0,0,delta.x,
				0,1,0,delta.y,
				0,0,1,delta.z,
				0,0,0,1);
}

mat4 Translate (float x, float y, float z)
{
	return mat4(1,0,0,x,
				0,1,0,y,
				0,0,1,z,
				0,0,0,1);
}

mat4 Scale (vec3 factor) {
	return mat4( factor.x, 0,0,0,
				0, factor.y, 0,0,
				0,0, factor.z, 0,
				0,0,0,         1);
}

mat4 Scale (GLfloat factor) {
	return mat4( factor, 0,0,0,
				0, factor, 0,0,
				0,0, factor, 0,
				0,0,0,       1);
}

mat4 RotateX (string degrees = "") (GLfloat radians) {
	static if (degrees != "") {
		radians = radians * PI / 180f;
	}
	return mat4(1,0,0,0,
				0, cos(radians), sin(radians),0,
	            0,-sin(radians), cos(radians),0,
	            0,0,0,1);
}

mat4 RotateY (string degrees = "") (GLfloat radians) {
	static if (degrees != "") {
		radians = radians * PI / 180f;
	}
	return mat4( cos(radians),0,-sin(radians),0,
	            0,1,0,0,
	             sin(radians),0, cos(radians),0,
	            0,0,0,1);
}

mat4 RotateZ (string degrees = "") (GLfloat radians) {
	static if (degrees != "") {
		radians = radians * PI / 180f;
	}
	return mat4( cos(radians), sin(radians),0,0,
	            -sin(radians), cos(radians),0,0,
	            0,0,1,0,
	            0,0,0,1);
}

mat4 Perspective (GLfloat fovy, GLfloat aspect, GLfloat near, GLfloat far) {
	GLfloat top   = tan(fovy * PI/180 / 2) * near;
	GLfloat right = top * aspect;

	mat4 temp;
	temp[0,0] = near / right;
	temp[1,1] = near / top;
	temp[2,2] = -(far + near) / (far - near);
	temp[2,3] = -2f * far * near / (far - near);
	temp[3,2] = -1f;
	return temp;
}

mat4 LookAt (vec4 eye, vec4 at, vec4 up) {
	vec4 n = (eye - at).norm;
	vec4 u = (up ^^ n).norm;
	vec4 v = (n ^^ u).norm;
	vec4 t = [0,0,0,1];
	return mat4(u,v,n,t) * Translate(-eye);
}
