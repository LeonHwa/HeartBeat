//
//  HeartBeatViewController.m
//  HeartBeat
//
//  Created by Leon.Hwa on 17/2/24.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "HeartBeatViewController.h"
#import "HeartBeatResultViewController.h"
#import "HelpViewController.h"
#import "Algorithm.h"
#import "HeartBeatProgressView.h"
#import "FANVideoCapture.h"
#import "HAnimation.h"
#import "HeartLive.h"

#import "Result.h"
#import "Settings.h"


@interface HeartBeatViewController ()<FANVideoCaptureDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) HeartBeatProgressView *progressView;
@property (nonatomic, strong) HeartLive *hearBeartView;
@property (nonatomic, weak) IBOutlet UILabel *headTipLabel;

// AVFoundation
@property (nonatomic,strong) FANVideoCapture * videoCapture;

// Audio
@property (nonatomic, retain) AVAudioPlayer *BeepSound;
// Algorithm
@property (nonatomic , strong) Algorithm *algorithm;
@property (nonatomic , strong) Algorithm *algorithm2;
@property (strong , nonatomic) NSDate *algorithmStartTime;
@property (strong , nonatomic) NSDate *bpmFinalResultFirstTimeDetected;

@property (nonatomic, strong) Result *result;
@property (strong, nonatomic) Settings *settings;

@property (strong, nonatomic) PushTransition * pushAnimation;

@property (strong, nonatomic) PopTransition  * popAnimation;

@property (strong, nonatomic) InteractionTransitionAnimation * popInteraction;

@property (strong, nonatomic) InteractiveTrasitionAnimation * popInteractive;

@property (strong, nonatomic) UIButton *tipBtn;

@end

@implementation HeartBeatViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self addProgressView];
       [self addBtn];
    [self setupVideoCapture];
    self.view.backgroundColor = COLOR(245, 247, 249, 1);//COLOR(233, 225, 190, 1);//
    self.headTipLabel.textColor = COLOR(97, 211,167, 1);
    NSURL *beepSound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pulse-beep" ofType:@"wav"]];
    self.BeepSound = [[AVAudioPlayer alloc] initWithContentsOfURL:beepSound error:nil];
    self.BeepSound.volume = 1;
}
- (void)addBtn{
  [self tipBtn];
}
- (void) addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headTipLabel setTextWithChangeAnimation:@"请将手指放在在摄像头上"];
    [self tipShow];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.videoCapture.startRunning = NO;
    [self pause];
    [self tipHidden];
}

- (void)tipShow{
   [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tipBtn.origin = CGPointMake(WIDTH - 60, -4);
   } completion:^(BOOL finished) {
       
   }];
}

