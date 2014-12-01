//
//  UIView+KCRViewUtilites.h
//  Kindred Core
//
//  Created by Mladen Despotovic on 11/05/2014.
//  Copyright 2003-2014 Monitise Group Limited. All Right Reserved.
//
//  Save to the extent permitted by law, you may not use, copy, modify,
//  distribute or create derivative works of this material or any part
//  of it without the prior written consent of Monitise Group Limited.
//  Any reproduction of this material must contain this notice.
//

typedef NS_OPTIONS(NSInteger, KCRPerforationPosition)
{
    KCRPerforationPositionNone      = 0,
    KCRPerforationPositionTop       = 1 << 0,
    KCRPerforationPositionBottom    = 1 << 1,
    KCRPerforationPositionLeft      = 1 << 2,
    KCRPerforationPositionRight     = 1 << 3
};

/**
 This category provides various UIView utilities that don't have very specific
 connection to specific functionality
 */
@interface UIView (KCRViewUtilites)

/**
 Method cuts perforation that is defined by circle and lines between specified number of dots on the circle radius
 thus acomplishing cutting various patterns
 
 @param paramRadius Radius of the circle
 @param paramPoints Number of pounts on circle radius connected with line
 @param paramPositions 2 possible positions defined as KCRPerforationPosition options
 */
- (void)cutRoundDiscretePerforationWithRadius:(CGFloat)paramRadius
                               pointsOnCircle:(NSUInteger)paramPoints
                                  onPositions:(KCRPerforationPosition)paramPositions;

- (void)cutSquarePerforationWithLength:(CGFloat)paramLength
                           onPositions:(KCRPerforationPosition)paramPositions;

- (void)cutSeesawPerforationWithLength:(CGFloat)paramLength
                           onPositions:(KCRPerforationPosition)paramPositions;


@end
