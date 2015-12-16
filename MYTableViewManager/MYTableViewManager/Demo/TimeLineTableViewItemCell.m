//
//  TimeLineTableViewItemCell.m
//  MYTableViewManager
//
//  Created by Melvin on 12/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "TimeLineTableViewItemCell.h"
#import "LikesNode.h"
#import "CommentsNode.h"
#import "TextStyles.h"

@interface TimeLineTableViewItemCell()<ASTextNodeDelegate,ASNetworkImageNodeDelegate> {
    ASTextNode          *_nickNameNode;
    ASTextNode          *_timeNode;
    ASNetworkImageNode  *_avatarNode;
    
    
    ASTextNode          *_titleNode;
    ASTextNode          *_contentNode;
    ASNetworkImageNode  *_mediaNode;
    ASNetworkImageNode  *_backgroundMediaNode;
    
    LikesNode           *_likesNode;
    CommentsNode        *_commentsNode;
    
}

@end

@implementation TimeLineTableViewItemCell
@dynamic tableViewItem;

- (void)initCell {
    [super initCell];
    // name node
    _nickNameNode = [[ASTextNode alloc] init];
    _nickNameNode.attributedString = [[NSAttributedString alloc] initWithString:[[self.tableViewItem.data objectForKey:@"author"] objectForKey:@"nickName"]
                                      
                                                                     attributes:[TextStyles nameStyle]];
    _nickNameNode.maximumNumberOfLines = 1;
    [self addSubnode:_nickNameNode];
    // username node
    _timeNode = [[ASTextNode alloc] init];
    _timeNode.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.tableViewItem.data objectForKey:@"date"]]
                                                                 attributes:[TextStyles usernameStyle]];
    _timeNode.flexShrink = YES; //if name and username don't fit to cell width, allow username shrink
    _timeNode.truncationMode = NSLineBreakByTruncatingTail;
    _timeNode.maximumNumberOfLines = 1;
    
    [self addSubnode:_timeNode];
    
    // user pic
    _avatarNode = [[ASNetworkImageNode alloc] init];
    _avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    _avatarNode.preferredFrameSize = CGSizeMake(44, 44);
    _avatarNode.cornerRadius = 22.0;
    _avatarNode.URL = [NSURL URLWithString:[[self.tableViewItem.data objectForKey:@"author"] objectForKey:@"avatar"]];
    _avatarNode.imageModificationBlock = ^UIImage *(UIImage *image) {
        
        UIImage *modifiedImage;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
        
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:44.0] addClip];
        [image drawInRect:rect];
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return modifiedImage;
        
    };
    [self addSubnode:_avatarNode];
    
    // title node
    _titleNode = [[ASTextNode alloc] init];
    _titleNode.attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.tableViewItem.data objectForKey:@"timeTitle"]]
                                                                  attributes:[TextStyles titleStyle]];
    _titleNode.flexShrink = YES; //if name and username don't fit to cell width, allow username shrink
    _titleNode.truncationMode = NSLineBreakByTruncatingTail;
    _titleNode.maximumNumberOfLines = 1;
    
    [self addSubnode:_titleNode];
    
    // post node
    _contentNode = [[ASTextNode alloc] init];
    _contentNode.maximumNumberOfLines = 4;
    
    // processing URLs in post
    NSString *kLinkAttributeName = @"TextLinkAttributeName";
    
    if(![[self.tableViewItem.data objectForKey:@"content"] isEqualToString:@""]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[self.tableViewItem.data objectForKey:@"content"]
                                                                                       attributes:[TextStyles postStyle]];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(0, attrString.string.length)];
        NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        [urlDetector enumerateMatchesInString:attrString.string
                                      options:kNilOptions
                                        range:NSMakeRange(0, attrString.string.length)
                                   usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
         {
             if (result.resultType == NSTextCheckingTypeLink)
             {
                 
                 NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:[TextStyles postLinkStyle]];
                 linkAttributes[kLinkAttributeName] = [NSURL URLWithString:result.URL.absoluteString];
                 
                 [attrString addAttributes:linkAttributes range:result.range];
             }
         }];
        
        // configure node to support tappable links
        _contentNode.delegate = self;
        _contentNode.userInteractionEnabled = YES;
        _contentNode.linkAttributeNames = @[ kLinkAttributeName ];
        _contentNode.attributedString = attrString;
        
    }
    
    [self addSubnode:_contentNode];
    
    // media
    NSArray *imageObjList = [self.tableViewItem.data objectForKey:@"imageObjList"];
    NSString *imageURL = @"";
    if ([imageObjList count] > 0) {
        imageURL = [[imageObjList objectAtIndex:0] objectForKey:@"imageUrl"];
    }
    if(![imageURL isEqualToString:@""]) {
        _mediaNode = [[ASNetworkImageNode alloc] init];
        _mediaNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _mediaNode.cornerRadius = 4.0;
        _mediaNode.URL = [NSURL URLWithString:imageURL];
        _mediaNode.delegate = self;
        _mediaNode.imageModificationBlock = ^UIImage *(UIImage *image) {
            UIImage *modifiedImage;
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:8.0] addClip];
            [image drawInRect:rect];
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return modifiedImage;
        };
        [self addSubnode:_mediaNode];
    }
    
    // bottom controls likeCount
    _likesNode = [[LikesNode alloc] initWithLikesCount:[[self.tableViewItem.data objectForKey:@"likeCount"] integerValue]];
    [self addSubnode:_likesNode];
    
    _commentsNode = [[CommentsNode alloc] initWithCommentsCount:[[self.tableViewItem.data objectForKey:@"commentCount"] integerValue]];
    [self addSubnode:_commentsNode];
}


- (void)layout {
    [super layout];
    _backgroundMediaNode.frame = self.bounds;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //Flexible spacer between username and time
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.flexGrow = YES;
    
    //Horizontal stack for name, username, via icon and time
    ASStackLayoutSpec *nameStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStretch
                                                                          children:@[_avatarNode,_nickNameNode, spacer,_timeNode]];
    
    
    
    nameStack.alignSelf = ASStackLayoutAlignSelfStretch;
    
    // bottom controls horizontal stack
    ASStackLayoutSpec *controlsStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_likesNode, _commentsNode]];
    
    //add more gaps for control line
    controlsStack.spacingAfter = 3.0;
    controlsStack.spacingBefore = 3.0;
    
    
    
    NSMutableArray *mainStackContent = [[NSMutableArray alloc] init];
    
    [mainStackContent addObject:nameStack];
    [mainStackContent addObject:_titleNode];
    [mainStackContent addObject:_contentNode];
    
    
    if([[self.tableViewItem.data objectForKey:@"imageObjList"] count] > 0) {
        CGFloat imageRatio;
        if(_mediaNode.image != nil) {
            imageRatio = _mediaNode.image.size.height / _mediaNode.image.size.width;
        }else {
            imageRatio = 0.5;
        }
        ASRatioLayoutSpec *imagePlace = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:imageRatio
                                                                              child:_mediaNode];
        imagePlace.spacingAfter = 3.0;
        imagePlace.spacingBefore = 3.0;
        [mainStackContent addObject:imagePlace];
        
    }
    
    [mainStackContent addObject:controlsStack];
    
    //Vertical spec of cell main content
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0
                                                                      justifyContent:ASStackLayoutJustifyContentStart
                                                                          alignItems:ASStackLayoutAlignItemsStart
                                                                            children:mainStackContent];
    
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                  child:contentSpec];
}
#pragma mark -
#pragma mark ASNetworkImageNodeDelegate methods.

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image
{
    [self setNeedsLayout];
}

@end
