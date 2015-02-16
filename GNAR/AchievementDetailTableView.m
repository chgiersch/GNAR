//
//  AchievementDetailTableView.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/13/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailTableView.h"
#import "Enum.h"
@implementation AchievementDetailTableView


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.achievement = [Achievement new];
        self.achievement[@"name"] = @"The Loft";
        //    ML[@"description"] = @"Make headband or hat out of Priority Mail tape from Olympic Valley Post Office. Get signed by \"Postman Larry\" and ski with it on for 3 full days.";
        self.achievement[@"type"] = @0;
        self.achievement[@"group"] = @"The Palisades";
    
    return self;
}


- (void)configureInsideTableView
{
    self.insideTableView.dataSource = self;
    self.insideTableView.delegate = self;

    self.insideTableView.backgroundColor = [UIColor clearColor];
    self.insideTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.insideTableView.separatorColor = [UIColor colorWithWhite:( 70/255.0) alpha:1.0];
}

-(NSInteger)numberOfChildrenUnderParentIndex:(NSInteger)parentIndex
{
    return 1;
}

-(NSInteger)heightForChildRows
{
    return 500;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.achievement.type == LineWorth)
    {
        return 6;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.achievement.type == LineWorth)
    {
        if (section == LWModifierCell)
        {
            return self.modifiersArray.count;
        }
        else if (section == LWPlayerCell)
        {
            return self.playersArray.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section == PlayerCell)
        {
            return self.playersArray.count;
        }
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWInfoCell)
        {
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionLabel.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";


            //        infoCell.funLabel.attributedText = [NSAttributedString stringWithFormat:@"Fun Factor: ", self.selectedAchievement.funFactor];
            //        infoCell.heroLabel.attributedText = [NSAttributedString stringWithFormat:@"Hero Factor: ", self.selectedAchievement.heroFactor];
            //        infoCell.difficultyLabel.attributedText = [NSAttributedString stringWithFormat:@"Difficulty: ", self.selectedAchievement.difficulty];
            //        infoCell.descriptionTextView.attributedText = [NSAttributedString stringWithFormat:@"Description: ", self.selectedAchievement.description];
            return infoCell;
        }
        else if (indexPath.section == LWSnowCell)
        {
            SnowTableViewCell *snowCell = [tableView dequeueReusableCellWithIdentifier:@"SnowCell"];
            snowCell.delegate = self;
            snowCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            NSMutableArray *pointValues = [NSMutableArray new];
            for (NSNumber *score in self.achievement.pointValues)
            {
                if ([score integerValue] == 0)
                {
                    [pointValues addObject:@"NR"];
                    [snowCell.segmentedControl setEnabled:NO forSegmentAtIndex:[self.achievement.pointValues indexOfObject:score]];
                }
                else
                {
                    [pointValues addObject:[NSString stringWithFormat:@"%@", score]];
                }
            }
            snowCell.lowSnowScoreLabel.text = pointValues[0];
            snowCell.medSnowScoreLabel.text = pointValues[1];
            snowCell.highSnowScoreLabel.text = pointValues[2];

            return snowCell;
        }
        else if (indexPath.section == LWModifierCell)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifierCell"];

            //        Score *score = self.modifiersArray[indexPath.row];
            // get achievement relation object from score object
            //        Achievement *achievement =
            //        cell.textLabel.text = score.
            //        cell.detailTextLabel.text =
            return cell;
        }
        else if (indexPath.section == LWAddModifierCell)
        {
            ModifierTableViewCell *modifierCell = [tableView dequeueReusableCellWithIdentifier:@"AddModifierCell"];
            modifierCell.delegate = self;
            modifierCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return modifierCell;
        }
        else if (indexPath.section == LWPlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            playersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return playersCell;
        }
        else
        {
            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlayersCell"];
            playerCell.delegate = self;
            playerCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return playerCell;
            //TODO: Change "Add Players" button to "Select Players"
        }
    }


    else
    {
        if (indexPath.section == InfoCell)
        {
            //TODO: modify InfoCell to display abbreviation, point values, and description instead of all the stuff LineWorths have
            InfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
            infoCell.delegate = self;
            infoCell.funLabel.text = @"Super FUN AWESOME saws!!!";
            infoCell.descriptionLabel.text = @"Description: as;df asd;lfj asd;lijasf a;soij fas;lis dfai asof a;odf asdo;f alfoh asodif a;oifjasodifj asodf.";
            //        infoCell.funLabel.attributedText = [NSAttributedString stringWithFormat:@"Fun Factor: ", self.selectedAchievement.funFactor];
            //        infoCell.heroLabel.attributedText = [NSAttributedString stringWithFormat:@"Hero Factor: ", self.selectedAchievement.heroFactor];
            //        infoCell.difficultyLabel.attributedText = [NSAttributedString stringWithFormat:@"Difficulty: ", self.selectedAchievement.difficulty];
            //        infoCell.descriptionTextView.attributedText = [NSAttributedString stringWithFormat:@"Description: ", self.selectedAchievement.description];
            return infoCell;
        }
        else if (indexPath.section == PlayerCell)
        {
            UITableViewCell *playersCell  = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
            playersCell.textLabel.text = [self.playersArray[indexPath.row] username];
            playersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return playersCell;
        }
        else
        {

            PlayerTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectPlayersCell"];
            playerCell.delegate = self;
            playerCell.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0];
            return playerCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //TODO: Make height dynamic based on height of description text view
        return 150.0;
    }
    else if (self.achievement.type == LineWorth)
    {
        if (indexPath.section == LWAddModifierCell || indexPath.section == LWSelectPlayersCell)
        {
            return 50.0;
        }
        else if (indexPath.section == LWSnowCell)
        {
            return 75.0;
        }
    }
    else if (indexPath.section == SelectPlayersCell)
    {
        return 50.0;
    }
    return 45.0;
}

