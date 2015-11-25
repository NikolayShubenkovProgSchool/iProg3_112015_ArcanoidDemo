//
//  Settings.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "Settings.h"

NSString * const kHighScoreKey = @"hightScore";

BOOL PhysicsCategoryIs(PhysicsCategory categoryToTest, PhysicsCategory refCategory) {
    //!!!!!!
    if (categoryToTest == refCategory){
        return YES;
    }
    return NO;
};

@implementation Settings

- (void)setHighScore:(NSInteger)highScore {
    if (self.highScore != highScore){
        _highScore = highScore;
        //класс для работы с настройками приложения
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@(_highScore)
                    forKey:kHighScoreKey];
        //сохранить настройки приложения
        [defaults synchronize];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey];
    }
    return self;
}


@end
