//
//  SuggestedTableViewCell.h
//  GNAR
//
//  Created by Chris Giersch on 2/25/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SuggestedTableViewCell <NSObject>

- (void)didPressAcceptButton;
- (void)didPressDeclineButton;

@end

@interface SuggestedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDetailLabel;

@property (weak, nonatomic) id <SuggestedTableViewCell> delegate;

@end