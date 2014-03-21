//
//  ItemTableViewCell.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/21/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "Item.h"
#import "Product.h"
#import "Creator.h"
#import "Board.h"
#import "PhotoPreview.h"
#import "ImageCache.h"

static NSString *const kItemTableViewCellIdentifier     =   @"ItemTableViewCellIdentifier";

@implementation ItemTableViewCell

+ (NSString*)cellIdentifier
{
    return kItemTableViewCellIdentifier;
}

- (void)updateWithItem:(Item*)item
{
    titleLabel.text = [item anyName];
    descriptionLabel.text = [item anyDescription];
    
    FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
        [spinnerView stopAnimating];
        imagePreview.image = image;
        [imagePreview.layer addAnimation:[CATransition animation] forKey:kCATransition];
    };
    
    PhotoPreview *photoPreview = nil;
    
    if (item.product.preview)
    {
        photoPreview = item.product.preview;
    }
    else if (item.board.creator.preview)
    {
        photoPreview = item.board.creator.preview;
    }
    
    if (photoPreview)
    {
        BOOL imageExists = [[ImageCache sharedImageCache] asynchronouslyRetrieveImageForEntity:photoPreview
                                                                                withFormatName:FICDPhotoImage32BitBGRFormatName
                                                                               completionBlock:completionBlock];
        
        if (imageExists == NO)
        {
            [spinnerView startAnimating];
            imagePreview.image = nil;
        }
    }
    else
    {
        imagePreview.image = nil;
    }
}

@end
