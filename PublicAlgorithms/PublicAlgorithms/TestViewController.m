//
//  TestViewController.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/25.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "TestViewController.h"

#import <Masonry.h>

#import "Tool.h"

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *sortArr;

@property (nonatomic, strong) UILabel *arrL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) ToolKLine *memory;
@property (nonatomic, strong) ToolKLine *cpu;

@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) NSMutableArray *cpuArr;
@property (nonatomic, strong) NSMutableArray *memoryArr;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int index = 0; index < 5000; index++) {
        NSString *num = [NSString stringWithFormat:@"%d",(arc4random()%5000)];
        [self.sortArr addObject:num];
        if (index == 4999) {
            self.sortBtn.enabled = YES;
        }
    }
    
    [self initSubLabel];
}
- (void)initSubLabel {
    switch (self.type) {
        case 0:
        case 1:
        case 2:
        case 3:{
            self.arrL.text = [NSString stringWithFormat:@"数组：(看控制台)"];
            [self.arrL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(16);
                make.right.equalTo(self.view.mas_right).offset(-16);
                make.top.equalTo(self.view.mas_top).offset(89);
            }];
            [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.arrL.mas_bottom).offset(25);
                make.size.mas_equalTo(CGSizeMake(80, 35));
            }];
        }
            break;
        case 4:
            [self Sort];
            break;
        case 5:
            [self Sort];
            break;
        case 6:
            [self Sort];
            break;
        case 7:
            [self Sort];
            break;
        case 8:
            [self Sort];
            break;
        case 9:
            [self Sort];
            break;
        case 10:
            [self Sort];
            break;
            
        default:
            break;
    }
}
- (void)startAlgorithm {
    self.sortBtn.enabled = NO;
    switch (self.type) {
        case 0:
        case 1:
        case 2:
        case 3:
            [self Sort];
            break;
        case 4:
            [self Sort];
            break;
        case 5:
            [self Sort];
            break;
        case 6:
            [self Sort];
            break;
        case 7:
            [self Sort];
            break;
        case 8:
            [self Sort];
            break;
        case 9:
            [self Sort];
            break;
        case 10:
            [self Sort];
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark   ==============算法调用==============
- (void)Sort{
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    __block NSMutableArray *arr = self.sortArr.mutableCopy;
    NSLog(@"未排序数组：\n%@",[arr componentsJoinedByString:@","]);
    double time = [Tool functionTime:^{
        if (self.type == 0) {
            [self bubbleSort:arr];
        }else if (self.type == 1) {
            [self selectSort:arr];
        }else if (self.type == 2) {
            [self quickSortArray:arr withLeftIndex:0 andRightIndex:arr.count - 1];
        }else if (self.type == 3) {
            arr = [self mergeSort:arr];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr];
        [self.cpu dravLineWithArr:self.cpuArr];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        NSLog(@"排序完成数组：\n%@",[arr componentsJoinedByString:@","]);
    });
}
#pragma mark -
#pragma mark   ==============算法==============
- (void)bubbleSort:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count - 1; i++) {
        for (int j = 0; j < arr.count - 1 - i; j++) {
            if ([arr[j] intValue] > [arr[j+1] intValue]) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}
- (void)selectSort:(NSMutableArray *)arr {
    int i, j, index;
    for(i = 0; i < arr.count - 1; i++) {
        index = i;
        for(j = i + 1; j < arr.count; j++) {
            if([arr[index] intValue] > [arr[j] intValue]) {
                index = j;
            }
        }
        if(index != i) {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:index];
        }
    }
}
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) {
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    NSInteger key = [array[i] integerValue];
    while (i < j) {
        while (i < j && [array[j] integerValue] >= key) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [array[i] integerValue] <= key) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = [NSString stringWithFormat:@"%ld",key];
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i - 1];
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}
- (NSMutableArray *)mergeSort:(NSMutableArray *)arr{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *number in arr) {
        NSMutableArray *childArray = [NSMutableArray array];
        [childArray addObject:number];
        [tempArray addObject:childArray];
    }
    while (tempArray.count != 1) {
        NSUInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArray:tempArray[i] secondArray:tempArray[i+1]];
            [tempArray removeObjectAtIndex:i+1];
            i += 1;
        }
    }
    return tempArray;
}
- (NSMutableArray *)mergeArray:(NSArray *)firstArray secondArray:(NSArray *)secondArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger firstIndex = 0;
    NSUInteger secondIndex = 0;
    while (firstIndex < firstArray.count && secondIndex < secondArray.count) {
        if ([firstArray[firstIndex] integerValue] < [secondArray[secondIndex] integerValue]) {
            [resultArray addObject:firstArray[firstIndex]];
            firstIndex += 1;
        }else {
            [resultArray addObject:secondArray[secondIndex]];
            secondIndex += 1;
        }
    }
    while (firstIndex < firstArray.count) {
        [resultArray addObject:firstArray[firstIndex]];
        firstIndex += 1;
    }
    while (secondIndex < secondArray.count) {
        [resultArray addObject:secondArray[secondIndex]];
        secondIndex += 1;
    }
    return resultArray;
}
- (void)binarySearch {
    
}
- (void)linkedListInversion {
    
}
- (void)reverseOrderOutputOfString {
    
}
- (void)findPositionOfOnlyOnceAndMostImportantCharacterString {
    
}
- (void)binaryTree {
    
}
- (void)printPrimeNumber {
    
}
- (void)findGreatestCommonDivisorOfTwoIntegers {
    
}
#pragma mark -
#pragma mark   ==============记录cpu+memory==============
- (void)startRecord {
    NSString *cpu = [NSString stringWithFormat:@"%f",[Tool cpuUsage]];
    NSString *memory = [NSString stringWithFormat:@"%lu",[Tool memoryUsage]];
    [self.cpuArr addObject:cpu];
    [self.memoryArr addObject:memory];
}
#pragma mark -
#pragma mark   ==============定时器==============
- (void)startOrEndAnimation:(BOOL)startOrEnd {
    if (startOrEnd) {
        if (self.timer) {
            return;
        }else {
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            
            dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
            
            dispatch_source_set_event_handler(self.timer, ^{
                [self startRecord];
            });
            
            dispatch_resume(self.timer);
        }
    }else {
        if (self.timer) {
            dispatch_cancel(self.timer);
            self.timer = nil;
            [self startRecord];
        }
    }
}
#pragma mark -
#pragma mark   ==============lazy==============
- (NSMutableArray *)sortArr {
    if (!_sortArr) {
        _sortArr = [NSMutableArray array];
    }
    return _sortArr;
}
- (NSMutableArray *)memoryArr {
    if (!_memoryArr) {
        _memoryArr = [NSMutableArray array];
    }
    return _memoryArr;
}
- (NSMutableArray *)cpuArr {
    if (!_cpuArr) {
        _cpuArr = [NSMutableArray array];
    }
    return _cpuArr;
}
- (UILabel *)arrL {
    if (!_arrL) {
        _arrL = [[UILabel alloc] init];
        _arrL.font = [UIFont systemFontOfSize:15];
        _arrL.numberOfLines = 0;
        [self.view addSubview:_arrL];
    }
    return _arrL;
}
- (UILabel *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:15];
        _timeL.numberOfLines = 0;
        [self.view addSubview:_timeL];
    }
    return _timeL;
}
- (UIButton *)sortBtn {
    if (!_sortBtn) {
        _sortBtn = [[UIButton alloc] init];
        [_sortBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_sortBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        _sortBtn.backgroundColor = [UIColor cyanColor];
        [_sortBtn addTarget:self action:@selector(startAlgorithm) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sortBtn];
        _sortBtn.enabled = NO;
    }
    return _sortBtn;
}
- (ToolKLine *)memory {
    if (!_memory) {
        _memory = [ToolKLine toolMemoryKLineWithFrame:CGRectMake(0, 0, (kWidth - 32) * 5, 150)];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 32, 150)];
        scroll.contentSize = CGSizeMake((kWidth - 32) * 5, 0);
        [scroll addSubview:_memory];
        [_memory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(scroll);
            make.size.mas_equalTo(CGSizeMake((kWidth - 32) * 5, 150));
        }];
        [self.view addSubview:scroll];
    }
    return _memory;
}
- (ToolKLine *)cpu {
    if (!_cpu) {
        _cpu = [ToolKLine toolCpuKLineWithFrame:CGRectMake(0, 0, (kWidth - 32) * 5, 150)];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 32, 150)];
        scroll.contentSize = CGSizeMake((kWidth - 32) * 5, 0);
        [scroll addSubview:_cpu];
        [_cpu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(scroll);
            make.size.mas_equalTo(CGSizeMake((kWidth - 32) * 5, 150));
        }];
        [self.view addSubview:scroll];
    }
    return _cpu;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
