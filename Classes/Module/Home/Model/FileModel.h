//
//  FileModel.h
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject
// 文件大小
@property (nonatomic, assign) double fileSize;
// 创建日期
@property (nonatomic, copy) NSString *creationDate;
// 修改日期
@property (nonatomic, copy) NSString *modificationDate;
// 文件路径
@property (nonatomic, copy) NSString *path;
// 文件名称
@property (nonatomic, copy) NSString *name;
// 文件标题
@property (nonatomic, copy) NSString *title;
// 文件类型
@property (nonatomic, copy) NSString *fileType;

@end
