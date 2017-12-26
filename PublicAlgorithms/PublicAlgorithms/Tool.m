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

@interface ToolKLine()

@property (nonatomic, assign) NSInteger type;

@end


@implementation ToolKLine

static CGFloat bounceX = 20;
static CGFloat bounceY = 20;

- (void)drawRect:(CGRect)rect{
    /*******画出坐标轴********/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextMoveToPoint(context, bounceX * 1.5, bounceY);
    CGContextAddLineToPoint(context, bounceX * 1.5, rect.size.height - bounceY);
    CGContextAddLineToPoint(context,rect.size.width -  bounceX, rect.size.height - bounceY);
    CGContextStrokePath(context);
}

#pragma mark 画折线图
- (void)dravLine:(BOOL)type withArr:(NSArray *)dataArr {
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    [path moveToPoint:CGPointMake(0, 0)];
    //创建折现点标记
    CGFloat height = self.frame.size.height - 2 * bounceY;
    CGFloat width = self.frame.size.width - 2.5 * bounceX;

    for (NSInteger i = 1; i< dataArr.count; i++) {
        NSNumber *num = dataArr[i];
        CGPoint point;
        if (self.type == 1) {
            point = CGPointMake( width * 0.1 * (i+1) + bounceX, num.floatValue * 0.002 * height);
        }else {
            point = CGPointMake( width * 0.1 * (i+1) + bounceX, num.floatValue * 0.01 * height);
        }
        [path addLineToPoint:point];
    }
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    lineChartLayer.strokeColor = [UIColor redColor].CGColor;
    lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer.lineWidth = 0;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    lineChartLayer.frame = CGRectMake(bounceX, bounceY, self.bounds.size.width - bounceX*2, self.bounds.size.height - 2*bounceY);
    [self.layer addSublayer:lineChartLayer];//直接添加导视图上
    
    lineChartLayer.lineWidth = 2;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}
#pragma mark 创建x轴的数据
- (void)createLabelX{
    CGFloat  month = 10;
    for (NSInteger i = 0; i < month; i++) {
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:
                                CGRectMake((self.frame.size.width - 2.5*bounceX)/month * (i+1) + bounceX, self.frame.size.height - bounceY + bounceY*0.3, (self.frame.size.width - 2.5*bounceX)/month- 5, bounceY/2)];
        LabelMonth.tag = 1000 + i;
        LabelMonth.text = [NSString stringWithFormat:@"%.1fs",(i+1)*0.1];
        LabelMonth.font = [UIFont systemFontOfSize:10];
        LabelMonth.transform = CGAffineTransformMakeRotation(M_PI * 0.3);
        [self addSubview:LabelMonth];
    }
    
}
#pragma mark 创建y轴数据
- (void)createLabelY{
    NSInteger Ydivision = 5;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 2 * bounceY)/Ydivision *i + bounceX, bounceY * 2, bounceY/2.0)];
        labelYdivision.tag = 2000 + i;
        if (self.type == 1) {
            labelYdivision.text = [NSString stringWithFormat:@"%ldM",(Ydivision - i) * 100];
        }else {
            labelYdivision.text = [NSString stringWithFormat:@"%%%ld",(Ydivision - i) * 20];
        }
        labelYdivision.font = [UIFont systemFontOfSize:10];
        [self addSubview:labelYdivision];
    }
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 12)];
    title.font = [UIFont systemFontOfSize:12];
    [self addSubview:title];
    if (self.type == 1) {
        title.text = @"内存使用值：";
    }else {
        title.text = @"CPU占用率：";
    }
}
//这两函数在 view的初始化方法里面调用
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//cpu 折线
+ (ToolKLine *)toolCpuKLineWithFrame:(CGRect)frame {
    ToolKLine *line = [[ToolKLine alloc] initWithFrame:frame];
    [line createLabelX];
    [line createLabelY];
    return line;
}
//内存 折线
+ (ToolKLine *)toolMemoryKLineWithFrame:(CGRect)frame {
    ToolKLine *line = [[ToolKLine alloc] initWithFrame:frame];
    line.type = 1;
    [line createLabelX];
    [line createLabelY];
    return line;
}

@end
