module glut;

import derelict.opengl3.gl3;

extern (C) alias GlutCallback_void  = void function ();
extern (C) alias GlutCallback_i     = void function (int);
extern (C) alias GlutCallback_ub_2i = void function (ubyte, int, int);
extern (C) alias GlutCallback_2i    = void function (int, int);
extern (C) alias GlutCallback_3i    = void function (int, int, int);
extern (C) alias GlutCallback_4i    = void function (int, int, int, int);
extern (C) alias GlutCallback_ui_3i = void function (uint, int, int, int);
extern (C) alias GlutCallback_5i    = void function (int, int, int, int, int);

/*
 * GLUT API macro definitions -- the special key codes:
 */
enum GLUT_KEY_F1                        = 0x0001;
enum GLUT_KEY_F2                        = 0x0002;
enum GLUT_KEY_F3                        = 0x0003;
enum GLUT_KEY_F4                        = 0x0004;
enum GLUT_KEY_F5                        = 0x0005;
enum GLUT_KEY_F6                        = 0x0006;
enum GLUT_KEY_F7                        = 0x0007;
enum GLUT_KEY_F8                        = 0x0008;
enum GLUT_KEY_F9                        = 0x0009;
enum GLUT_KEY_F10                       = 0x000A;
enum GLUT_KEY_F11                       = 0x000B;
enum GLUT_KEY_F12                       = 0x000C;
enum GLUT_KEY_LEFT                      = 0x0064;
enum GLUT_KEY_UP                        = 0x0065;
enum GLUT_KEY_RIGHT                     = 0x0066;
enum GLUT_KEY_DOWN                      = 0x0067;
enum GLUT_KEY_PAGE_UP                   = 0x0068;
enum GLUT_KEY_PAGE_DOWN                 = 0x0069;
enum GLUT_KEY_HOME                      = 0x006A;
enum GLUT_KEY_END                       = 0x006B;
enum GLUT_KEY_INSERT                    = 0x006C;

/*
 * GLUT API macro definitions -- mouse state definitions
 */
enum GLUT_LEFT_BUTTON                   = 0x0000;
enum GLUT_MIDDLE_BUTTON                 = 0x0001;
enum GLUT_RIGHT_BUTTON                  = 0x0002;
enum GLUT_DOWN                          = 0x0000;
enum GLUT_UP                            = 0x0001;
enum GLUT_LEFT                          = 0x0000;
enum GLUT_ENTERED                       = 0x0001;

/*
 * GLUT API macro definitions -- the display mode definitions
 */
enum GLUT_RGB                           = 0x0000;
enum GLUT_RGBA                          = 0x0000;
enum GLUT_INDEX                         = 0x0001;
enum GLUT_SINGLE                        = 0x0000;
enum GLUT_DOUBLE                        = 0x0002;
enum GLUT_ACCUM                         = 0x0004;
enum GLUT_ALPHA                         = 0x0008;
enum GLUT_DEPTH                         = 0x0010;
enum GLUT_STENCIL                       = 0x0020;
enum GLUT_MULTISAMPLE                   = 0x0080;
enum GLUT_STEREO                        = 0x0100;
enum GLUT_LUMINANCE                     = 0x0200;

/*
 * GLUT API macro definitions -- windows and menu related definitions
 */
enum GLUT_MENU_NOT_IN_USE               = 0x0000;
enum GLUT_MENU_IN_USE                   = 0x0001;
enum GLUT_NOT_VISIBLE                   = 0x0000;
enum GLUT_VISIBLE                       = 0x0001;
enum GLUT_HIDDEN                        = 0x0000;
enum GLUT_FULLY_RETAINED                = 0x0001;
enum GLUT_PARTIALLY_RETAINED            = 0x0002;
enum GLUT_FULLY_COVERED                 = 0x0003;

/*
 * GLUT API macro definitions -- the glutGet parameters
 */
