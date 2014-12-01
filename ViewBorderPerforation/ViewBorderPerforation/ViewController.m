//
//  ViewController.m
//  ViewBorderPerforation
//
//  Created by Mladen Despotovic on 01/12/14.
//  Copyright (c) 2014 Mladen Despotovic. All rights reserved.
//

#import "ViewController.h"
#import "UIView+KCRViewUtilites.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *foregroundView1;
@property (nonatomic, weak) IBOutlet UIView *foregroundView2;
@property (nonatomic, weak) IBOutlet UIView *foregroundView3;
@property (nonatomic, weak) IBOutlet UIView *foregroundView4;
@property (nonatomic, weak) IBOutlet UIView *foregroundView5;
@property (nonatomic, weak) IBOutlet UIView *foregroundView6;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self.foregroundView1 cutRoundDiscretePerforationWithRadius:20.0f
                                                         pointsOnCircle:1.0f
                                                            onPositions:KCRPerforationPositionTop | KCRPerforationPositionRight ];
    
    [self.foregroundView2 cutRoundDiscretePerforationWithRadius:20.0f
                                                 pointsOnCircle:2.0f
                                                    onPositions:KCRPerforationPositionTop | KCRPerforationPositionRight ];
    
    [self.foregroundView3 cutRoundDiscretePerforationWithRadius:20.0f
                                                 pointsOnCircle:3.0f
                                                    onPositions:KCRPerforationPositionTop | KCRPerforationPositionRight ];
    
    [self.foregroundView4 cutRoundDiscretePerforationWithRadius:20.0f
                                                 pointsOnCircle:20.0f
                                                    onPositions:KCRPerforationPositionTop | KCRPerforationPositionRight ];
    
    [self.foregroundView5 cutSquarePerforationWithLength:25.0f
                                             onPositions:KCRPerforationPositionTop | KCRPerforationPositionRight];
    
    [self.foregroundView6 cutSeesawPerforationWithLength:21.0f
                                             onPositions:KCRPerforationPositionTop | KCRPerforationPositionBottom];
}



@end
