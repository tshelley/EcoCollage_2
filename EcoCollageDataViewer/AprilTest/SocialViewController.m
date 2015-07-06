//
//  SocialViewController.m
//  AprilTest
//
//  Created by Ryan Fogarty on 6/2/15.
//  Copyright (c) 2015 Tia. All rights reserved.
//

#import "SocialViewController.h"
#import "AprilTestTabBarController.h"
#import "AprilTestSimRun.h"
#import "FebTestIntervention.h"
#import "AprilTestVariable.h"
#import "FebTestWaterDisplay.h"
#import "AprilTestEfficiencyView.h"
#import "AprilTestCostDisplay.h"
#import "AprilTestNormalizedVariable.h"
#import "XYPieChart.h"

@interface SocialViewController ()
@end

@implementation SocialViewController

@synthesize studyNum = _studyNum;
@synthesize profilesWindow = _profilesWindow;
@synthesize usernamesWindow = _usernamesWindow;
@synthesize trialNumber = _trialNumber;
@synthesize BudgetSlider = _BudgetSlider;
@synthesize StormPlayBack = _StormPlayBack;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize mapWindow = _mapWindow;

NSMutableDictionary *concernColors;
NSMutableDictionary *concernNames;
NSMutableDictionary *scoreColors;
NSMutableArray *OverBudgetLabels;
NSMutableArray * waterDisplays;
NSMutableArray *maxWaterDisplays;
NSMutableArray *efficiency;
int widthOfTitleVisualization = 220;
int heightOfVisualization = 200;
int dynamic_cd_width = 0;

//Important values that change elements of objects
float thresh_social = 6;
float hours_social = 0;
int hoursAfterStorm_social;
int maxBudget;
float min_budget = 100000;
float max_budget = 700000;
UILabel *budgetLabel;
UILabel *hoursAfterStormLabel;
UILabel *mapWindowStatusLabel;
NSArray *arrStatus_social;
int sortChosen_social= 0;
UIPickerView *SortType_social;
int smallSizeOfMapWindow = 50;
int largeSizeOfMapWindow = 220;
UIView *topOfMapWindow;
UIView *bottomOfMapWindow;
NSArray *sliceColors;
NSMutableArray *slices;
NSMutableDictionary *sliceNumbers;
NSMutableArray *slicesInfo;



