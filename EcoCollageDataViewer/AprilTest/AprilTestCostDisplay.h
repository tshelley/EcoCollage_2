//
//  AprilTestCostDisplay.h
//  AprilTest
//
//  Created by Tia on 3/30/15.
//  Copyright (c) 2015 Tia. All rights reserved.
//

@interface AprilTestCostDisplay : UIView
@property UIView *view;
@property float cost;
@property float normScore;
- (id) initWithCost: (float) cost andScore: (float) normScore andFrame: (CGRect) frame;


@end
