//
//  ViewController.m
//  PublicAlgorithms
//
//  Created by angle on 2017/12/22.
//  Copyright © 2017年 angle. All rights reserved.
//

#import "ViewController.h"

#include <mach/task_info.h>
#include <mach/mach.h>


@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
    NSInteger _count;
}

@property (nonatomic, strong) NSArray *algorithmNameArr;

#pragma mark -
#pragma mark   ==============数组==============
@property (weak, nonatomic) IBOutlet UITextField *oneText;
@property (weak, nonatomic) IBOutlet UITextField *twoText;
@property (weak, nonatomic) IBOutlet UITextField *thiText;
@property (weak, nonatomic) IBOutlet UITextField *fouText;
@property (weak, nonatomic) IBOutlet UITextField *fivText;
@property (weak, nonatomic) IBOutlet UITextField *sixText;
@property (weak, nonatomic) IBOutlet UITextField *sevText;
@property (weak, nonatomic) IBOutlet UITextField *eigText;
@property (weak, nonatomic) IBOutlet UITextField *ninText;
#pragma mark -
#pragma mark   ==============显示==============
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *thiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fouLabel;
@property (weak, nonatomic) IBOutlet UILabel *fivLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


#pragma mark -
#pragma mark   ==============UIPickerViewDelegate==============
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (row < self.algorithmNameArr.count) {
        
    }
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (row < self.algorithmNameArr.count) {
        return self.algorithmNameArr[row];
    }
    return nil;
}
#pragma mark -
#pragma mark   ==============UIPickerViewDataSource==============
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.algorithmNameArr.count;
}

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
+ (CGFloat)cpuUsage {
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
    
    CGFloat tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (CGFloat)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    //free mem
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}
#pragma mark -
#pragma mark   ==============页面的帧率==============
- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
}
#pragma mark -
#pragma mark   ==============算法==============
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
