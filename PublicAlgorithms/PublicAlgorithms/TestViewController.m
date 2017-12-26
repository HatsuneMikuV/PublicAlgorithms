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

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubLabel];
    
}
- (void)initSubLabel {
    switch (self.type) {
        case 0:
        case 1:
        case 2:
        case 3:{
            
        }
            break;
        case 4:
            [self bubbleSort];
            break;
        case 5:
            [self bubbleSort];
            break;
        case 6:
            [self bubbleSort];
            break;
        case 7:
            [self bubbleSort];
            break;
        case 8:
            [self bubbleSort];
            break;
        case 9:
            [self bubbleSort];
            break;
        case 10:
            [self bubbleSort];
            break;
            
        default:
            break;
    }
    
    
}

- (void)startAlgorithm {
    switch (self.type) {
        case 0:
            [self bubbleSort];
            break;
        case 1:
            [self bubbleSort];
            break;
        case 2:
            [self bubbleSort];
            break;
        case 3:
            [self bubbleSort];
            break;
        case 4:
            [self bubbleSort];
            break;
        case 5:
            [self bubbleSort];
            break;
        case 6:
            [self bubbleSort];
            break;
        case 7:
            [self bubbleSort];
            break;
        case 8:
            [self bubbleSort];
            break;
        case 9:
            [self bubbleSort];
            break;
        case 10:
            [self bubbleSort];
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark   ==============算法==============
- (void)bubbleSort {
    
}
- (void)selectSort {
    
}
- (void)quickSort {
    
}
- (void)mergeSort {
    
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
#pragma mark   ==============lazy==============

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
