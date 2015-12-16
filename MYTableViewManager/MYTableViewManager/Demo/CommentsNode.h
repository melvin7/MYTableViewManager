//
//  CommentsNode.h
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface CommentsNode : ASControlNode {
    
    
    ASImageNode *_iconNode;
    ASTextNode *_countNode;
    
    NSInteger _comentsCount;
}
- (instancetype)initWithCommentsCount:(NSInteger)comentsCount;

@end
