//
//  QPSearchViewController.m
//
//  Created by Tenfay on 2017/12/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPSearchViewController.h"
#import "QPAdvancedSearchController.h"

@interface QPSearchViewController ()

@end

@implementation QPSearchViewController

- (void)configureNavigationBar 
{
    UIView *tfLeftView         = [[UIView alloc] init];
    tfLeftView.frame           = CGRectMake(0, 0, 26, 26);
    UIImageView *searchImgView = [[UIImageView alloc] init];
    searchImgView.frame        = CGRectMake(5, 5, 16, 16);
    searchImgView.image        = QPImageNamed(@"search_gray");
    searchImgView.contentMode  = UIViewContentModeScaleToFill;
    [tfLeftView addSubview:searchImgView];
    
    UITextField *textField    = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    textField.borderStyle     = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType   = UIReturnKeyGo;
    textField.delegate        = self;
    textField.font            = [UIFont systemFontOfSize:15.f];
    textField.leftView        = tfLeftView;
    textField.leftViewMode    = UITextFieldViewModeAlways;
    [self setNavigationTitleView:textField];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setTitle:@"去看片" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(showVideoController) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:rightBtn];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    QPSearchPresenter *presenter = [[QPSearchPresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    self.adapter.scrollViewDelegate = presenter;
}

- (void)showVideoController
{
    QPAdvancedSearchController *advancedSearchController = [[QPAdvancedSearchController alloc] init];
    advancedSearchController.hidesBottomBarWhenPushed = YES;
    //[self.navigationController showViewController:advancedSearchController sender:self];
    [self.navigationController pushViewController:advancedSearchController animated:true];
}

@end
