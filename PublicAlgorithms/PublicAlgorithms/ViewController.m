//
//  ViewController.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/22.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *algorithmNameArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.tableView setTableFooterView:[UIView new]];
}

- (NSArray *)algorithmNameArr {
    if (!_algorithmNameArr) {
        _algorithmNameArr = @[@"冒泡排序",
                              @"选择排序",
                              @"快速排序",
                              @"归并排序",
                              @"二分查找",
                              @"链表逆序",
                              @"字符串的逆序输出",
                              @"查找字符串中只出现一次且最靠前的字符的位置",
                              @"二叉树",
                              @"打印2-100之间的素数",
                              @"求两个整数的最大公约数"];
    }
    return _algorithmNameArr;
}
#pragma mark -
#pragma mark   ==============UITableViewDataSource==============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.algorithmNameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row < self.algorithmNameArr.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.algorithmNameArr[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return cell;
}
#pragma mark -
#pragma mark   ==============UITableViewDelegate==============
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.algorithmNameArr.count) {
        TestViewController *vc = [[TestViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@",self.algorithmNameArr[indexPath.row]];
        vc.type = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
