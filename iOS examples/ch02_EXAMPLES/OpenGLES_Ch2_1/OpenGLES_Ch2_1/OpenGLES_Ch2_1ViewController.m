//
//  OpenGLES_Ch2_1ViewController.m
//  OpenGLES_Ch2_1
//

#import "OpenGLES_Ch2_1ViewController.h"

@implementation OpenGLES_Ch2_1ViewController

@synthesize baseEffect;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
// SceneVertex is a struct with one member positionCoords.
// positionCoords is a variable of type GLKVector3.
// GLKVector3 represents a vector with 3 components.
// GLKVector3 is a C union, similar to a struct.
// http://en.wikipedia.org/wiki/Union_(computer_science)
// Here GLKVector3 represents position x,y,z.
typedef struct {
    GLKVector3  positionCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
// vertices[] is an array with elements of type SceneVertex
static const SceneVertex vertices[] = 
{
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};


/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NOTE: Buck's example casts view type to GLKView, then calls isKindOfClass.
    // For clarity, check isKindOfClass before cast.
    // Casting the pointer tells the compiler that the pointer points to a GLKView object,
    // but it doesn't change the object. The object's isa pointer and type are unchanged.
    // http://stackoverflow.com/questions/1236434/how-to-cast-class-a-to-its-subclass-class-b-objective-c
    //     UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    //     GLKView *aViewCast = (GLKView *)aView;
    // This assertion would fail.
    //     NSAssert([aViewCast isKindOfClass:[GLKView class]], @"aViewCast is not a GLKView");
    
    // Verify the type of view created by the storyboard
    NSAssert([self.view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    GLKView *view = (GLKView *)self.view;
    
    // Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // Shading Language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color
    
    // Generate, bind, and initialize contents of a buffer to be
    // stored in GPU memory
    glGenBuffers(1,                // STEP 1
                 &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 vertexBufferID);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 sizeof(vertices), // Number of bytes to copy
                 vertices,         // Address of bytes to copy
                 GL_STATIC_DRAW);  // Hint: cache in GPU memory
}


/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
   
   // Clear Frame Buffer (erase previous drawing)
   glClear(GL_COLOR_BUFFER_BIT);
   
   // Enable use of positions from bound vertex buffer
   glEnableVertexAttribArray(      // STEP 4
      GLKVertexAttribPosition);
      
   glVertexAttribPointer(          // STEP 5
      GLKVertexAttribPosition, 
      3,                   // three components per vertex
      GL_FLOAT,            // data is floating point
      GL_FALSE,            // no fixed point scaling
      sizeof(SceneVertex), // no gaps in data
      NULL);               // NULL tells GPU to start at 
                           // beginning of bound buffer
                                   
   // Draw triangles using the first three vertices in the 
   // currently bound vertex buffer
   glDrawArrays(GL_TRIANGLES,      // STEP 6
      0,  // Start with first vertex in currently bound buffer
      3); // Use three vertices from currently bound buffer
}


/////////////////////////////////////////////////////////////////
// ARC doesn't automatically memory manage OpenGL items such as textures, framebuffers, VBOs.
// Because viewDidUnload is deprecated in iOS 6, moved code to dealloc.
// In this version of the app, it wouldn't make sense to put the code in didReceiveMemoryWarning,
// because the context never would be reloaded.
// References:
// http://stackoverflow.com/questions/12354576/crash-with-received-memory-warning-message-utilizing-glkit-and-arc
// http://9to5mac.com/2012/06/25/apple-pushes-ios-6-0-update-to-devs/
// http://developer.apple.com/library/mac/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html
- (void)dealloc
{
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    // Delete buffers that aren't needed when view is unloaded
    if (0 != vertexBufferID)
    {
        glDeleteBuffers (1,          // STEP 7
                         &vertexBufferID);
        vertexBufferID = 0;
    }
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
