//
//  Bonus.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 21/11/15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "Bonus.h"

#import "Settings.h"

@implementation Bonus

- (instancetype)init {
    self = [super initWithColor:[UIColor yellowColor]
                           size:CGSizeMake(30, 30)];
    if (self){
        
        SKPhysicsBody *abody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        abody.restitution = 1;
        abody.linearDamping = 0;
        abody.angularDamping = 0;
        abody.dynamic = YES;
        
        abody.categoryBitMask = PhysicsCategoryBonus;
        //не взаимодействовать ни скем
        //от кого объект будет отлитать
        //кто играл в half-life - это аналог noclip on
        //не сталкиваться ни с кем, проходить сквозь стены, как дракула
        abody.collisionBitMask   = 0;
        abody.contactTestBitMask = 0;
        
        self.physicsBody = abody;
    }
    
    return self;
}

+ (instancetype)bonusOfType:(BonusType)type {
    NSParameterAssert(type == BonusTypeFire);
    Bonus *aBonus = [[self alloc]init];
    aBonus.type = type;
    
    return aBonus;
    
}

@end
