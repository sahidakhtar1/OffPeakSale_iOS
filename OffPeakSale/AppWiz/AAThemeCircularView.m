//
//  AAThemeCircularView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/30/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAThemeCircularView.h"

@implementation AAThemeCircularView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initView];
    }
    
    return self;
}
-(void)initView
{
//    [self.layer setCornerRadius:self.frame.size.height];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
}
@end