- (void)tipHidden{
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tipBtn.origin = CGPointMake(WIDTH - 60, -self.tipBtn.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)addProgressView{
    _progressView = [[HeartBeatProgressView alloc] initWithFrame:CGRectMake(0, 140, WIDTH, WIDTH)];
    [self.view addSubview:_progressView];
    [self.progressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)] ];
    _hearBeartView = [[HeartLive alloc] initWithFrame:CGRectMake(10, 60, WIDTH - 20, 90)];
    [self.view addSubview:_hearBeartView];
}
- (IBAction)push:(id)sender {
    HeartBeatResultViewController *vc = [[HeartBeatResultViewController alloc] init];
    HeartBeatData *model = [[HeartBeatData alloc] init];
    model.bmp = 80;
    model.timestamp = [NSDate timeIntervalSinceReferenceDate];
    vc.heartBeatData = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupVideoCapture {
    self.videoCapture = [[FANVideoCapture alloc] init];
    self.videoCapture.delegate = self;
}

- (void)start{
    self.videoCapture.startRunning = YES;
    self.progressView.bmpLabel.text = @"0";
}
#define TIME_TO_DETERMINE_BPM_FINAL_RESULT 3 // in seconds
-(void)FANVideoCapture:(FANVideoCapture *)videoCapture didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    UIImage *image = [UIImage imageFromSampleBuffer:sampleBuffer];
    dispatch_queue_t algorithmQ = dispatch_queue_create("algorithm thread", NULL);
    dispatch_async(algorithmQ, ^{
        //内存转成图像
        UIColor *dominantColor = [image averageColorPrecise];// get the average color from the image
        CGFloat red , green , blue , alpha;
        [dominantColor getRed:&red green:&green blue:&blue alpha:&alpha];
        blue = blue*255.0f;
        green = green*255.0f;
        red = red*255.0f;
        [self.algorithm newFrameDetectedWithAverageColor:dominantColor];
        [self.algorithm2 newFrameDetectedWithAverageColor:dominantColor];
        __weak typeof(self) weakSelf = self;
        self.algorithm.filterBlock = ^(CGFloat p){
            [weakSelf.hearBeartView drawRateWithPoint:[NSNumber numberWithFloat:p]];
        };
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.algorithm.isFinalResultDetermined) {
                if (TIME_TO_DETERMINE_BPM_FINAL_RESULT <= [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected]) {
                    self.result.bpm = (int)self.algorithm.bpmLatestResult;
                    HeartBeatData *model = [[HeartBeatData alloc] init];
                    model.bmp = (NSInteger)self.algorithm.bpmLatestResult;
                    model.timestamp = [NSDate timeIntervalSinceReferenceDate];
                    self.result = nil;
                    self.algorithm = nil;
                    HeartBeatResultViewController *vc = [[HeartBeatResultViewController alloc] init];
                    vc.heartBeatData = model;
                    vc.type = HeartBeatResultViewControllerResultType;
                    [self.navigationController pushViewController:vc animated:YES];
                    //------------------------------------------------
#warning - incomplete implementation
                }
                self.progressView.bmpLabel.text = [NSString stringWithFormat:@"%d",(int)self.algorithm2.bpmLatestResult];
               NSString *text = [NSString stringWithFormat:@"Final BPM: %d , BPM2: %d" , (int)self.algorithm.bpmLatestResult , (int)self.algorithm2.bpmLatestResult];
                NSString *timeText = [NSString stringWithFormat:@"time till result: %.01fs" , TIME_TO_DETERMINE_BPM_FINAL_RESULT - [[NSDate date] timeIntervalSinceDate:self.bpmFinalResultFirstTimeDetected]];
                self.headTipLabel.text = timeText;
                NSLog(@"%@",text);
                NSLog(@"%@",timeText);
            } else {
                self.bpmFinalResultFirstTimeDetected = nil;
#warning - incomplete implementation
            }
            if (red < 210) {
                //finger isn't on camera
                if (self.settings.autoStopAfter) {
#warning - incomplete implementation
                    if ([[NSDate date] timeIntervalSinceDate:self.algorithmStartTime] > self.settings.autoStopAfter) {
                        if (self.algorithm.isFinalResultDetermined) {
                            //------------------Results BLOCK-----------------
                            self.result.bpm = (int)self.algorithm.bpmLatestResult;
                            self.result = nil;
                            self.algorithm = nil;
                            self.algorithm2 = nil;
                            self.algorithmStartTime = nil;
                            self.bpmFinalResultFirstTimeDetected = nil;
                            self.tabBarController.selectedIndex = 0;
                            self.videoCapture.startRunning = NO;
                            //------------------------------------------------
                            return;
                        }
                    }
                }
                else {
                    if (self.algorithm.isFinalResultDetermined) {
                        //------------------Results BLOCK-----------------
                        
                        self.result.bpm = (int)self.algorithm.bpmLatestResult;
                        self.result = nil;
                        self.algorithm = nil;
                        self.algorithm2 = nil;
                        self.algorithmStartTime = nil;
                        self.bpmFinalResultFirstTimeDetected = nil;
                        self.tabBarController.selectedIndex = 0;
                        self.videoCapture.startRunning = NO;
                         NSLog(@"==============跳转=====================");
                        return;
                    }
                }
                 self.headTipLabel.text = @"请将手指放在在摄像头上";
                [self pause];
                NSLog(@"%@",[NSString stringWithFormat:@"BPM: %d", 0]);
                self.algorithm = nil;
                self.algorithm2 = nil;
                self.algorithmStartTime = nil;
                self.bpmFinalResultFirstTimeDetected = nil;
                return;
            }
            else {
                self.headTipLabel.text = @"正在测量中...";
                  NSLog(@"%@",[NSString stringWithFormat:@"time: %.01fs", [[NSDate date] timeIntervalSinceDate:self.algorithmStartTime]]);
            }
            
            if (self.algorithm.shouldShowLatestResult && self.algorithm2.shouldShowLatestResult) {
                NSLog(@"%@", [NSString stringWithFormat:@"BPM: %.01f , BPM2: %.01f", self.algorithm.bpmLatestResult , self.algorithm2.bpmLatestResult]);
              self.progressView.bmpLabel.text = [NSString stringWithFormat:@"%d",(int)self.algorithm.bpmLatestResult];
            }
            else if (self.algorithm.shouldShowLatestResult) {
                  NSLog(@"%@", [NSString stringWithFormat:@"BPM: %.01f , BPM2: %d", self.algorithm.bpmLatestResult , 0]);
                 self.progressView.bmpLabel.text = [NSString stringWithFormat:@"%d",(int)self.algorithm.bpmLatestResult];
            }
            else if (self.algorithm2.shouldShowLatestResult) {
                 NSLog(@"%@", [NSString stringWithFormat:@"BPM: %d , BPM2: %.01f", 0 , self.algorithm2.bpmLatestResult]);
                 self.progressView.bmpLabel.text = [NSString stringWithFormat:@"%d",(int)self.algorithm2.bpmLatestResult];
            }
            else {
                NSLog(@"%@", [NSString stringWithFormat:@"BPM: %d , BPM2: %d", 0 , 0]);
            }
            
        });
        
        [self playBeepSound];
    });
}

