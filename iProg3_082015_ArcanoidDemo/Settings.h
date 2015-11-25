//
//  Settings.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(uint32_t, PhysicsCategory){
    PhysicsCategoryBall         = 1,        //1
    PhysicsCategoryGameOverLine = 1 << 1,   //2
    PhysicsCategoryDesk         = 1 << 2,
    PhysicsCategoryBrick        = 1 << 3,    //2 ^ 3 = 8
    PhysicsCategoryBonus        = 1 << 4
};

BOOL PhysicsCategoryIs(PhysicsCategory categoryToTest, PhysicsCategory refCategory);

@interface Settings : NSObject

@property (nonatomic) NSInteger highScore;

@end
