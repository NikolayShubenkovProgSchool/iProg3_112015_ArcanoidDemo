//
//  GameScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 08/08/15.
//  Copyright (c) 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameScene.h"
#import "Settings.h"
#import "GameOverScene.h"
#import "Brick.h"
#import "GameHUD.h"
#import "Bonus.h"

static const CGFloat kMnAllowedXYSpeed = 20;
//в слчае когда мяч возле самой стены
static const CGFloat kSeedToSetForBallNearWall = 80;

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *ball;
@property (nonatomic, strong) SKSpriteNode *desk;
@property (nonatomic, strong) SKSpriteNode *gameOverLine;
@property (nonatomic) BOOL isTouchingDesk;
@property (nonatomic, strong) GameHUD *hud;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) Bonus *currentBonus;
@property (nonatomic, strong) SKEmitterNode *fire;

@end

@implementation GameScene

#pragma mark - Properties Overload

- (void)setCurrentBonus:(Bonus *)currentBonus {
    _currentBonus = currentBonus;
    _currentBonus.physicsBody = nil;
    [self applyBonus:_currentBonus];
}

- (void)applyBonus:(Bonus *)bonus {
    [bonus runAction:[SKAction fadeOutWithDuration:0.4] completion:^{
        [bonus removeFromParent];
    }];
    
    switch (bonus.type) {
        case BonusTypeFire: {
            NSString *pathToFire = [[NSBundle mainBundle]pathForResource:@"fire" ofType:@"sks"];
            SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToFire];
            [self.fire removeFromParent];
            self.fire = fire;
            [self addChild:self.fire];
//            self.fire.targetNode = self;
            self.fire.position   = self.ball.position;
            //чтобы огонь красиво перемещался за шаром
            
            break;
        }
        default: {
            break;
        }
    }
}

- (SKEmitterNode *)createFire {
    NSString *pathToFire = [[NSBundle mainBundle]pathForResource:@"fire" ofType:@"sks"];
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToFire];
    return fire;
}

- (Settings *)settings{
    if (!_settings){
        _settings = [Settings new];
    }
    return _settings;
}

- (SKSpriteNode *)gameOverLine {
    if (!_gameOverLine){
        _gameOverLine = [SKSpriteNode new];
        
        CGRect bodyRect = CGRectMake(0,
                                     0,
                                     CGRectGetWidth(self.frame),
                                     1);
        _gameOverLine.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyRect];
        _gameOverLine.physicsBody.categoryBitMask = PhysicsCategoryGameOverLine;
        _gameOverLine.name = @"game over line";
    }
    return _gameOverLine;
}

- (SKSpriteNode *)ball
{
    if (!_ball){
        _ball = (SKSpriteNode *)[self childNodeWithName:@"ball"];
        NSParameterAssert(_ball);
        _ball.physicsBody.friction       = 0;
        _ball.physicsBody.restitution    = 1;
        _ball.physicsBody.linearDamping  = 0;
        _ball.physicsBody.angularDamping = 0;
        _ball.physicsBody.allowsRotation = NO;
        _ball.physicsBody.affectedByGravity = NO;
        _ball.position   = CGPointMake(100, 50);
        _ball.physicsBody.categoryBitMask    = PhysicsCategoryBall;
        _ball.physicsBody.contactTestBitMask = PhysicsCategoryGameOverLine | PhysicsCategoryBrick;
        _ball.physicsBody.usesPreciseCollisionDetection = YES;
    }
    return _ball;
}

- (SKSpriteNode *)desk
{
    if (!_desk){
        _desk = (SKSpriteNode *)[self childNodeWithName:@"desk"];
        NSParameterAssert(_desk);
        _desk.physicsBody.friction       = 0;
        _desk.physicsBody.restitution    = 1;
        _desk.physicsBody.linearDamping  = 0;
        _desk.physicsBody.angularDamping = 0;
        _desk.physicsBody.allowsRotation = NO;
        _desk.physicsBody.dynamic        = NO;
        _desk.physicsBody.categoryBitMask = PhysicsCategoryDesk;
        _desk.physicsBody.contactTestBitMask = PhysicsCategoryBonus;
        NSParameterAssert(_desk);
    }
    return _desk;
}

#pragma mark - Init

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return (GameScene *)scene;
}

#pragma mark - Life Cycle

- (void)didMoveToView:(SKView *)view {
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.friction       = 0;
    self.physicsBody      = border;
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    [self.ball.physicsBody applyImpulse:CGVectorMake(15, 10)];
    self.desk.color = [UIColor purpleColor];
    
    [self addChild:self.gameOverLine];
    NSParameterAssert([self.children containsObject:self.gameOverLine]);
    
    // наложим кирпичей на игрову сцену
    [self loadBricks];
    [self addHUD];
}

- (void)loadBricks {
    
    CGFloat y = CGRectGetHeight(self.frame) - 35;
    int rowsCount = 6;
    
    for (int i = 0; i < rowsCount; i++){
        CGFloat margin = i % 2 == 0? 35 : 15;
        
        for (CGFloat x = margin; x < CGRectGetWidth(self.frame) - margin; x += 40){
            Brick *aBrick = [Brick brickAtPoint:CGPointMake(x, y)];
            [self addChild:aBrick];
        }
        y-= 35;
    }
}

- (void)addHUD {
    GameHUD *hud = [[GameHUD alloc]initWithSize:CGSizeMake(self.size.width, self.size.height / 20)];
    hud.position = CGPointMake(self.size.width  / 2,
                               self.size.height - self.size.height / 20);
    self.hud = hud;
    self.hud.score = 0;
    self.hud.highScore = self.settings.highScore;
    [self addChild:hud];    
}

