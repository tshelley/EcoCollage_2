//
//  StackedBarGraph.m
//  AprilTest
//
//  Created by Ugrad Research on 11/5/15.
//  Copyright (c) 2015 Tia. All rights reserved.
//

#import "StackedBarGraph.h"

@implementation StackedBarGraph

@synthesize stackedBars = _stackedBars;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame andTabController:(AprilTestTabBarController *)tabControl {
    self = [super initWithFrame:frame];
    
    
    _stackedBars = [[NSMutableArray alloc]init];
    
    int x = 0;
    int y;
    
    // fill this with the max scores for each outcome category over the span of all trials and all users
    NSMutableArray *maxScores = [[NSMutableArray alloc]init];
    
    int maxInvestment = 0, maxDamageReduction = 0, maxEfficiency = 0, maxCapacity = 0, maxWaterFlow = 0, maxMaxFlood = 0, maxGroundwaterInfiltration = 0, maxImpact = 0;
    
    // find the max value for each outcome category
    // this will determine the "height" for that category
    for(int i = 0; i < tabControl.trialRuns.count; i++) {
        for(int j = 0; j < tabControl.profiles.count; j++) {
            NSMutableArray* scores = [tabControl getScoreBarValuesForProfile:j forTrial:i isDynamicTrial:0];
            NSMutableArray* scoreVisVals = [scores objectAtIndex:0];
            NSMutableArray* scoreVisNames = [scores objectAtIndex:1];
            
            for(int k = 0; k < scoreVisNames.count; k++) {
                if([[scoreVisNames objectAtIndex:k] isEqualToString:@"publicCost"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxInvestment)) {
                    maxInvestment = [[scoreVisVals objectAtIndex:k]floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"privateCostD"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxDamageReduction)) {
                    maxDamageReduction = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"impactingMyNeighbors"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxImpact)) {
                    maxImpact = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"groundwaterInfiltration"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxGroundwaterInfiltration)) {
                    maxGroundwaterInfiltration = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"puddleTime"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxWaterFlow)) {
                    maxWaterFlow = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"puddleMax"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxMaxFlood)) {
                    maxMaxFlood = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"capacity"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxCapacity)) {
                    maxCapacity = [[scoreVisVals objectAtIndex:k] floatValue] * 100 ;
                }
                else if([[scoreVisNames objectAtIndex:k] isEqualToString:@"efficiencyOfIntervention"] && ([[scoreVisVals objectAtIndex:k] floatValue] * 100 > maxEfficiency)) {
                    maxEfficiency = [[scoreVisVals objectAtIndex:k] floatValue] * 100;
                }
            }
        }
    }
    
    // must be added in this specific order
    [maxScores addObject:[NSNumber numberWithInt:maxInvestment]];
    [maxScores addObject:[NSNumber numberWithInt:maxDamageReduction]];
    [maxScores addObject:[NSNumber numberWithInt:maxEfficiency]];
    [maxScores addObject:[NSNumber numberWithInt:maxCapacity]];
    [maxScores addObject:[NSNumber numberWithInt:maxWaterFlow]];
    [maxScores addObject:[NSNumber numberWithInt:maxMaxFlood]];
    [maxScores addObject:[NSNumber numberWithInt:maxGroundwaterInfiltration]];
    [maxScores addObject:[NSNumber numberWithInt:maxImpact]];
    
    // create a stackedBar for each trial for each profile
    for(int i = 0; i < tabControl.trialNum; i++) {
        y = self.frame.size.height;
        for(int j = 0; j < tabControl.profiles.count; j++) {
            NSMutableArray* scores = [tabControl getScoreBarValuesForProfile:j forTrial:i isDynamicTrial:0];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resize:)];
            tapRecognizer.numberOfTapsRequired = 1;
            
            StackedBar *bar = [[StackedBar alloc]initWithFrame:CGRectMake(x, y, 30, 100) andProfile:[tabControl.profiles objectAtIndex:j] andWidth:30 andScores:scores andScaleSize:1 andMaxScores:maxScores];
            [_stackedBars addObject:bar];
            
            [bar setUserInteractionEnabled:YES];
            [bar addGestureRecognizer:tapRecognizer];
        }
        x += 40;
    }
    
    // add all the bars to this view
    for(StackedBar *s in _stackedBars) {
        [self addSubview:s];
    }
 
    return self;
}

- (void)resize:(UITapGestureRecognizer *)gr {
    StackedBar *sb = (StackedBar*)gr.view;
    
    int resizeFactor = 2;
    CGPoint center = sb.center;
    
    // if it is shrunk, we need to grow it
    if(sb.shrunk == 1) {
        [sb setFrame:CGRectMake(sb.frame.origin.x, sb.frame.origin.y, sb.frame.size.width * resizeFactor, sb.frame.size.height)];
        [sb setCenter:center];
        sb.shrunk = 0;
    }
    else { // otherwise, we need to shrink it
        [sb setFrame:CGRectMake(sb.frame.origin.x, sb.frame.origin.y, sb.frame.size.width / resizeFactor, sb.frame.size.height)];
        [sb setCenter:center];
        sb.shrunk = 1;
    }
}




@end