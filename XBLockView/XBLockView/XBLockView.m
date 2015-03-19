//
//  XBLockView.m
//  XBLockView
//
//  Created by Peter on 15/3/19.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "XBLockView.h"

#define minW        40

const static CGFloat kTrackedLocationInvalidInContentView = -1.0;

@interface XBLockView()
{
    __weak id<XBLockViewDelegate> delegate;
    NSMutableArray  *_allButtons;
    NSMutableArray  *_selectedButtons;
    int             _horCount;
    int             _verCount;
    CGPoint         _trackedLocationInContentView;
    UIColor         *_lineColor;
}
@end

@implementation XBLockView
@synthesize delegate;

- (id)initWithSize:(CGRect)frame hor:(int)hor ver:(int)ver
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _horCount = hor;
        _verCount = ver;
        _allButtons = [NSMutableArray array];
        _selectedButtons = [NSMutableArray array];
        [self setUI:frame];
    }
    return self;
}

- (void)setUI:(CGRect)frame
{
    [_allButtons removeAllObjects];
    CGFloat mainWidth = frame.size.width;
    CGFloat marginX = 30;
    CGFloat w = (mainWidth - marginX* 2 * _horCount) / 3;
    if(w < minW)
    {
        w = minW;
    }
    if (w*_horCount + _horCount*2*marginX > mainWidth)
    {
        marginX = (mainWidth - w*_horCount) / (_horCount * 2);
    }
    CGFloat marginY = w;
    int tag = 1;
    for (int v = 0; v < _verCount; v++) {
        for (int h = 0; h < _horCount; h++)
        {
            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(marginX *(h*2 +1) + (w * h), (v+1)*marginY + v * w, w, w)];
            btn.layer.cornerRadius = w / 2;
            [btn setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            btn.layer.masksToBounds = YES;
            btn.userInteractionEnabled = NO;
            btn.tag = tag++;
            [self addSubview:btn];
            [_allButtons addObject:btn];
        }
    }
    
    _trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
    self.backgroundColor = [UIColor clearColor];
    _lineColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if ([_selectedButtons count] > 0) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        UIButton *firstButton = [_selectedButtons objectAtIndex:0];
        [bezierPath moveToPoint:[self convertPoint:firstButton.center fromView:self]];
        
        for (int i = 1; i < [_selectedButtons count]; i++) {
            UIButton *button = [_selectedButtons objectAtIndex:i];
            [bezierPath addLineToPoint:[self convertPoint:button.center fromView:self]];
        }
        
        if (_trackedLocationInContentView.x != kTrackedLocationInvalidInContentView &&
            _trackedLocationInContentView.y != kTrackedLocationInvalidInContentView) {
            [bezierPath addLineToPoint:[self convertPoint:_trackedLocationInContentView fromView:self]];
        }
        [bezierPath setLineWidth:20];
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [_lineColor setStroke];
        [bezierPath stroke];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    UIButton* btn = nil;
    for (UIButton* _btn in _allButtons){
        if(CGRectContainsPoint(_btn.frame, point))
        {
            btn = _btn;
            break;
        }
    }
    if(btn)
    {
        btn.selected = YES;
        if(![_selectedButtons containsObject:btn])
            [_selectedButtons addObject:btn];
    }
    _trackedLocationInContentView = point;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f,%f",point.x,point.y);
    UIButton* btn = nil;
    for (UIButton* _btn in _allButtons){
        if(CGRectContainsPoint(_btn.frame, point))
        {
            btn = _btn;
            break;
        }
    }
    if(btn)
    {
        btn.selected = YES;
        if(![_selectedButtons containsObject:btn])
            [_selectedButtons addObject:btn];
    }
    _trackedLocationInContentView = point;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);

    NSMutableString* strResult = [NSMutableString string];
    if ([_selectedButtons count] > 0) {
        for(UIButton* btn in _selectedButtons)
            [strResult appendFormat:@"%d",(int)btn.tag];
    }
    if(delegate)
    {
        [delegate XBLockViewLockPassword:strResult];
    }
    for (UIButton *button in _selectedButtons) {
        button.selected = NO;
    }
    [_selectedButtons removeAllObjects];
    [self setNeedsDisplay];
}

@end
