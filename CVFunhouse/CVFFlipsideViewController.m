//
//  CVFFlipsideViewController.m
//  CVFunhouse
//
//  Created by John Brewer on 3/7/12.
//  Copyright (c) 2012 Jera Design LLC. All rights reserved.
//

#import "CVFFlipsideViewController.h"

@interface CVFFlipsideViewController () {
    int _demoNumber;    
}
@end

@implementation CVFFlipsideViewController
@synthesize menuTable = _menuTable;
@synthesize delegate = _delegate;
@synthesize navBar = _navBar;
@synthesize flipsidePopoverArray = _flipsidePopoverArray;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flipsidePopoverArray = [[NSMutableArray alloc] initWithObjects:
                             @"Canny Edge Detector",
                             @"Face Detector",
                             @"Farneback",
                             @"Laplace",
                             @"Lukas-Kanade",
                             @"Motion Templates",
                             @"Sepia Filter",
                             @"Pass Thru",
                             NULL];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self reloadViewHeight];
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    _demoNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"demoNumber"];
}

-(void) reloadViewHeight
{
    float currentTotal = 0;

    currentTotal += self.navBar.bounds.size.height;
    
    //Need to total each section
    for (int i = 0; i < [self.menuTable numberOfSections]; i++) 
    {
        CGRect sectionRect = [self.menuTable rectForSection:i];
        currentTotal += sectionRect.size.height;
    }
    
    //Set the contentSizeForViewInPopover
    self.contentSizeForViewInPopover = CGSizeMake(320, currentTotal);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_flipsidePopoverArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier] ;
    }
    
    if(indexPath.row < [_flipsidePopoverArray count]) {
        cell.textLabel.text = [_flipsidePopoverArray objectAtIndex:indexPath.row];
    }
        
    if (indexPath.row == _demoNumber) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_demoNumber inSection:0];
    
    [[tableView cellForRowAtIndexPath:oldIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    _demoNumber = [indexPath row];
    [[NSUserDefaults standardUserDefaults] setInteger:_demoNumber forKey:@"demoNumber"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"demoNumber" object:nil];
    [self.delegate flipsideViewControllerDidFinish:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
