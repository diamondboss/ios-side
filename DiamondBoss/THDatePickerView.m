//
//  THDatePickerView.m
//  rongyp-company
//
//  Created by Apple on 2016/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "THDatePickerView.h"

@interface THDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton *getBtn;
    BOOL issendBtn;
    NSDateFormatter *dateFormatter3;
    NSString *strDate3;
}
@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题
@property (strong, nonatomic) UIView *cancleView; // 工具条

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间

@property (strong, nonatomic) NSMutableArray *yearArr; // 年数组
@property (strong, nonatomic) NSMutableArray *monthArr; // 月数组
@property (strong, nonatomic) NSMutableArray *dayArr; // 日数组
@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSArray *timeArr; // 当前时间数组

@property (copy, nonatomic) NSString *year; // 选中年
@property (copy, nonatomic) NSString *month; //选中月
@property (copy, nonatomic) NSString *day; //选中日
@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分


@property (nonatomic,strong) UIButton *sednBtn;//送出按钮
@end

#define THColorRGB(rgb)    [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]

@implementation THDatePickerView

#pragma mark - init
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObject:self.dayArr];
        [self.dataArray addObject:self.hourArr];
        [self.dataArray addObject:self.minuteArr];
        
        issendBtn = YES;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        [self creatToolView];
        [self configToolView];
        [self configPickerView];
        [self configcancleView];
    }
    return self;
}
#pragma mark - 配置界面
- (void)creatToolView{
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, 110);
    [self addSubview:self.toolView];
    
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(0, 10, self.frame.size.width, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = THColorRGB(34);
    self.titleLbl.text = @"送接宠物时间";
    self.titleLbl.font = [UIFont systemFontOfSize:20];
    [self.toolView addSubview:self.titleLbl];
    
    
    NSDate * date = [NSDate date];//当前时间
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd"];
    NSString *strDate1 = [dateFormatter1 stringFromDate:nextDay];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
    NSString *strDate2 = [dateFormatter1 stringFromDate:nextDay];

    dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"YYYY"];
    strDate3 = [dateFormatter3 stringFromDate:date];

    
    self.sendTimeLbl = [[UILabel alloc] init];
    self.sendTimeLbl.frame = CGRectMake(0, 90, self.frame.size.width/2, 20);
    self.sendTimeLbl.textAlignment = NSTextAlignmentCenter;
    self.sendTimeLbl.textColor = [UIColor lightGrayColor];
    self.sendTimeLbl.text = [NSString stringWithFormat:@"%@ 09:00",strDate1];
    [self.toolView addSubview:self.sendTimeLbl];
    _orderTime = strDate2;
    _orderhour = @"09";
    
    
    self.getTimeLbl = [[UILabel alloc] init];
    self.getTimeLbl.frame = CGRectMake(self.frame.size.width/2, 90,self.frame.size.width/2, 20);
    self.getTimeLbl.textAlignment = NSTextAlignmentCenter;
    self.getTimeLbl.textColor = [UIColor lightGrayColor];
    self.getTimeLbl.text = [NSString stringWithFormat:@"%@ 18:00",strDate1] ;
    [self.toolView addSubview:self.getTimeLbl];
    
    _returnTime = strDate2;
    _returnhour = @"18";
    
    UIView *xianView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 55, 1, 55)];
    xianView.backgroundColor = UIColorRGB(237, 237, 237);
    [self.toolView addSubview:xianView];
}
/// 配置工具条
- (void)configToolView {
    if (issendBtn) {
        _sednBtn = [[UIButton alloc] init];
        _sednBtn.frame = CGRectMake(0, 50,self.frame.size.width/2, 40);
        [_sednBtn setTitle:@"送出" forState:UIControlStateNormal];
        [_sednBtn setTitleColor:DMBSColor forState:UIControlStateNormal];
        [_sednBtn addTarget:self action:@selector(sendBtnClik) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_sednBtn];

        getBtn = [[UIButton alloc] init];
        getBtn.frame = CGRectMake(self.frame.size.width/2, 50,self.frame.size.width/2, 40);
        [getBtn setTitle:@"接回" forState:UIControlStateNormal];
        [getBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [getBtn addTarget:self action:@selector(getBtnClik) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:getBtn];
    }else{
        _sednBtn = [[UIButton alloc] init];
        _sednBtn.frame = CGRectMake(0, 50,self.frame.size.width/2, 40);
        [_sednBtn setTitle:@"送出" forState:UIControlStateNormal];
        [_sednBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_sednBtn addTarget:self action:@selector(sendBtnClik) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:_sednBtn];
        
        getBtn = [[UIButton alloc] init];
        getBtn.frame = CGRectMake(self.frame.size.width/2, 50,self.frame.size.width/2, 40);
        [getBtn setTitle:@"接回" forState:UIControlStateNormal];
        [getBtn setTitleColor:DMBSColor forState:UIControlStateNormal];
        [getBtn addTarget:self action:@selector(getBtnClik) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:getBtn];
    }
}
- (void)sendBtnClik{
    [_sednBtn removeFromSuperview];
    [getBtn removeFromSuperview];
    
    issendBtn = YES;
    [self configToolView];
}
- (void)getBtnClik{
    [_sednBtn removeFromSuperview];
    [getBtn removeFromSuperview];
    
    issendBtn = NO;
    [self configToolView];
}
// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height - 160)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self addSubview:self.pickerView];
}
- (void)configcancleView{
    self.cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, self.frame.size.width, 50)];
    [self addSubview:self.cancleView];
    
    UIView *xiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    xiView.backgroundColor = UIColorRGB(237, 237, 237);
    [self.cancleView addSubview:xiView];
    
    _cancleBtn = [[UIButton alloc] init];
    _cancleBtn.frame = CGRectMake(0, 5,self.frame.size.width/2, 40);
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //    [getBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleView addSubview:_cancleBtn];
    
    _nextBtn = [[UIButton alloc] init];
    _nextBtn.frame = CGRectMake(self.frame.size.width/2, 5,self.frame.size.width/2, 40);
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:DMBSColor forState:UIControlStateNormal];
    [self.cancleView addSubview:_nextBtn];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 5, 1, 40)];
    downView.backgroundColor = UIColorRGB(237, 237, 237);
    [self.cancleView addSubview:downView];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)show {
    self.year = self.timeArr[0];
    self.month = [NSString stringWithFormat:@"%ld月", [self.timeArr[1] integerValue]];
    self.day = [NSString stringWithFormat:@"%ld日", [self.timeArr[2] integerValue]];
    self.hour = [NSString stringWithFormat:@"%ld时", [self.timeArr[3] integerValue]];
    self.minute = self.minuteArr[self.minuteArr.count / 2];
    
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
    [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:3 animated:YES];
    [self.pickerView selectRow:self.minuteArr.count / 2 inComponent:4 animated:YES];
    
    /// 刷新日
    [self refreshDay];
}

