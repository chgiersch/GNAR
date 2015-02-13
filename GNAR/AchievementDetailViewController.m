//
//  AchievementDetailViewController.m
//  GNAR
//
//  Created by Chris Giersch on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import "ParentTableView.h"
#import "ParentTableViewCell.h"
#import "SubTableView.h"
#import "SubTableViewCell.h"
#import "Achievement.h"
#import "Score.h"

@interface AchievementDetailViewController () <SubTableViewDataSource, SubTableViewDelegate>

@property (weak, nonatomic) IBOutlet ParentTableView *tableView;
@property NSArray *achievementsArray;
@property NSArray *childrenArray;

@property NSMutableArray *scoresArray;



typedef NS_ENUM(NSInteger, AchievementType) {
    LineWorth,
    ECP,
    TrickBonus,
    Penalty
};

@end

@implementation AchievementDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Achievement getAchievementsOfType:self.type inGroup:self.group withCompletion:^(NSArray *array) {
        self.achievementsArray = array;

        // *** Must set delegates AFTER you set the tables data source (array)
        [self.tableView setDataSourceDelegate:self];
        [self.tableView setTableViewDelegate:self];
        [self.tableView reloadData];
    }];
}


//-----------------------------------    SUB Table View Data Source    ----------------------------------------------------
#pragma mark - Sub Table View Data Source - Parent
// @required
- (NSInteger)numberOfParentCells
{
    return self.achievementsArray.count;
}

- (NSInteger)heightForParentRows
{
    return 75;
}

// @optional
- (NSString *)titleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return [self.achievementsArray[parentIndex] name];
}

- (NSString *)subtitleLabelForParentCellAtIndex:(NSInteger)parentIndex
{
    return @"";
}



#pragma mark - Sub Table View Data Source - Child
// @required
- (NSInteger)numberOfChildCellsUnderParentIndex:(NSInteger)parentIndex
{
    return self.childrenArray.count;
}

- (NSInteger)heightForChildRows
{
    return 55;
}

// @optional
- (NSString *)titleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    return @"Child Label";
}

- (NSString *)subtitleLabelForCellAtChildIndex:(NSInteger)childIndex withinParentCellIndex:(NSInteger)parentIndex
{
    return @"";
}

//-----------------------------------    SUB Table View Delegate    ----------------------------------------------------
#pragma mark - Sub Table View Delegate
// @optional
- (void)tableView:(UITableView *)tableView didSelectCellAtChildIndex:(NSInteger)childIndex withInParentCellIndex:(NSInteger)parentIndex
{
    
}

- (void)tableView:(UITableView *)tableView didSelectParentCellAtIndex:(NSInteger)parentIndex
{
    Achievement *selectedAchievement = [self.achievementsArray objectAtIndex:parentIndex];
    [self saveScoresFromAchievement:selectedAchievement toUsers:@[[PFUser currentUser]]];
}



//
- (void)saveScoresFromAchievement: (Achievement *) achievement toUsers:(NSArray *)usersArray
{
    for (PFUser *user in usersArray)
    {
#warning        //Implement logic to get modifiers from custom table view cell
        NSArray *modifiersArray = @[];
        Score *score = [[Score alloc]initScoreWithAchievement:achievement withModifiers:modifiersArray];
        PFRelation *scoresRelation = [[PFUser currentUser] relationForKey:@"scores"];
        [scoresRelation addObject:score];
        [score saveInBackground];

    PFRelation *scorerRelation = [score relationForKey:@"scorer"];
    [scorerRelation addObject:[PFUser currentUser]];
        [user saveInBackground];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
