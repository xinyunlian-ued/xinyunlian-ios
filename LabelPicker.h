//
//  LabelPicker.h
//  focustoresaojie
//
//  Created by quanzhen on 2017/3/29.
//  Copyright © 2017年 qz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelTextFieldView.h"

@protocol LabelPickerDelegate <NSObject>
-(void)pickerSelect:(NSInteger)row didSelectViewTag:(NSInteger)tag didSelectString:(NSString *)string;

@end

@interface LabelPicker : LabelTextFieldView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    id<LabelPickerDelegate> LabelPickerDelegate;
}
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic,retain) UIPickerView *pickerView;
@property (nonatomic,retain) NSMutableArray *arrData;
@property (nonatomic,retain) NSString *rightImage;
@property (nonatomic,strong)id<LabelPickerDelegate> LabelPickerDelegate;
-(void)closePicker;
-(void)reload;
@end