//#pragma mark - 点击方法
///// 保存按钮点击方法
//- (void)saveBtnClick {
//    NSLog(@"点击了保存");
//    NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
//    NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
//    NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
//    _sendTimeLbl.text = [NSString stringWithFormat:@"%@/%@:%@", day, hour, minute];
////    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
////        [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr];
////    }
//}
#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags =  NSCalendarUnitMonth;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSLog(@"%ld", (long)comp.month);
    

    NSString *day = self.day.length == 3 ? [NSString stringWithFormat:@"%ld", self.day.integerValue] : [NSString stringWithFormat:@"0%ld", self.day.integerValue];
    NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
    NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
    
    if (issendBtn){
        self.sendTimeLbl.text = [NSString stringWithFormat:@"%.2ld/%@ %@:%@",  (long)comp.month, day, hour, minute];
        _orderTime = [NSString stringWithFormat:@"%@-%.2ld-%@",strDate3,(long)comp.month,day];
        _orderhour = hour;
    }else{
        self.getTimeLbl.text = [NSString stringWithFormat:@"%.2ld/%@ %@:%@",  (long)comp.month, day, hour, minute];
        _returnTime = [NSString stringWithFormat:@"%@-%.2ld-%@",strDate3,(long)comp.month,day];
        _returnhour = hour;
    }
    
//    if ([self.delegate respondsToSelector:@selector(datePickerViewSaveBtnClickDelegate:)]) {
//        [self.delegate datePickerViewSaveBtnClickDelegate:self.selectStr];
//    }
}

/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if ([self.delegate respondsToSelector:@selector(datePickerViewCancelBtnClickDelegate)]) {
        [self.delegate datePickerViewCancelBtnClickDelegate];
    }
}
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 3;
    }else if (component == 1) {
        return 17;
    }else{
        return 12;
    }
}
// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSInteger time_integerValue = [self.timeArr[component] integerValue];
    switch (component) {
        case 0: { // 日
            NSLog(@"%ld", self.dayArr.count);
            self.day = self.dayArr[row%[self.dataArray[component] count]];
        } break;
        case 1: { // 时
            // 如果选择年大于当前年 就直接赋值时
            self.hour = self.hourArr[row%[self.dataArray[component] count]];
        } break;
        case 2: { // 分
            self.minute = self.minuteArr[row%[self.dataArray[component] count]];
        } break;
        default: break;
    }
    
    [self saveBtnClick];
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
        
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 44)];
    titleLbl.font = [UIFont systemFontOfSize:15];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    return titleLbl;
}


- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}
//
///// 获取年份
//- (NSMutableArray *)yearArr {
//    if (!_yearArr) {
//        _yearArr = [NSMutableArray array];
//        for (int i = 2017; i < 2018; i ++) {
//            [_yearArr addObject:[NSString stringWithFormat:@"%d年", i]];
//        }
//    }
//    return _yearArr;
//}

/// 获取月份
- (NSMutableArray *)monthArr {
    //    NSDate *today = [NSDate date];
    //    NSCalendar *c = [NSCalendar currentCalendar];
    //    NSRange days = [c rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:today];
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        
        for (int i = 7; i <= 7; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}


/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        // 获取代表公历的NSCalendar对象
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags =  kCFCalendarUnitDay;
        // 获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags
                                              fromDate:dt];
        NSLog(@"%ld", (long)comp.day);
        
        [self getNumberOfDaysInMonth];
        
        _dayArr = [NSMutableArray array];
        if (comp.day == 30) {
            _dayArr = @[@"30日",@"31日",@"1日"];
        }else if (comp.day == 31) {
            _dayArr = @[@"31日",@"1日",@"2日"];
        }else{
            for (int i = comp.day; i <= comp.day+2; i ++) {
                [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
            }
        }
    }
    return _dayArr;
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 5; i < 22; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i <= 55; i ++) {
            if (i % 5 == 0) {
                [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
                continue;
            }
        }
    }
    return _minuteArr;
}

// 获取当前的年月日时
- (NSArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd日,HH时,mm分"];
        NSDate *date = [NSDate date];
        NSString *time = [formatter stringFromDate:date];
        _timeArr = [time componentsSeparatedByString:@","];
    }
    return _timeArr;
}

// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd日,HH时,mm分"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


- (void)refreshDay {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d日", i]];
    }
    [self.dataArray replaceObjectAtIndex:2 withObject:arr];
    [self.pickerView reloadComponent:2];
}

- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}

// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}




@end
