//
//  ModifiersListTableViewCell.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/18/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "ModifiersListTableViewCell.h"
#import "Achievement.h"
#import "Score.h"

@implementation ModifiersListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.textLabel.text = self.playerUsername;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ModifierCell"];
        Score *score = [self.modifiersList objectAtIndex:indexPath.row];
        cell.textLabel.text = score.achievementPointer.abbreviation;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", score.score];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // First section is user
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.modifiersList.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Add logic where if parent cell is removed, all cells are removed.
    [self.modifiersList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
    [self adjustHeightOfTableview];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)adjustHeightOfTableview
{
    CGFloat height = self.tableView.contentSize.height;

    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstraint.constant = height;
    }];
    
    NSLog(@"Modifiers height: %f", height);
}


@end