enum GLUT_WINDOW_X                      = 0x0064;
enum GLUT_WINDOW_Y                      = 0x0065;
enum GLUT_WINDOW_WIDTH                  = 0x0066;
enum GLUT_WINDOW_HEIGHT                 = 0x0067;
enum GLUT_WINDOW_BUFFER_SIZE            = 0x0068;
enum GLUT_WINDOW_STENCIL_SIZE           = 0x0069;
enum GLUT_WINDOW_DEPTH_SIZE             = 0x006A;
enum GLUT_WINDOW_RED_SIZE               = 0x006B;
enum GLUT_WINDOW_GREEN_SIZE             = 0x006C;
enum GLUT_WINDOW_BLUE_SIZE              = 0x006D;
enum GLUT_WINDOW_ALPHA_SIZE             = 0x006E;
enum GLUT_WINDOW_ACCUM_RED_SIZE         = 0x006F;
enum GLUT_WINDOW_ACCUM_GREEN_SIZE       = 0x0070;
enum GLUT_WINDOW_ACCUM_BLUE_SIZE        = 0x0071;
enum GLUT_WINDOW_ACCUM_ALPHA_SIZE       = 0x0072;
enum GLUT_WINDOW_DOUBLEBUFFER           = 0x0073;
enum GLUT_WINDOW_RGBA                   = 0x0074;
enum GLUT_WINDOW_PARENT                 = 0x0075;
enum GLUT_WINDOW_NUM_CHILDREN           = 0x0076;
enum GLUT_WINDOW_COLORMAP_SIZE          = 0x0077;
enum GLUT_WINDOW_NUM_SAMPLES            = 0x0078;
enum GLUT_WINDOW_STEREO                 = 0x0079;
enum GLUT_WINDOW_CURSOR                 = 0x007A;

enum GLUT_SCREEN_WIDTH                  = 0x00C8;
enum GLUT_SCREEN_HEIGHT                 = 0x00C9;
enum GLUT_SCREEN_WIDTH_MM               = 0x00CA;
enum GLUT_SCREEN_HEIGHT_MM              = 0x00CB;
enum GLUT_MENU_NUM_ITEMS                = 0x012C;
enum GLUT_DISPLAY_MODE_POSSIBLE         = 0x0190;
enum GLUT_INIT_WINDOW_X                 = 0x01F4;
enum GLUT_INIT_WINDOW_Y                 = 0x01F5;
enum GLUT_INIT_WINDOW_WIDTH             = 0x01F6;
enum GLUT_INIT_WINDOW_HEIGHT            = 0x01F7;
enum GLUT_INIT_DISPLAY_MODE             = 0x01F8;
enum GLUT_ELAPSED_TIME                  = 0x02BC;
enum GLUT_WINDOW_FORMAT_ID              = 0x007B;

/*
 * GLUT API macro definitions -- the glutDeviceGet parameters
 */
enum GLUT_HAS_KEYBOARD                  = 0x0258;
enum GLUT_HAS_MOUSE                     = 0x0259;
enum GLUT_HAS_SPACEBALL                 = 0x025A;
enum GLUT_HAS_DIAL_AND_BUTTON_BOX       = 0x025B;
enum GLUT_HAS_TABLET                    = 0x025C;
enum GLUT_NUM_MOUSE_BUTTONS             = 0x025D;
enum GLUT_NUM_SPACEBALL_BUTTONS         = 0x025E;
enum GLUT_NUM_BUTTON_BOX_BUTTONS        = 0x025F;
enum GLUT_NUM_DIALS                     = 0x0260;
enum GLUT_NUM_TABLET_BUTTONS            = 0x0261;
enum GLUT_DEVICE_IGNORE_KEY_REPEAT      = 0x0262;
enum GLUT_DEVICE_KEY_REPEAT             = 0x0263;
enum GLUT_HAS_JOYSTICK                  = 0x0264;
enum GLUT_OWNS_JOYSTICK                 = 0x0265;
enum GLUT_JOYSTICK_BUTTONS              = 0x0266;
enum GLUT_JOYSTICK_AXES                 = 0x0267;
enum GLUT_JOYSTICK_POLL_RATE            = 0x0268;

/*
 * GLUT API macro definitions -- the glutLayerGet parameters
 */
enum GLUT_OVERLAY_POSSIBLE              = 0x0320;
enum GLUT_LAYER_IN_USE                  = 0x0321;
enum GLUT_HAS_OVERLAY                   = 0x0322;
enum GLUT_TRANSPARENT_INDEX             = 0x0323;
enum GLUT_NORMAL_DAMAGED                = 0x0324;
enum GLUT_OVERLAY_DAMAGED               = 0x0325;

/*
 * GLUT API macro definitions -- the glutVideoResizeGet parameters
 */
