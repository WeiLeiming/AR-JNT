//
//  QJBaseTableViewCell.m
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJBaseTableViewCell.h"

@implementation QJBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
