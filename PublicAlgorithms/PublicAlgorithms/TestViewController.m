//
//  TestViewController.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/25.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "TestViewController.h"

#import <Masonry.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self startAlgorithm];
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
