//
//  EditAnimalSexSheet.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/18.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "EditAnimalSexSheet.h"
#import <UIKit/UIKit.h>

static CGFloat MainScreenHeight = 0;
static CGFloat MainScreenWidth = 0;

@interface EditAnimalSexSheet()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (strong, nonatomic) NSArray *dayArr; // 日数组
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UIButton *btnCancel;
@property (strong, nonatomic) UIPickerView *pickerView; // 选择器

@end
@implementation EditAnimalSexSheet

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        MainScreenHeight =kScreenHeight;
        MainScreenWidth = kScreenWidth;
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        _AnimalSexStr = nil;
        _AnimalSexStr = @"公";
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.dayArr];
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(22, MainScreenHeight/2 - 100, MainScreenWidth - 44, 180)];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 3;
    _containerView.layer.masksToBounds = YES;
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 44, 135)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [_containerView addSubview:self.pickerView];
    
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(0, 134, MainScreenWidth, 1)];
    xianview.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [_containerView addSubview:xianview];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.frame = CGRectMake((MainScreenWidth - 44)/2, 135, MainScreenWidth/2, 45);
    [_btnDone setTitleColor:DMBSColor forState:UIControlStateNormal];
    [_btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_btnDone];
    
    UIView *dowview = [[UIView alloc]initWithFrame:CGRectMake((MainScreenWidth - 44)/2, 140, 1, 30)];
    dowview.backgroundColor = UIColorFromRGB(0xD8D8D8);
    [_containerView addSubview:dowview];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame = CGRectMake(0, 135, (MainScreenWidth - 44)/2, 45);
    [_btnCancel setTitleColor:UIColorFromRGB(0xC9C9C9) forState:UIControlStateNormal];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_btnCancel];
    
    [self addSubview:_containerView];
}

#pragma mark - private method
- (void)clickEmpty:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}
#pragma mark - Action
- (void)doneAction:(UIButton *)btn {
    if (self.GetSelectDate) {
        _GetSelectDate(self.AnimalSexStr);
        [self removeFromSuperview];
    }
}

- (void)cancelAction:(UIButton *)btn {
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.AnimalSexStr = self.dayArr[row%[self.dataArray[component] count]];
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// 获取当前月的天数
- (NSArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSArray array];
        _dayArr = @[@"公",@"母"];
    }
    return _dayArr;
}


@end
