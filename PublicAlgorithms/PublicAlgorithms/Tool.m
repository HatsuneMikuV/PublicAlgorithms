//
//  Tool.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/25.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "Tool.h"

#include <mach/task_info.h>
#include <mach/mach.h>

@implementation Tool

#pragma mark -
#pragma mark   ==============内存使用值==============
+ (unsigned long)memoryUsage {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    unsigned long memorySize = info.resident_size >> 10;
    
    return memorySize;
}
#pragma mark -
#pragma mark   ==============CPU占用率==============
+ (float)cpuUsage {
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kern_return_t kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    float tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    //free mem
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}
#pragma mark -
#pragma mark   ==============方法耗时==============
+ (double)functionTime:(void(^)(void))functionBlock {
    NSDate* Start = [NSDate date];
    //上面这段代码放是放在从哪里开始计时
    if (functionBlock) {
        functionBlock();
    }
    double deltaTime = [[NSDate date] timeIntervalSinceDate:Start];
//    NSLog(@"＊＊＊＊＊＊cost time = %f", deltaTime);
    return deltaTime;
}

@end
