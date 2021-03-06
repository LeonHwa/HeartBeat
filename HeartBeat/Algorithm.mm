//
//  Algorithm.m
//  Heartbeat
//
//  Created by Or Maayan on 9/13/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "Algorithm.h"
#import "Butterworth.h"

@interface Algorithm()
//
@property (nonatomic , readwrite) NSUInteger framesCounter;
@property (nonatomic) NSUInteger firstPeakPlace;// first place peak was determined. if 0 the none found
@property (nonatomic) NSUInteger numOfPeaks;// number of peaks in the last calibrationDuration frames

@property (nonatomic , strong) NSMutableArray *points;// represent the array of color values (doubles) wrapped by NSNumbers
@property (nonatomic , strong) NSMutableArray *bpmValues;// array of the calculated beats per minute values wrapped by NSNumbers
// array size should be approximately windowSizeForAverageCalculation
@property (nonatomic , strong) NSMutableArray *bpmAverageValues;// array of average values of the bpm wrapped by NSNumbers;
// we could save only the latest bpmAverageValue calculated
@property (nonatomic , strong) NSMutableArray *isPeak;// array of the BOOLs represent if the matching point is peak in the graph

//
@property (nonatomic , readwrite) BOOL isCalibrationOver;
@property (nonatomic , readwrite) BOOL isFinalResultDetermined;

@property (nonatomic, readwrite) BOOL isPeakInLastFrame;
@property (nonatomic, readwrite) BOOL isMissedTheLastPeak;

@property (nonatomic , readwrite) BOOL shouldShowLatestResult;

@property (nonatomic) NSUInteger lastPeakPlace;

@end

@implementation Algorithm

// Properties

#define FPS 30
#define WINDOW_SIZE 9
#define WINDOW_SIZE_FOR_FILTER_CALCULATION 60// should be at least WINDOW_SIZE*2
#define CALIBRATION_DURATION 90
#define WINDOW_SIZE_FOR_AVERAGE_CALCULATION 75

- (CGFloat)frameRate{
    if (!_frameRate) {
        _frameRate = FPS;
    }
    return _frameRate;
}

- (NSUInteger)windowSize{
    if (!_windowSize) {
        _windowSize = WINDOW_SIZE;
    }
    return _windowSize;
}

- (NSUInteger)filterWindowSize{
    if (!_filterWindowSize) {
        _filterWindowSize = WINDOW_SIZE_FOR_FILTER_CALCULATION;
    }
    return _filterWindowSize;
}

- (NSUInteger)calibrationDuration{
    if (!_calibrationDuration) {
        _calibrationDuration = CALIBRATION_DURATION;
    }
    return _calibrationDuration;
}

- (NSUInteger)windowSizeForAverageCalculation{
    if (!_windowSizeForAverageCalculation) {
        _windowSizeForAverageCalculation = WINDOW_SIZE_FOR_AVERAGE_CALCULATION;
    }
    return _windowSizeForAverageCalculation;
}

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (NSMutableArray *)bpmValues
{
    if (!_bpmValues) {
        _bpmValues = [NSMutableArray array];
    }
    return _bpmValues;
}

- (NSMutableArray *)bpmAverageValues
{
    if (!_bpmAverageValues) {
        _bpmAverageValues = [NSMutableArray array];
    }
    return _bpmAverageValues;
}

- (NSMutableArray *)isPeak
{
    if (!_isPeak) {
        _isPeak = [NSMutableArray array];
    }
    return _isPeak;
}

#define FILTER_ORDER 5
#define FILTER_LOWER_BAND 0.04 //36  (最低心跳)
#define FILTER_UPPER_BAND 0.2 //180  (最高心跳)

- (double**)buttterworthValues{
    if (!_buttterworthValues) {
        double frequencyBands[2] = {FILTER_LOWER_BAND , FILTER_UPPER_BAND};
        _buttterworthValues = butter(frequencyBands, FILTER_ORDER);
    }
    return _buttterworthValues;
}

// outside API

- (BOOL)isCalibrationOver{
    // self.calibrationDuration == 90  self.filterWindowSize == 60  self.windowSize==9
    if ((self.framesCounter > self.calibrationDuration + self.filterWindowSize) && (self.framesCounter > (self.calibrationDuration + self.firstPeakPlace + self.windowSize))) {
        _isCalibrationOver = YES;
    }
    else {
        _isCalibrationOver = NO;
    }
    return _isCalibrationOver;
}

#define FINAL_RESULT_MARGIN 1.5

