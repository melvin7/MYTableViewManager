//
//  TimeLineTableViewItem.m
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "TimeLineTableViewItem.h"

@implementation TimeLineTableViewItem

+ (TimeLineTableViewItem*)itemWithModel:(NSDictionary*)data {
    TimeLineTableViewItem *item = [[TimeLineTableViewItem alloc] init];
    item.data = data;
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    return item;
}

@end