enum GLUT_VIDEO_RESIZE_POSSIBLE         = 0x0384;
enum GLUT_VIDEO_RESIZE_IN_USE           = 0x0385;
enum GLUT_VIDEO_RESIZE_X_DELTA          = 0x0386;
enum GLUT_VIDEO_RESIZE_Y_DELTA          = 0x0387;
enum GLUT_VIDEO_RESIZE_WIDTH_DELTA      = 0x0388;
enum GLUT_VIDEO_RESIZE_HEIGHT_DELTA     = 0x0389;
enum GLUT_VIDEO_RESIZE_X                = 0x038A;
enum GLUT_VIDEO_RESIZE_Y                = 0x038B;
enum GLUT_VIDEO_RESIZE_WIDTH            = 0x038C;
enum GLUT_VIDEO_RESIZE_HEIGHT           = 0x038D;

/*
 * GLUT API macro definitions -- the glutUseLayer parameters
 */
enum GLUT_NORMAL                        = 0x0000;
enum GLUT_OVERLAY                       = 0x0001;

/*
 * GLUT API macro definitions -- the glutGetModifiers parameters
 */
enum GLUT_ACTIVE_SHIFT                  = 0x0001;
enum GLUT_ACTIVE_CTRL                   = 0x0002;
enum GLUT_ACTIVE_ALT                    = 0x0004;

/*
 * GLUT API macro definitions -- the glutSetCursor parameters
 */
enum GLUT_CURSOR_RIGHT_ARROW            = 0x0000;
enum GLUT_CURSOR_LEFT_ARROW             = 0x0001;
enum GLUT_CURSOR_INFO                   = 0x0002;
enum GLUT_CURSOR_DESTROY                = 0x0003;
enum GLUT_CURSOR_HELP                   = 0x0004;
enum GLUT_CURSOR_CYCLE                  = 0x0005;
enum GLUT_CURSOR_SPRAY                  = 0x0006;
enum GLUT_CURSOR_WAIT                   = 0x0007;
enum GLUT_CURSOR_TEXT                   = 0x0008;
enum GLUT_CURSOR_CROSSHAIR              = 0x0009;
enum GLUT_CURSOR_UP_DOWN                = 0x000A;
enum GLUT_CURSOR_LEFT_RIGHT             = 0x000B;
enum GLUT_CURSOR_TOP_SIDE               = 0x000C;
enum GLUT_CURSOR_BOTTOM_SIDE            = 0x000D;
enum GLUT_CURSOR_LEFT_SIDE              = 0x000E;
enum GLUT_CURSOR_RIGHT_SIDE             = 0x000F;
enum GLUT_CURSOR_TOP_LEFT_CORNER        = 0x0010;
enum GLUT_CURSOR_TOP_RIGHT_CORNER       = 0x0011;
enum GLUT_CURSOR_BOTTOM_RIGHT_CORNER    = 0x0012;
enum GLUT_CURSOR_BOTTOM_LEFT_CORNER     = 0x0013;
enum GLUT_CURSOR_INHERIT                = 0x0064;
enum GLUT_CURSOR_NONE                   = 0x0065;
enum GLUT_CURSOR_FULL_CROSSHAIR         = 0x0066;

/*
 * GLUT API macro definitions -- RGB color component specification definitions
 */
enum GLUT_RED                           = 0x0000;
enum GLUT_GREEN                         = 0x0001;
enum GLUT_BLUE                          = 0x0002;

/*
 * GLUT API macro definitions -- additional keyboard and joystick definitions
 */
enum GLUT_KEY_REPEAT_OFF                = 0x0000;
enum GLUT_KEY_REPEAT_ON                 = 0x0001;
enum GLUT_KEY_REPEAT_DEFAULT            = 0x0002;

enum GLUT_JOYSTICK_BUTTON_A             = 0x0001;
enum GLUT_JOYSTICK_BUTTON_B             = 0x0002;
enum GLUT_JOYSTICK_BUTTON_C             = 0x0004;
enum GLUT_JOYSTICK_BUTTON_D             = 0x0008;

/*
 * GLUT API macro definitions -- game mode definitions
 */
