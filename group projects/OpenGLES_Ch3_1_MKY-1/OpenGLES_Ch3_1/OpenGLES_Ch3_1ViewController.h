//
//  OpenGLES_Ch3_1ViewController.h
//  OpenGLES_Ch3_1
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;


@interface OpenGLES_Ch3_1ViewController : GLKViewController
{
}

@property (nonatomic, strong) IBOutlet UISlider *sliderVert0s;
@property (nonatomic, strong) IBOutlet UISlider *sliderVert1s;
@property (nonatomic, strong) IBOutlet UISlider *sliderVert2s;
@property (nonatomic, strong) IBOutlet UISlider *sliderVert0t;
@property (nonatomic, strong) IBOutlet UISlider *sliderVert1t;
@property (nonatomic, strong) IBOutlet UISlider *sliderVert2t;

@property (nonatomic, strong) IBOutlet UILabel *vert0Text;
@property (nonatomic, strong) IBOutlet UILabel *vert1Text;
@property (nonatomic, strong) IBOutlet UILabel *vert2Text;

- (IBAction)sliderChanged:(UISlider *)sender;




@property (strong, nonatomic) GLKBaseEffect 
   *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer 
   *vertexBuffer;

@end
