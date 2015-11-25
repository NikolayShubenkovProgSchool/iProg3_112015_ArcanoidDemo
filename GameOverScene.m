//
//  GameOverScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

- (instancetype)initWithSize:(CGSize)size victory:(BOOL)playerWin score:(NSInteger)score {
    self = [super initWithSize:size];
    if (self){
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize backgroundSize = CGSizeApplyAffineTransform(size,
                                                           CGAffineTransformMakeScale(scale, scale));
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor]
                                                                size:backgroundSize];
        [self addChild:background];
        
        //Win or Lose
        SKLabelNode *victoryLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        victoryLabel.fontSize = 20;
        
//        self.frame;
        victoryLabel.position = CGPointMake(CGRectGetWidth (self.frame) / 2,
                                            CGRectGetHeight(self.frame) / 2);
        victoryLabel.text = playerWin ? @"Поздравляем! Ура!!!" : @"Повезет в другой раз(";
        
        [self addChild:victoryLabel];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startNewGame];
}

- (void)startNewGame {
    GameScene *game = [GameScene unarchiveFromFile:@"GameScene"];
    
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1];
    
    [self.view presentScene:game transition:transition];
}

@end