- (void)viewDidLoad {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    _studyNum = tabControl.studyNum;
    
    self.trialNumber.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    concernColors = [[NSMutableDictionary alloc] initWithObjects:
                   [NSArray arrayWithObjects:
                    [UIColor colorWithHue:.3 saturation:.6 brightness:.9 alpha: 0.5],
                    [UIColor colorWithHue:.31 saturation:.6 brightness:.91 alpha: 0.5],
                    [UIColor colorWithHue:.32 saturation:.6 brightness:.92 alpha: 0.5],
                    [UIColor colorWithHue:.33 saturation:.6 brightness:.93 alpha: 0.5],
                    [UIColor colorWithHue:.35 saturation:.8 brightness:.6 alpha: 0.5],
                    [UIColor colorWithHue:.36 saturation:.8 brightness:.61 alpha: 0.5],
                    [UIColor colorWithHue:.37 saturation:.8 brightness:.62 alpha: 0.5],
                    [UIColor colorWithHue:.38 saturation:.8 brightness:.63 alpha: 0.5],
                    [UIColor colorWithHue:.4 saturation:.8 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.65 saturation:.8 brightness:.6 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.8 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.0 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.0 brightness:.9 alpha: 0.5],
                    [UIColor colorWithHue:.55 saturation:.8 brightness:.9 alpha: 0.5], nil]  forKeys: [[NSArray alloc] initWithObjects: @"Investment", @"publicCostI", @"publicCostM", @"publicCostD", @"Damage Reduction", @"privateCostI", @"privateCostM", @"privateCostD",  @"Efficiency of Intervention ($/Gallon)", @"Water Depth Over Time", @"Maximum Flooded Area", @"Groundwater Infiltration", @"Impact on my Neighbors", @"Capacity Used", nil] ];
    
    concernNames = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects: @"publicCost", @"privateCost", @"efficiencyOfIntervention", @"capacity", @"puddleTime", @"puddleMax", @"groundwaterInfiltration", @"impactingMyNeighbors", nil] forKeys:[[NSArray alloc] initWithObjects:@"Investment", @"Damage Reduction", @"Efficiency of Intervention ($/Gallon)", @"Capacity Used", @"Water Depth Over Time", @"Maximum Flooded Area", @"Groundwater Infiltration", @"Impact on my Neighbors", nil]];
    
    scoreColors = [[NSMutableDictionary alloc] initWithObjects:
                   [NSArray arrayWithObjects:
                    [UIColor colorWithHue:.3 saturation:.6 brightness:.9 alpha: 0.5],
                    [UIColor colorWithHue:.31 saturation:.6 brightness:.91 alpha: 0.5],
                    [UIColor colorWithHue:.32 saturation:.6 brightness:.92 alpha: 0.5],
                    [UIColor colorWithHue:.33 saturation:.6 brightness:.93 alpha: 0.5],
                    [UIColor colorWithHue:.35 saturation:.8 brightness:.6 alpha: 0.5],
                    [UIColor colorWithHue:.36 saturation:.8 brightness:.61 alpha: 0.5],
                    [UIColor colorWithHue:.37 saturation:.8 brightness:.62 alpha: 0.5],
                    [UIColor colorWithHue:.38 saturation:.8 brightness:.63 alpha: 0.5],
                    [UIColor colorWithHue:.4 saturation:.8 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.65 saturation:.8 brightness:.6 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.8 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.0 brightness:.3 alpha: 0.5],
                    [UIColor colorWithHue:.6 saturation:.0 brightness:.9 alpha: 0.5],
                    [UIColor colorWithHue:.55 saturation:.8 brightness:.9 alpha: 0.5], nil]  forKeys: [[NSArray alloc] initWithObjects: @"publicCost", @"publicCostI", @"publicCostM", @"publicCostD", @"privateCost", @"privateCostI", @"privateCostM", @"privateCostD",  @"efficiencyOfIntervention", @"puddleTime", @"puddleMax", @"groundwaterInfiltration", @"impactingMyNeighbors", @"capacity", nil] ];
    
    sliceNumbers = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects: [NSNumber numberWithInt:8], [NSNumber numberWithInt:7],[NSNumber numberWithInt:6],[NSNumber numberWithInt:5],[NSNumber numberWithInt:4],[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],[NSNumber numberWithInt:1], nil] forKeys: [NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8], nil]];
    
    sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithHue:.3 saturation:.6 brightness:.9 alpha: 0.5],
                       [UIColor colorWithHue:.35 saturation:.8 brightness:.6 alpha: 0.5],
                       [UIColor colorWithHue:.4 saturation:.8 brightness:.3 alpha: 0.5],
                       [UIColor colorWithHue:.55 saturation:.8 brightness:.9 alpha: 0.5],
                       [UIColor colorWithHue:.65 saturation:.8 brightness:.6 alpha: 0.5],
                       [UIColor colorWithHue:.6 saturation:.8 brightness:.6 alpha: 0.5],
                       [UIColor colorWithHue:.6 saturation:.0 brightness:.3 alpha: 0.5],
                       [UIColor colorWithHue:.65 saturation:.0 brightness:.9 alpha: 0.5],
                       [UIColor colorWithHue:.7 saturation: 0.6 brightness:.3 alpha: 0.5],
                       [UIColor colorWithHue:.75 saturation: 0.6 brightness:.6 alpha: 0.5], nil];
    
    slicesInfo = [[NSMutableArray alloc] initWithObjects:@"Investment", @"Damage Reduction", @"Efficiency of Intervention ($/Gallon)", @"Capacity Used", @"Water Depth Over Time", @"Maximum Flooded Area", @"Groundwater Infiltration", @"Impact on my Neighbors", nil];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadingIndicator.center = CGPointMake(512, 300);
    _loadingIndicator.color = [UIColor blueColor];
    [self.view addSubview:_loadingIndicator];
    
    
    arrStatus_social = [[NSArray alloc] initWithObjects:@"Trial 0", @"Favorite trials", nil];
    _trialNumber.text = [NSString stringWithFormat:@"%@", arrStatus_social[sortChosen_social]];
    _trialNumber.delegate = self;
    if (SortType_social == nil){
        SortType_social = [[UIPickerView alloc]init];
        [SortType_social setDataSource:self];
        [SortType_social setDelegate:self];
        [SortType_social setShowsSelectionIndicator:YES];
        _trialNumber.selectedTextRange = nil;
        [_trialNumber setInputView:SortType_social];
    }
    
    
    OverBudgetLabels    = [[NSMutableArray alloc] init];
    waterDisplays = [[NSMutableArray alloc]init];
    maxWaterDisplays = [[NSMutableArray alloc]init];
    efficiency = [[NSMutableArray alloc]init];
    slices = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 8; i++) {
        [slices addObject:[NSNumber numberWithInt:1]];
    }
    
    
    [self drawMinMaxSliderLabels];
    _BudgetSlider.minimumValue = min_budget;
    _BudgetSlider.maximumValue = max_budget;
    [_BudgetSlider addTarget:self action:@selector(BudgetChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_BudgetSlider addTarget:self action:@selector(BudgetValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self BudgetChanged:_BudgetSlider];
    
    _StormPlayBack.minimumValue = 0;
    _StormPlayBack.maximumValue = 48;
    [_StormPlayBack addTarget:self action:@selector(StormHoursChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_StormPlayBack addTarget:self
                      action:@selector(StormHoursChosen:)
            forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    [_StormPlayBack addTarget:self
                       action:@selector(changeHoursLabel)
             forControlEvents:(UIControlEventValueChanged)];
    _StormPlayBack.continuous = YES;
    _StormPlayBack.value = hours_social;
    
    _profilesWindow.delegate = self;
    _usernamesWindow.delegate = self;
    _mapWindow.delegate = self;
    
    
    _mapWindow.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _mapWindow.layer.borderWidth = 1.0;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMapWindowRecognized)];
    [_mapWindow addGestureRecognizer:singleTap];
    
    topOfMapWindow = [[UIView alloc]init];
    topOfMapWindow.frame = CGRectMake(0, 0, _mapWindow.frame.size.width, smallSizeOfMapWindow);
    [_mapWindow addSubview:topOfMapWindow];
    
    bottomOfMapWindow = [[UIView alloc]init];
    bottomOfMapWindow.frame = CGRectMake(0, smallSizeOfMapWindow, _mapWindow.frame.size.width, largeSizeOfMapWindow - smallSizeOfMapWindow);
    [_mapWindow addSubview:bottomOfMapWindow];
    
    mapWindowStatusLabel = [[UILabel alloc]init];
    mapWindowStatusLabel.text = @"Tap to view map(s)";
    mapWindowStatusLabel.font = [UIFont systemFontOfSize:15.0];
    [mapWindowStatusLabel sizeToFit];
    mapWindowStatusLabel.frame = CGRectMake((topOfMapWindow.frame.size.width - mapWindowStatusLabel.frame.size.width) / 2, (smallSizeOfMapWindow - mapWindowStatusLabel.frame.size.height) / 2, mapWindowStatusLabel.frame.size.width, mapWindowStatusLabel.frame.size.height);
    [_mapWindow addSubview:mapWindowStatusLabel];
    
}


-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// release notification if view is unloaded for memory purposes
- (void) viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdate)
                                                 name:@"profileUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePicker)
                                                 name:@"updatePicker"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(usernameUpdate:)
                                                 name:@"usernameUpdate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSingleProfile:)
                                                 name:@"updateSingleProfile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawNewProfile)
                                                 name:@"drawNewProfile"
                                               object:nil];
    
    // line below data viewers
    UIView *lineBelowData = [[UIView alloc]init];
    lineBelowData.frame = CGRectMake(0, _usernamesWindow.frame.origin.y + _usernamesWindow.frame.size.height, self.view.frame.size.width, 1);
    lineBelowData.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lineBelowData.layer.borderWidth = 1.0;
    lineBelowData.tag = 9000;
    [self.view addSubview:lineBelowData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self profileUpdate];
}


- (void)viewWillDisappear:(BOOL)animated {
    // remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"profileUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePicker" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"usernameUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSingleProfile" object:nil];
    
    UIView *line = [self.view viewWithTag:9000];
    [line removeFromSuperview];
    /*
    // empty _usernamesWindow and _profilesWindow to free memory
    for (UIView *view in [_usernamesWindow subviews])
        [view removeFromSuperview];
    for (UIView *view in [_profilesWindow subviews])
        [view removeFromSuperview];
    */
}

