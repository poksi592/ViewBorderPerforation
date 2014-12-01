//
//  ViewController.h
//  ViewBorderPerforation
//
//  Created by Mladen Despotovic on 01/12/14.
//  Copyright (c) 2014 Mladen Despotovic. All rights reserved.
//

#import "UIView+KCRViewUtilites.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

static id KCRViewUtilitesFoundSubview = nil;
static id KCRViewUtilitiesFoundTopView = nil;


@implementation UIView (KCRViewUtilites)


- (void)cutRoundDiscretePerforationWithRadius:(CGFloat)paramRadius
                               pointsOnCircle:(NSUInteger)paramPoints
                                  onPositions:(KCRPerforationPosition)paramPositions
{
    if (paramPoints < 1) {
        
        return;
    }
    
    CGMutablePathRef perforationPath = CGPathCreateMutable();
    
    __block CGFloat Xpos = 0;
    __block CGFloat Ypos = 0;
    __block CGFloat lineLength = 0;
    CGFloat radianStep = M_PI / (paramPoints + 1);
    __block NSUInteger numberOfCuts = 0;
    
    
    typedef void (^CutHorizontalPath)(BOOL isTop);

    CutHorizontalPath horizontalPathBlock = ^(BOOL isTop) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Xpos = (self.bounds.size.width - (numberOfCuts * paramRadius * 3) - paramRadius) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            Xpos += paramRadius;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            CGFloat currentRadian = 0;
            CGPathMoveToPoint(perforationPath, NULL, Xpos + paramRadius * 2, Ypos);
            for (NSInteger pointCounter = 0; pointCounter < paramPoints; pointCounter++) {
                
                if (isTop) {
                    
                    currentRadian += radianStep;
                }
                else {
                    
                    currentRadian -= radianStep;
                }
                
                CGFloat circleX = (Xpos + paramRadius) + (paramRadius * cos(currentRadian));
                CGFloat circleY = Ypos + (paramRadius * sin(currentRadian));
                CGPathAddLineToPoint(perforationPath, NULL, circleX, circleY);
            }
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            Xpos += paramRadius * 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
            
        }
        
        if (Xpos < self.bounds.size.width) {
            
            CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        }
    };
    
        
    typedef void (^CutVerticalPath)(BOOL isLeft);
    
    CutVerticalPath verticalPathBlock = ^(BOOL isLeft) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Ypos = (self.bounds.size.height - (numberOfCuts * paramRadius * 3) - paramRadius) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            Ypos += paramRadius;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            CGFloat currentRadian = M_PI / 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos + paramRadius * 2);
            for (NSInteger pointCounter = 0; pointCounter < paramPoints; pointCounter++) {
                
                if (isLeft) {
                    
                    currentRadian -= radianStep;
                }
                else {
                    
                    currentRadian += radianStep;
                }
                
                CGFloat circleX = Xpos + (paramRadius * cos(currentRadian));
                CGFloat circleY = Ypos + paramRadius + (paramRadius * sin(currentRadian));
                CGPathAddLineToPoint(perforationPath, NULL, circleX, circleY);
            }
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
            Ypos += paramRadius * 2;
            CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
            
        }
        
        if (Ypos < self.bounds.size.height) {
            
            CGPathMoveToPoint(perforationPath, NULL, Xpos, self.bounds.size.height);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        }
    };

    
    if (paramPositions & KCRPerforationPositionTop) {
        
        Xpos = 0.f;
        Ypos = 0.f;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));

        horizontalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, 0);
    }
    
    if (paramPositions & KCRPerforationPositionRight) {
        
        Xpos = self.bounds.size.width;
        Ypos = 0.f;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
    
        verticalPathBlock(NO);

    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionBottom) {
        
        Xpos = 0.f;
        Ypos = self.bounds.size.height;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
        
        horizontalPathBlock(NO);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionLeft) {
        
        Xpos = 0;
        Ypos = 0;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramRadius * 3));
        
        verticalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, 0);
    }
    
    
    CGPathAddRect(perforationPath, NULL, self.bounds);
    
    CAShapeLayer *perforationMaskLayer = [CAShapeLayer new];
    perforationMaskLayer.path = perforationPath;
    CFRelease(perforationPath);

    perforationMaskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = perforationMaskLayer;

}


