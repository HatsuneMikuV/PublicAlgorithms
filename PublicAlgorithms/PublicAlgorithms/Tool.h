//
//  Tool.h
//  PublicAlgorithms
//
//  Created by angle on 2017/12/25.
//  Copyright © 2017年 angle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
//内存使用值
+ (unsigned long)memoryUsage;
//cpu使用率
+ (float)cpuUsage;
//方法耗时
+ (double)functionTime:(void(^)(void))functionBlock;
@end