- (void)usernameUpdate:(NSNotification *)note {
    NSDictionary *dict  = note.userInfo;
    int index = [[dict objectForKey:@"data"]integerValue];
    
    
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    
    if ([tabControl.profiles count] <= index)
        return;
    
    UIView *viewInUsernamesWindow = [_usernamesWindow viewWithTag:index + 1];
    UILabel *nameLabel = (UILabel*) [viewInUsernamesWindow viewWithTag:1];
    nameLabel.text = [NSString stringWithFormat:@"  %@",[[tabControl.profiles objectAtIndex:index]objectAtIndex:2]];
}

- (void)updateSingleProfile:(NSNotification *)note {
    NSDictionary *dict = note.userInfo;
    int index = [[dict objectForKey:@"data"]integerValue];
    
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    
    if([tabControl.profiles count] <= index)
        return;
    
    UIView *viewInProfilesWindow = [_profilesWindow viewWithTag:index + 1];
    [viewInProfilesWindow removeFromSuperview];
    UIView *viewInUsernamesWindow = [_usernamesWindow viewWithTag:index + 1];
    [viewInUsernamesWindow removeFromSuperview];
    
    
    [maxWaterDisplays removeObjectAtIndex:index];
    [waterDisplays removeObjectAtIndex:index];
    [efficiency removeObjectAtIndex:index];
    
    [self createSubviewsForUsernamesWindow:index];
    [self createSubviewsForProfilesWindow:index];
    [self drawTrialForSpecificProfile:sortChosen_social forProfile:index];
}

- (void)drawNewProfile {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    int index = [tabControl.profiles count] - 1;
    
    [self createSubviewsForUsernamesWindow:index];
    [self createSubviewsForProfilesWindow:index];
    [self drawTrialForSpecificProfile:sortChosen_social forProfile:index];
}

- (void)updatePicker {
    [self pickerView:SortType_social numberOfRowsInComponent:0];
    
    [SortType_social reloadAllComponents];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // if the chosen trial is already loaded, return
    if (sortChosen_social == row) {
        [[self view] endEditing:YES];
        return;
    }
    
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    // Handle the selection
    if (row == tabControl.trialNum)
        _trialNumber.text = @"Favorite Trials";
    else
        _trialNumber.text = [NSString stringWithFormat:@"Trial %d", row];
    sortChosen_social = (int)row;
    
    [[self view] endEditing:YES];

    // trial number was changed, so reset arrays which are filled with info for previous trial loaded
    [maxWaterDisplays removeAllObjects];
    [waterDisplays removeAllObjects];
    [efficiency removeAllObjects];
    
    [self profileUpdate];

}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    
    // add an extra row for "favorite trials"
    NSUInteger numRows = tabControl.trialNum + 1;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.frame = CGRectMake(0, 0, 250, 30);
        tView.font = [UIFont boldSystemFontOfSize:15.0];
        
    }
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    if (row == tabControl.trialNum)
        tView.text = @"Favorite Trials";
    else
        tView.text = [NSString stringWithFormat:@"Trial %d", (int)row];
    // Fill the label text here
    
    return tView;
}

