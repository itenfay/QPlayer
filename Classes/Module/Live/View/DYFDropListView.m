//
//  DYFDropListView.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "DYFDropListView.h"
#import "DYFDropListModel.h"

// Transforms two objects's title to pinying and sorts them.
NSInteger sortObjects(DYFDropListModel *obj1, DYFDropListModel *obj2, void *context) {
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:obj1.m_title];
    if (CFStringTransform((__bridge CFMutableStringRef)str1, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:obj2.m_title];
    if (CFStringTransform((__bridge CFMutableStringRef)str2, 0,     kCFStringTransformMandarinLatin, NO)) {
    }
    
    return [str1 localizedCompare:str2];
}

NSString *const kResourceBundle   = @"DYFDropListView.bundle";
NSString *const kDropListDataFile = @"DropListViewData.plist";

@interface DYFDropListView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property ( copy , nonatomic) DropListViewOnCloseHandler onCloseHandler;
@property ( copy , nonatomic) DropListViewOnSelectRowHandler onSelectRowHandler;
@property (assign, nonatomic) BOOL isDarkMode;

@end

@implementation DYFDropListView

- (void)awakeFromNib {
    [super awakeFromNib];
    QPLog(@" >>>>>>>>>> ");
    self.backgroundColor = UIColor.clearColor;
    
    [self setupCorner];
    [self setupMtableView];
    [self setupCloseButton];
    [self identifyMode];
    
    [self preLoadData];
}

- (IBAction)onClose:(id)sender {
    QPLog(@" >>>>>>>>>> ");
    self.alpha = 1.f;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
    !self.onCloseHandler ?: self.onCloseHandler();
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)setupCorner {
    self.m_visualEffectView.layer.cornerRadius = 15.f;
    self.m_visualEffectView.layer.masksToBounds = YES;
}

- (void)setupMtableView {
    self.m_tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.m_tableView.backgroundColor = UIColor.clearColor;
    
    self.m_tableView.delegate   = self;
    self.m_tableView.dataSource = self;
}

- (void)setupCloseButton {
    self.closeButton.backgroundColor = UIColor.clearColor;
    
    // BGC: QPColorFromRGB(242, 82, 81), BC: QPColorFromRGB(254, 194, 49)
    CGRect     rect  = self.closeButton.bounds;
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

- (void)preLoadData {
    [self.dataArray removeAllObjects];
    [self onLoadData];
}

- (void)onLoadData {
    [QPHudObject showActivityMessageInWindow:@"正在加载数据..."];
    
    // DYFDropListView.bundle -> DropListViewData.plist
    NSString *path       = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    NSString *filePath   = [bundlePath stringByAppendingPathComponent:kDropListDataFile];
    QPLog(@" >>>>>>>>>> filePath: %@", filePath);
    
    //NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //NSEnumerator *enumerator = [dict keyEnumerator];
    //id key;
    //while ((key = [enumerator nextObject]) != nil) {
    //    NSString *content = [dict objectForKey:key];
    
    //    DYFDropListModel *model = [[DYFDropListModel alloc] init];
    //    model.m_title = key;
    //    model.m_content = content;
    //
    //    [self.dataArray addObject:model];
    //}
    
    //[self.dataArray sortUsingFunction:sortObjects context:NULL];
    
    NSArray *tvList = [NSArray arrayWithContentsOfFile:filePath];
    
    NSEnumerator *enumerator = [tvList objectEnumerator];
    id obj;
    while ((obj = [enumerator nextObject]) != nil) {
        
        NSDictionary *dict = (NSDictionary *)obj;
        
        DYFDropListModel *model = [[DYFDropListModel alloc] init];
        model.m_title = dict.allKeys.firstObject;
        model.m_content = dict.allValues.firstObject;
        
        [self.dataArray addObject:model];
    }
    
    [self delayToScheduleTask:1 completion:^{
        [QPHudObject hideHUD];
    }];
}

- (void)onCloseAction:(DropListViewOnCloseHandler)completionHandler {
    self.onCloseHandler = completionHandler;
}

- (void)onSelectRow:(DropListViewOnSelectRowHandler)completionHandler {
    self.onSelectRowHandler = completionHandler;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DropListViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DropListViewCellID";
    
    DYFDropListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DYFDropListViewCell class]) bundle:nil];
        cell = [nib instantiateWithOwner:nil options:nil].firstObject;
    }
    
    cell.left   = 0.f;
    cell.top    = 0.f;
    cell.width  = self.width;
    cell.height = DropListViewCellHeight;
    
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle  = UITableViewCellSelectionStyleGray;
    
    DYFDropListModel *model = self.dataArray[indexPath.row];
    
    cell.m_titleLabel.text = model.m_title;
    cell.m_titleLabel.textColor = self.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_titleLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_titleLabel.numberOfLines = 2;
    
    cell.m_detailLabel.text = model.m_content;
    cell.m_detailLabel.textColor = self.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_detailLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_detailLabel.numberOfLines = 2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DYFDropListModel *model = self.dataArray[indexPath.row];
    QPLog(@" >>>>>>>>>> title: %@",   model.m_title);
    QPLog(@" >>>>>>>>>> content: %@", model.m_content);
    
    !self.onSelectRowHandler ?:
    self.onSelectRowHandler(indexPath.row, model.m_title, model.m_content);
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self identifyMode];
    [self.m_tableView reloadData];
}

- (void)identifyMode {
    
    if (@available(iOS 13.0, *)) {
        
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        
        if (mode == UIUserInterfaceStyleDark) {
            // Dark Mode
            self.isDarkMode = YES;
            self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else if (mode == UIUserInterfaceStyleLight) {
            // Light Mode or unspecified Mode
            self.isDarkMode = NO;
            self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        
    } else {
        
        self.isDarkMode = NO;
        self.m_visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
}

@end
