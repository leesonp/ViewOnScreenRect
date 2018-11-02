//
//  PopTableView.m
//  ViewOnScreenRect
//
//  Created by leeson on 2018/10/23.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

#import "PopTableView.h"
#import "PopDataModel.h"

@implementation PopTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"PopTableCell"];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopTableCell"];
    PopDataModel *model = self.dataArrM[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.valueCallBack) {
        self.valueCallBack(self.dataArrM[indexPath.row]);
    }
}

- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    [self reloadData];
}

@end
