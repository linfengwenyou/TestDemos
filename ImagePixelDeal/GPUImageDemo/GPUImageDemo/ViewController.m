//
//  ViewController.m
//  GPUImageDemo
//
//  Created by rayor on 2021/5/12.
//

#import "ViewController.h"
#import <GPUImageView.h>
#import <GPUImage/GPUImage.h>
#import "RoundGradientLayer.h"
#import "KGCircleBubbleView.h"
#import "UIImage+Pixels.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@property (nonatomic, strong) KGCircleBubbleView *bubbleView;

@property (nonatomic, assign) KGImageBlendType type;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Real_0216a27c67531e10149a49fa80b9d0ab.jpg_720x1280.jpg"];
    
    self.colorView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.colorView.layer.borderWidth = 2;
    self.colorView.layer.cornerRadius = 5;
    [self.colorView clipsToBounds];
    
    
    self.picView.image = image;
    self.picView.contentMode = UIViewContentModeScaleAspectFill;
    
//    [self testRoundShadeAnimation];

    
    self.bubbleView = [[KGCircleBubbleView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.bubbleView.enlargeRate = [UIScreen mainScreen].bounds.size.width / 200;
    [self.view addSubview:self.bubbleView];
    self.type = 0;
    [self testCicleAnimation];
}

/*发散圆环效果*/
- (void)testCicleAnimation {
    
    
    
    UIImage *image = [UIImage imageNamed:@"Real_0216a27c67531e10149a49fa80b9d0ab.jpg_720x1280.jpg"];
//    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    
//    unsigned char *rawData = [image rawPixelDatas];
    
//    NSLog(@"%s",rawData);
    
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
//    format.scale = 1;
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 2.0f) format:format];
    UIImage *imageB = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        
        UIColor *randomColor = [[UIColor alloc] initWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        
        [randomColor setFill];
        [rendererContext fillRect:render.format.bounds];
    
    }];
    
    UIColor *randomColor = [[UIColor alloc] initWithRed:self.redSlider.value
                                                  green:self.greenSlider.value
                                                   blue:self.blueSlider.value
                                                  alpha:1];
    self.colorView.backgroundColor = randomColor;
    self.textLabel.text = [NSString stringWithFormat:@"RGB(%.2f,%.2f,%.2f)",self.redSlider.value, self.greenSlider.value, self.blueSlider.value];

    self.typeLabel.text = [NSString stringWithFormat:@"混合模式:%@",[UIImage nameWithType:self.type]];
    self.typeLabel.backgroundColor = UIColor.whiteColor;
//    UIImage *image1 = [image blendImageWithBImage:imageB blendType:KGImageBlendType_OverLay];
    UIImage *image1 = [image blendImageWithColor:randomColor blendType:self.type];
    
    self.picView.image = image1;
    
    
//    [self.bubbleView startAnimationWithDuration:2 isSilence:NO];
    
}




/*内圆阴影效果展示*/
- (void)testRoundShadeAnimation {
    
    CALayer *redLayer = [CALayer layer];
    redLayer.backgroundColor = UIColor.redColor.CGColor;
    redLayer.frame = CGRectMake(100, 100, 200, 200);
    
    CGRect frame = redLayer.bounds;
    
    CGFloat locations[] = {0.f, 0.5f,1.0f};
    NSArray *color = @[(__bridge id)[UIColor.blueColor colorWithAlphaComponent:0].CGColor,
                       (__bridge id)[UIColor.blueColor colorWithAlphaComponent:0].CGColor,
                       (__bridge id)UIColor.blueColor.CGColor];
    
    RoundGradientLayer *layer = [RoundGradientLayer createGradientLayerWithFrame:frame locations:locations colors:color];
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 100;
    
    redLayer.mask = layer;
    
    
    [self.picView.layer addSublayer:redLayer];
    
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.values = @[(id)UIColor.redColor.CGColor,
                    (id)UIColor.blueColor.CGColor,
                    (id)UIColor.yellowColor.CGColor
    ];
    anim.duration = 0.3f;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = YES;
    
    [redLayer addAnimation:anim forKey:nil];
    
    
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
//    [self changeFilter];
    
    [self testCicleAnimation];
    
}

- (void)changeFilter {
    [self useColorInvertEffect];
}



- (void)useShadowEffect {
    UIImage *inputImage = self.picView.image;
    
    
    GPUImageVignetteFilter *disFilter = [[GPUImageVignetteFilter alloc] init];
    
    [disFilter forceProcessingAtSize:inputImage.size];
    [disFilter useNextFrameForImageCapture];
    
    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    [imageSource addTarget:disFilter];
    
    [imageSource processImage];
    
    UIImage *newImage = [disFilter imageFromCurrentFramebuffer];
    
    // 加载出来
    self.filterImageView.image = newImage;
}


- (void)useColorInvertEffect {
    UIImage *image = self.picView.image;
    GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    
    self.filterImageView.image = newImage;
    self.filterImageView.alpha = 0.2f;
    
 
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.values = @[@1,@1.1,@1.15,@1.25,@1.15,@1];
    anima.keyPath = @"transform.scale";
    
    
    CGPoint position = self.filterImageView.layer.position;
    
    
    CAKeyframeAnimation *posiAnimation = [CAKeyframeAnimation animation];
    posiAnimation.values = @[[NSValue valueWithCGPoint:position],
                             [NSValue valueWithCGPoint:CGPointMake(position.x + 10, position.y)],
                              [NSValue valueWithCGPoint:position],
                             [NSValue valueWithCGPoint:CGPointMake(position.x - 10,position.y)],
                             [NSValue valueWithCGPoint:position]];
    posiAnimation.keyPath = @"position";
    posiAnimation.duration = 0.8f;
    
    group.animations = @[anima];
    group.duration = 0.8f;
    group.repeatCount = 2;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    
    [self.filterImageView.layer addAnimation:group forKey:@"Yahoo"];
    
}

- (void)useHistogramFIleter {
    UIImage *image = self.picView.image;
    GPUImageHistogramGenerator *filter = [[GPUImageHistogramGenerator alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.filterImageView.image = newImage;
}

- (void)useSpecialFilter {
    UIImage *image = self.picView.image;
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.filterImageView.image = newImage;
}
- (IBAction)didClickPreAction:(id)sender {
    self.type -= 1;
    if (self.type < 0) {
        self.type = KGImageBlendType_Exclusion;
    }
    [self testCicleAnimation];
}

- (IBAction)didClickNextAction:(id)sender {
    self.type += 1;
    if (self.type > KGImageBlendType_Exclusion) {
        self.type = 0;
    }
    [self testCicleAnimation];
}

- (IBAction)didClickShowOrigin:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"Real_0216a27c67531e10149a49fa80b9d0ab.jpg_720x1280.jpg"];
    
    self.picView.image = image;

}

- (IBAction)didSlideAction:(id)sender {
    [self testCicleAnimation];
}


@end