#pragma mark - Touchs

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    //найдем все ноды в точке касания
    NSArray *nodes = [self nodesAtPoint:touchLocation];
    
    //если среди нодов, которых коснулись есть доска
    self.isTouchingDesk = [nodes containsObject:self.desk];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouchingDesk){
        return;
    }
    UITouch *aTouch = [touches anyObject];
    //Считаем текущую и предыдущую точки касания
    CGPoint currentPoint = [aTouch locationInNode:self];
    CGPoint prevPoint    = [aTouch previousLocationInNode:self];
    
    //В соответствии с ними переместрим доску
    
    CGFloat delta = currentPoint.x - prevPoint.x;
    CGFloat newX = self.desk.position.x + delta;
    
    CGPoint newPosition = CGPointMake(newX, self.desk.position.y);
    
    CGFloat deskWidth = CGRectGetWidth(self.desk.frame);
    if (newPosition.x < deskWidth / 2){
        newPosition.x = deskWidth / 2;
    }
    
    if (newPosition.x > CGRectGetWidth(self.frame) - deskWidth / 2){
        newPosition.x = CGRectGetWidth(self.frame) - deskWidth / 2;
    }
    
    self.desk.position = newPosition;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}

-(void)update:(CFTimeInterval)currentTime {
    if (fabs(self.ball.physicsBody.velocity.dx) < kMnAllowedXYSpeed){
        CGVector velocity     = self.ball.physicsBody.velocity;
        SKPhysicsBody *abody  = self.ball.physicsBody;
        self.ball.physicsBody = nil;
        velocity.dx           = self.ball.position.x > 200 ? -kSeedToSetForBallNearWall :
        kSeedToSetForBallNearWall;
        abody.velocity        = velocity;
        self.ball.physicsBody = abody;
    }
    if (fabs(self.ball.physicsBody.velocity.dy) < kMnAllowedXYSpeed){
        CGVector velocity     = self.ball.physicsBody.velocity;
        SKPhysicsBody *abody  = self.ball.physicsBody;
        self.ball.physicsBody = nil;
        velocity.dy           = -kSeedToSetForBallNearWall;
        abody.velocity        = velocity;
        self.ball.physicsBody = abody;
    }
    
    self.fire.position = self.ball.position;
}

#pragma mark - Physics

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *bodyA;//битавая маска будет всегда меньше по значению
    SKPhysicsBody *bodyB;//битавая маска будет всегда больше по значению
    
    //Сделаем так, чтобы в body A всегда был объект с битовой маской меньшего значения
    if (contact.bodyB.categoryBitMask > contact.bodyA.categoryBitMask){
        bodyB = contact.bodyB;
        bodyA = contact.bodyA;
    }
    else {
        bodyB = contact.bodyA;
        bodyA = contact.bodyB;
    }
    
    [self testForGameOver:bodyA bodyB:bodyB];
    [self testForBrickCollision:bodyA bodyB:bodyB];
    [self testForGettingBonus:bodyA bodyB:bodyB];
}

- (void)testForGettingBonus:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB{
    //если доской поймали бонус, то
    if ((PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryDesk)) &&
        (PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryBonus))){
        self.currentBonus = (Bonus *)bodyB.node;
        self.currentBonus.physicsBody = nil;
    }
}

- (void)testForGameOver:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    //мяч + нижняя невидимая линия
    if ( (PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
          PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryGameOverLine))){
        //show gameOver
        NSLog(@"game over");
        [self showGameOver];
    }
}

- (void)testForBrickCollision:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    //мяч + кирпич
    if (  PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
          PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryBrick)){
        NSLog(@"кирпич ударился! ");

        [self addBonusFromPoint:bodyB.node.position];
        
        if (self.fire){
            SKEmitterNode *fire = [self createFire];
            [bodyB.node addChild:fire];
        }
        
        [self removeBrick:bodyB];
        
    }
}

- (void)addBonusFromPoint:(CGPoint)aPoint {
    //с некоторой вероятностью создадим бонус
    int posibility = 2;
    //
    if (arc4random() % posibility != 0){
        return;
    }
    Bonus *myBonus = [Bonus bonusOfType:BonusTypeFire];
    myBonus.position = aPoint;
    [self addChild:myBonus];
    
    [myBonus.physicsBody applyImpulse:CGVectorMake(0,-10)];
//                                                   (arc4random() % 10) - 5,
//                                                   -(arc4random() % 5))];
}

#pragma mark - Handle Events

- (void)removeBrick:(SKPhysicsBody *)brick {
    
    SKAction *fade = [SKAction fadeOutWithDuration:0.3];
    //Удалить блок
    SKAction *removeFromParent = [SKAction runBlock:^{
        [brick.node removeFromParent];
    }];
    
    //запихнем последовательность действий
    SKAction *sequence = [SKAction sequence:@[fade,removeFromParent]];
    
    [brick.node runAction:sequence];
    self.hud.score++;
}

- (void)showGameOver {    
    GameOverScene *scene = [[GameOverScene alloc]initWithSize:self.size
                                                      victory:NO
                                                        score:0];
    SKTransition *transition = [SKTransition doorsCloseVerticalWithDuration:1];
    if (self.hud.score > self.settings.highScore){
        self.settings.highScore = self.hud.score;
    }
    [self.view presentScene:scene
                 transition:transition];
}


@end
