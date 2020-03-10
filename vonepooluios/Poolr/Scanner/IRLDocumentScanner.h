#import <Availability.h>

#ifndef __IPHONE_8_0
#warning "This project uses features only available in iPhone SDK 8.0 and later."
#endif

// Version
#define IRLDOCUMENTSCANNER_VERSION       @"0.2.0"

// iOS Framework
#ifdef __OBJC__
@import UIKit;
@import CoreImage;
@import AVFoundation;
@import GLKit;
#endif

// All-in-one Scanner
#import "IRLScannerViewController.h"
