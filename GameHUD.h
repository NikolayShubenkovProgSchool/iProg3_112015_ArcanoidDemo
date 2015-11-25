//
//  GameHUD.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameHUD : SKSpriteNode

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger highScore;

- (instancetype)initWithSize:(CGSize)size;

@end
