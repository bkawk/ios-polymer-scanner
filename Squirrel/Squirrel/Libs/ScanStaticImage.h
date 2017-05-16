//
//  ScanStaticImage.h
//  Squirrel
//
//  Created by Duc Nguyen on 5/15/17.
//  Copyright © 2017 Squirrel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScanStaticImage : NSObject

- (NSString *)scanForQR:(UIImage *)image;

@end
