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


typedef struct NODE {
    struct NODE *next;
    int num;
}node;

node *createLinkList(int length) {
    if (length <= 0) {
        return NULL;
    }
    node *head,*p,*q;
    int number = 1;
    head = (node *)malloc(sizeof(node));
    head->num = 1;
    head->next = head;
    p = q = head;
    while (++number <= length) {
        p = (node *)malloc(sizeof(node));
        p->num = number;
        p->next = NULL;
        q->next = p;
        q = p;
    }
    return head;
}
void printLinkList(node *head) {
    if (head == NULL) {
        return;
    }
    node *p = head;
    while (p) {
        printf("%d ", p->num);
        p = p -> next;
    }
    printf("\n");
}
node *reverseFunc1(node *head) {
    if (head == NULL) {
        return head;
    }
    node *p,*q;
    p = head;
    q = NULL;
    while (p) {
        node *pNext = p -> next;
        p -> next = q;
        q = p;
        p = pNext;
    }
    return q;
}

int spliterFunc(char *p) {
    char c[100][100];
    int i = 0;
    int j = 0;
    while (*p != '\0') {
        if (*p == ' ') {
            i++;
            j = 0;
        } else {
            c[i][j] = *p;
            j++;
        }
        p++;
    }
    for (int k = i; k >= 0; k--) {
        printf("%s", c[k]);
        if (k > 0) {
            printf(" ");
        } else {
            printf("\n");
        }
    }
    return 0;
}

char findIt(const char *str) {
    int count[26]={0};
    int index[26]={0};  //注意int数组初始化赋值时，如果写成={-1}是不能给所有元素初始化为-1的，只有第一个元素是-1，其余为默认值0
    unsigned int i;
    int pos;
    for(i=0;i<strlen(str);i++) {
        count[str[i]-'a']++;   //记录该字母出现的次数
        // cout<<count[str[i]-'a']<<endl;
        if(index[str[i]-'a']==0) {
            index[str[i]-'a']=i;  //记住该字母第一次出现时的索引
        }
    }
    pos = (int)strlen(str);
    for(i=0;i<26;i++) {
        if(count[i]==1){  //找到只出现一次的字母
            if(index[i]!=-1&&index[i]<pos){  //在只出现一次的字母中找出索引值最小的即可
                pos=index[i];
            }
        }
    }
    if(pos<strlen(str))
        return str[pos];
    return '\0';
}

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *sortArr;

@property (nonatomic, strong) UILabel *arrL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) ToolKLine *memory;
@property (nonatomic, strong) ToolKLine *cpu;

@property (nonatomic, strong) UIButton *sortBtn;

