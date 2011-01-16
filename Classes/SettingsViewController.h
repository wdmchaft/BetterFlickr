//
//  SettingsViewController.h
//  BetterFlickr
//
//  Created by Johan Attali on 1/16/11.
//  Copyright 2011 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSettingsViewCellIdentifier @"kSettingsViewCellIdentifier"

@interface SettingsViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
	IBOutlet UITableView* _tableViewSettings;
}

/*! @method		layoutTableView
 *	@abstract	Common fucntion for both the PhotoStream and the SearchDisplay Controllers
 *				for applyting the same properties to both tables views
 *	@param		iTableView		The Table View to setup
 */
- (void)layoutTableView:(UITableView*)iTableView;

/*! @method		layoutTableViewCell:
 *	@abstract	Creates the views inside the table view cell
 *	@param		iCell		The cell to setup
 *	@param		iIndexPath	The cell index path
 */
- (void)layoutTableViewCell:(UITableViewCell*)iCell atIndexPath:(NSIndexPath *)iIndexPath;

/*! @method		changeLayoutClicked:
 *	@abstract	Action Function. Called by user action (click,drag...)
 *	@param		sender		The object initiating the call
 */
- (void)changeLayoutClicked:(id)sender;

@end
