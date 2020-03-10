//
//  IRLScannerViewController
//
//  Created by Denis Martin on 28/06/2015.
//  Copyright (c) 2015 Denis Martin. All rights reserved.
//

#import "IRLScannerViewController.h"
#import "IRLCameraView.h"

@interface IRLScannerViewController () <IRLCameraViewProtocol>

@property (weak)                        id<IRLScannerViewControllerDelegate> camera_PrivateDelegate;


@property (weak, nonatomic, readwrite)  IBOutlet UIButton       *cancel_button;
@property (weak, nonatomic) IBOutlet UILabel *scannerTitleLabel;

@property (weak, nonatomic)             IBOutlet IRLCameraView  *cameraView;


@property (readwrite, nonatomic)        IRLScannerViewType                   cameraViewType;

@property (readwrite, nonatomic)        IRLScannerDetectorType               detectorType;

@end

@implementation IRLScannerViewController

#pragma mark - Initializer

+ (instancetype)standardCameraViewWithDelegate:(id<IRLScannerViewControllerDelegate>)delegate {
    return [self cameraViewWithDefaultType:IRLScannerViewTypeNormal defaultDetectorType:IRLScannerDetectorTypeAccuracy withDelegate:delegate];
}

+ (instancetype)cameraViewWithDefaultType:(IRLScannerViewType)type
                      defaultDetectorType:(IRLScannerDetectorType)detector
                             withDelegate:(id<IRLScannerViewControllerDelegate>)delegate {
    
    NSAssert(delegate != nil, @"You must provide a delegate");
    
    IRLScannerViewController*    cameraView = [[UIStoryboard storyboardWithName:@"IRLCamera" bundle:[NSBundle bundleForClass:self]] instantiateInitialViewController];
    cameraView.cameraViewType = type;
    cameraView.detectorType = detector;
    cameraView.camera_PrivateDelegate = delegate;
    cameraView.showControls = YES;
    cameraView.detectionOverlayColor = [UIColor blueColor];
    return cameraView;
}

#pragma mark - Button delegates

-(IBAction)cancelTapped:(id)sender{
    if (self.camera_PrivateDelegate){
        [self.camera_PrivateDelegate didCancelIRLScannerViewController:self];
    }
}

#pragma mark - Setters

- (void)setCameraViewType:(IRLScannerViewType)cameraViewType {
    _cameraViewType = cameraViewType;
    [self.cameraView setCameraViewType:cameraViewType];
}

- (void)setDetectorType:(IRLScannerDetectorType)detectorType {
    _detectorType = detectorType;
    [self.cameraView setDetectorType:detectorType];
}

- (void)setShowControls:(BOOL)showControls {
    _showControls = showControls;
   
}

- (void)setShowAutoFocusWhiteRectangle:(BOOL)showAutoFocusWhiteRectangle {
    _showAutoFocusWhiteRectangle = showAutoFocusWhiteRectangle;
    [self.cameraView setEnableShowAutoFocus:showAutoFocusWhiteRectangle];
}

- (void)setPoolType:(NSString *)poolType {
    _poolType = poolType;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cameraView setupCameraView];
    [self.cameraView setDelegate:self];
    [self.cameraView setOverlayColor:self.detectionOverlayColor];
    [self.cameraView setDetectorType:self.detectorType];
    [self.cameraView setCameraViewType:self.cameraViewType];
    [self.cameraView setEnableShowAutoFocus:self.showAutoFocusWhiteRectangle];
    [self.cameraView setEnableBorderDetection:YES];
    [self.cameraView setEnableTorch:true];
    
    self.scannerTitleLabel.text = self.poolType;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.cameraView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cameraView stop];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.cameraView prepareForOrientationChange];
    
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // we just want the completion handler
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [weakSelf.cameraView finishedOrientationChange];
        
    }];
}

#pragma mark - CameraVC Actions

- (IBAction)cancelButtonPush:(id)sender {
 
    [self.cameraView stop];


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([self.camera_PrivateDelegate respondsToSelector:@selector(cameraViewCancelRequested:)]) {
        [self.camera_PrivateDelegate cameraViewCancelRequested:self];
    }
#pragma clang diagnostic pop

    if ([self.camera_PrivateDelegate respondsToSelector:@selector(didCancelIRLScannerViewController:)]) {
        [self.camera_PrivateDelegate didCancelIRLScannerViewController:self];
    }
}


#pragma mark - IRLCameraViewProtocol

-(void)didLostConfidence:(IRLCameraView*)view {

}

-(void)didDetectRectangle:(IRLCameraView*)view withConfidence:(NSUInteger)confidence {

}

-(void)didGainFullDetectionConfidence:(IRLCameraView*)view {
    
    [self.cameraView captureImageWithCompletionHander:^(id data) {
        UIImage *image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
        
        if (self.camera_PrivateDelegate){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 *NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.camera_PrivateDelegate pageSnapped:image from:self];
            });
        }
    }];
}


@end
