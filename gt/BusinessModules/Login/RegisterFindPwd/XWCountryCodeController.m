//
//  XWCountryCodeController.m
//  XWCountryCodeDemo
//GGU
//  Created by 邱学伟 on 16/4/19.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWCountryCodeController.h"

//判断系统语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])

@interface XWCountryCodeController () <UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating> {
    UITableView *_tableView;
    //    UISearchController *_searchController;
    NSDictionary *_sortedNameDict;
    NSArray *_indexArray;
    NSMutableArray *_results;
}
@end

@implementation XWCountryCodeController

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatSubviews];
    kWeakSelf(self);
    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - private
//创建子视图
- (void)creatSubviews{
    _results = [NSMutableArray arrayWithCapacity:1];
    
    float top = YBSystemTool.isIphoneX ? 84 : 44;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, self.view.bounds.size.height-top) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44.0;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self headerView];

    //判断当前系统语言
    if (LanguageIsEnglish) {
        NSString *plistPathEN = [[NSBundle mainBundle] pathForResource:@"sortedNameCH" ofType:@"plist"];
        _sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathEN];
    } else {
        NSString *plistPathCH = [[NSBundle mainBundle] pathForResource:@"sortedNameCH" ofType:@"plist"];
        _sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathCH];
    }
    
    _indexArray = [[NSArray alloc] initWithArray:[[_sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (UIView *) headerView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80)];
    headerView.backgroundColor = kWhiteColor;
    _tableView.tableHeaderView = headerView;
    UILabel*l = CreateLabelWith(CGRectZero, @"请为您的电话号码选择国家/地区", kFontMediumSize(20), RGBCOLOR(51, 51, 51), kClearColor, NSTextAlignmentLeft, headerView);
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    return headerView;
}

- (NSString *)showCodeStringIndex:(NSIndexPath *)indexPath jieQue:(BOOL)jieQu {
    NSString *showCodeSting;
    if (_indexArray.count > indexPath.section) {
        NSArray *sectionArray = [_sortedNameDict valueForKey:[_indexArray objectAtIndex:indexPath.section]];
        if (sectionArray.count > indexPath.row) {
            showCodeSting = [sectionArray objectAtIndex:indexPath.row];
            NSArray *array = [showCodeSting componentsSeparatedByString:@"+"];
            if (jieQu) {
                showCodeSting = array[0];
            }else{
                showCodeSting = array[1];
            }
        }
    }
    return showCodeSting;
}

- (void)selectCodeIndex:(NSIndexPath *)indexPath {
    
    NSString * originText = [self showCodeStringIndex:indexPath jieQue:NO];
    if (self.deleagete && [self.deleagete respondsToSelector:@selector(returnCountryName:code:)]) {
        [self.deleagete returnCountryName:originText code:originText];
    }
    if (self.countryCodeBlock != nil) {
        self.countryCodeBlock(originText,originText);
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
//    NSLog(@"选择国家: %@   代码: %@",originText,originText);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (_results.count > 0) {
        [_results removeAllObjects];
    }
    NSString *inputText = searchController.searchBar.text;
    __weak __typeof(self)weakSelf = self;
    [_sortedNameDict.allValues enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:inputText]) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_results addObject:obj];
            }
        }];
    }];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sortedNameDict allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_indexArray.count > section) {
        NSArray *array = [_sortedNameDict objectForKey:[_indexArray objectAtIndex:section]];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *title = CreateLabelWith(CGRectZero, @"", kFontMediumSize(16), RGBCOLOR(51, 51, 51), kClearColor, NSTextAlignmentLeft, cell.contentView);
        title.tag = 20;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
        }];
    }
    UILabel *title = [cell.contentView viewWithTag:20];
    title.text = [self showCodeStringIndex:indexPath jieQue:YES];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _indexArray;
    }else{
        return nil;
    }
}

#pragma mark - 选择国际获取代码
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCodeIndex:indexPath];
}

@end
