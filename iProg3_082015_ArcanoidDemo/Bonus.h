//
//  Bonus.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, BonusType){
    BonusTypeFire
};

@interface Bonus : SKSpriteNode

@property (nonatomic) BonusType type;

+ (instancetype)bonusOfType:(BonusType)type;

@end
