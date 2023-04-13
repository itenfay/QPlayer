//
//  QPDropListView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPDropListView.h"

@interface QPDropListView ()
@property (nonatomic, strong) QPDropListViewPresenter *presenter;
@end

@implementation QPDropListView

- (QPDropListViewPresenter *)presenter
{
    return _presenter;
}

- (void)setup
{
    [super setup];
    self.backgroundColor = UIColor.clearColor;
    
    _presenter = [[QPDropListViewPresenter alloc] init];
    _presenter.view = self;
    _presenter.viewController = nil;
    _adapter = [[QPDropListViewAdapter alloc] init];
    _adapter.listViewDelegate = _presenter;
    
    [self setupCorner];
    [self setupTableView];
    [self setupCloseButton];
    [self adaptThemeStyle];
    
    [_presenter loadData];
}

- (void)setupCorner
{
    self.m_visualEffectView.layer.cornerRadius = 15.f;
    self.m_visualEffectView.layer.masksToBounds = YES;
}

- (void)setupTableView
{
    self.m_tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.m_tableView.backgroundColor = UIColor.clearColor;
    self.m_tableView.delegate   = _adapter;
    self.m_tableView.dataSource = _adapter;
    self.m_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.m_tableView.rowHeight = UITableViewAutomaticDimension;
    self.m_tableView.estimatedRowHeight = 50.f;
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
    
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", kResourceBundle, @"dlv_close"];
    UIImage *image = [UIImage imageNamed:imgPath];
    [self.closeButton setImage:image forState:UIControlStateNormal];
    
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    //self.closeButton.showsTouchWhenHighlighted = YES;
    //self.closeButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.9];
}

- (void)refreshUI
{
    [self.m_tableView reloadData];
}

- (IBAction)onClose:(id)sender
{
    self.alpha = 1.f;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) { [self removeFromSuperview]; }
    }];
    !_presenter.onCloseHandler ?: _presenter.onCloseHandler();
}

- (void)onCloseAction:(DropListViewOnCloseHandler)completionHandler
{
    _presenter.onCloseHandler = completionHandler;
}

- (void)onSelectRow:(DropListViewOnSelectRowHandler)completionHandler
{
    _presenter.onSelectRowHandler = completionHandler;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self adaptThemeStyle];
    [self.m_tableView reloadData];
}

- (void)adaptThemeStyle
{
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            // Dark Mode
            _isDarkMode = YES;
            self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else if (mode == UIUserInterfaceStyleLight) {
            // Light Mode or unspecified Mode
            _isDarkMode = NO;
            self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
    } else {
        _isDarkMode = NO;
        self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
}

@end
