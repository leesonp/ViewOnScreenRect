//
//  PopTableView.h
//  ViewOnScreenRect
//
//  Created by leeson on 2018/10/23.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ValueBlock)(id model);

@interface PopTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArrM;

@property (nonatomic,copy) ValueBlock valueCallBack;

@end
