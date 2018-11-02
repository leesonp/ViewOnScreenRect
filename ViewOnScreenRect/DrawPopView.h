//
//  DrawPopView.h
//  ViewOnScreenRect
//
//  Created by leeson on 2018/10/17.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ValueBlock)(id model);

@interface DrawPopView : UIView

@property (nonatomic,copy) ValueBlock valueCallBack;

///参数说明：dealView：操作视图   size：popView的尺寸  valueCallBack：回调值
+ (DrawPopView *)showPopVeiw:(UIView *)dealView viewSize:(CGSize)size showData:(NSMutableArray *)dataArrM valueCallBack:(ValueBlock)valueCallBack;

/** 找到某点的对称点  参数说明：point：当前点;  isParallel_x：YES 对称轴为平行X的轴，NO为平行Y的轴;  offset：相对X轴或者Y轴的偏移量，可为正负,它们的平行线可看做对称轴.（列：isParallel_x为YES时相当于垂直于Y轴，从X轴出发在Y轴上下平移量为offset的直线）*/
+ (CGPoint)findSymmetricPoint:(CGPoint)point isParallel_x:(BOOL)isParallel_x offSet:(CGFloat)offSet;

@property (nonatomic, strong) NSMutableArray *dataArrM;

@end
