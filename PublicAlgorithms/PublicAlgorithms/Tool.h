//
//  Tool.h
//  PublicAlgorithms
//
//  Created by angle on 2017/12/25.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


#define kWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeight ([UIScreen mainScreen].bounds.size.height)


@interface Tool : NSObject
//内存使用值
+ (unsigned long)memoryUsage;
//cpu使用率
+ (float)cpuUsage;
//方法耗时
+ (double)functionTime:(void(^)(void))functionBlock;
@end

@interface ToolKLine : UIView
//cpu 折线
+ (ToolKLine *)toolCpuKLineWithFrame:(CGRect)frame;
//内存 折线
+ (ToolKLine *)toolMemoryKLineWithFrame:(CGRect)frame;
//绘制折线
- (void)dravLineWithArr:(NSArray *)dataArr withColor:(UIColor *)color;

@end
