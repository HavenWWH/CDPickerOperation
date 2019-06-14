//
//  CDPickerOperation.m
//  CDProgramme
//
//  Created by 王乾 on 2018/8/12.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDPickerOperation.h"
#import <objc/runtime.h>

#define PORGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define PORGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define POSCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define POSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CDPickerOperation ()<UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *proTitleListArrays;

@property (nonatomic, assign) CDPickerOperationType pickerType;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *lastString;
@property (nonatomic, copy) CDSelectCompeleteBlock success;

@property (nonatomic, copy) NSString *selectedString;

@end

@implementation CDPickerOperation
//  普通的选择器
+ (CDPickerOperation *)creatPickTitile:(NSString *)titleString
                           selectSting:(NSString *)lastSting
                            itemsArray:(NSArray *)itemsArray
                               success:(CDSelectCompeleteBlock)success {
    CDPickerOperation *oprataion = [[CDPickerOperation alloc] initWithTitle:titleString selectSting:lastSting itemsArray:itemsArray success:success pickerOperationType:CDPickerOperationTypePick];
    [oprataion show];
    return oprataion;
}

//  时间选择器
+ (CDPickerOperation *)creatDataTitile:(NSString *)titleString
                           selectSting:(NSString *)lastSting
                               success:(CDSelectCompeleteBlock)success {
    CDPickerOperation *oprataion = [[CDPickerOperation alloc] initWithTitle:titleString selectSting:lastSting itemsArray:nil success:success pickerOperationType:CDPickerOperationTypeDate];
    [oprataion show];
    return oprataion;
}
- (instancetype)initWithTitle:(NSString *)titleString
                  selectSting:(NSString *)lastSting
                   itemsArray:(NSArray *)itemsArray
                      success:(CDSelectCompeleteBlock)success
          pickerOperationType:(CDPickerOperationType)type {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, POSCREEN_WIDTH, POSCREEN_HEIGHT)]) {
        
        _titleString = [titleString copy];
        _lastString = [lastSting copy];
        if ([itemsArray count] > 0) {
            [self.proTitleListArrays addObjectsFromArray:itemsArray];
        }
        _success = success;
        _pickerType = type;
        
         [self setupView];
    }
    return self;
}
#pragma mark - Intial Methods
- (void)setupView {
    
    [self addSubview:self.bottomView];
    
    if (_pickerType == CDPickerOperationTypePick) {

        UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, POSCREEN_WIDTH, 216)];
        pick.delegate = self;
        pick.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:pick];

        if (_lastString.length > 0) {
            if ([self.proTitleListArrays containsObject:_lastString]) {
                NSUInteger index = [self.proTitleListArrays indexOfObject:_lastString];
                [pick selectRow:index inComponent:0 animated:NO];
            }
        }
    } else {

        UIDatePicker *datePickr = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44,POSCREEN_WIDTH, 216)];
        datePickr.backgroundColor = [UIColor whiteColor];
        [datePickr setDatePickerMode:UIDatePickerModeDate];
        [datePickr setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];

        [datePickr setMaximumDate:[NSDate date]];
        //        [datePickr setMinimumDate:[NSDate date]];
        [datePickr addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        if (_lastString.length > 0 && ![_lastString isEqualToString:@"未设置"]) {

            NSDate *lastDate = [self conversionDateFromDateString:_lastString withDateFormat:@"yyyy-MM-dd"];
            [datePickr setDate:lastDate];
            _selectedString = _lastString;
        }
        [self modifyTheDatePicker:datePickr];
        [self.bottomView addSubview:datePickr];
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *bottomViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapGesture:)];
    [self.bottomView addGestureRecognizer:bottomViewTapGesture];
}



#pragma mark - Private Method
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture {
    
    [self hidden];
}

