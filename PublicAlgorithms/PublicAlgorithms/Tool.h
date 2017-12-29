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


@interface BinaryTreeNode : NSObject
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) BinaryTreeNode *leftNode;
@property (nonatomic, strong) BinaryTreeNode *rightNode;
//打印二叉树
- (NSString *)printfBinaryTree;
//创建二叉树
+ (BinaryTreeNode *)createTreeWithValues:(NSArray *)values;
//二叉树中某个位置的节点（按层次遍历）
+ (BinaryTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(BinaryTreeNode *)rootNode;
//向二叉排序树节点添加一个节点
+ (BinaryTreeNode *)addTreeNode:(BinaryTreeNode *)treeNode value:(NSInteger)value;
//翻转二叉树
+ (BinaryTreeNode *)invertBinaryTree:(BinaryTreeNode *)rootNode;
// 非递归方式翻转
+ (BinaryTreeNode *)invertBinaryTreeNot:(BinaryTreeNode *)rootNode;
//先序遍历：先访问根，再遍历左子树，再遍历右子树。典型的递归思想。
+ (void)preOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler;
//中序遍历:先遍历左子树，再访问根，再遍历右子树
+ (void)inOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler;
//后序遍历:先遍历左子树，再遍历右子树，再访问根
+ (void)postOrderTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler;
//层次遍历（广度优先)
+ (void)levelTraverseTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *treeNode))handler;
//二叉树的宽度
+ (NSInteger)widthOfTree:(BinaryTreeNode *)rootNode;
//二叉树的所有节点数
+ (NSInteger)numberOfNodesInTree:(BinaryTreeNode *)rootNode;
//二叉树某层中的节点数
+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(BinaryTreeNode *)rootNode;

//二叉树叶子节点数
+ (NSInteger)numberOfLeafsInTree:(BinaryTreeNode *)rootNode;
//二叉树最大距离（直径）
+ (NSInteger)maxDistanceOfTree:(BinaryTreeNode *)rootNode;

@end
