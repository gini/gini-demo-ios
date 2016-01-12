//
//  ViewController.m
//  gini-demo
//
//  Created by Gini on 11/11/15.
//  Copyright © 2015 Gini. All rights reserved.
//

#import "GiniDemoViewController.h"
#import "GiniDemoAppDelegate.h"
#import "GiniDemoDocumentDetailTableViewController.h"

// Import Gini Vision Library to use the photo module
#import <GiniVision/GiniVision.h>

// Import Gini SDK to communicate with the Gini API
#import <Gini-iOS-SDK/GiniSDK.h>

@interface GiniDemoViewController () <GiniVisionDelegate>

@property (nonatomic, weak) NSUserDefaults *userDefaults;

@end

@implementation GiniDemoViewController

- (void)viewDidLoad {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)startGiniVisionModule:(id)sender {
    /**
     * If you'd like to configure the module check out the [documentation](http://developer.gini.net/ginivision-ios/guides/style-the-module.html) for more information.
     * There it will be described how to use the `GiniConfiguration` class.
     *
     * To keep this code clean and simple we'll go with the standard configuration.
     */
    [GiniVision setLogLevel:GINILogLevelNone];
    [GiniVision captureImageWithViewController:self delegate:self];
}

// MARK: GiniVisionDelegate
- (void)didScan:(UIImage *)document documentType:(GINIDocumentType)docType uploadDelegate:(id<GINIVisionUploadDelegate>)delegate {
    // Rectified and processed image created by the Gini Vision Module
    
    // If set save the processed image
    if ([_userDefaults boolForKey:@"storeRectifiedImageSetting"]) {
        [self storeImage:document withCondition:@"processed"];
    }
    
    /*********************************************
     * UPLOAD DOCUMENT WITH THE GINI SDK FOR IOS *
     *********************************************/
    
    [delegate didProgressWithMessage:@"Prepare document"];
    
    // Get current Gini SDK instance to upload image and process exctraction
    GiniSDK *sdk = ((GiniDemoAppDelegate *)[[UIApplication sharedApplication] delegate]).giniSDK;
    
    // Create a document task manager to handle document tasks on the Gini API
    GINIDocumentTaskManager *manager = sdk.documentTaskManager;
    
    // Create a file name for the document
    NSString *fileName = @"your_filename";
    
    __block GINIDocument *giniDocument;
    __block NSString *documentId;
    __block NSDictionary *extractions;
    
    [[[[[[sdk.sessionManager getSession] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            return [sdk.sessionManager logIn];
        }
        return task.result;
    }] continueWithSuccessBlock:^id(BFTask *task) {
        return [manager createDocumentWithFilename:fileName fromImage:document];
    }] continueWithSuccessBlock:^id(BFTask *task) {
        [delegate didProgressWithMessage:@"Analyse document"];
        giniDocument = (GINIDocument *)task.result;
        documentId = giniDocument.documentId;
        NSLog(@"documentId: %@", documentId);
        return giniDocument.extractions;
    }] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            NSLog(@"Error while handling documentation upload and extraction.");
            return nil;
        }
        extractions = (NSDictionary *)task.result;
        // Make something with the extractions
        // In this demo we will simply show the results
        return nil;
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        // Notify delegate that upload is finished, so Gini Vision UI gets dismissed
        if (extractions) {
            [self showDocumentDetailViewController:extractions];
        }
        [delegate didEndUpload];
        return nil;
    }];
}

- (void)didScanOriginal:(UIImage *)image {
    // Original image taken by the Gini Vision Module
    // If set save the original image
    if ([_userDefaults boolForKey:@"storeOriginalImageSetting"]) {
        [self storeImage:image withCondition:@"original"];
    }
}

- (void)didFinishCapturing:(BOOL)success {
    // Gini Vision Module UI was dismissed
}

- (void)didCancelUpload {
    // User wants to cancel the document upload
}

// MARK: Save images
- (void)storeImage:(UIImage *)image withCondition:(NSString *)condition {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self storeImage:image fileName:[NSString stringWithFormat:@"%@_%@.jpg", dateString, condition] compressionQuality:100.0];
}

- (void)storeImage:(UIImage *)image fileName:(NSString *)fileName compressionQuality:(float)compression {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:fileName];
    if (![UIImageJPEGRepresentation(image, compression / 100.0f) writeToFile:filePath atomically:YES]) {
        NSLog(@"Error writing image to disk.(%@)", fileName);
    }
}

// MARK: Navigation
- (void)showDocumentDetailViewController:(NSDictionary *)extractions {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GiniDemoDocumentDetailTableViewController *vc = (GiniDemoDocumentDetailTableViewController *)[sb instantiateViewControllerWithIdentifier:@"documentDetailViewController"];
    vc.extractions = [self rawValuesFromGiniExtractions:extractions];
    [self.navigationController pushViewController:vc animated:NO];
}

// MARK: Helper method
- (NSDictionary *)rawValuesFromGiniExtractions:(NSDictionary *)extractions {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:extractions.count];
    for (NSString *key in extractions) {
        GINIExtraction *extraction = (GINIExtraction *)extractions[key];
        dict[key] = extraction.value;
    }
    return dict;
}

@end
