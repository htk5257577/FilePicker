//
//  FilePickerViewController.m
//  FilePicker
//
//  Created by 胡焘坤 on 2017/8/28.
//  Copyright © 2017年 胡焘坤. All rights reserved.
//

#import "FilePickerViewController.h"
#import "Masonry.h"



@interface FilePickerCell : UITableViewCell

@property(nonatomic ,retain) UIImageView *fileTypeImageView;
@property(nonatomic ,retain) UILabel *fileNameLabel;
@property(nonatomic ,retain) UIButton *chooseButton;
@property (nonatomic, copy) void (^onChooseButtonClicked)();
@end

@implementation FilePickerCell

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.fileTypeImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.fileTypeImageView];
        [self.fileTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(7);
            make.bottom.equalTo(self.contentView).offset(-7);
            make.width.equalTo(self.fileTypeImageView.mas_height);
        }];
        
        self.chooseButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.chooseButton];
        [self.chooseButton setImage:[UIImage imageNamed:@"方形未选中"] forState:UIControlStateNormal];
        [self.chooseButton addTarget:self action:@selector(onChooseButoonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(30));
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        self.fileNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.fileNameLabel];
        [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.fileTypeImageView.mas_right).offset(5);
            make.right.equalTo(self.chooseButton.mas_left).offset(-5);
        }];

    }
    return self;
}

- (void)configCell:(NSArray *)dataSource row:(NSInteger)row path:(NSString *)currentPath index:(NSNumber *)chooseIndex{
    self.fileNameLabel.text = dataSource[row];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@",currentPath,dataSource[row]];
    BOOL isDir;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        [self.fileTypeImageView setImage:[UIImage imageNamed:@"文件夹"]];
    }else{
        [self.fileTypeImageView setImage:[UIImage imageNamed:@"文件"]];
    }
    
    if (chooseIndex && chooseIndex.integerValue == row) {
        [self.chooseButton setImage:[UIImage imageNamed:@"方形选中"] forState:UIControlStateNormal];
    }else{
        [self.chooseButton setImage:[UIImage imageNamed:@"方形未选中"] forState:UIControlStateNormal];
    }
}

- (void)configCell:(NSArray *)dataSource row:(NSInteger)row path:(NSString *)currentPath indexArray:(NSArray<NSNumber *> *)chooseIndexArray{
    self.fileNameLabel.text = dataSource[row];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@",currentPath,dataSource[row]];
    BOOL isDir;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        [self.fileTypeImageView setImage:[UIImage imageNamed:@"文件夹"]];
    }else{
        [self.fileTypeImageView setImage:[UIImage imageNamed:@"文件"]];
    }
    
    if ([chooseIndexArray containsObject:@(row)]) {
        [self.chooseButton setImage:[UIImage imageNamed:@"方形选中"] forState:UIControlStateNormal];
    }else{
        [self.chooseButton setImage:[UIImage imageNamed:@"方形未选中"] forState:UIControlStateNormal];
    }
}


- (void)onChooseButoonClicked:(UIButton *)button{
    if (self.onChooseButtonClicked) {
        self.onChooseButtonClicked();
    }
}


@end

@interface FilePickerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)UIColor *backgroundColor;
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, copy)NSString *currentPath;
@property (nonatomic, retain)NSArray *dataSource;
@property (nonatomic, retain)NSNumber *chooseIndex;
@property (nonatomic, retain)NSMutableArray<NSNumber *> *chooseIndexArray;
@end

@implementation FilePickerViewController

-(instancetype)initWithMode:(ChooseMode)mode{
    if (self = [super init]) {
        self.mode = mode;
    }
    return self;
}

-(NSMutableArray<NSNumber *> *)chooseIndexArray{
    if (!_chooseIndexArray) {
        _chooseIndexArray = [[NSMutableArray alloc] init];
    }
    return _chooseIndexArray;
}

-(NSString *)currentPath{
    if (!_currentPath) {
        _currentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return _currentPath;
}

-(NSArray *)dataSource{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.currentPath error:nil];;
}

