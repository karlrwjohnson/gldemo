#include <algorithm>
#include <exception>
#include <iostream>
#include <memory>
#include <list>
#include <set>
#include <stdexcept>
#include <string>
#include <sstream>

#include <GL/glew.h>
#include <GL/freeglut.h>

void quit();
void init();

void onDisplay();
void onKeyDown(unsigned char key, int x, int y);
void onSpecialKeyDown(int key, int x, int y);
void onKeyUp(unsigned char key, int x, int y);
void onSpecialKeyDown(int key, int x, int y);

