//
//  QPWebVideoListView.m
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPWebVideoListView.h"

@interface QPWebVideoListView ()
@property (nonatomic, strong) QPWebVideoListViewPresenter *presenter;
@end

@implementation QPWebVideoListView

- (QPWebVideoListViewPresenter *)presenter
{
    return _presenter;
}

- (void)setup
{
    [super setup];
    self.backgroundColor = UIColor.clearColor;
    
    _presenter = [[QPWebVideoListViewPresenter alloc] init];
    _presenter.view = self;
    _presenter.viewController = nil;
    _adapter = [[QPWebVideoListViewAdapter alloc] init];
    _adapter.listViewDelegate = _presenter;
    
    [self setupBackgroundView];
    [self setupTableView];
    [self setupCloseButton];
    [self adaptThemeStyle];
}

- (void)setupBackgroundView
{
    self.backgroundView.backgroundColor = QPColorFromRGBAlp(20, 20, 20, 0.8);
    self.backgroundView.layer.cornerRadius = 15.f;
    self.backgroundView.layer.masksToBounds = YES;
}

- (void)setupTableView
{
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.delegate   = _adapter;
    self.tableView.dataSource = _adapter;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.f;
}

- (void)setupCloseButton
{
    self.closeButton.backgroundColor = UIColor.clearColor;
    
    // BGC: QPColorFromRGB(242, 82, 81), BC: QPColorFromRGB(254, 194, 49)
    CGRect    rect   = self.closeButton.bounds;
    CGFloat   radius = rect.size.height/2;
    UIImage *bgImage = [self colorImage:rect
                           cornerRadius:radius
                         backgroudColor:QPColorFromRGB(242, 82, 81)
                            borderWidth:0
                            borderColor:nil];
    [self.closeButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", @"QPDropListView.bundle", @"dlv_close"];
    UIImage *image = [UIImage imageNamed:imgPath];
    [self.closeButton setImage:image forState:UIControlStateNormal];
    
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    //self.closeButton.showsTouchWhenHighlighted = YES;
    //self.closeButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}

- (void)refreshUI
{
    [self.tableView reloadData];
}

- (IBAction)onClose:(id)sender
{
    self.alpha = 1.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) { [self removeFromSuperview]; }
    }];
    !_presenter.onCloseHandler ?: _presenter.onCloseHandler();
}

- (void)onCloseAction:(WebVideoListViewOnCloseHandler)completionHandler
{
    _presenter.onCloseHandler = completionHandler;
}

- (void)onSelectRow:(WebVideoListViewOnSelectRowHandler)completionHandler
{
    _presenter.onSelectRowHandler = completionHandler;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self adaptThemeStyle];
    [self refreshUI];
}

- (void)adaptThemeStyle
{
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            // Dark Mode
            _isDarkMode = YES;
        } else {
            // Light Mode or unspecified Mode, mode == UIUserInterfaceStyleLight
            _isDarkMode = NO;
        }
    } else {
        _isDarkMode = NO;
    }
    self.backgroundView.backgroundColor = _isDarkMode ? QPColorFromRGBAlp(255, 255, 255, 1.0) : QPColorFromRGBAlp(20, 20, 20, 0.9);
}

@end