- (void)profileUpdate {
    [_loadingIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
    [self loadVisualizationForNewTrial];
    [_loadingIndicator stopAnimating];
}

- (void)tapOnMapWindowRecognized {
    int sizeOfChange = largeSizeOfMapWindow - smallSizeOfMapWindow;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (_mapWindow.frame.size.height < largeSizeOfMapWindow) {
        mapWindowStatusLabel.text = @"Tap to hide map(s)";
        _usernamesWindow.frame = CGRectMake(_usernamesWindow.frame.origin.x, _usernamesWindow.frame.origin.y + sizeOfChange, _usernamesWindow.frame.size.width, _usernamesWindow.frame.size.height - sizeOfChange);
        _profilesWindow.frame = CGRectMake(_profilesWindow.frame.origin.x, _profilesWindow.frame.origin.y + sizeOfChange, _profilesWindow.frame.size.width, _profilesWindow.frame.size.height - sizeOfChange);
        _mapWindow.frame = CGRectMake(_mapWindow.frame.origin.x, _mapWindow.frame.origin.y, _mapWindow.frame.size.width, largeSizeOfMapWindow);
    }
    else {
        mapWindowStatusLabel.text = @"Tap to view map(s)";
        _usernamesWindow.frame = CGRectMake(_usernamesWindow.frame.origin.x, _usernamesWindow.frame.origin.y - sizeOfChange, _usernamesWindow.frame.size.width, _usernamesWindow.frame.size.height + sizeOfChange);
        _profilesWindow.frame = CGRectMake(_profilesWindow.frame.origin.x, _profilesWindow.frame.origin.y - sizeOfChange, _profilesWindow.frame.size.width, _profilesWindow.frame.size.height + sizeOfChange);
        _mapWindow.frame = CGRectMake(_mapWindow.frame.origin.x, _mapWindow.frame.origin.y, _mapWindow.frame.size.width, smallSizeOfMapWindow);
    }
    [UIView commitAnimations];
}


- (void)createSubviewsForProfilesWindow:(int) i {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    UIView *profileSubview = [[UIView alloc]init];
    profileSubview.frame = CGRectMake(0, i * heightOfVisualization, widthOfTitleVisualization * 8, heightOfVisualization);
    // tag == i + 1 since 0 tag goes to the superview
    profileSubview.tag = i + 1;
    [_profilesWindow addSubview:profileSubview];
    
    
    // draw profile concerns in order
    int width = 0;
    for (int j = 3; j < [[tabControl.profiles objectAtIndex:i] count]; j++) {
        NSArray *profileArray = [tabControl.profiles objectAtIndex:i];
        
        UILabel *currentLabel = [[UILabel alloc]init];
        currentLabel.backgroundColor = [concernColors objectForKey:[profileArray objectAtIndex:j]];
        currentLabel.frame = CGRectMake(width, 2, widthOfTitleVisualization, 40);
        currentLabel.font = [UIFont boldSystemFontOfSize:15.3];
        
        if([[profileArray objectAtIndex:j] isEqualToString:@"Investment"])
            currentLabel.text = @"  Investment";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Damage Reduction"])
            currentLabel.text = @"  Damage Reduction";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Efficiency of Intervention ($/Gallon)"])
            currentLabel.text = @"  Efficiency of Intervention";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Capacity Used"])
            currentLabel.text = @"  Intervention Capacity";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Water Depth Over Time"])
            currentLabel.text = @"  Water Depth Over Storm";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Maximum Flooded Area"])
            currentLabel.text = @"  Maximum Flooded Area";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Groundwater Infiltration"])
            currentLabel.text = @"  Groundwater Infiltration";
        else if([[profileArray objectAtIndex:j] isEqualToString:@"Impact on my Neighbors"])
            currentLabel.text = @"  Impact on my Neighbors";
        else {
            currentLabel = NULL;
        }
        
        if(currentLabel != NULL){
            [profileSubview addSubview:currentLabel];
            width += widthOfTitleVisualization;
        }
    }
}

- (void)createSubviewsForUsernamesWindow:(int) i {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    UIView *usernameSubview = [[UIView alloc]init];
    usernameSubview.frame = CGRectMake(0, i * heightOfVisualization, _usernamesWindow.frame.size.width, heightOfVisualization);
    // tag == i + 1 since 0 tag goes to the superview
    usernameSubview.tag = i + 1;
    [_usernamesWindow addSubview:usernameSubview];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.tag = 1;
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.frame = CGRectMake(0, 2, _usernamesWindow.frame.size.width, 40);
    nameLabel.font = [UIFont boldSystemFontOfSize:15.3];
    if ([[tabControl.profiles objectAtIndex:i] isEqual:tabControl.ownProfile])
        nameLabel.text = [NSString stringWithFormat:@"  %@ (You)", [[tabControl.profiles objectAtIndex:i] objectAtIndex:2]];
    else
        nameLabel.text = [NSString stringWithFormat:@"  %@", [[tabControl.profiles objectAtIndex:i] objectAtIndex:2]];
    if(nameLabel != NULL) {
        [[_usernamesWindow viewWithTag:i + 1] addSubview:nameLabel];
    }
    
    // draw pie chart
    // draw profile pie charts
    XYPieChart *pie = [[XYPieChart alloc]initWithFrame:CGRectMake(-5, 5, 120, 120) Center:CGPointMake(80, 100) Radius:60.0];
    
    for (int j = 0; j < 8; j++) {
        int index = [[tabControl.profiles objectAtIndex:i] indexOfObject:[slicesInfo objectAtIndex:j]] - 2;
        [slices replaceObjectAtIndex:j withObject:[sliceNumbers objectForKey:[NSNumber numberWithInt:index]]];
    }
    
    
    [pie setDataSource:self];
    [pie setStartPieAngle:M_PI_2];
    [pie setAnimationSpeed:1.0];
    [pie setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [pie setUserInteractionEnabled:NO];
    pie.showLabel = false;
    [pie setLabelShadowColor:[UIColor blackColor]];
    
    [pie reloadData];
    
    [[_usernamesWindow viewWithTag:i + 1] addSubview:pie];
}


// create a new subview for each profile with frame.origin.y = i * heightOfVisualization and width = widthOfTitleVisualization * 8
    // fill subview in _profilesWindow with profile information
    // fill subview in _profilesWindow with trial information
// create a new subview for each username with frame.origin.y = i * heightOfVisualization and width = _usernameWindow...width
    // fill subview in _usernamesWindow with username info and profile pie chart
// create a new subview for each map with frame.origin.x = i * heightOfVisualization
    // fill subview in _mapWindow with map visualization

- (void)loadVisualizationForNewTrial {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    int numberOfProfiles = tabControl.profiles.count;
    
    // first, remove all current subviews from the 3 visualization scrollViews
    for (UIView *subview in [_profilesWindow subviews])
        [subview removeFromSuperview];
    for (UIView *subview in [_usernamesWindow subviews])
        [subview removeFromSuperview];
    for (UIView *subview in [bottomOfMapWindow subviews])
        [subview removeFromSuperview];
    
    // load map visualization
    if ([tabControl.trialRuns count] > sortChosen_social) {
        UILabel *mapWindowLabel = [[UILabel alloc]init];
        mapWindowLabel.text = [NSString stringWithFormat:@"  Trial %d", sortChosen_social];
        mapWindowLabel.font = [UIFont systemFontOfSize:15.0];
        [mapWindowLabel sizeToFit];
        mapWindowLabel.frame = CGRectMake(0, 2, mapWindowLabel.frame.size.width, mapWindowLabel.frame.size.height);
        [bottomOfMapWindow addSubview:mapWindowLabel];
    
        AprilTestSimRun *simRun = [tabControl.trialRuns objectAtIndex:sortChosen_social];
    
        FebTestIntervention *interventionView = [[FebTestIntervention alloc] initWithPositionArray:simRun.map andFrame:(CGRectMake(mapWindowLabel.frame.origin.x + 20, mapWindowLabel.frame.size.height + 5, 115, 125))];
        interventionView.view = [[bottomOfMapWindow subviews] objectAtIndex:0];
        [interventionView updateView];
    }
    
    
    [maxWaterDisplays removeAllObjects];
    [waterDisplays removeAllObjects];
    [efficiency removeAllObjects];
    
    // create subviews in _usernamesWindow
    // nameLabel.tag == 1
    for (int i = 0; i < numberOfProfiles; i++) {
        [self createSubviewsForUsernamesWindow:i];
    }
    
    for (int i = 0; i < numberOfProfiles; i++) {
        [self createSubviewsForProfilesWindow:i];

        // draw trial for each profile
        [self drawTrialForSpecificProfile:sortChosen_social forProfile:i];
    }
    
    
    [_usernamesWindow setContentSize: CGSizeMake(_usernamesWindow.frame.size.width, numberOfProfiles * heightOfVisualization)];
    [_profilesWindow setContentSize: CGSizeMake(widthOfTitleVisualization * 8 + 10, numberOfProfiles * heightOfVisualization)];
}

- (void) drawTrialForSpecificProfile:(int)trial forProfile:(int)currentProfileIndex {
    AprilTestTabBarController *tabControl = (AprilTestTabBarController *)[self parentViewController];
    
    // error checking
    if ([tabControl.profiles count] < currentProfileIndex + 1)
        return;
    
    // make sure trial asked for is loaded
    if ([tabControl.trialRuns count] < trial + 1)
        return;
    
    
    AprilTestSimRun *simRun = [tabControl.trialRuns objectAtIndex:trial];
    AprilTestNormalizedVariable *simRunNormal = [tabControl.trialRunsNormalized objectAtIndex:trial];
    
    NSMutableArray *currentConcernRanking = [[NSMutableArray alloc]init];
    NSArray *currentProfile = [[NSArray alloc]init];
    currentProfile = [tabControl.profiles objectAtIndex:currentProfileIndex];
    
    for (int i = 3; i < [currentProfile count]; i++) {
        [currentConcernRanking addObject:[[AprilTestVariable alloc] initWith:[concernNames objectForKey:[currentProfile objectAtIndex:i]] withDisplayName:[currentProfile objectAtIndex: i] withNumVar:1 withWidth:widthOfTitleVisualization withRank:9-i]];
    }
    
    float priorityTotal= 0;
    float scoreTotal = 0;
    for(int i = 0; i < currentConcernRanking.count; i++){
        
        priorityTotal += [(AprilTestVariable *)[currentConcernRanking objectAtIndex:i] currentConcernRanking];
    }
    
    int width = 0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    
    NSArray *sortedArray = [currentConcernRanking sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(AprilTestVariable*)a currentConcernRanking];
        NSInteger second = [(AprilTestVariable*)b currentConcernRanking];
        if(first > second) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    NSMutableArray *scoreVisVals = [[NSMutableArray alloc] init];
    NSMutableArray *scoreVisNames = [[NSMutableArray alloc] init];
    AprilTestCostDisplay *cd;
    int visibleIndex = 0;
    
    for(int i = 0 ; i < currentConcernRanking.count ; i++){
        
        AprilTestVariable * currentVar =[sortedArray objectAtIndex:i];
        
        //laziness: this is just the investment costs
        if([currentVar.name compare: @"publicCost"] == NSOrderedSame){
            float investmentInstall = simRun.publicInstallCost;
            float investmentMaintain = simRun.publicMaintenanceCost;
            float investmentInstallN = simRunNormal.publicInstallCost;
            float investmentMaintainN = simRunNormal.publicMaintenanceCost;
            dynamic_cd_width = [self getWidthFromSlider:_BudgetSlider toValue:maxBudget];
            CGRect frame = CGRectMake(width + 25, 60, dynamic_cd_width, 30);
            
            
            //NSLog(@"Drawing water display for first time");
            
            //cd = [[AprilTestCostDisplay alloc] initWithCost:investmentInstall andMaxBudget:maxBudget andbudgetLimit:max_budget_limit  andScore:investmentInstallN andFrame:CGRectMake(width + 25, profileIndex*heightOfVisualization + 60, dynamic_cd_width, 30)];
            
            float costWidth = [self getWidthFromSlider:_BudgetSlider toValue:simRun.publicInstallCost];
            float maxBudgetWidth = [self getWidthFromSlider:_BudgetSlider toValue:maxBudget];
            
            cd = [[AprilTestCostDisplay alloc] initWithCost:investmentInstall normScore:investmentInstallN costWidth:costWidth maxBudgetWidth:maxBudgetWidth andFrame:frame];
            
            [[_profilesWindow viewWithTag:currentProfileIndex + 1] addSubview: cd];
            
            //checks if over budget, if so, prints warning message
            if (simRun.publicInstallCost > maxBudget){
                //store update labels for further use (updating over budget when using absolute val)
                
                UILabel *valueLabel;
                [self drawTextBasedVar:[NSString stringWithFormat: @"Over budget: $%@", [formatter stringFromNumber: [NSNumber numberWithInt: (int) (investmentInstall-maxBudget)]] ] withConcernPosition:width+25 andyValue:100 andColor:[UIColor redColor] to:&valueLabel withIndex:currentProfileIndex];
                
                [OverBudgetLabels addObject:valueLabel];
            }
            
            
            [self drawTextBasedVar: [NSString stringWithFormat:@"Maintenance Cost: $%@", [formatter stringFromNumber: [NSNumber numberWithInt:investmentMaintain ]]] withConcernPosition:width + 25 andyValue:120 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            
            
            scoreTotal += ((currentVar.currentConcernRanking/2.0)/priorityTotal * (1 - investmentInstallN));
            scoreTotal += ((currentVar.currentConcernRanking/2.0)/priorityTotal * (1 - investmentMaintainN));
            //scoreTotal += ((currentVar.currentConcernRanking/3.0)/priorityTotal * (1 - simRun.impactNeighbors));
            
            [scoreVisVals addObject:[NSNumber numberWithFloat:((currentVar.currentConcernRanking/2.0)/priorityTotal * (1 - investmentInstallN))]];
            [scoreVisVals addObject:[NSNumber numberWithFloat:((currentVar.currentConcernRanking/2.0)/priorityTotal * (1 - investmentMaintainN))]];
            //[scoreVisVals addObject:[NSNumber numberWithFloat:((currentVar.currentConcernRanking/3.0)/priorityTotal * (1 - simRun.impactNeighbors))]];
            [scoreVisNames addObject: @"publicCostI"];
            [scoreVisNames addObject: @"publicCostM"];
            //[scoreVisNames addObject: @"publicCostD"];
            
            
            //just damages now
        } else if ([currentVar.name compare: @"privateCost"] == NSOrderedSame){
            
            
            [self drawTextBasedVar: [NSString stringWithFormat:@"Rain Damage: $%@", [formatter stringFromNumber: [NSNumber numberWithInt:simRun.privateDamages]]] withConcernPosition:width + 25 andyValue:60 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            [self drawTextBasedVar: [NSString stringWithFormat:@"Damaged Reduced by: %@%%", [formatter stringFromNumber: [NSNumber numberWithInt: 100 -(int)(100*simRunNormal.privateDamages)]]] withConcernPosition:width + 25 andyValue: 90 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            [self drawTextBasedVar: [NSString stringWithFormat:@"Sewer Load:%.2f%%", 100*simRun.neighborsImpactMe] withConcernPosition:width + 25 andyValue:120 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            
            
            scoreTotal += (currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.privateDamages) + currentVar.currentConcernRanking/priorityTotal * (1-simRunNormal.neighborsImpactMe)) /2;
            
            //add values for the score visualization
            
            [scoreVisVals addObject:[NSNumber numberWithFloat:(currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.privateDamages) + currentVar.currentConcernRanking/priorityTotal * (1-simRunNormal.neighborsImpactMe)) /2]];
            //scoreTotal +=currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.privateDamages);
            //[scoreVisVals addObject: [NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.privateDamages)]];
            [scoreVisNames addObject: @"privateCostD"];
            
        } else if ([currentVar.name compare: @"impactingMyNeighbors"] == NSOrderedSame){
            
            
            [self drawTextBasedVar: [NSString stringWithFormat:@"%.2f%% of rainwater", 100*simRun.impactNeighbors] withConcernPosition:width + 30 andyValue:60 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            [self drawTextBasedVar: [NSString stringWithFormat:@" run-off to neighbors"] withConcernPosition:width + 30 andyValue: 75 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            
            scoreTotal += currentVar.currentConcernRanking/priorityTotal * (1-simRunNormal.impactNeighbors);
            [scoreVisVals addObject:[NSNumber numberWithFloat: currentVar.currentConcernRanking/priorityTotal * (1-simRunNormal.impactNeighbors)]];
            [scoreVisNames addObject: currentVar.name];
        }  else if ([currentVar.name compare: @"neighborImpactingMe"] == NSOrderedSame){
            
            
            [self drawTextBasedVar: [NSString stringWithFormat:@"%.2f%%", 100*simRun.neighborsImpactMe] withConcernPosition:width + 50 andyValue:60 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            
            scoreTotal += currentVar.currentConcernRanking/priorityTotal * ( simRunNormal.neighborsImpactMe);
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * ( simRunNormal.neighborsImpactMe)]];
            [scoreVisNames addObject: currentVar.name];
        } else if ([currentVar.name compare: @"groundwaterInfiltration"] == NSOrderedSame){
            
            
            [self drawTextBasedVar: [NSString stringWithFormat:@"%.2f%% of rainwater was", 100*simRun.infiltration] withConcernPosition:width + 30 andyValue:60 andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            [self drawTextBasedVar: [NSString stringWithFormat:@" infiltrated by the swales"] withConcernPosition:width + 30 andyValue:75  andColor:[UIColor blackColor] to:nil withIndex:currentProfileIndex];
            
            scoreTotal += (currentVar.currentConcernRanking/priorityTotal) * (simRunNormal.infiltration );
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * ( simRunNormal.infiltration )]];
            [scoreVisNames addObject: currentVar.name];
        } else if([currentVar.name compare:@"puddleTime"] == NSOrderedSame){
            FebTestWaterDisplay * wd;
            //NSLog(@"%d, %d", waterDisplays.count, i);
            if(waterDisplays.count <= currentProfileIndex){
                //NSLog(@"Drawing water display for first time");
                wd = [[FebTestWaterDisplay alloc] initWithFrame:CGRectMake(width + 10, 60, 115, 125) andContent:simRun.standingWater];
                wd.view = [_profilesWindow viewWithTag:currentProfileIndex + 1];
                [waterDisplays addObject:wd];
            } else {
                wd = [waterDisplays objectAtIndex:currentProfileIndex];
                wd.frame = CGRectMake(width + 10, 60, 115, 125);
            }
            
            wd.thresholdValue = thresh_social;
            [wd fastUpdateView: _StormPlayBack.value];
            
            
            scoreTotal += currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.floodedStreets);
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * (1- simRunNormal.floodedStreets)]];
            [scoreVisNames addObject: currentVar.name];
            
        } else if([currentVar.name compare:@"puddleMax"] == NSOrderedSame){
            //display window for maxHeights
            FebTestWaterDisplay * mwd;
            if(maxWaterDisplays.count <= currentProfileIndex){
                mwd  = [[FebTestWaterDisplay alloc] initWithFrame:CGRectMake(width + 10, 60, 115, 125) andContent:simRun.maxWaterHeights];
                mwd.view = [_profilesWindow viewWithTag:currentProfileIndex + 1];
                [maxWaterDisplays addObject:mwd];
            } else {
                mwd = [maxWaterDisplays objectAtIndex:currentProfileIndex];
                mwd.frame = CGRectMake(width + 10, 60, 115, 125);
            }
            mwd.thresholdValue = thresh_social;
            [mwd updateView:48];
            scoreTotal += currentVar.currentConcernRanking/priorityTotal * (1 - simRunNormal.standingWater);
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * (1- simRunNormal.standingWater)]];
            [scoreVisNames addObject: currentVar.name];
        } else if ([currentVar.name compare: @"capacity"] == NSOrderedSame){
            AprilTestEfficiencyView *ev;
            if( efficiency.count <= currentProfileIndex){
                //NSLog(@"Drawing efficiency display for first time");
                ev = [[AprilTestEfficiencyView alloc] initWithFrame:CGRectMake(width, 60, 130, 150) withContent: simRun.efficiency];
                ev.trialNum = trial;
                ev.view = [_profilesWindow viewWithTag:currentProfileIndex + 1];
                [efficiency addObject:ev];
            } else {
                //NSLog(@"Repositioning efficiency display");
                ev = [efficiency objectAtIndex:currentProfileIndex];
                ev.frame = CGRectMake(width, 60, 130, 150);
            }
            
            scoreTotal += currentVar.currentConcernRanking/priorityTotal *  simRunNormal.efficiency;
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal *  simRunNormal.efficiency]];
            //NSLog(@"%@", NSStringFromCGRect(ev.frame));
            [scoreVisNames addObject: currentVar.name];
            
            [ev updateViewForHour: _StormPlayBack.value];
        } else if ([currentVar.name compare: @"efficiencyOfIntervention"] == NSOrderedSame){
            [self drawTextBasedVar: [NSString stringWithFormat:@"$/Gallon Spent: $%.2f", simRun.dollarsGallons  ] withConcernPosition:width + 25 andyValue: 60 andColor: [UIColor blackColor] to:nil withIndex:currentProfileIndex];
            scoreTotal += currentVar.currentConcernRanking/priorityTotal * 1;
            [scoreVisVals addObject:[NSNumber numberWithFloat:currentVar.currentConcernRanking/priorityTotal * 0]];
            [scoreVisNames addObject:currentVar.name];
        }
        
        width+= currentVar.widthOfVisualization;
        if (currentVar.widthOfVisualization > 0) visibleIndex++;
    }
    
    //border around component score
    UILabel *fullValueBorder = [[UILabel alloc] initWithFrame:CGRectMake(148, 78,  114, 26)];
    fullValueBorder.backgroundColor = [UIColor grayColor];
    UILabel *fullValue = [[UILabel alloc] initWithFrame:CGRectMake(150, 80,  110, 22)];
    fullValue.backgroundColor = [UIColor whiteColor];
    [[_usernamesWindow viewWithTag:currentProfileIndex + 1] addSubview:fullValueBorder];
    [[_usernamesWindow viewWithTag:currentProfileIndex + 1] addSubview:fullValue];
    //NSLog(@" %@", scoreVisVals);
    float maxX = 150;
    float totalScore = 0;
    UILabel * componentScore;
    
    //computing and drawing the final component score
    for(int i =  0; i < scoreVisVals.count; i++){
        float scoreWidth = [[scoreVisVals objectAtIndex: i] floatValue] * 100;
        if (scoreWidth < 0) scoreWidth = 0.0;
        totalScore += scoreWidth;
        componentScore = [[UILabel alloc] initWithFrame:CGRectMake(maxX, 80, floor(scoreWidth), 22)];
        componentScore.backgroundColor = [scoreColors objectForKey:[scoreVisNames objectAtIndex:i]];
        [[_usernamesWindow viewWithTag:currentProfileIndex + 1] addSubview:componentScore];
        maxX+=floor(scoreWidth);
    }
    
    [_profilesWindow setContentSize:CGSizeMake(width+=20, (currentProfileIndex+1)*200)];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 40, 0, 0)];
    //scoreLabel.text = [NSString stringWithFormat:  @"Score: %.0f / 100", totalScore];
    scoreLabel.text = @"Performance:";
    scoreLabel.font = [UIFont systemFontOfSize:14.0];
    [scoreLabel sizeToFit];
    scoreLabel.textColor = [UIColor blackColor];
    [[_usernamesWindow viewWithTag:currentProfileIndex + 1] addSubview:scoreLabel];
    UILabel *scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 65, 0, 0)];
    scoreLabel2.text = [NSString stringWithFormat:  @"Broken down by source:"];
    scoreLabel2.font = [UIFont systemFontOfSize:10.0];
    [scoreLabel2 sizeToFit];
    scoreLabel2.textColor = [UIColor blackColor];
    [[_usernamesWindow viewWithTag:currentProfileIndex + 1] addSubview:scoreLabel2];
}