-(NSString *)titleStr{
    if (!_titleStr) {
        _titleStr = @"文件选择";
    }
    return _titleStr;
}

-(UIColor *)backgroundColor{
    if (!_backgroundColor) {
        _backgroundColor = [UIColor colorWithRed:30/255.0 green:169/255.0 blue:252/255.0 alpha:1];
    }
    return _backgroundColor;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)configView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topBar = [[UIView alloc] init];
    [self.view addSubview:topBar];
    topBar.backgroundColor = self.backgroundColor;
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(60));
    }];
    
    UILabel *titleLable = [[UILabel alloc] init];
    [topBar addSubview:titleLable];
    titleLable.text = self.titleStr;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBar.mas_centerX);
        make.bottom.equalTo(topBar.mas_bottom);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    UIButton *returnButton = [[UIButton alloc] init];
    [topBar addSubview:returnButton];
    [returnButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(onReturnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(25));
        make.left.equalTo(topBar).offset(10);
        make.bottom.equalTo(topBar).offset(-7);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [topBar addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onCloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(25));
        make.right.equalTo(topBar).offset(-10);
        make.bottom.equalTo(topBar).offset(-7);
    }];
    
    UIButton *chooseButton = [[UIButton alloc] init];
    [self.view addSubview:chooseButton];
    [chooseButton setTitle:@"选中" forState:UIControlStateNormal];
    chooseButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    chooseButton.backgroundColor = self.backgroundColor;
    [chooseButton addTarget:self action:@selector(onFinishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topBar.mas_bottom);
        make.bottom.equalTo(chooseButton.mas_top);
    }];
    
}


- (void)onReturnButtonClicked:(UIButton *)button{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if (![self.currentPath isEqualToString:docPath]) {
        self.currentPath = [self.currentPath stringByDeletingLastPathComponent];
        self.chooseIndex = nil;
        [self.chooseIndexArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)onCloseButtonClicked:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFinishButtonClicked:(UIButton *)button{
    if (self.mode == FilePickerSingle && self.chooseIndex) {
        if (self.onFinishButtonClicked) {
            self.onFinishButtonClicked([self.currentPath stringByAppendingPathComponent:self.dataSource[self.chooseIndex.integerValue]]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (self.mode == FilePickerMutiple && self.chooseIndexArray.count > 0){
        if (self.onFinishButtonClicked) {
            NSMutableArray *pathArray = [NSMutableArray array];
            for (NSNumber *index in self.chooseIndexArray) {
                NSString *path = [self.currentPath stringByAppendingPathComponent:self.dataSource[index.integerValue]];
                [pathArray addObject:path];
            }
            self.onFinishButtonClicked(pathArray);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未选中" message:@"请选择文件/文件夹" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"identifier";
    FilePickerCell* cell = (FilePickerCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FilePickerCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    if (self.mode == FilePickerSingle) {
        [cell configCell:self.dataSource row:indexPath.row path:self.currentPath index:self.chooseIndex];
    }else{
        [cell configCell:self.dataSource row:indexPath.row path:self.currentPath indexArray:self.chooseIndexArray];
    }
    __weak FilePickerViewController *weakSelf= self;
    cell.onChooseButtonClicked = ^(){
        if (weakSelf.mode == FilePickerSingle) {
            if (weakSelf.chooseIndex && weakSelf.chooseIndex.integerValue == indexPath.row) {
                weakSelf.chooseIndex = nil;
            }else{
                weakSelf.chooseIndex = @(indexPath.row);
            }
        }else{
            if ([weakSelf.chooseIndexArray containsObject:@(indexPath.row)]) {
                [weakSelf.chooseIndexArray removeObject:@(indexPath.row)];
            }else{
                [weakSelf.chooseIndexArray addObject:@(indexPath.row)];
            }
        }
        [weakSelf.tableView reloadData];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.currentPath,self.dataSource[indexPath.row]];
    BOOL isDir;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir) {
        self.currentPath = path;
        self.chooseIndex = nil;
        [self.chooseIndexArray removeAllObjects];
        [self.tableView reloadData];
    }
}
@end
