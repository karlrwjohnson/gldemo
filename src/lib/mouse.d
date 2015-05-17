import std_all;

import glut;

struct MouseState {
    int x;
    int y;

    bool left;
    bool middle;
    bool right;

    bool opIndex (int button) {
        switch (button) {
            case GLUT_LEFT_BUTTON:   return left;
            case GLUT_MIDDLE_BUTTON: return middle;
            case GLUT_RIGHT_BUTTON:  return right;
            default: throw new Exception("Unknown button ID " ~ to!string(button));
        }
    }

    int opIndexAssign (int state, int button) {
        bool v;
        switch (state) {
            case GLUT_DOWN: v = true;  break;
            case GLUT_UP:   v = false; break;
            default: throw new Exception("Unknown button state ID " ~ to!string(state));
        }
        switch (button) {
            case GLUT_LEFT_BUTTON:   left   = v; return state;
            case GLUT_MIDDLE_BUTTON: middle = v; return state;
            case GLUT_RIGHT_BUTTON:  right  = v; return state;
            default: throw new Exception("Unknown button ID " ~ to!string(button));
        }
    }

    bool opIndexAssign (bool state, int button) {
        switch (button) {
            case GLUT_LEFT_BUTTON:   left   = state; return state;
            case GLUT_MIDDLE_BUTTON: middle = state; return state;
            case GLUT_RIGHT_BUTTON:  right  = state; return state;
            default: throw new Exception("Unknown button ID " ~ to!string(button));
        }
    }
}