- (BOOL)isFinalResultDetermined{
    if (self.isCalibrationOver) {
        if ((fabs(self.bpmLatestResult - [self.bpmAverageValues[self.framesCounter - (int)(self.calibrationDuration/2)-self.windowSize-1] doubleValue]) <= FINAL_RESULT_MARGIN*2/3) &&
            (fabs(self.bpmLatestResult - [self.bpmAverageValues[self.framesCounter - self.calibrationDuration-self.windowSize -1] doubleValue]) <= FINAL_RESULT_MARGIN)) {
                return _isFinalResultDetermined = YES;
        }
        else {
            _isFinalResultDetermined = NO;//*
        }
    }
    else {
        _isFinalResultDetermined = NO;//*
    }
    return _isFinalResultDetermined;
}

- (CGFloat)bpmLatestResult
{
    if (self.isCalibrationOver) {
        return [self.bpmAverageValues[self.framesCounter-self.windowSize - 1] doubleValue];
    }
    return 0;
}

- (BOOL)shouldShowLatestResult
{
    if (self.isCalibrationOver && (self.framesCounter > self.calibrationDuration + self.firstPeakPlace + self.windowSize + self.windowSizeForAverageCalculation)) {

        if (fabs([self.bpmAverageValues[self.framesCounter-self.calibrationDuration-self.windowSize - 1] doubleValue] - [self.bpmAverageValues[self.framesCounter-self.calibrationDuration-self.windowSize - 2] doubleValue]) < 0.083) {

            if (fabs([self.bpmAverageValues[self.framesCounter-self.calibrationDuration/2-self.windowSize - 1] doubleValue] - [self.bpmAverageValues[self.framesCounter-self.calibrationDuration/2-self.windowSize - 2] doubleValue]) < 0.066) {
                
                if (fabs([self.bpmAverageValues[self.framesCounter-self.windowSize - 1] doubleValue] - [self.bpmAverageValues[self.framesCounter-self.windowSize - 2] doubleValue]) < 0.05) {
                    _shouldShowLatestResult = YES;
                }
            }
        }
    }
    return _shouldShowLatestResult;
}

//

- (CGFloat)getColorValueFrom:(UIColor *)color
{
    // default value is green (for iphone 5)
    CGFloat green;
    
    if ([color getRed:nil green:&green blue:nil alpha:nil]) {
        return green*255.0f;
    }
    else {
        //error
        NSLog(@"color error");
        return 0;
    }
}

//

- (void)getLatestPoints:(NSUInteger)numOfPoints andSetIntoDoubleArray:(double *)arrayOfDoubles{
    NSRange range;
    range.length = numOfPoints;
    range.location = [self.points count] - range.length;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    NSUInteger index = [indexSet firstIndex];
    //获取最后numOfPoints个点
    for (int i=0; index != NSNotFound ; i++ , index = [indexSet indexGreaterThanIndex: index]) {
        arrayOfDoubles[i] = [self.points[index] doubleValue];
    }
}

- (BOOL)isPeak:(double *)graph :(NSInteger)window
{
    // graph size should be window*2+1
    // window must be positive
    
    if (self.framesCounter-window-1 - self.lastPeakPlace < window) {
        return NO;
    }
    
    double middlePoint = graph[window];
    for (NSInteger i=0; i < window; i++) {
        if (middlePoint <= graph[i]) { // the middle point should be larger from all points detected before it
            return NO;
        }
    }
    for (NSInteger i=window+1; i <= 2*window; i++) {
        if (middlePoint < graph[i]) {// the middle point should be larger or equal to all points detected after it
            return NO;
        }
    }
    return YES;
}

- (double)mean:(double *)points withSize:(NSInteger)n
{
    double sum = 0;
    for (NSInteger i=0 ; i<n ; i++) {
        sum += points[i];
    }
    return sum/n;
}

- (void)Substract:(double)num fromArray:(double *)points withSize:(NSInteger)n
{
    for (NSInteger i=0 ; i<n ; i++) {
        points[i] -= num;
        //points[i] *= -1;//*
    }
}

- (BOOL)isMissedPeak
{
    double excpectedFramesSinceLastPeak = 1/(self.bpmLatestResult/(60*self.frameRate));
    double marginFactor = 0.5;
    if (self.framesCounter - self.windowSize - 1 - self.lastPeakPlace > (1+marginFactor)*excpectedFramesSinceLastPeak) {
        printf("missed peak\n");
        return YES;
    }
    return NO;
}

//心跳次数范围

#define DEFAULT_BPM_VALUE 72
#define MIN_BPM_VALUE 36
#define MAX_BPM_VALUE 180

