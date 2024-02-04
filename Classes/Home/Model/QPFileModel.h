//
//  QPFileModel.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseModel.h"

@interface QPFileModel : BaseModel

/// The size of file.
@property (nonatomic, assign) double fileSize;

/// The date of file creation.
@property (nonatomic, copy) NSString *creationDate;

/// The date of file modification.
@property (nonatomic, copy) NSString *modificationDate;

/// The path of file.
@property (nonatomic, copy) NSString *path;

/// The name of file.
@property (nonatomic, copy) NSString *name;

/// The title of file.
@property (nonatomic, copy) NSString *title;

/// The type of file.
@property (nonatomic, copy) NSString *fileType;

@end
