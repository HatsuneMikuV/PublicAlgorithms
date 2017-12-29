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
    unsigned long memorySize = info.resident_size >> 10 >> 10;
    
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
- (void)dravLineWithArr:(NSArray *)dataArr  withColor:(UIColor *)color{
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    //创建折现点标记
    CGFloat height = self.frame.size.height - 2 * bounceY;
    CGFloat width = self.frame.size.width - 2.5 * bounceX;

    [path moveToPoint:CGPointMake(bounceX * 0.5, height)];
    for (NSInteger i = 1; i< dataArr.count; i++) {
        NSString *num = dataArr[i];
        CGPoint point;
        if (self.type == 1) {
            point = CGPointMake( width * 0.02 * (i+1) + 1.5 * bounceX, (1 - num.floatValue * 0.01) * height);
        }else {
            point = CGPointMake( width * 0.02 * (i+1) + 1.5 * bounceX, (1 - num.floatValue * 0.01) * height);
        }
        [path addLineToPoint:point];
    }
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    color = color ? color:[UIColor greenColor];
    lineChartLayer.strokeColor = color.CGColor;
    lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer.lineWidth = 0;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    lineChartLayer.frame = CGRectMake(bounceX, bounceY, self.bounds.size.width - bounceX*2, self.bounds.size.height - 2*bounceY);
    [self.layer addSublayer:lineChartLayer];//直接添加导视图上
    
    lineChartLayer.lineWidth = 1.f;
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
    CGFloat  month = 50;
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
            labelYdivision.text = [NSString stringWithFormat:@"%ldM",(Ydivision - i) * 20];
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


@implementation BinaryTreeNode

+ (void)printBinaryTree:(BinaryTreeNode *)node withString:(NSMutableString *)printfString {
    if (node) {
        [printfString appendString:[NSString stringWithFormat:@"%ld",node.value]];
        if (node.leftNode || node.rightNode) {
            [printfString appendString:@"("];
            [BinaryTreeNode printBinaryTree:node.leftNode withString:printfString];
            if (node.rightNode) {
                [printfString appendString:@","];
            }
            [BinaryTreeNode printBinaryTree:node.rightNode withString:printfString];
            [printfString appendString:@")"];
        }
    }
}
- (NSString *)printfBinaryTree {
    NSMutableString *printfString = [NSMutableString stringWithFormat:@"二叉树结构：\n"];
    [BinaryTreeNode printBinaryTree:self withString:printfString];
    return [NSString stringWithFormat:@"%@",printfString];
}
/**
 *  创建二叉排序树
 *  二叉排序树：左节点值全部小于根节点值，右节点值全部大于根节点值
 *
 *  @param values 数组
 *
 *  @return 二叉树根节点
 */
+ (BinaryTreeNode *)createTreeWithValues:(NSArray *)values {
    BinaryTreeNode *root = nil;
    for (NSInteger i=0; i<values.count; i++) {
        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
        root = [BinaryTreeNode addTreeNode:root value:value];
    }
    return root;
}

/**
 *  向二叉排序树节点添加一个节点
 *
 *  @param treeNode 根节点
 *  @param value    值
 *
 *  @return 根节点
 */
+ (BinaryTreeNode *)addTreeNode:(BinaryTreeNode *)treeNode value:(NSInteger)value {
    //根节点不存在，创建节点
    if (!treeNode) {
        treeNode = [BinaryTreeNode new];
        treeNode.value = value;
//        NSLog(@"node:%@", @(value));
    }
    else if (value <= treeNode.value) {
//        NSLog(@"to left");
        //值小于根节点，则插入到左子树
        treeNode.leftNode = [BinaryTreeNode addTreeNode:treeNode.leftNode value:value];
    }
    else {
//        NSLog(@"to right");
        //值大于根节点，则插入到右子树
        treeNode.rightNode = [BinaryTreeNode addTreeNode:treeNode.rightNode value:value];
    }
    return treeNode;
}
/**
 * 翻转二叉树（又叫：二叉树的镜像）
 *
 * @param rootNode 根节点
 *
 * @return 翻转后的树根节点（其实就是原二叉树的根节点）
 */
+ (BinaryTreeNode *)invertBinaryTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return nil;
    }
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return rootNode;
    }
    [BinaryTreeNode invertBinaryTree:rootNode.leftNode];
    [BinaryTreeNode invertBinaryTree:rootNode.rightNode];
    BinaryTreeNode *tempNode = rootNode.leftNode;
    rootNode.leftNode = rootNode.rightNode;
    rootNode.rightNode = tempNode;
    return rootNode;
}

/**
 *    非递归方式翻转
 */
+ (BinaryTreeNode *)invertBinaryTreeNot:(BinaryTreeNode *)rootNode {
    if (!rootNode) {  return nil; }
    if (!rootNode.leftNode && !rootNode.rightNode) {  return rootNode; }
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    while (queueArray.count > 0) {
        BinaryTreeNode *node = [queueArray firstObject];
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
        
        BinaryTreeNode *pLeft = node.leftNode;
        node.leftNode = node.rightNode;
        node.rightNode = pLeft;
        
        if (node.leftNode) {
            [queueArray addObject:node.leftNode];
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode];
        }
        
    }
    
    return rootNode;
}

/**
 *  二叉树中某个位置的节点（按层次遍历）
 *
 *  @param index    按层次遍历树时的位置(从0开始算)
 *  @param rootNode 树根节点
 *
 *  @return 节点
 */
+ (BinaryTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(BinaryTreeNode *)rootNode {
    //按层次遍历
    if (!rootNode || index < 0) {
        return nil;
    }
    //数组当成队列
    NSMutableArray *queueArray = [NSMutableArray array];
    //压入根节点
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        BinaryTreeNode *node = [queueArray firstObject];
        if (index == 0) {
            return node;
        }
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
        //移除节点，index减少
        index--;
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
        
    }
    //层次遍历完，仍然没有找到位置，返回nil
    return nil;
}