//Draws Labels to set on the dataWindow Scrollview but also returns object to be added into a MutableArray (used for updating labels)
-(void) drawTextBasedVar: (NSString *) outputValue withConcernPosition: (int) concernPos andyValue: (int) yValue andColor: (UIColor*) color to:(UILabel**) label withIndex:(int)currentProfileIndex{
    if (label != nil){
        *label = [[UILabel alloc] init];
        (*label).text = outputValue;
        (*label).frame =CGRectMake(concernPos, yValue, 0, 0);
        [*label sizeToFit ];
        (*label).font = [UIFont systemFontOfSize:14.0];
        (*label).textColor = color;
        [[_profilesWindow viewWithTag:currentProfileIndex + 1] addSubview:*label];
    }else
    {
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = outputValue;
        valueLabel.frame =CGRectMake(concernPos, yValue, 0, 0);
        [valueLabel sizeToFit ];
        valueLabel.font = [UIFont systemFontOfSize:14.0];
        valueLabel.textColor = color;
        [[_profilesWindow viewWithTag:currentProfileIndex + 1] addSubview:valueLabel];
    }
}

/**
 * Returns the width from the minimum end of a slider
 * to a particular value on the slider
 *
 * Used to draw the budget labels underneath the budget slider
 */
- (int)getWidthFromSlider:(UISlider *)aSlider toValue:(float)value {
    if (value < aSlider.minimumValue){
        return 0;
    }
    
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);
    
    float sliderValueToPixels = (((value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue)) * sliderRange) + sliderOrigin;
    float sliderValforZero    = ((0/(aSlider.maximumValue-aSlider.minimumValue)) * sliderRange) + sliderOrigin;
    
    int returnLocation = (int)sliderValueToPixels - (int)sliderValforZero;
    if (returnLocation == 0){
        return 1;
    }
    else
        return returnLocation;
}

