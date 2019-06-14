//
//  CDPickerOperation.h
//  CDProgramme
//
//  Created by 王乾 on 2018/8/12.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CDPickerOperationType) {
    
    CDPickerOperationTypeDate = 0, //时间选择器
    CDPickerOperationTypePick = 1, //普通的选择器
};

typedef void(^CDSelectCompeleteBlock)(NSString *string);
@interface CDPickerOperation : UIView

//  普通的选择器
+ (CDPickerOperation *)creatPickTitile:(NSString *)titleString
                      selectSting:(NSString *)lastSting
                       itemsArray:(NSArray *)itemsArray
                          success:(CDSelectCompeleteBlock)success;

//  时间选择器
+ (CDPickerOperation *)creatDataTitile:(NSString *)titleString
                        selectSting:(NSString *)lastSting
                           success:(CDSelectCompeleteBlock)success;
@end




@interface UIPickerView (seqPickView)
// 去除分割线
- (void)clearSpearatorLine;

@end


@interface UIView (PickView)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end
