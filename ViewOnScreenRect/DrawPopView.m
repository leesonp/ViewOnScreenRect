//
//  DrawPopView.m
//  ViewOnScreenRect
//
//  Created by leeson on 2018/10/17.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

#import "DrawPopView.h"
#import "PopTableView.h"
#import "PopDataModel.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface DrawPopView ()

///传入视图相对window的位置
@property (nonatomic) CGRect rect;
///弹框是否位于点击视图下方
@property (nonatomic,assign) BOOL isBelow;
///遮罩层
@property (nonatomic, strong) UIButton *bgView;

@property (nonatomic, strong) PopTableView *tableView;

@end

@implementation DrawPopView

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setIsBelow:(BOOL)isBelow{
    _isBelow = isBelow;
}

///参数说明：dealView：操作视图   size：popView的尺寸  valueCallBack：回调值
+ (DrawPopView *)showPopVeiw:(UIView *)dealView viewSize:(CGSize)size showData:(NSMutableArray *)dataArrM valueCallBack:(ValueBlock)valueCallBack{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self getViewRect:dealView];
    //origin.x
    CGFloat v_x = 10;
    if (dealView.center.x - size.width / 2.0 >= 10) {
        v_x = dealView.center.x - size.width / 2.0;
    }
    if (dealView.center.x + size.width / 2.0 >= SCREEN_WIDTH) {
        v_x = SCREEN_WIDTH - size.width - 10;
    }
    
    //间距
    CGFloat offset = 2;
    //origin.y
    CGFloat v_y = CGRectGetMaxY(rect) + offset;
    BOOL isBelow = [self calculateViewlocation:rect viewSize:size];
    if (isBelow == NO) {
        v_y = rect.origin.y - size.height - offset;
        if (v_y < 0) {
            v_y = offset;
        }
    }else{
        if (SCREEN_HEIGHT - (CGRectGetMaxY(rect) + offset) < size.height) {
            v_y = SCREEN_HEIGHT - (size.height + offset);
        }
    }
    
    //透明遮罩层
    UIButton *bgView =  [UIButton buttonWithType:UIButtonTypeCustom];
    bgView.frame = window.bounds;
    bgView.tag = 18101900;
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
    [bgView addTarget:self action:@selector(dismissDrawPopView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:bgView];
    
    //本类弹框视图
    DrawPopView *popView = [[DrawPopView alloc] initWithFrame:CGRectMake(v_x, v_y, size.width, size.height)];
    popView.rect = rect;
    popView.isBelow = isBelow;
    popView.tag = 18101901;
    popView.valueCallBack = valueCallBack;
    [popView addSubview:popView.tableView];
    [window addSubview:popView];
    popView.dataArrM = dataArrM;
    return popView;
}

//接收数据
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    _tableView.dataArrM = _dataArrM;
}

//懒加载tableView
- (PopTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PopTableView alloc] initWithFrame:CGRectMake(0, self.isBelow?10:0, self.bounds.size.width, self.bounds.size.height -10)];
        [_tableView setValueCallBack:^(id model) {
            [DrawPopView hidViews:model];
        }];
    }
    return _tableView;
}

//点击遮罩层销毁视图
+ (void)dismissDrawPopView{
    [DrawPopView hidViews:@0];
}

///隐藏(销毁)视图
+ (void)hidViews:(id)value{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *bgView = (UIButton *)[window viewWithTag:18101900];
    [bgView removeFromSuperview];
    DrawPopView *popView = (DrawPopView *)[window viewWithTag:18101901];
    if (popView.valueCallBack) {
        popView.valueCallBack(value);
    }
    [popView removeFromSuperview];
}

//返回YES弹框popView在点击视图的下方  NO在上方
+ (BOOL)calculateViewlocation:(CGRect)rect viewSize:(CGSize)size{
    if (CGRectGetMaxY(rect) + size.height >= SCREEN_HEIGHT) {
        if (SCREEN_HEIGHT - CGRectGetMaxY(rect) > rect.origin.y) {
            return YES;
        }
        return NO;
    }else{
        if (SCREEN_HEIGHT - CGRectGetMaxY(rect) < rect.origin.y) {
            return NO;
        }
    }
    return YES;
}

//获取视图在window中的位置
+ (CGRect)getViewRect:(UIView *)view{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect=[view convertRect:view.bounds toView:window];
    return rect;
}