- (void)cutSquarePerforationWithLength:(CGFloat)paramLength
                           onPositions:(KCRPerforationPosition)paramPositions
{
    CGMutablePathRef perforationPath = CGPathCreateMutable();
    
    __block CGFloat Xpos = 0;
    __block CGFloat Ypos = 0;
    __block CGFloat lineLength = 0;
    __block NSUInteger numberOfCuts = 0;
    
    typedef void (^CutHorizontalPath)(BOOL isTop);

    CutHorizontalPath horizontalPathBlock = ^(BOOL isTop) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Xpos = (self.bounds.size.width - (numberOfCuts * paramLength * 2) - paramLength) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            CGFloat YposOffset = paramLength;
            if (!isTop) {
                
                YposOffset = -paramLength;
            }
            
            Xpos += paramLength;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos + YposOffset);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + paramLength, Ypos + YposOffset);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + paramLength, Ypos);
            Xpos += paramLength;
            
        }
        
        if (Xpos < self.bounds.size.width) {
            
            CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
         
        }
    };
    
    
    typedef void (^CutVerticalPath)(BOOL isLeft);
    
    CutVerticalPath verticalPathBlock = ^(BOOL isLeft) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Ypos = (self.bounds.size.height - (numberOfCuts * paramLength * 2) - paramLength) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            CGFloat XposOffset = paramLength;
            if (!isLeft) {
                
                XposOffset = -paramLength;
            }
            
            Ypos += paramLength;
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + XposOffset, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + XposOffset, Ypos + paramLength);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos + paramLength);
            Ypos += paramLength;
            
        }
        
        if (Ypos < self.bounds.size.height) {

            CGPathMoveToPoint(perforationPath, NULL, Xpos, self.bounds.size.height);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        }
    };
    
    
    if (paramPositions & KCRPerforationPositionTop) {
        
        Xpos = 0.f;
        Ypos = 0.f;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramLength * 2));
        
        horizontalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, 0);
    }
    
    if (paramPositions & KCRPerforationPositionRight) {
        
        Xpos = self.bounds.size.width;
        Ypos = 0.f;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramLength * 2));
        
        verticalPathBlock(NO);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionBottom) {
        
        Xpos = 0.f;
        Ypos = self.bounds.size.height;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / (paramLength * 2));
        
        horizontalPathBlock(NO);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionLeft) {
        
        Xpos = 0;
        Ypos = 0;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / (paramLength * 2));
        
        verticalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, 0);
    }
    
    
    CGPathAddRect(perforationPath, NULL, self.bounds);
    
    CAShapeLayer *perforationMaskLayer = [CAShapeLayer new];
    perforationMaskLayer.path = perforationPath;
    CFRelease(perforationPath);
    
    perforationMaskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = perforationMaskLayer;
    
}


- (void)cutSeesawPerforationWithLength:(CGFloat)paramLength
                           onPositions:(KCRPerforationPosition)paramPositions

{
    CGMutablePathRef perforationPath = CGPathCreateMutable();
    
    __block CGFloat Xpos = 0;
    __block CGFloat Ypos = 0;
    __block CGFloat lineLength = 0;
    __block NSUInteger numberOfCuts = 0;
    
    typedef void (^CutHorizontalPath)(BOOL isTop);
    
    CutHorizontalPath horizontalPathBlock = ^(BOOL isTop) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Xpos = (self.bounds.size.width - numberOfCuts * paramLength) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            CGFloat YposOffset = sqrt(3) * paramLength / 2;
            if (!isTop) {
                
                YposOffset = -paramLength;
            }

            CGPathAddLineToPoint(perforationPath, NULL, Xpos + paramLength / 2, Ypos + YposOffset);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + paramLength, Ypos);
            Xpos += paramLength;
            
        }
        
        if (Xpos < self.bounds.size.width) {
            
            CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, Ypos);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
            
        }
    };
    
    
    typedef void (^CutVerticalPath)(BOOL isLeft);
    
    CutVerticalPath verticalPathBlock = ^(BOOL isLeft) {
        
        CGPathMoveToPoint(perforationPath, NULL, Xpos, Ypos);
        Ypos = (self.bounds.size.height - numberOfCuts * paramLength) / 2;
        CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        
        for (NSInteger cutCounter = 0; cutCounter < numberOfCuts; cutCounter++) {
            
            CGFloat XposOffset = sqrt(3) * paramLength / 2;
            if (!isLeft) {
                
                XposOffset = -paramLength;
            }
            
            CGPathAddLineToPoint(perforationPath, NULL, Xpos + XposOffset, Ypos + paramLength / 2);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos + paramLength);
            Ypos += paramLength;
            
        }
        
        if (Ypos < self.bounds.size.height) {
            
            CGPathMoveToPoint(perforationPath, NULL, Xpos, self.bounds.size.height);
            CGPathAddLineToPoint(perforationPath, NULL, Xpos, Ypos);
        }
    };
    
    
    if (paramPositions & KCRPerforationPositionTop) {
        
        Xpos = 0.f;
        Ypos = 0.f;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / paramLength);
        
        horizontalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, 0);
    }
    
    if (paramPositions & KCRPerforationPositionRight) {
        
        Xpos = self.bounds.size.width;
        Ypos = 0.f;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / paramLength);
        
        verticalPathBlock(NO);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, 0);
        CGPathAddLineToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionBottom) {
        
        Xpos = 0.f;
        Ypos = self.bounds.size.height;
        lineLength = self.bounds.size.width;
        numberOfCuts = (NSUInteger)(lineLength / paramLength );
        
        horizontalPathBlock(NO);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, self.bounds.size.height);
    }
    
    if (paramPositions & KCRPerforationPositionLeft) {
        
        Xpos = 0;
        Ypos = 0;
        lineLength = self.bounds.size.height;
        numberOfCuts = (NSUInteger)(lineLength / paramLength);
        
        verticalPathBlock(YES);
        
    }
    else {
        
        CGPathMoveToPoint(perforationPath, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(perforationPath, NULL, 0, 0);
    }
    
    
    CGPathAddRect(perforationPath, NULL, self.bounds);
    
    CAShapeLayer *perforationMaskLayer = [CAShapeLayer new];
    perforationMaskLayer.path = perforationPath;
    CFRelease(perforationPath);
    
    perforationMaskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = perforationMaskLayer;
    
}



@end






