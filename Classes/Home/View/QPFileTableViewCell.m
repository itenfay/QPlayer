//
//  QPFileTableViewCell.m
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPFileTableViewCell.h"

@interface QPFileTableViewCell () <QPFileModelDelegate>

@end

@implementation QPFileTableViewCell

- (void)setup
{
    _presenter = [[QPFileModelPresenter alloc] initWithView:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (void)setThumbnail:(NSString *)filePath
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    UIImage *thumbnail = self.yf_videoThumbnailImage(url, 3, 107, 60);
    [self.thumbnailImgView setBackgroundColor:QPColorFromRGB(36, 39, 46)];
    [self.thumbnailImgView setImage:thumbnail];
    [self.thumbnailImgView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setFormatImage:(NSString *)fileType
{
    NSString *ext = [fileType lowercaseString];
    NSString *iconName = QPMatchingIconName(ext);
    self.formatImgView.image = QPImageNamed(iconName);
    self.formatImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setTitleText:(NSString *)title
{
    self.titleLabel.text = title;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setTitleTextColor:(UIColor *)color
{
    _titleLabel.textColor = color;
}

- (void)setDateText:(NSString *)text
{
    _dateLabel.text = text;
}

- (void)setDateTextColor:(UIColor *)color
{
    _dateLabel.textColor = color;
}

- (void)setText:(NSString *)filePath fileSize:(double)fileSize
{
    NSURL *aURL = [NSURL fileURLWithPath:filePath];
    int duration = self.yf_videoDuration(aURL);
    NSString *displayTime = [AppHelper formatVideoDuration:duration];
    
    double ret = fileSize / 1000.0;
    NSString *sizeStr;
    if (ret < 1.0) {
        sizeStr = [NSString stringWithFormat:@"%0.1f MB", fileSize];
    } else {
        sizeStr = [NSString stringWithFormat:@"%0.1f GB", ret];
    }
    
    NSString *info = [NSString stringWithFormat:@"%@ | %@", displayTime, sizeStr];
    [_infolabel setText:info];
}

- (void)setTextColor:(UIColor *)color
{
    _infolabel.textColor = color;
}

- (void)setDividerColor:(UIColor *)color
{
    _divider.backgroundColor = color;
}

@end
