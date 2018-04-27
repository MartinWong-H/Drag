//
//  ViewController.m
//  Drag
//
//  Created by MARTIN_HUANG on 2018/4/24.
//  Copyright © 2018年 MARTIN_HUANG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *dragView;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

- (void)setupViews {
    self.dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.dragView.layer.borderWidth = 1.0f;
    self.dragView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.dragView];
    self.dragView.hidden = YES;
    
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)changeDragViewWith:(CGPoint)point panViewFrame:(CGRect)rect {
    CGFloat locX = point.x;
    CGFloat locY = point.y;
    
    CGRect frame = self.dragView.frame;
    CGFloat aWidth = CGRectGetWidth(frame);
    CGFloat aHeight = CGRectGetHeight(frame);
    //中心坐标
    CGFloat fCenterX = locX + aWidth *0.5;
    CGFloat fCenterY = locY + aHeight *0.5;
    
    CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat halfHeight = [UIScreen mainScreen].bounds.size.height/2;
    // 手势超类中心
    CGFloat rCenterX = rect.size.width/2;
    CGFloat rCenterY = rect.size.height/2;
    
    if (rCenterX - (locX - aWidth/2) > halfWidth) {// 出了左边边界
        locX = aWidth/2;
    }
    if (fCenterX - rCenterX > halfWidth) {//右边界
        locX = halfWidth*2 - aWidth/2;
    }
    
    if (rCenterY - (locY - aHeight/2) > halfHeight) {
        locY = aHeight/2;
    }
    if (fCenterY - rCenterY >halfHeight) {
        locY = halfHeight *2 - aHeight/2;
    }
    
    self.dragView.frame = CGRectMake(locX - aWidth/2, locY - aHeight/2, aWidth, aHeight);
    self.dragView.hidden = NO;
}

- (void)dragViewMoved:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
//        CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
//        CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
        //返回在横坐标上、纵坐标上拖动了多少像素
//        CGPoint point = [panGestureRecognizer translationInView:self.view];
        
        CGPoint point1 = [panGestureRecognizer locationInView:self.view];
        [self changeDragViewWith:point1 panViewFrame:panGestureRecognizer.view.frame];
                //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point1 = [panGestureRecognizer locationInView:self.view];
        [self changeDragViewWith:point1 panViewFrame:panGestureRecognizer.view.frame];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.dragView.hidden = YES;
    }
}

#pragma mark - accessor
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewMoved:)];
    }
    return _panGestureRecognizer;
}



@end