//selector method that handles a change in value when budget changes (slider under titles)
-(void)BudgetChanged:(id)sender {
    UISlider *slider = (UISlider*)sender;
    int value = slider.value;
    //-- Do further actions
    
    value = 1000.0 * floor((value/1000.0)+0.5);
    
    maxBudget = value;
    [self changeBudgetLabel:(int)maxBudget];
    
    
    //only update all labels/bars if Static normalization is switched on
    [self profileUpdate];
}
     
     
- (void)BudgetValueChanged:(id)sender {
    UISlider *slider = (UISlider*)sender;
    int value = slider.value;
    
    value = 1000.0 * floor((value/1000.0)+0.5);
    maxBudget = value;
    [self changeBudgetLabel:(int)maxBudget];
}


// synchronizes vertical scrolling between usersnamesWindow and profilesWindow
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_usernamesWindow]) {
        float verticalOffset = _usernamesWindow.contentOffset.y;
        CGPoint contentOffset;
        contentOffset.y = verticalOffset;
        contentOffset.x = _profilesWindow.contentOffset.x;
        [_profilesWindow setContentOffset:contentOffset];
    }
    else if ([scrollView isEqual:_profilesWindow]) {
        float verticalOffset = _profilesWindow.contentOffset.y;
        CGPoint contentOffset;
        contentOffset.y = verticalOffset;
        contentOffset.x = _usernamesWindow.contentOffset.x;
        [_usernamesWindow setContentOffset:contentOffset];
    }
}




