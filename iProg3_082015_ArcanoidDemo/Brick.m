//
//  Brick.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "Brick.h"
#import "Settings.h"

@implementation Brick

+ (instancetype)brickAtPoint:(CGPoint)point {
    Brick *brick = [self spriteNodeWithImageNamed:@"brick"];
    brick.name = @"brick";
    
    SKPhysicsBody *brickBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.size];
    brickBody.categoryBitMask = PhysicsCategoryBrick;
    //бесконечно большая масса, кирпич никуда не улетит при столкновении
    brickBody.dynamic = 0;
    brickBody.friction = 0;
    brickBody.restitution = 1;
    brickBody.linearDamping = 0;
    brickBody.angularDamping = 0;
    brickBody.allowsRotation = NO;
    brickBody.affectedByGravity = NO;
    
    brick.physicsBody = brickBody;
    brick.position = point;
    
    
    
    return brick;
}

@end
