//
//  ViewController.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 3/20/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ListViewController.h"
#import <SVPullToRefresh.h>
#import "StylightModel.h"
#import "Item.h"
#import "ItemTableViewCell.h"
#import "MBProgressHUD.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) StylightModel *stylightModel;

@end

@implementation ListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        
    }
    
    return self;
}

- (StylightModel*)stylightModel
{
    if (!_stylightModel)
    {
        _stylightModel = [[StylightModel alloc] init];
    }
    
    return _stylightModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Stylight Test Task";
    
    __weak ListViewController *weakSelf = self;
    
    [mainTableView addPullToRefreshWithActionHandler:^{
        [weakSelf.stylightModel reset];
        [weakSelf loadItems];
        [mainTableView.pullToRefreshView stopAnimating];
    }];
    
    [mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadItems];
        [mainTableView.infiniteScrollingView stopAnimating];
    }];
    
    mainTableView.showsInfiniteScrolling = YES;
    
    [self loadItems];
}

- (void)loadItems
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.stylightModel loadNextPageWithSuccessBlock:^() {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [mainTableView reloadData];
        
    } onFailure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [[[UIAlertView alloc] initWithTitle:nil
                                   message:[error localizedDescription]
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [mainTableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate's methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource's methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stylightModel.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemTableViewCell *itemTableViewCell = [tableView dequeueReusableCellWithIdentifier:[ItemTableViewCell cellIdentifier]];
    
    Item *item = self.stylightModel.items[indexPath.row];
    [itemTableViewCell updateWithItem:item];
    
    return itemTableViewCell;
}

@end