- (void)newFrameDetectedWithAverageColor:(UIColor *)color
{
    //
     CGFloat g = [self getColorValueFrom:color];
    if(self.filterBlock){
        self.filterBlock(g);
    }
    if (self.isFinalResultDetermined) {
        // do nothing
        //return;
    }
    
   
    self.framesCounter++;
    [self.points addObject:@(g)];
    [self.isPeak addObject:@(NO)];
    [self.bpmValues addObject:@(DEFAULT_BPM_VALUE)];
    [self.bpmAverageValues addObject:@(DEFAULT_BPM_VALUE)];
    
    NSUInteger i = self.framesCounter;
    NSUInteger w = self.windowSize;
    NSUInteger calib = self.calibrationDuration;

    if (i <= self.filterWindowSize) {
        return;// continue, nothing to be done yet
    }
    
    //
    NSUInteger dynamicwindowSize = self.filterWindowSize+1;
    double x[dynamicwindowSize] , y[dynamicwindowSize];
    //获取poits 最后numOfPoints个点
    [self getLatestPoints:dynamicwindowSize andSetIntoDoubleArray:x];
    //mean..widthSize获取x中的平均值    Substract方法让x中元素减去平均值保存在x数组中
    [self Substract:[self mean:x withSize:dynamicwindowSize] fromArray:x withSize:dynamicwindowSize];
    filter(2*FILTER_ORDER, self.buttterworthValues[1], self.buttterworthValues[0], dynamicwindowSize, x, y);
    double *z = y+dynamicwindowSize-2*w-1;

    if (!self.firstPeakPlace) {
        
        self.isPeak[i-w-1] = @([self isPeak:z :w]);
        
        self.numOfPeaks += [self.isPeak[i-w-1] boolValue];
        
        if ([self.isPeak[i-w-1] boolValue]) {
            self.firstPeakPlace = i-w-1;
            self.bpmValues[i-w-1] = @(0);
            self.bpmAverageValues[i-w-1] = @(0);
        }
        
        return;// continue
    }
    //calib == 90
    if (i < calib + self.firstPeakPlace + w + 1) {
        
        self.isPeak[i-w-1] = @([self isPeak:z :w]);
        
        self.numOfPeaks += [self.isPeak[i-w-1] integerValue];
        
        NSUInteger frames = i - self.firstPeakPlace-1;
        if (frames > calib) {
            frames = calib;
        }
        
        self.bpmValues[i-w-1] = @(MIN(MAX((self.numOfPeaks/(frames/self.frameRate))*60 , MIN_BPM_VALUE), MAX_BPM_VALUE));
        double k = i-(self.firstPeakPlace+w+1) - 1 + 4.5;// + 4.5 to improve calibration result for low bpm
        double sensitiveFactor = 1.5;// adjust this bigger the make the algorithm more sensitive to changes
        self.bpmAverageValues[i-w-1] = @([self.bpmAverageValues[i-w-2] doubleValue] * k/(k+sensitiveFactor) + [self.bpmValues[i-w-1] doubleValue] * sensitiveFactor/(k+sensitiveFactor));
    }
    
    else {
        //calibration is over
        
        if (i < calib + (self.firstPeakPlace + w + 1) + 2.5*30){
            self.isPeak[i-w-1] = @([self isPeak:z :w]);
        } else {
            self.isPeak[i-w-1] = @([self isMissedPeak] ? 1 : [self isPeak:z :w]);//*
            self.isMissedTheLastPeak = [self isMissedPeak];
        }
        
        self.numOfPeaks += [self.isPeak[i-w-1] integerValue] - [self.isPeak[i-w-1-calib] integerValue];
        
        NSUInteger frames = calib;
        
        self.bpmValues[i-w-1] = @(MIN(MAX((self.numOfPeaks/(frames/self.frameRate))*60 , MIN_BPM_VALUE), MAX_BPM_VALUE));
        
        double tempSum = 0;
        for (int j = 1; j <= self.windowSizeForAverageCalculation; j++) {
            tempSum += [self.bpmValues[i-w-1-self.windowSizeForAverageCalculation+j] doubleValue];
        }
        double average_bpm = tempSum/self.windowSizeForAverageCalculation;
        
        int calibrationWeight = 2.5;// simulate the weight of the calibration calculated results.
        double sensitiveFactor = 2.5;// adjust this bigger the make the algorithm more sensitive to changes
        int k = i - (calib + self.firstPeakPlace + w + 1) + calibrationWeight;
        self.bpmAverageValues[i-w-1] = @([self.bpmAverageValues[i-w-2] doubleValue] * k/(k+sensitiveFactor) + average_bpm * sensitiveFactor/(k+sensitiveFactor));
        
    }
    
    self.isPeakInLastFrame = [self.isPeak[i-w-1] boolValue];
    
    if ([self.isPeak[i-w-1] boolValue]) {
        self.lastPeakPlace = i-w-1;
        printf("%d\n" , i-w-1);
    }

}

@end
