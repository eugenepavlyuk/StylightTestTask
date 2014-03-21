//
//  ItemTableViewCell.h
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemTableViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIImageView *imagePreview;
    IBOutlet UIActivityIndicatorView *spinnerView;
}

+ (NSString*)cellIdentifier;
- (void)updateWithItem:(Item*)item;

@end