- (void)bottomViewTapGesture:(UITapGestureRecognizer *)tapGesture {
    
}
- (NSDate *)conversionDateFromDateString:(NSString *)dateString withDateFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _selectedString = [formatter stringFromDate:datePicker.date];
}
- (void)modifyTheDatePicker:(UIDatePicker *)datePicker {
    unsigned int outCount;
    int i;
    
    objc_property_t *pProperty = class_copyPropertyList([UIDatePicker class], &outCount);
    
    for (i = outCount -1; i >= 0; i--) {
        
        // 循环获取属性的名字   property_getName函数返回一个属性的名称
        
        NSString *getPropertyName = [NSString stringWithCString:property_getName(pProperty[i]) encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",getPropertyName);
        
        if([getPropertyName isEqualToString:@"textColor"]) {
            
            [datePicker setValue:PORGB(41, 42, 46) forKey:@"textColor"];
        }
    }
    
    ///修改最大最小时间颜色的BUG
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    
    //NSInvocation;用来包装方法和对应的对象，它可以存储方法的名称，对应的对象，对应的参数,
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    
    BOOL no = NO;
    
    [invocation setSelector:selector];
    
    //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用
    
    [invocation setArgument:&no atIndex:2];
    
    [invocation invokeWithTarget:datePicker];
    
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.proTitleListArrays count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44.f;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectedString = [self.proTitleListArrays objectAtIndex:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, POSCREEN_WIDTH, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text =[self.proTitleListArrays objectAtIndex:row];
    myView.font = [UIFont systemFontOfSize:16.0];
    myView.backgroundColor = [UIColor clearColor];
    [pickerView clearSpearatorLine];
    return myView;
}
#pragma mark - Public Methods
- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    self.bottomView.top = POSCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.backgroundColor = PORGBA(0, 0, 0, 0.65);
        self.bottomView.top = POSCREEN_HEIGHT - 260;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hidden {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.bottomView.top = POSCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}
- (void)cancel:(UIButton *)btn {
    [self hidden];
}
- (void)submit:(UIButton *)btn  {
    
    [self hidden];
    
    NSString *pickStr = _selectedString;
    if (!pickStr || pickStr.length == 0) {
        if(_pickerType == CDPickerOperationTypeDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            _selectedString = [formatter stringFromDate:[NSDate date]];
        } else {
            if (_lastString.length > 0 && ![_lastString isEqualToString:@"请选择"]) {
                _selectedString = _lastString;
            } else {
                if (self.proTitleListArrays.count != 0) {
                    _selectedString = self.proTitleListArrays[0];
                }
            }
        }
    }
    
    NSLog(@"选中字段:   %@",_selectedString);

    if (_success) {
        _success(_selectedString);
    }
    
}
#pragma mark - Target Methods

#pragma mark - Setter Getter Methods
- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, POSCREEN_WIDTH, 260)];
        _bottomView.backgroundColor = [UIColor whiteColor];
//        _bottomView.clipsToBounds = true;
//        _bottomView.layer.cornerRadius = CDREALVALUE_WIDTH(4);
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, POSCREEN_WIDTH - 100, 44)];
        titleLbl.text = self.titleString;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = PORGB(41, 42, 46);
        titleLbl.font = [UIFont systemFontOfSize:16.0];
        [_bottomView addSubview:titleLbl];
        
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
        submit.frame = CGRectMake(_bottomView.width - 50, 0, 50, 44);
        [submit setTitle:@"确定" forState:UIControlStateNormal];
        [submit setTitleColor:PORGB(255,136,32) forState:UIControlStateNormal];
        submit.backgroundColor = [UIColor whiteColor];
        submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:submit];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 50 ,submit.frame.size.height);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:PORGB(255,136,32) forState:UIControlStateNormal];
        cancel.backgroundColor = [UIColor whiteColor];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLbl.bottom - 1, _bottomView.width, 1.f)];
        lineView.backgroundColor = PORGB(238,238,238);
        [_bottomView addSubview:lineView];
    }
    return _bottomView;
}
- (NSMutableArray *)proTitleListArrays {
    
    if (!_proTitleListArrays) {
        _proTitleListArrays = [NSMutableArray array];
    }
    return _proTitleListArrays;
}
@end

@implementation UIPickerView (seqPickView)
- (void)clearSpearatorLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}
@end


@implementation UIView (PickView)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