- (void)drawMinMaxSliderLabels {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    
    UILabel *minLabelBudget = [[UILabel alloc]init];
    minLabelBudget.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[NSNumber numberWithInt:min_budget]]];
    minLabelBudget.font = [UIFont systemFontOfSize:15.0];
    [minLabelBudget sizeToFit];
    minLabelBudget.frame = CGRectMake(_BudgetSlider.frame.origin.x - (minLabelBudget.frame.size.width + 10), _BudgetSlider.frame.origin.y + 6, minLabelBudget.frame.size.width, minLabelBudget.frame.size.height);
    [minLabelBudget setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:minLabelBudget];
    
    UILabel *maxLabelBudget = [[UILabel alloc]init];
    maxLabelBudget.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[NSNumber numberWithInt:max_budget]]];
    maxLabelBudget.font = [UIFont systemFontOfSize:15.0];
    [maxLabelBudget sizeToFit];
    maxLabelBudget.frame = CGRectMake(_BudgetSlider.frame.origin.x + (_BudgetSlider.frame.size.width + 10), _BudgetSlider.frame.origin.y + 6, maxLabelBudget.frame.size.width, maxLabelBudget.frame.size.height);
    [maxLabelBudget setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:maxLabelBudget];
    
    budgetLabel = [[UILabel alloc]init];
    budgetLabel.text = [NSString stringWithFormat:@"Set Budget $%@", [formatter stringFromNumber:[NSNumber numberWithInt:min_budget]]];
    budgetLabel.font = [UIFont systemFontOfSize:15.0];
    [budgetLabel sizeToFit];
    budgetLabel.frame = CGRectMake(minLabelBudget.frame.origin.x - (_BudgetSlider.frame.size.width + 10) , _BudgetSlider.frame.origin.y + 6, budgetLabel.frame.size.width, budgetLabel.frame.size.height);
    [budgetLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:budgetLabel];
    
    UILabel *minLabelStorm = [[UILabel alloc]init];
    minLabelStorm.text = @"0 hrs";
    minLabelStorm.font = [UIFont systemFontOfSize:15.0];
    [minLabelStorm sizeToFit];
    minLabelStorm.frame = (CGRectMake(_StormPlayBack.frame.origin.x - (minLabelStorm.frame.size.width + 10), _StormPlayBack.frame.origin.y + 6, minLabelStorm.frame.size.width, minLabelStorm.frame.size.height));
    [minLabelStorm setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:minLabelStorm];
    
    UILabel *maxLabelStorm = [[UILabel alloc]init];
    maxLabelStorm.text = @"48 hrs";
    maxLabelStorm.font = [UIFont systemFontOfSize: 15.0];
    [maxLabelStorm sizeToFit];
    maxLabelStorm.frame = CGRectMake(_StormPlayBack.frame.origin.x + (_StormPlayBack.frame.size.width + 10), _StormPlayBack.frame.origin.y + 6, maxLabelStorm.frame.size.width, maxLabelStorm.frame.size.height);
    [maxLabelStorm setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:maxLabelStorm];
    
    hoursAfterStormLabel = [[UILabel alloc]init];
    hoursAfterStormLabel.text = [NSString stringWithFormat:@"Storm Playback %d hours", (int)hours_social];
    hoursAfterStormLabel.font = [UIFont systemFontOfSize:15.0];
    [hoursAfterStormLabel sizeToFit];
    hoursAfterStormLabel.frame = CGRectMake(budgetLabel.frame.origin.x, _StormPlayBack.frame.origin.y + 6, hoursAfterStormLabel.frame.size.width, hoursAfterStormLabel.frame.size.height);
    [hoursAfterStormLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:hoursAfterStormLabel];
}


