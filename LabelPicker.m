//
//  LabelPicker.m
//  focustoresaojie
//
//  Created by quanzhen on 2017/3/29.
//  Copyright © 2017年 qz. All rights reserved.
//

#import "LabelPicker.h"

@implementation LabelPicker
@synthesize LabelPickerDelegate;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _selectIndex=-1;
        _arrData=[[NSMutableArray alloc]init];
        [[self findViewController].view addSubview:self.pickerView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _pickerView.hidden=YES;
    _pickerView.frame=CGRectMake(0, ScreenHeight-216, ScreenWidth, 216);
    
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.textField.frame.size.width, self.textField.frame.size.height)];
    [btn addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.textField addSubview:btn];
    
    if (_arrData.count>0) {
        self.selectIndex=0;
        self.textField.text=[_arrData objectAtIndex:0];
    }
    
    if ([_rightImage length]>0) {
        UIImageView *imagev=[[UIImageView alloc]initWithImage:[UIImage imageNamed:_rightImage]];
        [self addSubview:imagev];
        imagev.center=CGPointMake(self.frame.size.width-imagev.image.size.width-5, self.frame.size.height/2);
    }
}
- (UIViewController *)findViewController
{
    id target=self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
-(void)showPicker
{
    self.pickerView.hidden=NO;
    if (_selectIndex>=0&&_selectIndex<_arrData.count) {
        [self.pickerView selectRow:_selectIndex inComponent:0 animated:YES];
    }
    if (_arrData.count>0) {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        self.selectIndex=row;
        self.textField.text=[_arrData objectAtIndex:row];
    }

    
    [_pickerView reloadAllComponents];
    
    UIViewController *vc= [self findViewController];
    UIButton *btn_hide=[[UIButton alloc]initWithFrame:vc.view.frame];
    btn_hide.tag=1100;
    [btn_hide addTarget:self action:@selector(closePicker) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:btn_hide];
    
    
    UIToolbar *tbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight-260, ScreenWidth, 44)];
    tbar.tag=1101;
    [tbar setBarStyle:UIBarStyleDefault];
    [vc.view addSubview:tbar];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(4, 5, 40, 25);
    [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closePicker) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [tbar setItems:buttonsArray];
    
    _pickerView.frame=CGRectMake(0, ScreenHeight-216, ScreenWidth, 216);
    _pickerView.tag=1102;
    [vc.view addSubview:_pickerView];
    
    
    if (self.LabelPickerDelegate&&[self.LabelPickerDelegate respondsToSelector:@selector(pickerSelect:didSelectViewTag:didSelectString:)]) {
        
        if (self.selectIndex>=0&&_arrData.count>self.selectIndex) {
            [LabelPickerDelegate pickerSelect:self.selectIndex didSelectViewTag:self.tag didSelectString:[self.arrData objectAtIndex:self.selectIndex]];
        }
        
        
    }
}
-(void)closePicker
{
    UIViewController *vc= [self findViewController];
    [[vc.view viewWithTag:1100] removeFromSuperview];
    [[vc.view viewWithTag:1101] removeFromSuperview];
    [[vc.view viewWithTag:1102] removeFromSuperview];
    self.pickerView.hidden=YES;
}
-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor=[UIColor whiteColor];
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_arrData count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_arrData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str = [_arrData objectAtIndex:row];
    
    self.textField.text=str;
    self.selectIndex=row;
    if (self.LabelPickerDelegate&&[self.LabelPickerDelegate respondsToSelector:@selector(pickerSelect:didSelectViewTag:didSelectString:)]) {
        [LabelPickerDelegate pickerSelect:row didSelectViewTag:self.tag didSelectString:str];
        
    }
}

-(void)reload
{
    if (_selectIndex>=0&&_selectIndex<_arrData.count) {
        self.textField.text=[_arrData objectAtIndex:_selectIndex];
    }
    if (self.LabelPickerDelegate&&[self.LabelPickerDelegate respondsToSelector:@selector(pickerSelect:didSelectViewTag:didSelectString:)]) {
        
        if (self.selectIndex>=0&&_arrData.count>self.selectIndex) {
            [LabelPickerDelegate pickerSelect:self.selectIndex didSelectViewTag:self.tag didSelectString:[self.arrData objectAtIndex:self.selectIndex]];
        }
        
        
    }
}
@end
