//
//  main.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/22.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


void sort(int *a, int left, int right) {
    if(left >= right) {
        return ;
    }
    int i = left;
    int j = right;
    int key = a[left];
    while (i < j) {
        while (i < j && key >= a[j]) {
            j--;
        }
        a[i] = a[j];
        while (i < j && key <= a[i]) {
            i++;
        }
        a[j] = a[i];
    }
    a[i] = key;
    sort(a, left, i-1);
    sort(a, i+1, right);
}
