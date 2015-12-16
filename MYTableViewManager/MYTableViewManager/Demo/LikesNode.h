//
//  LikesNode.h
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface LikesNode : ASControlNode {
    
    ASImageNode *_iconNode;
    ASTextNode *_countNode;
    
    NSInteger _likesCount;
    BOOL _liked;
    
}

- (instancetype)initWithLikesCount:(NSInteger)likesCount;

+ (BOOL) getYesOrNo;

@end