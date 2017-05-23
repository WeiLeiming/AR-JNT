//
//  QJBaseCollectionViewCell.m
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJBaseCollectionViewCell.h"

@implementation QJBaseCollectionViewCell

/**
 set data
 
 @param data model
 */
- (void)setData:(id)data {
    
}

/**
 reuse identifier
 
 @return identifier
 */
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
