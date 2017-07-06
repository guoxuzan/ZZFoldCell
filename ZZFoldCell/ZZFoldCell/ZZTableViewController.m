//
//  ZZTableViewController.m
//  ZZFoldCell
//
//  Created by 郭旭赞 on 2017/7/6.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "ZZTableViewController.h"
#import "ZZFoldCellModel.h"

@interface ZZTableViewController ()

@property(nonatomic,strong) NSMutableArray<__kindof ZZFoldCellModel *> *data;

@end

@implementation ZZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    NSArray *netData = @[
                         @{
                             @"text":@"河北省",
                             @"level":@"0",
                             @"submodels":@[
                                     @{
                                         @"text":@"衡水市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"阜城县",
                                                     @"level":@"2",
                                                     @"submodels":@[
                                                             @{
                                                                 @"text":@"大白乡",
                                                                 @"level":@"3",
                                                                 },
                                                             @{
                                                                 @"text":@"建桥乡",
                                                                 @"level":@"3",
                                                                 },
                                                             @{
                                                                 @"text":@"古城镇",
                                                                 @"level":@"3",
                                                                 }
                                                             ]
                                                     },
                                                 @{
                                                     @"text":@"武邑县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"景县",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         },
                                     @{
                                         @"text":@"廊坊市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"固安县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"三河市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"霸州市",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         }
                                     ]
                             },
                         @{
                             @"text":@"山东省",
                             @"level":@"0",
                             @"submodels":@[
                                     @{
                                         @"text":@"德州市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"临邑县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"齐河县",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"平原县",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         },
                                     @{
                                         @"text":@"烟台市",
                                         @"level":@"1",
                                         @"submodels":@[
                                                 @{
                                                     @"text":@"蓬莱市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"招远市",
                                                     @"level":@"2",
                                                     },
                                                 @{
                                                     @"text":@"海阳市",
                                                     @"level":@"2",
                                                     }
                                                 ]
                                         }
                                     ]
                             },
                         ];
    
    self.data = [NSMutableArray new];
    for (int i = 0; i < netData.count; i++) {
        ZZFoldCellModel *foldCellModel = [ZZFoldCellModel modelWithDic:(NSDictionary *)netData[i]];
        [self.data addObject:foldCellModel];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZFoldCellModel *foldCellModel = self.data[indexPath.row];
    cell.textLabel.text = foldCellModel.text;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFoldCellModel *foldCellModel = self.data[indexPath.row];
    return foldCellModel.level.intValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFoldCellModel *didSelectFoldCellModel = self.data[indexPath.row];
    
    [tableView beginUpdates];
    if (didSelectFoldCellModel.belowCount == 0) {
        
        //Data
        NSArray *submodels = [didSelectFoldCellModel open];
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
        [self.data insertObjects:submodels atIndexes:indexes];
        
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    }else {
        
        //Data
        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
        [didSelectFoldCellModel closeWithSubmodels:submodels];
        [self.data removeObjectsInArray:submodels];
        
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
}

@end
