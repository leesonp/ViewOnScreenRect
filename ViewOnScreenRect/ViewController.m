//
//  ViewController.m
//  ViewOnScreenRect
//
//  Created by leeson on 2018/10/17.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "DrawPopView.h"
#import "PopDataModel.h"

#define SCREEN_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT        [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) DrawPopView *popView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条数据",indexPath.row + 1];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.imageView.layer.cornerRadius = 25;
    cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://6c65-leeson-a5fee7-1257914072.tcb.qcloud.la/my-image1540795847000.jpg?sign=455fdd5790113542eaa0e3859ba89d3d&t=1540795956"]]];//https://6c65-leeson-a5fee7-1257914072.tcb.qcloud.la/my-image1540795837000.jpg?sign=0a2ab0728149061bc12928fd745f43f5&t=1540796647
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 40, 40);
    bt.backgroundColor = [UIColor grayColor];
    bt.tag = 181023 + indexPath.row;
    [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:bt];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)btClick:(UIButton *)bt{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= 10; i ++) {
        PopDataModel *model = [PopDataModel new];
        model.title = [NSString stringWithFormat:@"第%ld行数据",i];
        [dataArr addObject:model];
    }
    self.popView = [DrawPopView showPopVeiw:bt viewSize:CGSizeMake(100, 250) showData:dataArr valueCallBack:^(id model) {
        if ([model isKindOfClass:[NSNumber class]]) {
            NSLog(@"%@ 视图销毁",model);
        }else{
            PopDataModel *data = model;
            NSLog(@"%@",data.title);
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
