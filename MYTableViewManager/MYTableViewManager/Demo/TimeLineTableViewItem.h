//
//  TimeLineTableViewItem.h
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "MYTableViewItem.h"

@interface TimeLineTableViewItem : MYTableViewItem

@property (nonatomic, strong) NSDictionary  *data;

@property (nonatomic, assign) NSInteger     index;

@property (nonatomic, assign) CGFloat       contentHeight;

@property (nonatomic, assign) CGFloat       contentImageHeight;

+ (TimeLineTableViewItem*)itemWithModel:(NSDictionary*)data;


@end