//--------------------------------------    TableViewEditing    ---------------------------------------------
#pragma mark - TableViewEditing
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.playersArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.insideTableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.achievement.type == LineWorth && indexPath.section == LWPlayerCell)
    {
        return YES;
    }
    else if (self.achievement.type != LineWorth && indexPath.section == PlayerCell)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//-------------------------------------------    PrepareForSegue    -------------------------------------------------
#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{


    SelectPlayersViewController *addVC = segue.destinationViewController;
    addVC.delegate = self;
    addVC.selectedUsersArray = self.playersArray;
}


//--------------------------------    Add Players View Controller Delegate Methods   ---------------------------------------------
#pragma mark - Custom Cell Delegate Methods
//TODO: this should be called didPressAddFriendsSaveButton
- (void)didPressDoneButtonWithSelectedUsers:(NSMutableArray *)selectedUsersArray
{
    //TODO: maybe change this to only move the deselested players and add the newly selected players
    self.playersArray = selectedUsersArray;
    NSRange range;
    if (self.achievement.type == LineWorth)
    {
        range = NSMakeRange(LWPlayerCell, 1);
    }
    else
    {
        range = NSMakeRange(PlayerCell, 1);
    }

    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];

    [self.insideTableView beginUpdates];
    [self.insideTableView deleteSections:section withRowAnimation:UITableViewRowAnimationFade];
    [self.insideTableView insertSections:section withRowAnimation:UITableViewRowAnimationRight];
    [self.insideTableView endUpdates];
    NSLog(@"addFriendsSaveButtonPressed method called");

}

//--------------------------------------    Custom Cell Delegate Methods   ---------------------------------------------
#pragma mark - Custom Cell Delegate Methods
-(void)didPressAddButton
{
    // Create a score object for each of the players

    // Add score objects to each of the players

//    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"Add Button delegate called");
}

-(void)didPressAddModifiersButton
{
    NSLog(@"Add Modifiers Button delegate called");

    // Create new instance of AddAchievementViewController
    //    AchievementViewController *controller = [[AchievementViewController alloc] initWithNibName:@"AchievementViewController" bundle:[NSBundle mainBundle]];

//    [self performSegueWithIdentifier:@"AddModifiersSegue" sender:self];

    // Display only ECPs, Trick Bonuses, and Penalties

}

-(void)didPressSelectPlayersButton
{
    NSLog(@"Select Players Cell Button delegate called");
}

-(void)didChangeSegment:(NSInteger)selectedSegment
{
    NSLog(@"Change Segment delegate called");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
