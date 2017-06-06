//
//  FANVideoCapture.m
//  FanLiveing
//
//  Created by hyf on 16/7/30.
//  Copyright © 2016年 FanHwa. All rights reserved.
//

#import "FANVideoCapture.h"


@interface FANVideoCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_semaphore_t _lock;
     AVCaptureSession * _AVSession;//调用闪光灯的时候创建的类
}
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureDevice *cameraDevice;
@property (strong) AVCaptureDeviceInput * videoInput;
@property(nonatomic,strong)AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic,strong)AVCaptureConnection *captureConnection;//判断是视频还是音频


@property (nonatomic, assign) uint64_t timestamp;

@end

@implementation FANVideoCapture


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCamera];
    }
    return self;
}
- (void)setupCamera{


    // Create the session
    self.session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    // Find a suitable AVCaptureDevice
    self.cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.cameraDevice error:&error];
    
    if (!self.videoInput) {
        return;
    }
    
    if(![self.session canAddInput:self.videoInput]){
        return;
    }
    [self.session addInput:self.videoInput];
    
    // Create a VideoDataOutput and add it to the session
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // Configure your output.
    // Specify the pixel format
    self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // shouldn't throw away frames
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    
    dispatch_queue_t queue = dispatch_queue_create("frameOutputQueue", NULL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:queue];
    
    [self.session addOutput:self.videoDataOutput];

}

- (void)setStartRunning:(BOOL)startRunning{
   
    _startRunning = startRunning;
    if(_startRunning){
    [self.cameraDevice lockForConfiguration:nil];
    [self.session startRunning];
        
        if ([self.cameraDevice hasFlash]) {
            if (self.cameraDevice.torchMode == AVCaptureTorchModeOn) {
                [self.cameraDevice setTorchMode:AVCaptureTorchModeOff];
                   self.cameraDevice.flashMode = AVCaptureFlashModeOn;
            }else{
                
                [self.cameraDevice setTorchMode:AVCaptureTorchModeOn];
                self.cameraDevice.flashMode = AVCaptureFlashModeOff;
                [self.cameraDevice setTorchModeOnWithLevel:0.01 error:nil];
            }
             [self.cameraDevice unlockForConfiguration];
        }
    }else{
     [self.session stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  [self.delegate FANVideoCapture:self didOutputSampleBuffer:sampleBuffer];

}


@end