///选中视图相对popview的位置x
- (CGFloat)viewCenter_x{
    CGFloat point = self.rect.origin.x + self.rect.size.width / 2.0 - self.frame.origin.x;
    return point;
}

///绘制视图
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置路径颜色
    //CGContextSetRGBStrokeColor(context, 1.0, 0.5, 0.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    
    CGFloat startP = [self viewCenter_x] < 15?15:[self viewCenter_x];
    if ([self viewCenter_x] > self.frame.size.width - 15) {
        startP = self.frame.size.width - 15;
    }
    
    //弹框绘制在下面
    if (self.isBelow) {
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, startP, 0);
        //设置下一个坐标点 三角右
        CGContextAddLineToPoint(context, startP + 10, 10);
        
        //绘制右上角圆弧（起始圆弧）
        NSDictionary *rt = @{@"startPoint":@(CGPointMake(rect.size.width -5, 10)), @"endPoint":@(CGPointMake(rect.size.width, 15)), @"centerPoint":@(CGPointMake(rect.size.width - 5, 15)), @"startPi":@(1.5), @"endPi":@(0)};
        NSArray *ltArr = [self drawArc:context pointDic:rt clockwise:1];
        
        //绘制右下角倒角
        NSDictionary *rb = @{@"startPoint":ltArr[0], @"endPoint":ltArr[1], @"centerPoint":ltArr[2], @"startPi":@(0), @"endPi":@(0.5)};
        NSArray *rbArr = [self drawParallelArc:context pointDic:rb clockwise:1 isParallel_x:YES offSet:(rect.size.height - 10) / 2.0 + 10];
        
        //绘制左下角倒角
        NSDictionary *lb = @{@"startPoint":rbArr[0], @"endPoint":rbArr[1], @"centerPoint":rbArr[2], @"startPi":@(0.5), @"endPi":@(1.0)};
        NSArray *lbArr = [self drawParallelArc:context pointDic:lb clockwise:1 isParallel_x:NO offSet:rect.size.width/2.0];
        
        //绘制左上角圆弧
        NSDictionary *lt = @{@"startPoint":lbArr[0], @"endPoint":lbArr[1], @"centerPoint":lbArr[2], @"startPi":@(1.0), @"endPi":@(1.5)};
        [self drawParallelArc:context pointDic:lt clockwise:1 isParallel_x:YES offSet:(rect.size.height - 10) / 2 + 10];
        
        //设置下一个坐标点 三角左
        CGContextAddLineToPoint(context, startP - 10, 10);
        //设置下一个坐标点 三角顶点
        CGContextAddLineToPoint(context, startP, 0);
    }else{
        //三角顶点
        CGContextMoveToPoint(context, startP, rect.size.height);
        //三角右侧
        CGContextAddLineToPoint(context, startP + 10, rect.size.height - 10);

        //绘制右下角圆弧（起始圆弧）
        NSDictionary *rb = @{@"startPoint":@(CGPointMake(rect.size.width -5, rect.size.height - 10)), @"endPoint":@(CGPointMake(rect.size.width, rect.size.height - 15)), @"centerPoint":@(CGPointMake(rect.size.width - 5, rect.size.height - 15)), @"startPi":@(0.5), @"endPi":@(0)};
        NSArray *rbArr = [self drawArc:context pointDic:rb clockwise:0];

        //绘制右上角圆弧倒角
        NSDictionary *rt = @{@"startPoint":rbArr[0], @"endPoint":rbArr[1], @"centerPoint":rbArr[2], @"startPi":@(0), @"endPi":@(1.5)};
        NSArray *rtArr = [self drawParallelArc:context pointDic:rt clockwise:0 isParallel_x:YES offSet:(rect.size.height - 10) / 2.0];

        //绘制左上角
        NSDictionary *lt = @{@"startPoint":rtArr[0], @"endPoint":rtArr[1], @"centerPoint":rtArr[2], @"startPi":@(1.5), @"endPi":@(1.0)};
        NSArray *ltArr = [self drawParallelArc:context pointDic:lt clockwise:0 isParallel_x:NO offSet:rect.size.width / 2.0];

        //绘制左下角圆弧
        NSDictionary *lb = @{@"startPoint":ltArr[0], @"endPoint":ltArr[1], @"centerPoint":ltArr[2], @"startPi":@(1.0), @"endPi":@(0.5)};
        [self drawParallelArc:context pointDic:lb clockwise:0 isParallel_x:YES offSet:(rect.size.height - 10) / 2.0];
        
        //三角左侧
        CGContextAddLineToPoint(context, startP - 10, rect.size.height - 10);
        //三角顶点
        CGContextAddLineToPoint(context, startP, rect.size.height);
    }
    
    //填充 颜色值 相当于{r/255.0, g/255.0, b/255.0, 1.0}
    CGFloat myFillColor[] = {1.0, 1.0, 1.0, 1.0};
    CGContextSetFillColor(context, myFillColor);
    CGContextFillPath(context);
    
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

