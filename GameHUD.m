//
//  GameHUD.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameHUD.h"

@interface GameHUD ()

@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *hightScoreLabel;

@end

@implementation GameHUD

#pragma mark - Init

- (instancetype)initWithSize:(CGSize)size {
    /**
     /////
     
     - returns: <#return value description#>
     */
    self = [super initWithColor:[UIColor redColor] size:size];
    
    SKLabelNode *score = [SKLabelNode node];
    score.fontSize = size.height;
    
    self.scoreLabel = score;
    
    SKLabelNode *hightScore = [SKLabelNode new];
    
    hightScore.fontSize = score.fontSize;
    
    self.hightScoreLabel = hightScore;
    
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.hightScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    
    self.scoreLabel.position = CGPointMake(size.width / -2,
                                           -size.height / 2);
    self.hightScoreLabel.position = CGPointMake(size.width / 2,
                                                -size.height / 2);
    
    [self addChild:self.scoreLabel];
    [self addChild:self.hightScoreLabel];
    
    self.score = 555;
    self.highScore = 777;
    
    return self;
}

#pragma mark - Properties

- (void)setScore:(NSInteger)score {
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Cчет: %ld",(long)self.score];
    if (self.highScore < self.score){
        self.highScore = self.score;
    }
}

- (void)setHighScore:(NSInteger)highScore {
    _highScore = highScore;
    self.hightScoreLabel.text = [NSString stringWithFormat:@"Рекод: %ld",(long)self.highScore];
}

@end