- (void)pause{
[self.progressView progressPause];
    [self.hearBeartView clearLine];
}
- (void)playBeepSound
{
    if (self.settings.beepWithPulse){
        if (self.algorithm.isPeakInLastFrame && !self.algorithm.isMissedTheLastPeak) {
            [self.BeepSound play];
            [self.progressView animateBeat];
            [self.progressView progressBegin];
        }
    }
}

- (void)applicationWillEnterForeground
{
    if (self.isViewLoaded && self.view.window) {
        [self resetAlgorithm];
     
    }
}

- (void)applicationEnteredForeground
{
    if (self.isViewLoaded && self.view.window) {
        
    }
}

- (void)applicationEnteredBackground
{
    if (self.isViewLoaded && self.view.window) {
       [self pause];
       self.videoCapture.startRunning = NO;
    }
}

- (void)resetAlgorithm
{
    self.settings = nil;
    self.algorithmStartTime = nil;
    self.bpmFinalResultFirstTimeDetected = nil;
    self.algorithm = nil;
    self.algorithm2 = nil;
}
// Algorithm
- (NSDate *)algorithmStartTime
{
    if (!_algorithmStartTime) {
        _algorithmStartTime = [NSDate date];
    }
    return _algorithmStartTime;
}

- (NSDate *)bpmFinalResultFirstTimeDetected
{
    if (!_bpmFinalResultFirstTimeDetected) {
        _bpmFinalResultFirstTimeDetected = [NSDate date];
    }
    return _bpmFinalResultFirstTimeDetected;
}
- (Algorithm *)algorithm
{
    if (!_algorithm) {
        _algorithm = [[Algorithm alloc] init];
    }
    return _algorithm;
}

- (Algorithm *)algorithm2
{
    if (!_algorithm2) {
        _algorithm2 = [[Algorithm alloc] init];
        _algorithm2.windowSize = 9;
        _algorithm2.filterWindowSize = 45;
    }
    return _algorithm2;
}

- (Settings *)settings
{
    if (!_settings)
        _settings = [Settings currentSettings];
    
    return _settings;
}

- (UIButton *)tipBtn
{
    if (!_tipBtn){
        _tipBtn = [[UIButton alloc] init];
        _tipBtn.size = CGSizeMake(30, 70);
        _tipBtn.origin = CGPointMake(WIDTH - 60, -_tipBtn.height);
        [_tipBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication].keyWindow addSubview:_tipBtn];
        [_tipBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}


- (void)next{
//    HeartBeatResultViewController *vc = [[HeartBeatResultViewController alloc] init];
//    HeartBeatData *model = [[HeartBeatData alloc] init];
//    model.bmp = 80;
//    model.timestamp = [NSDate timeIntervalSinceReferenceDate];
//    vc.heartBeatData = model;
//     vc.type = HeartBeatResultViewControllerResultType;
//    [self.navigationController pushViewController:vc animated:YES];

    [self performSegueWithIdentifier:@"HelpViewController" sender:nil];
}
-(PushTransition *)pushAnimation
{
    if (!_pushAnimation) {
        _pushAnimation = [[PushTransition alloc] init];
    }
    return _pushAnimation;
}
-(PopTransition *)popAnimation
{
    if (!_popAnimation) {
        _popAnimation = [[PopTransition alloc] init];
    }
    return _popAnimation;
}
#pragma mark - **************** Navgation delegate
/** 返回转场动画实例*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }else if (operation == UINavigationControllerOperationPop){
        return self.popAnimation;
    }
    return nil;
}
/** 返回交互手势实例*/
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    //    return self.popInteraction.isActing ? self.popInteraction : nil;
    return self.popInteractive.isActing ? self.popInteractive : nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController - %@",self.popInteraction.isActing ?@"YES":@"NO");
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"didShowViewController - %@",self.popInteraction.isActing ?@"YES":@"NO");
}

@end
