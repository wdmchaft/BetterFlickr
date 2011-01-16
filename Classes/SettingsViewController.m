//
//  SettingsViewController.m
//  BetterFlickr
//
//  Created by Johan Attali on 1/16/11.
//  Copyright 2011 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "BetterFlickrAppDelegate.h"
#import "SettingsViewController.h"
#import "Locales.h"

@implementation SettingsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization 
 // that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Setup TableView
	[self layoutTableView:_tableViewSettings];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Layout Methods

/*! @method		layoutTableView
 *	@abstract	Common fucntion for both the PhotoStream and the SearchDisplay Controllers
 *				for applyting the same properties to both tables views
 *	@param		iTableView		The Table View to setup
 */
- (void)layoutTableView:(UITableView*)iTableView
{
	iTableView.rowHeight		= 75.0;	
	iTableView.backgroundColor	= [UIColor blackColor];
	iTableView.separatorColor	= [UIColor darkGrayColor];	
}

/*! @method		layoutTableViewCell:
 *	@abstract	Creates the views inside the table view cell
 *	@param		iCell		The cell to setup
 *	@param		iIndexPath	The cell index path
 */
- (void)layoutTableViewCell:(UITableViewCell*)iCell atIndexPath:(NSIndexPath *)iIndexPath
{
	if (iIndexPath.section == 0)
	{
		UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[aButton setFrame:CGRectMake(0, 0, 320, 75)];
		
		NSUserDefaults *defaults		= [NSUserDefaults standardUserDefaults];
		NSString* aUserSettingLayout	= [defaults objectForKey:kUserSettingPhotostreamLayout];
		
		// List Setting
		if (iIndexPath.row == 0)
		{	
			[aButton setTitle:kUserSettingPhotostreamLayoutList forState:UIControlStateReserved];
			[aButton setBackgroundImage:[UIImage imageNamed:@"SettingsList.png"] forState:UIControlStateNormal];
			[aButton setBackgroundImage:[UIImage imageNamed:@"SettingsListSelected.png"] forState:UIControlStateSelected];
			[aButton addTarget:self action:@selector(changeLayoutClicked:)  forControlEvents:UIControlEventTouchDown];
			
			if (!aUserSettingLayout || aUserSettingLayout == kUserSettingPhotostreamLayoutList)
				[aButton setSelected:YES];
		}
		// Grid Setting
		if (iIndexPath.row == 1)
		{
			[aButton setTitle:kUserSettingPhotostreamLayoutGrid forState:UIControlStateReserved];
			[aButton setBackgroundImage:[UIImage imageNamed:@"SettingsGrid.png"] forState:UIControlStateNormal];
			[aButton setBackgroundImage:[UIImage imageNamed:@"SettingsGridSelected.png"] forState:UIControlStateSelected];
			[aButton addTarget:self action:@selector(changeLayoutClicked:)  forControlEvents:UIControlEventTouchDown];
			
			if (aUserSettingLayout && aUserSettingLayout == kUserSettingPhotostreamLayoutGrid)
				[aButton setSelected:YES];
		}
		
		// Add button to cell view
		[iCell addSubview:aButton];
	}
	
	
}

/*! @method		changeLayoutClicked:
 *	@abstract	Action Function. Called by user action (click,drag...)
 *	@param		sender		The object initiating the call
 */
- (void)changeLayoutClicked:(id)sender
{
	if ([sender class] == [UIButton class])
	{
		UIButton* aButton = (UIButton*)sender;
		[aButton setSelected:!aButton.selected];
		
				
		BetterFlickrAppDelegate* aDelegate = (BetterFlickrAppDelegate*)[[UIApplication sharedApplication] delegate];
		[aDelegate registerUserSetting:[aButton titleForState:UIControlStateReserved] forKey:kUserSettingPhotostreamLayout];
		
		[_tableViewSettings reloadData];
	}
		
}

#pragma mark -
#pragma mark UITableView delegate methods

/* numberOfSectionsInTableView:
 * Right now, should only return 1 because there is only 
 * 1 section in the tableview
 * @return  Always 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{ return 1; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	{
		return NSLocalizedString(kLocaleSettingsLayout, nil);
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kSettingsViewCellIdentifier];
	if (cell == nil) 
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									  reuseIdentifier:kSettingsViewCellIdentifier];
	}
	
	[self layoutTableViewCell:cell atIndexPath:indexPath];
	return cell;
}

@end