- (void)changeBudgetLabel:(int)budget {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    
    budgetLabel.text = [NSString stringWithFormat:@"Set Budget $%@", [formatter stringFromNumber:[NSNumber numberWithInt:budget]]];
    [budgetLabel sizeToFit];
}

- (void)changeHoursLabel {
    hoursAfterStormLabel.text = [NSString stringWithFormat:@"Storm Playback %d hours", (int)_StormPlayBack.value];
    [hoursAfterStormLabel sizeToFit];
    hoursAfterStormLabel.frame = CGRectMake(budgetLabel.frame.origin.x, _StormPlayBack.frame.origin.y + 6, hoursAfterStormLabel.frame.size.width, hoursAfterStormLabel.frame.size.height);
    hours_social = (int)_StormPlayBack.value;
}


-(void)StormHoursChanged:(id)sender{
    UISlider *slider = (UISlider*)sender;
    hours_social= slider.value;
    _StormPlayBack.value = hours_social;
    
    hoursAfterStorm_social = floorf(hours_social);
    if (hoursAfterStorm_social % 2 != 0) hoursAfterStorm_social--;
    
}

- (void)StormHoursChosen:(NSNotification *)notification {
    
    [_loadingIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
    
    NSMutableString * content = [NSMutableString alloc];
    for(int i = 0; i < waterDisplays.count; i++){
        FebTestWaterDisplay * temp = (FebTestWaterDisplay *) [waterDisplays objectAtIndex:i];
        AprilTestEfficiencyView * temp2 = (AprilTestEfficiencyView *)[efficiency objectAtIndex:i];
        FebTestWaterDisplay * tempHeights = (FebTestWaterDisplay *) [maxWaterDisplays objectAtIndex: i];
        [temp2 updateViewForHour:hoursAfterStorm_social];
        //[temp updateView:hoursAfterStorm];
        [temp fastUpdateView:hoursAfterStorm_social];
        [tempHeights updateView:48];
    }
    
    [_loadingIndicator stopAnimating];
    
    
    /*
    NSDate *myDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    //if(notification == UIControlEventTouchUpInside || notification == UIControlEventTouchUpOutside){
    content = [content initWithFormat:@"%@\tHours after storm set to: %d",prettyVersion, hoursAfterStorm_social];
    
    //    NSLog(content);
    [content appendString:@"\n\n"];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"logfile_simResults.txt"];
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];;
    //}
     */
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 8;
}

- (CGFloat) pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[slices objectAtIndex:index] intValue];
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [sliceColors objectAtIndex:(index % sliceColors.count)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* code for splitting up a view into subviews
- (IBAction)button:(UIButton *)sender {
    for (UIView *view in [_usernamesWindow subviews])
        [view removeFromSuperview];
    
    for (int i = 0; i < 3; i++) {
        UIView *subview = [[UIView alloc]init];
        subview.frame = CGRectMake(0, heightOfVisualization * i, _usernamesWindow.frame.size.width, heightOfVisualization);
        // 0 tag goes to the _usernameWindow view itself
        subview.tag = i + 1;
        [_usernamesWindow addSubview:subview];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(5, 5, 100, 25);
        label.text = [NSString stringWithFormat:@"%d", i];
        label.tag = 0;
        [subview addSubview:label];
    }
}

- (IBAction)button2:(UIButton *)sender {
    UIView *subview = [[UIView alloc]init];
    subview = [[UIView alloc]init];
    subview = [_usernamesWindow viewWithTag:1];
    [subview removeFromSuperview];
    
    
    for (int i = 2; i < [[_usernamesWindow subviews] count] + 2; i++) {
        UIView *subview = [_usernamesWindow viewWithTag:i];
        if (subview != nil)
        {
        subview.frame = CGRectMake(0, subview.frame.origin.y - heightOfVisualization, subview.frame.size.width, subview.frame.size.height);
        subview.tag--;
        }
    }
    
    
}
 */
@end