///绘制圆弧倒角
- (NSArray *)drawArc:(CGContextRef)context pointDic:(NSDictionary *)pointDic clockwise:(int)clockwise{
    //设置圆弧的起点、终点
    CGPoint fp = [pointDic[@"startPoint"] CGPointValue];
    CGPoint sp = [pointDic[@"endPoint"] CGPointValue];
    CGContextAddLineToPoint(context, fp.x, fp.y);
    CGContextAddLineToPoint(context, sp.x, sp.y);
    //设置圆心
    CGPoint centerPoint = [pointDic[@"centerPoint"] CGPointValue];
    // 设置半径
    CGFloat radius = 5;
    // 设置起始角度
    CGFloat startAngle = [pointDic[@"endPi"] floatValue] * M_PI;
    // 设置结束角度
    CGFloat endAngle = [pointDic[@"endPi"] floatValue] * M_PI;
    // 绘制弧线
    // 第1个参数：上下文
    // 第2个参数：圆心.x
    // 第3个参数：圆心.y
    // 第4个参数：半径
    // 第5个参数：起始角度
    // 第6个参数：结束角度
    // 第7个参数：旋转方向 1为顺时针， 0为逆时针
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockwise);
    return @[@(fp),@(sp),@(centerPoint)];
}

/*
     找镜像点：
     |                |
     |                |  isParallel_x = NO
     |                |
     |         length | length = point.x - offSet
     |        |<----->|<----->|
     |                |       |
-----------------------------------> x
     | 0              |       |
     |                |       |
     |        .       |       . point
     |          ?     |
     |                |
     |<----offSet---->|
     ↓ y
 */
/** 找到某点的对称点  参数说明：point：当前点;  isParallel_x：YES 对称轴为平行X的轴，NO为平行Y的轴;  offset：相对X轴或者Y轴的偏移量，可为正负,它们的平行线可看做对称轴.（列：isParallel_x为YES时相当于垂直于Y轴，从X轴出发在Y轴上下平移量为offset的直线）*/
+ (CGPoint)findSymmetricPoint:(CGPoint)point isParallel_x:(BOOL)isParallel_x offSet:(CGFloat)offSet {
    CGFloat length = 0;
    length = (isParallel_x?point.y:point.x) - offSet;
    return isParallel_x?CGPointMake(point.x, offSet - length):CGPointMake(offSet - length, point.y);
}

///传入始、终、圆心点画对称圆弧倒角  pointDic = @{"startPoint":(CGPoint)startPoint "endPoint":(CGPoint)endPoint "centerPoint":(CGPoint)centerPoint}
- (NSArray *)drawParallelArc:(CGContextRef)context pointDic:(NSDictionary *)pointDic clockwise:(int)clockwise isParallel_x:(BOOL)isParallel_x offSet:(CGFloat)offSet{
    CGPoint starPoint = [DrawPopView findSymmetricPoint:[pointDic[@"startPoint"] CGPointValue] isParallel_x:isParallel_x offSet:offSet];
    CGPoint endPoint = [DrawPopView findSymmetricPoint:[pointDic[@"endPoint"] CGPointValue] isParallel_x:isParallel_x offSet:offSet];
    CGPoint centerPoint = [DrawPopView findSymmetricPoint:[pointDic[@"centerPoint"] CGPointValue] isParallel_x:isParallel_x offSet:offSet];
    CGContextAddLineToPoint(context, starPoint.x, starPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGFloat radius = 5;
    CGFloat startAngle = [pointDic[@"startPi"] floatValue] * M_PI;
    CGFloat endAngle = [pointDic[@"endPi"] floatValue] * M_PI;
    // 绘制弧线
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockwise);
    
    return @[@(starPoint),@(endPoint),@(centerPoint)];
}


@end
