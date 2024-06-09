//
//  QPDropListModel.h
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © Tenfay dyf. All rights reserved.
//

#import "BaseModel.h"

@interface QPDropListModel : BaseModel

// Returns a title string.
@property (nonatomic, copy) NSString *m_title;

// Returns a content string.
@property (nonatomic, copy) NSString *m_content;

@end
