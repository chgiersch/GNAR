//
//  ParentTableViewCell.m
//  SubTableExample
//
//  Created by Alex Koshy on 7/16/14.
//  Copyright (c) 2014 ajkoshy7. All rights reserved.
//

#import "ParentTableViewCell.h"

@implementation ParentTableViewCell
@synthesize parentIndex;
@synthesize titleLabel;
@synthesize subtitleLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [[self contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    if (!self) {
        return self;
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.opaque = NO;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];

    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 15, 20, 20)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.opaque = NO;
    subtitleLabel.textColor = [UIColor darkTextColor];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:subtitleLabel];

    [self.contentView setAutoresizesSubviews:YES];
    
    return self;
}

- (void)setCellForegroundColor:(UIColor *)foregroundColor {
    self.titleLabel.textColor = foregroundColor;
    self.subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
}
- (void)setCellBackgroundColor:(UIColor *)backgroundColor {
    self.contentView.backgroundColor = backgroundColor;
}

@end
