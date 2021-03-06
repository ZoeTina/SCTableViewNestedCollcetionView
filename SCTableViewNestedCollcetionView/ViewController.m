//
//  ViewController.m
//  SCTableViewNestedCollcetionView
//
//  Created by 宁小陌 on 2018/7/6.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "ViewController.h"
#import "SCTableViewCell.h"
#import "BaseTableViewCell.h"
#import "SCBaseSectionHeaderView.h"

static NSString * const reuseIdentifier_t = @"SCTableViewCell";
static NSString * const reuseIdentifier_c = @"BaseTableViewCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SCTableViewCellDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
//// 装高度
@property (nonatomic, strong) NSMutableDictionary *dictHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = @[@[@"1元", @"2元", @"3元", @"4元", @"5元", @"6元"],
                     @[@"1元", @"2元", @"3元", @"4元", @"10元", @"20元", @"30元", @"40元", @"11元", @"22元", @"33元"],
                     @[@"100元", @"200元", @"300元", @"400元", @"10元", @"20元", @"30元", @"40元", @"11元", @"22元", @"33元",@"1元", @"2元", @"3元", @"4元", @"5元", @"6元"]];
    [self.view addSubview:self.tableView];
    
    self.title = @"TableView嵌套CollectionView";
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return 10;
    }else if (section==2) return 1;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dictHeight[indexPath]) {
        NSNumber *num = self.dictHeight[indexPath];
        return [num floatValue];
    } else {
        return 60;
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0;
    return 10;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SCBaseSectionHeaderView *sectionView = [[SCBaseSectionHeaderView alloc] init];
    sectionView.section = section;
    sectionView.tableView = tableView;
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView registerClass:[SCTableViewCell class] forCellReuseIdentifier:reuseIdentifier_t];
        SCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier_t forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.dataArray = self.dataArray[indexPath.row];
        return cell;
    } else {
        [tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:reuseIdentifier_c];
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier_c forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark ====== RootTableCellDelegate ======
- (void)updateTableViewCellHeight:(SCTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.dictHeight[indexPath] isEqualToNumber:@(height)]) {
        self.dictHeight[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

//点击UICollectionViewCell的代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content {

    
    NSLog(@"%@",content);
}

#pragma mark ====== init ======
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableDictionary *)dictHeight {
    if (!_dictHeight) {
        _dictHeight = [[NSMutableDictionary alloc] init];
    }
    return _dictHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
