//
//  ViewController.m
//  pictureWipe
//
//  Created by NegHao.W on 16/6/5.
//  Copyright © 2016年 NegHao.W. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) UIView *wipeView;
@property (assign, nonatomic) CGPoint startPoint;

@end

@implementation ViewController
- (IBAction)reset:(id)sender {
    _bgImageView.image = [UIImage imageNamed:@"IMG_20150205_144215.jpg"];
}

-(UIView *)wipeView{

    if (_wipeView == nil) {
        UIView *wipeView = [[UIView alloc] init];
        wipeView.backgroundColor = [UIColor blackColor];
        wipeView.alpha = 0.5;
        [self.view addSubview:wipeView];
        _wipeView = wipeView;
    }
    return _wipeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(createNewPicture:)];
    [_bgImageView addGestureRecognizer:pan];
    
    
}

-(void)createNewPicture:(UIPanGestureRecognizer *)pan{

    CGPoint endPoint = CGPointZero;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        _startPoint = [pan locationInView:self.view];
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
    
        endPoint = [pan locationInView:self.view];
        
        CGFloat newW = endPoint.x - _startPoint.x;
        CGFloat newH = endPoint.y - _startPoint.y;
        
        self.wipeView.frame = CGRectMake(_startPoint.x, _startPoint.y, newW, newH);
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
    
        UIGraphicsBeginImageContextWithOptions(_bgImageView.bounds.size, NO, 0);
        
        //裁剪区域
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_wipeView.frame];
        
        [path addClip];
        
        //获取当前上下文
        CGContextRef ref = UIGraphicsGetCurrentContext();
        
        //把控件上的内容渲染到上下文
        [_bgImageView.layer renderInContext:ref];
        
        //生成一张新的图片
        _bgImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        [_wipeView removeFromSuperview];
        _wipeView = nil;
        
    }
}

@end