enum GLUT_GAME_MODE_ACTIVE              = 0x0000;
enum GLUT_GAME_MODE_POSSIBLE            = 0x0001;
enum GLUT_GAME_MODE_WIDTH               = 0x0002;
enum GLUT_GAME_MODE_HEIGHT              = 0x0003;
enum GLUT_GAME_MODE_PIXEL_DEPTH         = 0x0004;
enum GLUT_GAME_MODE_REFRESH_RATE        = 0x0005;
enum GLUT_GAME_MODE_DISPLAY_CHANGED     = 0x0006;

extern (C) extern __gshared void* glutStrokeRoman;
extern (C) extern __gshared void* glutStrokeMonoRoman;
extern (C) extern __gshared void* glutBitmap9By15;
extern (C) extern __gshared void* glutBitmap8By13;
extern (C) extern __gshared void* glutBitmapTimesRoman10;
extern (C) extern __gshared void* glutBitmapTimesRoman24;
extern (C) extern __gshared void* glutBitmapHelvetica10;
extern (C) extern __gshared void* glutBitmapHelvetica12;
extern (C) extern __gshared void* glutBitmapHelvetica18;

extern (C) __gshared void glutInit( int* pargc, char** argv );
extern (C) __gshared void glutInitWindowPosition( int x, int y );
extern (C) __gshared void glutInitWindowSize( int width, int height );
extern (C) __gshared void glutInitDisplayMode( uint displayMode );
extern (C) __gshared void glutInitDisplayString( const char* displayMode );
extern (C) __gshared void glutMainLoop();
extern (C) __gshared int glutCreateWindow( const char* title );
extern (C) __gshared int glutCreateSubWindow( int window, int x, int y, int width, int height );
extern (C) __gshared void glutDestroyWindow( int window );
extern (C) __gshared void glutSetWindow( int window );
extern (C) __gshared int glutGetWindow();
extern (C) __gshared void glutSetWindowTitle( const char* title );
extern (C) __gshared void glutSetIconTitle( const char* title );
extern (C) __gshared void glutReshapeWindow( int width, int height );
extern (C) __gshared void glutPositionWindow( int x, int y );
extern (C) __gshared void glutShowWindow();
extern (C) __gshared void glutHideWindow();
extern (C) __gshared void glutIconifyWindow();
extern (C) __gshared void glutPushWindow();
extern (C) __gshared void glutPopWindow();
extern (C) __gshared void glutFullScreen();
extern (C) __gshared void glutPostWindowRedisplay( int window );
extern (C) __gshared void glutPostRedisplay();
extern (C) __gshared void glutSwapBuffers();
extern (C) __gshared void glutWarpPointer( int x, int y );
extern (C) __gshared void glutSetCursor( int cursor );
extern (C) __gshared void glutEstablishOverlay();
extern (C) __gshared void glutRemoveOverlay();
extern (C) __gshared void glutUseLayer( GLenum layer );
extern (C) __gshared void glutPostOverlayRedisplay();
extern (C) __gshared void glutPostWindowOverlayRedisplay( int window );
extern (C) __gshared void glutShowOverlay();
extern (C) __gshared void glutHideOverlay();
extern (C) __gshared int glutCreateMenu( GlutCallback_i callback );
extern (C) __gshared void glutDestroyMenu( int menu );
extern (C) __gshared int glutGetMenu();
extern (C) __gshared void glutSetMenu( int menu );
extern (C) __gshared void glutAddMenuEntry( const char* label, int value );
extern (C) __gshared void glutAddSubMenu( const char* label, int subMenu );
extern (C) __gshared void glutChangeToMenuEntry( int item, const char* label, int value );
extern (C) __gshared void glutChangeToSubMenu( int item, const char* label, int value );
extern (C) __gshared void glutRemoveMenuItem( int item );
extern (C) __gshared void glutAttachMenu( int button );
extern (C) __gshared void glutDetachMenu( int button );

