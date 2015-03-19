//
//  XBLockView.h
//  XBLockView
//
//  Created by Peter on 15/3/19.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBLockViewDelegate <NSObject>
- (void)XBLockViewLockPassword:(NSString*)password;
@end

@interface XBLockView : UIView
@property(nonatomic,weak)id<XBLockViewDelegate> delegate;
- (id)initWithSize:(CGRect)frame hor:(int)hor ver:(int)ver;
@end
