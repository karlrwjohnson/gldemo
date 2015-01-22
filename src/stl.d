import std.conv;
import std.regex;
import std.stdio;
import std.typecons;

import vectypes;

Tuple!(vec3[],vec3[]) loadStl (string filename) {
	auto file = File(filename, "r");

	const string FLOAT = r"(-?[0-9]+|-?[0-9]*\.[0-9]+)";
	const string WHITESPACE = r"\s+";
	auto regex_facet_normal = ctRegex!("facet" ~ WHITESPACE ~ "normal" ~ WHITESPACE ~ FLOAT ~ WHITESPACE ~ FLOAT ~ WHITESPACE ~ FLOAT ~ r"\s*$");
	auto regex_vertex = ctRegex!("vertex" ~ WHITESPACE ~ FLOAT ~ WHITESPACE ~ FLOAT ~ WHITESPACE ~ FLOAT ~ r"\s*$");
	auto regex_end_facet = ctRegex!("endfacet");

	vec3[] ret_points;
	vec3[] ret_normals;

	vec3 normal;
	vec3[] points;
	int i = 0;
	for (string line = file.readln(); line !is null; line = file.readln(), i++) {
		auto match_facet_normal = matchFirst(line, regex_facet_normal);
		if (match_facet_normal.length > 0) {
			normal = vec3(to!GLfloat(match_facet_normal[1]), to!GLfloat(match_facet_normal[2]), to!GLfloat(match_facet_normal[3]));
			continue;
		}

		auto match_vertex = matchFirst(line, regex_vertex);
		if (match_vertex.length > 0) {
			points ~= vec3(to!GLfloat(match_vertex[1]), to!GLfloat(match_vertex[2]), to!GLfloat(match_vertex[3]));
			continue;
		}

		if (matchFirst(line, regex_end_facet).length > 0) {
			if (points.length != 3) {
				throw new Exception("Error on line " ~ to!string(i) ~ " of " ~ filename ~
					": There were " ~ to!string(points.length) ~ "points defined in that last shape; expected 3.");
			}

			else {
				ret_points ~= points;
				points = [];
				ret_normals ~= normal;
				ret_normals ~= normal;
				ret_normals ~= normal;
			}
			continue;
		}

	}

	return tuple(ret_points, ret_normals);
}