/**
 *  先序遍历：先访问根，再遍历左子树，再遍历右子树。典型的递归思想。
 *
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)preOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler {
    if (rootNode) {
        
        if (handler) {
            handler(rootNode);
        }
        
        [BinaryTreeNode preOrderTraverseTree:rootNode.leftNode handler:handler];
        [BinaryTreeNode preOrderTraverseTree:rootNode.rightNode handler:handler];
    }
}

/**
 *  中序遍历
 *  先遍历左子树，再访问根，再遍历右子树
 *
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)inOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)  (BinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [BinaryTreeNode inOrderTraverseTree:rootNode.leftNode handler:handler];
        
        if (handler) {
            handler(rootNode);
        }
        
        [BinaryTreeNode  inOrderTraverseTree:rootNode.rightNode handler:handler];
    }
}

/**
 *  后序遍历
 *  先遍历左子树，再遍历右子树，再访问根
 *
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)postOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [BinaryTreeNode postOrderTraverseTree:rootNode.leftNode handler:handler];
        [BinaryTreeNode postOrderTraverseTree:rootNode.rightNode handler:handler];
        if (handler) {
            handler(rootNode);
        }
    }
}


/**
 *  层次遍历（广度优先）
 *
 *  @param rootNode 二叉树根节点
 *  @param handler  访问节点处理函数
 */
+ (void)levelTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler {
    if (!rootNode) {
        return;
    }
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    while (queueArray.count > 0) {
        BinaryTreeNode *node = [queueArray firstObject];
        if (handler) {
            handler(node);
        }
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先 出原则
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
    }
}

/**
 *  二叉树的深度
 *
 *  @param rootNode 二叉树根节点
 *
 *  @return 二叉树的深度
 */
+ (NSInteger)depthOfTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return 1;
    }
    
    //左子树深度
    NSInteger leftDepth = [BinaryTreeNode depthOfTree:rootNode.leftNode];
    //右子树深度
    NSInteger rightDepth = [BinaryTreeNode depthOfTree:rootNode.rightNode];
    
    return MAX(leftDepth, rightDepth) + 1;
}

/**
 *  二叉树的宽度
 *
 *  @param rootNode 二叉树根节点
 *
 *  @return 二叉树宽度
 */
+ (NSInteger)widthOfTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    NSInteger maxWidth = 1; //最大的宽度，初始化为1（因为已经有根节点）
    NSInteger curWidth = 0; //当前层的宽度
    
    while (queueArray.count > 0) {
        
        curWidth = queueArray.count;
        //依次弹出当前层的节点
        for (NSInteger i=0; i<curWidth; i++) {
            BinaryTreeNode *node = [queueArray firstObject];
            [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
            //压入子节点
            if (node.leftNode) {
                [queueArray addObject:node.leftNode];
            }
            if (node.rightNode) {
                [queueArray addObject:node.rightNode];
            }
        }
        //宽度 = 当前层节点数
        maxWidth = MAX(maxWidth, queueArray.count);
    }
    
    return maxWidth;
}

/**
 *  二叉树的所有节点数
 *
 *  @param rootNode 根节点
 *
 *  @return 所有节点数
 */
+ (NSInteger)numberOfNodesInTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //节点数=左子树节点数+右子树节点数+1（根节点）
    return [BinaryTreeNode numberOfNodesInTree:rootNode.leftNode] + [BinaryTreeNode numberOfNodesInTree:rootNode.rightNode] + 1;
}

/**
 *  二叉树某层中的节点数
 *
 *  @param level    层
 *  @param rootNode 根节点
 *
 *  @return 层中的节点数
 */
+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(BinaryTreeNode *)rootNode {
    if (!rootNode || level < 1) { //根节点不存在或者level<0
        return 0;
    }
    if (level == 1) { //level=1，返回1（根节点）
        return 1;
    }
    //递归：level层节点数 = 左子树level-1层节点数+右子树level-1层节点数
    return [BinaryTreeNode numberOfNodesOnLevel:level-1 inTree:rootNode.leftNode] + [BinaryTreeNode numberOfNodesOnLevel:level-1 inTree:rootNode.rightNode];
}

/**
 *  二叉树叶子节点数
 *
 *  @param rootNode 根节点
 *
 *  @return 叶子节点数
 */
+ (NSInteger)numberOfLeafsInTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //左子树和右子树都是空，说明是叶子节点
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return 1;
    }
    //递归：叶子数 = 左子树叶子数 + 右子树叶子数
    return [BinaryTreeNode numberOfLeafsInTree:rootNode.leftNode] + [BinaryTreeNode numberOfLeafsInTree:rootNode.rightNode];
}

/**
 *  二叉树最大距离（直径）
 *
 *  @param rootNode 根节点
 *
 *  @return 最大距离
 */
+ (NSInteger)maxDistanceOfTree:(BinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //    方案一：（递归次数较多，效率较低）
    //分3种情况：
    //1、最远距离经过根节点：距离 = 左子树深度 + 右子树深度
    NSInteger distance = [BinaryTreeNode depthOfTree:rootNode.leftNode] + [BinaryTreeNode depthOfTree:rootNode.rightNode];
    //2、最远距离在根节点左子树上，即计算左子树最远距离
    NSInteger disLeft = [BinaryTreeNode maxDistanceOfTree:rootNode.leftNode];
    //3、最远距离在根节点右子树上，即计算右子树最远距离
    NSInteger disRight = [BinaryTreeNode maxDistanceOfTree:rootNode.rightNode];
    
    return MAX(MAX(disLeft, disRight), distance);
}

@end