extern (C) __gshared void glutTimerFunc( uint time, GlutCallback_i callback, int value );
extern (C) __gshared void glutIdleFunc( GlutCallback_void callback );
extern (C) __gshared void glutKeyboardFunc( GlutCallback_ub_2i callback );
extern (C) __gshared void glutSpecialFunc( GlutCallback_3i callback );
extern (C) __gshared void glutReshapeFunc( GlutCallback_2i callback );
extern (C) __gshared void glutVisibilityFunc( GlutCallback_i callback );
extern (C) __gshared void glutDisplayFunc( GlutCallback_void callback );
extern (C) __gshared void glutMouseFunc( GlutCallback_4i callback );
extern (C) __gshared void glutMotionFunc( GlutCallback_2i callback );
extern (C) __gshared void glutPassiveMotionFunc( GlutCallback_2i callback );
extern (C) __gshared void glutEntryFunc( GlutCallback_i callback );
extern (C) __gshared void glutKeyboardUpFunc( GlutCallback_ub_2i callback );
extern (C) __gshared void glutSpecialUpFunc( GlutCallback_3i callback );
extern (C) __gshared void glutJoystickFunc( GlutCallback_ui_3i callback, int pollInterval );
extern (C) __gshared void glutMenuStateFunc( GlutCallback_i callback );
extern (C) __gshared void glutMenuStatusFunc( GlutCallback_3i callback );
extern (C) __gshared void glutOverlayDisplayFunc( GlutCallback_void callback );
extern (C) __gshared void glutWindowStatusFunc( GlutCallback_i callback );
extern (C) __gshared void glutSpaceballMotionFunc( GlutCallback_3i callback );
extern (C) __gshared void glutSpaceballRotateFunc( GlutCallback_3i callback );
extern (C) __gshared void glutSpaceballButtonFunc( GlutCallback_2i callback );
extern (C) __gshared void glutButtonBoxFunc( GlutCallback_2i callback );
extern (C) __gshared void glutDialsFunc( GlutCallback_2i callback );
extern (C) __gshared void glutTabletMotionFunc( GlutCallback_2i callback );
extern (C) __gshared void glutTabletButtonFunc( GlutCallback_4i callback );
extern (C) __gshared int glutGet( GLenum query );
extern (C) __gshared int glutDeviceGet( GLenum query );
extern (C) __gshared int glutGetModifiers();
extern (C) __gshared int glutLayerGet( GLenum query );
extern (C) __gshared void glutBitmapCharacter( void* font, int character );
extern (C) __gshared int glutBitmapWidth( void* font, int character );
extern (C) __gshared void glutStrokeCharacter( void* font, int character );
extern (C) __gshared int glutStrokeWidth( void* font, int character );
extern (C) __gshared int glutBitmapLength( void* font, const ubyte* string );
extern (C) __gshared int glutStrokeLength( void* font, const ubyte* string );
extern (C) __gshared void glutWireCube( GLdouble size );
extern (C) __gshared void glutSolidCube( GLdouble size );
extern (C) __gshared void glutWireSphere( GLdouble radius, GLint slices, GLint stacks );
extern (C) __gshared void glutSolidSphere( GLdouble radius, GLint slices, GLint stacks );
extern (C) __gshared void glutWireCone( GLdouble base, GLdouble height, GLint slices, GLint stacks );
extern (C) __gshared void glutSolidCone( GLdouble base, GLdouble height, GLint slices, GLint stacks );
extern (C) __gshared void glutWireTorus( GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings );
extern (C) __gshared void glutSolidTorus( GLdouble innerRadius, GLdouble outerRadius, GLint sides, GLint rings );
extern (C) __gshared void glutWireDodecahedron();
extern (C) __gshared void glutSolidDodecahedron();
extern (C) __gshared void glutWireOctahedron();
extern (C) __gshared void glutSolidOctahedron();
extern (C) __gshared void glutWireTetrahedron();
extern (C) __gshared void glutSolidTetrahedron();
extern (C) __gshared void glutWireIcosahedron();
extern (C) __gshared void glutSolidIcosahedron();
extern (C) __gshared void glutWireTeapot( GLdouble size );
extern (C) __gshared void glutSolidTeapot( GLdouble size );
extern (C) __gshared void glutGameModeString( const char* string );
extern (C) __gshared int glutEnterGameMode();
extern (C) __gshared void glutLeaveGameMode();
extern (C) __gshared int glutGameModeGet( GLenum query );
extern (C) __gshared int glutVideoResizeGet( GLenum query );
extern (C) __gshared void glutSetupVideoResizing();
extern (C) __gshared void glutStopVideoResizing();
extern (C) __gshared void glutVideoResize( int x, int y, int width, int height );
extern (C) __gshared void glutVideoPan( int x, int y, int width, int height );
extern (C) __gshared void glutSetColor( int color, GLfloat red, GLfloat green, GLfloat blue );
extern (C) __gshared GLfloat glutGetColor( int color, int component );
extern (C) __gshared void glutCopyColormap( int window );
extern (C) __gshared void glutIgnoreKeyRepeat( int ignore );
extern (C) __gshared void glutSetKeyRepeat( int repeatMode );
extern (C) __gshared void glutForceJoystickFunc();
extern (C) __gshared int glutExtensionSupported( const char* extension );
extern (C) __gshared void glutReportErrors();
extern (C) __gshared void glutMainLoopEvent();
extern (C) __gshared void glutLeaveMainLoop();
extern (C) __gshared void glutExit ();
extern (C) __gshared void glutFullScreenToggle();
extern (C) __gshared void glutLeaveFullScreen();
extern (C) __gshared void glutMouseWheelFunc( GlutCallback_4i callback );
extern (C) __gshared void glutCloseFunc( GlutCallback_void callback );
extern (C) __gshared void glutWMCloseFunc( GlutCallback_void callback );
extern (C) __gshared void glutMenuDestroyFunc( GlutCallback_void callback );
extern (C) __gshared void glutSetOption ( GLenum option_flag, int value );
extern (C) __gshared int * glutGetModeValues(GLenum mode, int * size);
extern (C) __gshared void* glutGetWindowData();
extern (C) __gshared void glutSetWindowData(void* data);
extern (C) __gshared void* glutGetMenuData();
extern (C) __gshared void glutSetMenuData(void* data);
extern (C) __gshared int glutBitmapHeight( void* font );
extern (C) __gshared GLfloat glutStrokeHeight( void* font );
extern (C) __gshared void glutBitmapString( void* font, const ubyte *string );
extern (C) __gshared void glutStrokeString( void* font, const ubyte *string );
extern (C) __gshared void glutWireRhombicDodecahedron();
extern (C) __gshared void glutSolidRhombicDodecahedron();
extern (C) __gshared void glutWireSierpinskiSponge ( int num_levels, GLdouble offset[3], GLdouble scale );
extern (C) __gshared void glutSolidSierpinskiSponge ( int num_levels, GLdouble offset[3], GLdouble scale );
extern (C) __gshared void glutWireCylinder( GLdouble radius, GLdouble height, GLint slices, GLint stacks);
extern (C) __gshared void glutSolidCylinder( GLdouble radius, GLdouble height, GLint slices, GLint stacks);
//extern (C) __gshared typedef void (*GLUTproc)();
//extern (C) __gshared GLUTproc glutGetProcAddress( const char *procName );
extern (C) __gshared void glutMultiEntryFunc( GlutCallback_2i callback );
extern (C) __gshared void glutMultiButtonFunc( GlutCallback_5i callback );
extern (C) __gshared void glutMultiMotionFunc( GlutCallback_3i callback );
extern (C) __gshared void glutMultiPassiveFunc( GlutCallback_3i callback );
extern (C) __gshared int glutJoystickGetNumAxes( int ident );
extern (C) __gshared int glutJoystickGetNumButtons( int ident );
extern (C) __gshared int glutJoystickNotWorking( int ident );
extern (C) __gshared float glutJoystickGetDeadBand( int ident, int axis );
extern (C) __gshared void glutJoystickSetDeadBand( int ident, int axis, float db );
extern (C) __gshared float glutJoystickGetSaturation( int ident, int axis );
extern (C) __gshared void glutJoystickSetSaturation( int ident, int axis, float st );
extern (C) __gshared void glutJoystickSetMinRange( int ident, float *axes );
extern (C) __gshared void glutJoystickSetMaxRange( int ident, float *axes );
extern (C) __gshared void glutJoystickSetCenter( int ident, float *axes );
extern (C) __gshared void glutJoystickGetMinRange( int ident, float *axes );
extern (C) __gshared void glutJoystickGetMaxRange( int ident, float *axes );
extern (C) __gshared void glutJoystickGetCenter( int ident, float *axes );
extern (C) __gshared void glutInitContextVersion( int majorVersion, int minorVersion );
extern (C) __gshared void glutInitContextFlags( int flags );
extern (C) __gshared void glutInitContextProfile( int profile );
//extern (C) __gshared void glutInitErrorFunc( void (* vError)( const char *fmt, va_list ap ) );
//extern (C) __gshared void glutInitWarningFunc( void (* vWarning)( const char *fmt, va_list ap ) );
