//
//  AddFriendsViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "User.h"

@interface AddFriendsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property NSArray *displayedUsersArray;
@property NSArray *currentArray;

@property NSArray *allUsersArray;
@property NSArray *facebookUsersArray;
@property NSArray *myCrewUsersArray;

@property NSMutableArray *searchResultsArray;
@property BOOL isSearching;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.displayedUsersArray = [NSArray new];
    self.searchResultsArray = [NSMutableArray new];

    [User getCurrentUserFriendsWithCompletion:^(NSArray *array) {
        self.myCrewUsersArray = array;
    }];
    // Search for my facebook friends
    [User getAllFacebookUsers:^(NSArray *array) {
        self.facebookUsersArray = array;
    }];
    // Search for all GNAR users
    [User getAllUsers:^(NSArray *array) {
        self.allUsersArray = array;
        self.displayedUsersArray = self.allUsersArray;
        self.currentArray = self.allUsersArray;
        [self.activitySpinner stopAnimating];
        [self.tableView reloadData];
    }];

    // Create tap gesture recognizer to dismiss heyboard on click outside search bar
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    // Don't disable all other user touches
    gestureRecognizer.cancelsTouchesInView = NO;

    self.navigationController.navigationBar.topItem.title = @"Cancel";
}

//-----------------------------------    Helper Methods    ----------------------------------------------------
#pragma mark - Helper Methods
- (void)hideKeyboard
{
    [self.searchBar resignFirstResponder];
}

//--------------------------------------    Search Bar    ----------------------------------------------------
#pragma mark - Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempSearchArray = [NSMutableArray new];
    // If search bar is empty:
    if ([searchText isEqualToString:@""])
    {
        self.isSearching = FALSE;
        // Replace displayed users to original array of users
        self.displayedUsersArray = self.currentArray;
    }
    else
    {
        self.isSearching = TRUE;
        // Set up predicate to search for search bar text case-insensitive.
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@",searchText];
        tempSearchArray = [NSMutableArray arrayWithArray:[self.currentArray filteredArrayUsingPredicate:predicate]];
        // Change displayed users to search results
        self.displayedUsersArray = tempSearchArray;
    }
    [self.tableView reloadData];
}


//----------------------------------------    Actions    ----------------------------------------------------
#pragma mark - Actions
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate didPressDoneButtonWithSelectedUsers:self.selectedUsersArray];
    // unwind to previous view controller
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    // Start activity spinner
    [self.activitySpinner startAnimating];
    // Reset the search bar: clear text field
    self.searchBar.text = @"";
    // Dismiss keyboard
    [self.searchBar resignFirstResponder];
    if (sender.selectedSegmentIndex == 0)
    {
        // Display users in "my crew" (aka users I have friended within the GNAR app)
        self.displayedUsersArray = self.myCrewUsersArray;
        self.currentArray = self.myCrewUsersArray;
        [self.tableView reloadData];
        [self.activitySpinner stopAnimating];
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        // Display users who are also my facebook friends
        self.displayedUsersArray = self.facebookUsersArray;
        self.currentArray = self.facebookUsersArray;
        [self.tableView reloadData];
        [self.activitySpinner stopAnimating];
    }
    else
    {
        // Display all GNAR users
        self.displayedUsersArray = self.allUsersArray;
        self.currentArray = self.allUsersArray;
        [self.tableView reloadData];
        [self.activitySpinner stopAnimating];
    }
}


//----------------------------------------    Table View    ----------------------------------------------------
#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayedUsersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    User *currentUser = self.displayedUsersArray[indexPath.row];
    // Set cell title to user's name
    if ([currentUser.objectId isEqual:[User currentUser].objectId])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (me)", currentUser.username];

    }
    else
    {
        cell.textLabel.text = currentUser.username;
    }

    //TODO: need to make a custom cell class to hold the image view for profile pictures
//    PFFile *userImageFile = [currentUser objectForKey:@"profileImage"];
//    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if (!error)
//        {
//            UIImage *image = [UIImage imageWithData:imageData];
//            cell.imageView.image = image;
//        }
//        else
//        {
//            NSLog(@"%@", error);
//        }
//    }];


    cell.textLabel.textColor = [UIColor whiteColor];
    // Remove check mark
    cell.accessoryType = UITableViewCellAccessoryNone;
    // apply checkmark to users who have already been selected
    for (PFUser *user in self.selectedUsersArray)
    {
        // Users ID matches any User ID in the selectedUsers array
        if ([currentUser.objectId isEqualToString:user.objectId])
        {
            // Add a checkmark to show player has already been selected
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = self.displayedUsersArray[indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.objectId == %@", user.objectId];
    NSArray *filtered = [self.selectedUsersArray filteredArrayUsingPredicate:predicate];
    if (filtered.count > 0)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsersArray removeObject:filtered.firstObject];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedUsersArray addObject:self.displayedUsersArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

















@end
