//
//  QJBaseTableViewCell.h
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJBaseTableViewCell : UITableViewCell


/**
 set data

 @param data model
 */
- (void)setData:(id)data;

/**
 reuse identifier
 
 @return identifier
 */
+ (NSString *)reuseIdentifier;

@end