@property (nonatomic, strong) NSMutableArray *cpuArr;
@property (nonatomic, strong) NSMutableArray *memoryArr;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.type <= 9) {
        int count = self.type > 8 ? 10000:5000;
        
        for (int index = 0; index < count; index++) {
            NSString *num = [NSString stringWithFormat:@"%d",(arc4random()%count)];
            [self.sortArr addObject:num];
            if (index == count - 1) {
                self.sortBtn.enabled = YES;
            }
        }
    }else {
        self.sortBtn.enabled = YES;
    }
    
    [self initSubLabel];
}
- (void)initSubLabel {
    switch (self.type) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            self.arrL.text = [NSString stringWithFormat:@"数组：(看控制台)"];
            break;
        case 10:
            self.arrL.text = [NSString stringWithFormat:@"链表逆序：(看控制台)"];
            break;
        case 11:
            self.arrL.text = [NSString stringWithFormat:@"字符串逆序输出：(看控制台)"];
            break;
        case 12:
            self.arrL.text = [NSString stringWithFormat:@"查找字符串中只出现一次且最靠前的字符的位置：未计算"];
            break;
        case 13:
            self.arrL.text = [NSString stringWithFormat:@"二叉树"];
            break;
        case 14:
            self.arrL.text = [NSString stringWithFormat:@"2-100之间素数：未计算"];
            break;
        case 15:
            self.arrL.text = [NSString stringWithFormat:@"2465与8965的最大公约数：未计算"];
            break;
        case 16:
            break;
            
        default:
            break;
    }
    
    [self.arrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.view.mas_top).offset(89);
    }];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.arrL.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
}
- (void)startAlgorithm {
    switch (self.type) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:{
            self.sortBtn.enabled = NO;
            [self Sort];
        }
            break;
        case 9:{
            [self binarySearch];
        }
            break;
        case 10:
            [self linkedListInversion];
            break;
        case 11:
            [self reverseOrderOutputOfString];
            break;
        case 12:
            [self findPositionOfOnlyOnceAndMostImportantCharacterString];
            break;
        case 13:
            [self binaryTree];
            break;
        case 14:{
            [self printPrimeNumber];
        }
            break;
        case 15:{
            [self findGreatestCommonDivisorOfTwoIntegers];
        }
            break;
        case 16:
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark   ==============算法调用==============
- (void)Sort{
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    __block NSMutableArray *arr;
    NSMutableArray *arr1 = self.sortArr.mutableCopy;
    NSLog(@"未排序数组：\n%@",[arr1 componentsJoinedByString:@","]);
    double time = [Tool functionTime:^{
        if (self.type == 0) {
            [self bubbleSort:arr1];
            arr = arr1;
        }else if (self.type == 1) {
            [self selectSort:arr1];
            arr = arr1;
        }else if (self.type == 2) {
            [self quickSortArray:arr1 withLeftIndex:0 andRightIndex:arr1.count - 1];
            arr = arr1;
        }else if (self.type == 3) {
            arr = [self mergeSort:arr1];
        }else if (self.type == 4) {
            arr = [self shellAscendingOrderSort:arr1];
        }else if (self.type == 5) {
            arr = [self radixAscendingOrderSort:arr1];
        }else if (self.type == 6) {
            arr = [self heapsortAsendingOrderSort:arr1];
        }else if (self.type == 7) {
            arr = [self insertionAscendingOrderSort:arr1];
        }else if (self.type == 8) {
            arr = [self insertionAscendingHalfSort:arr1];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        NSLog(@"排序完成数组：\n%@",[arr componentsJoinedByString:@","]);
    });
}
- (void)binarySearch {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    NSMutableArray *arr = [self shellAscendingOrderSort:self.sortArr];
    __block NSInteger index = 0;
    NSLog(@"未查找位置：%ld",index);
    double time = [Tool functionTime:^{
        index = [self binarySearch:arr];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        UIColor *color = self.sortBtn.tag == 2 ? [UIColor blueColor]:(self.sortBtn.tag == 1 ?[UIColor orangeColor]:nil);
        [self.memory dravLineWithArr:self.memoryArr  withColor:color];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:color];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.tag ++;
        self.sortBtn.enabled = !(self.sortBtn.tag == 3);
        NSLog(@"查找的位置：%ld",index);
    });
}
#pragma mark -
#pragma mark   ==============算法==============
//冒泡排序
- (void)bubbleSort:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count - 1; i++) {
        for (int j = 0; j < arr.count - 1 - i; j++) {
            if ([arr[j] intValue] > [arr[j+1] intValue]) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}
//选择排序
- (void)selectSort:(NSMutableArray *)arr {
    int i, j, index;
    for(i = 0; i < arr.count - 1; i++) {
        index = i;
        for(j = i + 1; j < arr.count; j++) {
            if([arr[index] intValue] > [arr[j] intValue]) {
                index = j;
            }
        }
        if(index != i) {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:index];
        }
    }
}
//快速排序
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) {
        return ;
    }
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    NSInteger key = [array[i] integerValue];
    while (i < j) {
        while (i < j && [array[j] integerValue] >= key) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [array[i] integerValue] <= key) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = [NSString stringWithFormat:@"%ld",key];
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i - 1];
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}
//归并排序
- (NSMutableArray *)mergeSort:(NSMutableArray *)arr{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *number in arr) {
        NSMutableArray *childArray = [NSMutableArray array];
        [childArray addObject:number];
        [tempArray addObject:childArray];
    }
    while (tempArray.count != 1) {
        NSUInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArray:tempArray[i] secondArray:tempArray[i+1]];
            [tempArray removeObjectAtIndex:i+1];
            i += 1;
        }
    }
    return tempArray;
}
- (NSMutableArray *)mergeArray:(NSArray *)firstArray secondArray:(NSArray *)secondArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger firstIndex = 0;
    NSUInteger secondIndex = 0;
    while (firstIndex < firstArray.count && secondIndex < secondArray.count) {
        if ([firstArray[firstIndex] integerValue] < [secondArray[secondIndex] integerValue]) {
            [resultArray addObject:firstArray[firstIndex]];
            firstIndex += 1;
        }else {
            [resultArray addObject:secondArray[secondIndex]];
            secondIndex += 1;
        }
    }
    while (firstIndex < firstArray.count) {
        [resultArray addObject:firstArray[firstIndex]];
        firstIndex += 1;
    }
    while (secondIndex < secondArray.count) {
        [resultArray addObject:secondArray[secondIndex]];
        secondIndex += 1;
    }
    return resultArray;
}
//希尔排序
- (NSMutableArray *)shellAscendingOrderSort:(NSMutableArray *)ascendingArr {
    NSMutableArray *buckt = [self createBucket];
    NSString *maxnumber = [self listMaxItem:ascendingArr];
    NSInteger maxLength = maxnumber.length;
    for (int digit = 1; digit <= maxLength; digit++) {
        // 入桶
        for (NSString *item in ascendingArr) {
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray *mutArray = buckt[baseNumber];
            [mutArray addObject:item];
        }
        NSInteger index = 0;
        for (int i = 0; i < buckt.count; i++) {
            NSMutableArray *array = buckt[i];
            while (array.count != 0) {
                NSString *number = [array objectAtIndex:0];
                ascendingArr[index] = number;
                [array removeObjectAtIndex:0];
                index++;
            }
        }
    }
    return ascendingArr;
}
//基数排序
- (NSMutableArray *)radixAscendingOrderSort:(NSMutableArray *)ascendingArr {
    NSMutableArray *buckt = [self createBucket];
    NSString *maxnumber = [self listMaxItem:ascendingArr];
    NSInteger maxLength = maxnumber.length;
    for (int digit = 1; digit <= maxLength; digit++) {
        for (NSString *item in ascendingArr) {
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray *mutArray = buckt[baseNumber];
            [mutArray addObject:item];
        }
        NSInteger index = 0;
        for (int i = 0; i < buckt.count; i++) {
            NSMutableArray *array = buckt[i];
            while (array.count != 0) {
                NSString *number = [array objectAtIndex:0];
                ascendingArr[index] = number;
                [array removeObjectAtIndex:0];
                index++;
            }
        }
    }
    return ascendingArr;
}
- (NSMutableArray *)createBucket {
    NSMutableArray *bucket = [NSMutableArray array];
    for (int index = 0; index < 10; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [bucket addObject:array];
    }
    return bucket;
}
- (NSString *)listMaxItem:(NSArray *)list {
    NSString *maxNumber = list[0];
    for (NSString *number in list) {
        if ([maxNumber integerValue] < [number integerValue]) {
            maxNumber = number;
        }
    }
    return maxNumber;
}
- (NSInteger)fetchBaseNumber:(NSString *)number digit:(NSInteger)digit {
    if (digit > 0 && digit <= number.length) {
        NSMutableArray *numbersArray = [NSMutableArray array];
        NSString *string = [NSString stringWithFormat:@"%@", number];
        for (int index = 0; index < number.length; index++) {
            [numbersArray addObject:[string substringWithRange:NSMakeRange(index, 1)]];
        }
        NSString *str = numbersArray[numbersArray.count - digit];
        return [str integerValue];
    }
    return 0;
}
// 堆排序
- (NSMutableArray *)heapsortAsendingOrderSort:(NSMutableArray *)ascendingArr {
    NSInteger endIndex = ascendingArr.count - 1;
    ascendingArr = [self heapCreate:ascendingArr];
    while (endIndex >= 0) {
        NSString *temp = ascendingArr[0];
        ascendingArr[0] = ascendingArr[endIndex];
        ascendingArr[endIndex] = temp;
        endIndex -= 1;
        ascendingArr = [self heapAdjast:ascendingArr withStartIndex:0 withEndIndex:endIndex + 1];
    }
    return ascendingArr;
}
- (NSMutableArray *)heapCreate:(NSMutableArray *)array {
    NSInteger i = array.count;
    while (i > 0) {
        array = [self heapAdjast:array withStartIndex:i - 1 withEndIndex:array.count];
        i -= 1;
    }
    return array;
}
- (NSMutableArray *)heapAdjast:(NSMutableArray *)items withStartIndex:(NSInteger)startIndex withEndIndex:(NSInteger)endIndex {
    NSString *temp = items[startIndex];
    NSInteger fatherIndex = startIndex + 1;
    NSInteger maxChildIndex = 2 * fatherIndex;
    while (maxChildIndex <= endIndex) {
        if (maxChildIndex < endIndex && [items[maxChildIndex - 1] floatValue] < [items[maxChildIndex] floatValue]) {
            maxChildIndex++;
        }
        if ([temp floatValue] < [items[maxChildIndex - 1] floatValue]) {
            items[fatherIndex - 1] = items[maxChildIndex - 1];
        } else {
            break;
        }
        fatherIndex = maxChildIndex;
        maxChildIndex = fatherIndex * 2;
    }
    items[fatherIndex - 1] = temp;
    return items;
}
// 直接插入排序
- (NSMutableArray *)insertionAscendingOrderSort:(NSMutableArray *)ascendingArr {
    for (NSInteger i = 1; i < ascendingArr.count; i ++) {
        NSInteger temp = [ascendingArr[i] integerValue];
        for (NSInteger j = i - 1; j >= 0 && temp < [ascendingArr[j] integerValue]; j --) {
            ascendingArr[j + 1] = ascendingArr[j];
            ascendingArr[j] = [NSString stringWithFormat:@"%ld",temp];
        }
    }
    return ascendingArr;
}
//二分法插入排序
- (NSMutableArray *)insertionAscendingHalfSort:(NSMutableArray *)dataArr {
    for (int i = 1; i < dataArr.count; i++) {
        int left = 0;
        int right = i - 1;
        int mid;
        int temp = [dataArr[i] intValue];
        if (temp  < [dataArr[right] intValue]) {
            while (left <= right) {
                mid = (left + right) / 2;
                if ([dataArr[mid] intValue] < temp) {
                    left = mid + 1;
                }else if ([dataArr[mid] intValue] > temp) {
                    right = mid - 1;
                }else {
                    left += 1;
                }
            }
            for (int j = i; j > left; j--) {
                [dataArr exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            }
            dataArr[left] = [NSString stringWithFormat:@"%d",temp];
        }
    }
    return dataArr;
}
//二分查找
- (NSInteger)binarySearch:(NSMutableArray *)sortedArray {
    NSString *searchObject = sortedArray[6666];
    if (self.sortBtn.tag == 0) {
        NSRange searchRange = NSMakeRange(0, [sortedArray count]);
        NSUInteger findIndex = [sortedArray indexOfObject:searchObject
                                            inSortedRange:searchRange
                                                  options:NSBinarySearchingFirstEqual
                                          usingComparator:^(id obj1, id obj2) {
                                              return [obj1 compare:obj2];
                                          }];
        return findIndex;
    }else if (self.sortBtn.tag == 1) {
        unsigned index = (unsigned)CFArrayBSearchValues((CFArrayRef)sortedArray,
                                                        CFRangeMake(0, CFArrayGetCount((CFArrayRef)sortedArray)),
                                                        (CFStringRef)searchObject,
                                                        (CFComparatorFunction)CFStringCompare,
                                                        NULL);
        if (index < [sortedArray count] && [searchObject isEqualToString:sortedArray[index]]) {
            return index;
        } else {
            return -1;
        }
    }else if (self.sortBtn.tag == 2) {
        NSUInteger mid;
        NSUInteger min = 0;
        NSUInteger max = [sortedArray count] - 1;
        BOOL found = NO;
        while (min <= max) {
            mid = (min + max)/2;
            if ([searchObject isEqualToString:sortedArray[mid]]) {
                return mid;
            } else if ([searchObject intValue] < [sortedArray[mid] intValue]) {
                max = mid - 1;
            } else if ([searchObject intValue] > [sortedArray[mid] intValue]) {
                min = mid + 1;
            }
        }
        if (!found) {
            return -1;
        }
    }
    return -1;
}
//链表逆序
- (void)linkedListInversion {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    double time = [Tool functionTime:^{
        node *head = createLinkList(7);
        if (head) {
            printLinkList(head);
            node *reHead = reverseFunc1(head);
            printLinkList(reHead);
            free(reHead);
        }
        free(head);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr  withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.enabled = NO;
    });
}
//字符串的逆序输出
- (void)reverseOrderOutputOfString {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    double time = [Tool functionTime:^{
        char *p = "hello world";
        spliterFunc(p);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr  withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.enabled = NO;
    });
}
//查找字符串中只出现一次且最靠前的字符的位置
- (void)findPositionOfOnlyOnceAndMostImportantCharacterString {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    __block char s;
    double time = [Tool functionTime:^{
        char *p = "hello world flsnlnf hello world";
        s = findIt(p);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.arrL.text = [NSString stringWithFormat:@"查找字符串中只出现一次且最靠前的字符的位置：%c",s];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr  withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.enabled = NO;
    });
}
//二叉树
- (void)binaryTree {
    NSArray *arr = [NSArray arrayWithObjects:@(7),@(6),@(3),@(2),@(1),@(9),@(10),@(12),@(14),@(4),@(14), nil];
    BinaryTreeNode *tree = [BinaryTreeNode new];
    tree = [BinaryTreeNode createTreeWithValues:arr];
    NSString *treeString = [tree printfBinaryTree];
    
    BinaryTreeNode *tree1 = [BinaryTreeNode treeNodeAtIndex:3 inTree:tree];
    NSString *tree1String = [tree1 printfBinaryTree];

    NSMutableArray *orderArray = [NSMutableArray array];
    [BinaryTreeNode preOrderTraverseTree:tree handler:^(BinaryTreeNode *treeNode) {
        [orderArray addObject:@(treeNode.value)];
    }];
    NSString *startString = [NSString stringWithFormat:@"先序遍历结果：%@", [orderArray componentsJoinedByString:@","]];
    
    NSMutableArray *orderArray1 = [NSMutableArray array];
    [BinaryTreeNode inOrderTraverseTree:tree handler:^(BinaryTreeNode *treeNode) {
        
        [orderArray1 addObject:@(treeNode.value)];
        
    }];
    NSString *midString = [NSString stringWithFormat:@"中序遍历结果：%@", [orderArray1 componentsJoinedByString:@","]];

    NSMutableArray *orderArray2 = [NSMutableArray array];
    [BinaryTreeNode postOrderTraverseTree:tree handler:^(BinaryTreeNode *treeNode) {
        [orderArray2 addObject:@(treeNode.value)];
        
    }];
    NSString *endString = [NSString stringWithFormat:@"后序遍历结果：%@", [orderArray2 componentsJoinedByString:@","]];

    NSMutableArray *orderArray3 = [NSMutableArray array];
    [BinaryTreeNode levelTraverseTree:tree handler:^(BinaryTreeNode *treeNode) {
        [orderArray3 addObject:@(treeNode.value)];
        
    }];
    NSString *cengString = [NSString stringWithFormat:@"层次遍历结果：%@", [orderArray3 componentsJoinedByString:@","]];
    
    self.arrL.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",treeString,tree1String,startString,midString,endString,cengString];
}
//打印2-100之间的素数
- (void)printPrimeNumber {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    __block NSMutableArray *arr = [NSMutableArray array];
    NSInteger a = 2;
    NSInteger b = 100;
    double time = [Tool functionTime:^{
        for (NSInteger index = a; index < b; index++) {
            if ([self isPrime:index]) {
                [arr addObject:[NSString stringWithFormat:@"%ld",index]];
            }
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.arrL.text = [NSString stringWithFormat:@"2-100之间素数：%@",[arr componentsJoinedByString:@","]];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr  withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.enabled = NO;
    });
}
- (BOOL)isPrime:(NSInteger)num {
    for (NSInteger i = 2; i <= sqrt(num); i++) {
        if (num % i == 0) return NO;
    }
    return 1;
}
//求两个整数的最大公约数
- (void)findGreatestCommonDivisorOfTwoIntegers {
    [self.memoryArr removeAllObjects];
    [self.cpuArr removeAllObjects];
    [self startOrEndAnimation:YES];
    __block NSInteger index = 0;
    NSInteger a = 2465;
    NSInteger b = 8965;
    double time = [Tool functionTime:^{
        index = [self getGcd:a with:b];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startOrEndAnimation:NO];
        self.arrL.text = [NSString stringWithFormat:@"2465与8965的最大公约数：%ld",index];
        self.timeL.text = [NSString stringWithFormat:@"耗时：%.8fs",time];
        [self.memory dravLineWithArr:self.memoryArr  withColor:nil];
        [self.cpu dravLineWithArr:self.cpuArr  withColor:nil];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(16);
            make.right.equalTo(self.view.mas_right).offset(-16);
            make.top.equalTo(self.sortBtn.mas_bottom).offset(25);
        }];
        [self.memory.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.timeL.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        [self.cpu.superview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.memory.superview.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(kWidth - 32, 150));
        }];
        self.sortBtn.enabled = NO;
    });
}
- (NSInteger)getGcd:(NSInteger )a with:(NSInteger)b  {
    NSInteger temp = 0;
    if (a < b) {
        temp = a;
        a = b;
        b = temp;
    }
    while (b != 0) {
        temp = a % b;
        a = b;
        b = temp;
    }
    return a;
}
#pragma mark -
#pragma mark   ==============记录cpu+memory==============
- (void)startRecord {
    NSString *cpu = [NSString stringWithFormat:@"%f",[Tool cpuUsage]];
    NSString *memory = [NSString stringWithFormat:@"%lu",[Tool memoryUsage]];
    [self.cpuArr addObject:cpu];
    [self.memoryArr addObject:memory];
}
#pragma mark -
#pragma mark   ==============定时器==============
- (void)startOrEndAnimation:(BOOL)startOrEnd {
    if (startOrEnd) {
        if (self.timer) {
            return;
        }else {
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(self.timer, ^{
                [self startRecord];
            });
            dispatch_resume(self.timer);
        }
    }else {
        if (self.timer) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    }
}
#pragma mark -
#pragma mark   ==============lazy==============
- (NSMutableArray *)sortArr {
    if (!_sortArr) {
        _sortArr = [NSMutableArray array];
    }
    return _sortArr;
}
- (NSMutableArray *)memoryArr {
    if (!_memoryArr) {
        _memoryArr = [NSMutableArray array];
    }
    return _memoryArr;
}
- (NSMutableArray *)cpuArr {
    if (!_cpuArr) {
        _cpuArr = [NSMutableArray array];
    }
    return _cpuArr;
}
- (UILabel *)arrL {
    if (!_arrL) {
        _arrL = [[UILabel alloc] init];
        _arrL.font = [UIFont systemFontOfSize:15];
        _arrL.numberOfLines = 0;
        [self.view addSubview:_arrL];
    }
    return _arrL;
}
- (UILabel *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:15];
        _timeL.numberOfLines = 0;
        [self.view addSubview:_timeL];
    }
    return _timeL;
}
- (UIButton *)sortBtn {
    if (!_sortBtn) {
        _sortBtn = [[UIButton alloc] init];
        [_sortBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_sortBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        _sortBtn.backgroundColor = [UIColor cyanColor];
        _sortBtn.tag = 0;
        [_sortBtn addTarget:self action:@selector(startAlgorithm) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sortBtn];
        _sortBtn.enabled = NO;
    }
    return _sortBtn;
}
- (ToolKLine *)memory {
    if (!_memory) {
        _memory = [ToolKLine toolMemoryKLineWithFrame:CGRectMake(0, 0, (kWidth - 32) * 5, 150)];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 32, 150)];
        scroll.contentSize = CGSizeMake((kWidth - 32) * 5, 0);
        [scroll addSubview:_memory];
        [_memory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(scroll);
            make.size.mas_equalTo(CGSizeMake((kWidth - 32) * 5, 150));
        }];
        [self.view addSubview:scroll];
    }
    return _memory;
}
- (ToolKLine *)cpu {
    if (!_cpu) {
        _cpu = [ToolKLine toolCpuKLineWithFrame:CGRectMake(0, 0, (kWidth - 32) * 5, 150)];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 32, 150)];
        scroll.contentSize = CGSizeMake((kWidth - 32) * 5, 0);
        [scroll addSubview:_cpu];
        [_cpu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(scroll);
            make.size.mas_equalTo(CGSizeMake((kWidth - 32) * 5, 150));
        }];
        [self.view addSubview:scroll];
    }
    return _cpu;
}

@end
