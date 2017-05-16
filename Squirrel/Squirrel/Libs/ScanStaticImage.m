//
//  ScanStaticImage.m
//  Squirrel
//
//  Created by Duc Nguyen on 5/15/17.
//  Copyright © 2017 Squirrel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanStaticImage.h"
#import "ZXingObjC.h"

@implementation ScanStaticImage

- (NSString *)scanForQR:(UIImage *)image
{
//    CGImageRef imageToDecode = image.CGImage; // Given a CGImage in which we are looking for barcodes
    ZXImage *imageToDecode = [[ZXImage alloc] initWithCGImageRef:[image CGImage]];
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode.cgimage];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    hints.tryHarder = YES;
    hints.pureBarcode = YES;
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        
        return contents;
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        return nil;
    }
    
    
    return nil;
}

@end
