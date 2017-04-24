//
//  LabelPCDPicker.m
//  focustoresaojie
//
//  Created by quanzhen on 2017/3/30.
//  Copyright © 2017年 qz. All rights reserved.
//

#import "LabelPCDPicker.h"
@implementation LabelPCDPicker
@synthesize LabelPCDPickerDelegate;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        arrDistrict=[[NSMutableArray alloc]init];
        arrCity=[[NSMutableArray alloc]init];
        arrProvince=[[NSMutableArray alloc]init];
        
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"xml"]];
        ProvinceList = [xmlDoc objectForKey:@"Province"];
        latitude=[DataProvider shareProvider].latitude;
        longitude=[DataProvider shareProvider].longitude;
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.pModel&&self.cModel&&self.dModel) {
        cityName=self.cModel.cityName;
        provinceName=self.pModel.provinceName;
        districtName=self.dModel.districtName;
        [self loadCityWithProvinceName:provinceName cityName:cityName districtName:districtName];
    }
    else
    {
        [self getAddress];
    }
    
}

-(void)getAddress
{
    if (latitude>0&&longitude>0) {
        search = [[BMKGeoCodeSearch alloc]init];
        search.delegate=self;
        BMKReverseGeoCodeOption *opt=[[BMKReverseGeoCodeOption alloc]init];
        opt.reverseGeoPoint=CLLocationCoordinate2DMake(latitude, longitude);
        [search reverseGeoCode:opt];
    }
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if ([result.address length]>0)
    {
        cityName=[NSString stringWithString:result.addressDetail.city];
        provinceName=[NSString stringWithString:result.addressDetail.province];
        districtName=[NSString stringWithString:result.addressDetail.district];
        [self loadCityWithProvinceName:provinceName cityName:cityName districtName:districtName];
    }
}

#pragma mark -获取地区id-
-(void)loadCityWithProvinceName:(NSString *)inputProvinceName cityName:(NSString *)inputCityName districtName:(NSString *)inputDistrictName
{
    [arrDistrict removeAllObjects];
    [arrCity removeAllObjects];
    [arrProvince removeAllObjects];
    for (int i=0; i<ProvinceList.count; i++)
    {
        NSDictionary *dict_province=[ProvinceList objectAtIndex:i];
        
        ProvinceModel *pmodel=[[ProvinceModel alloc]init];
        pmodel.provinceId=[NSString stringWithFormat:@"%@",[dict_province objectForKey:@"provinceId"]];
        pmodel.provinceName=[NSString stringWithFormat:@"%@",[dict_province objectForKey:@"provinceName"]];
        [arrProvince addObject:pmodel];
        
        if ([pmodel.provinceName isEqualToString:inputProvinceName])
        {
            selectProvinceRow=i;
            NSDictionary *cityList=[dict_province objectForKey:@"cityList"];
            id City=[cityList objectForKey:@"City"];
            
            NSMutableArray *arr_city=[NSMutableArray array];
            if ([City isKindOfClass:[NSArray class]]) {
                [arr_city addObjectsFromArray:City];
            }
            else if ([City isKindOfClass:[NSDictionary class]])
            {
                [arr_city addObject:City];
            }
            else
            {
                selectCityRow=-1;
                selectDistrictRow=-1;
            }
            
            for (int j=0; j<arr_city.count; j++)
            {
                NSDictionary *dict_city=[arr_city objectAtIndex:j];
                CityModel *cityModel=[[CityModel alloc]init];
                cityModel.cityName=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityName"]];
                cityModel.cityId=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityId"]];
                [arrCity addObject:cityModel];
                
                if ([cityModel.cityName isEqualToString:inputCityName])
                {
                    selectCityRow=j;
                    id districtObj=[[dict_city objectForKey:@"districtList"] objectForKey:@"District"];
                    NSMutableArray *districtList=[NSMutableArray array];
                    if ([districtObj isKindOfClass:[NSDictionary class]])
                    {
                        [districtList addObject:districtObj];
                    }
                    else if ([districtObj isKindOfClass:[NSArray class]])
                    {
                        [districtList addObjectsFromArray:districtObj];
                    }
                    else
                    {
                        selectDistrictRow=-1;
                    }
                    
                    
                    for (int m=0; m<districtList.count; m++) {
                        NSDictionary *dict_District=[districtList objectAtIndex:m];
                        DistrictModel *districtModel=[[DistrictModel alloc]init];
                        districtModel.districtId=[NSString stringWithFormat:@"%@",[dict_District objectForKey:@"districtId"]];
                        districtModel.districtName=[NSString stringWithFormat:@"%@",[dict_District objectForKey:@"districtName"]];
                        [arrDistrict addObject:districtModel];
                        
                        if ([districtModel.districtName isEqualToString:inputDistrictName]) {
                            selectDistrictRow=m;
                            
                        }
                    }
                }
            }
        }
    }
    
    [self.pickerView reloadAllComponents];
    if (selectProvinceRow>=0&&selectCityRow>=0&&selectDistrictRow>=0) {
        [self.pickerView selectRow:selectProvinceRow inComponent:0 animated:YES];
        [self.pickerView selectRow:selectCityRow inComponent:1 animated:YES];
        [self.pickerView selectRow:selectDistrictRow inComponent:2 animated:YES];
        
    }
    [self responeData];
    if (self.LabelPCDPickerDelegate&&[self.LabelPCDPickerDelegate respondsToSelector:@selector(pickerClose)]) {
        [self.LabelPCDPickerDelegate pickerClose];
    }
}
-(void)loadCity
{
    [arrDistrict removeAllObjects];
    [arrCity removeAllObjects];
    [arrProvince removeAllObjects];
    for (int i=0; i<ProvinceList.count; i++)
    {
        NSDictionary *dict_province=[ProvinceList objectAtIndex:i];
        
        ProvinceModel *pmodel=[[ProvinceModel alloc]init];
        pmodel.provinceId=[NSString stringWithFormat:@"%@",[dict_province objectForKey:@"provinceId"]];
        pmodel.provinceName=[NSString stringWithFormat:@"%@",[dict_province objectForKey:@"provinceName"]];
        [arrProvince addObject:pmodel];
        
        if (i==selectProvinceRow)
        {
            NSDictionary *cityList=[dict_province objectForKey:@"cityList"];
            id City=[cityList objectForKey:@"City"];
            if ([City isKindOfClass:[NSArray class]])
            {
                NSArray *arr_city=(NSArray *)City;
                for (int j=0; j<arr_city.count; j++) {
                    NSDictionary *dict_city=[arr_city objectAtIndex:j];
                    CityModel *cityModel=[[CityModel alloc]init];
                    cityModel.cityName=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityName"]];
                    cityModel.cityId=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityId"]];
                    [arrCity addObject:cityModel];
                    
                    if (selectCityRow==j) {
                        id districtList=[[dict_city objectForKey:@"districtList"] objectForKey:@"District"];
                        [self makeDistrict:districtList];
                    }
                }
            }
            else if ([City isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict_city=(NSDictionary *)City;
                CityModel *cityModel=[[CityModel alloc]init];
                cityModel.cityName=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityName"]];
                cityModel.cityId=[NSString stringWithFormat:@"%@",[dict_city objectForKey:@"cityId"]];
                [arrCity addObject:cityModel];
                
                id districtObj=[[dict_city objectForKey:@"districtList"] objectForKey:@"District"];
                [self makeDistrict:districtObj];
                
                //selectCityRow=0;
                //selectDistrictRow=0;
            }
            else
            {
                selectCityRow=-1;
                selectDistrictRow=-1;
            }
        }
    }
    [self.pickerView reloadAllComponents];
}
-(void)makeDistrict:(id)sender
{
    if ([sender isKindOfClass:[NSArray class]])
    {
        NSArray *districtList=(NSArray *)sender;
        for (int m=0; m<districtList.count; m++) {
            NSDictionary *dict_District=[districtList objectAtIndex:m];
            DistrictModel *districtModel=[[DistrictModel alloc]init];
            districtModel.districtId=[NSString stringWithFormat:@"%@",[dict_District objectForKey:@"districtId"]];
            districtModel.districtName=[NSString stringWithFormat:@"%@",[dict_District objectForKey:@"districtName"]];
            [arrDistrict addObject:districtModel];
        }
    }
    else if ([sender isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *districtList=(NSDictionary *)sender;
        DistrictModel *districtModel=[[DistrictModel alloc]init];
        districtModel.districtId=[NSString stringWithFormat:@"%@",[districtList objectForKey:@"districtId"]];
        districtModel.districtName=[NSString stringWithFormat:@"%@",[districtList objectForKey:@"districtName"]];
        [arrDistrict addObject:districtModel];
    }
}
-(void)setPCDPickerSelectIndex
{
    if (selectProvinceRow<arrProvince.count) {
        [self.pickerView selectRow:selectProvinceRow inComponent:0 animated:NO];
    }
    if (selectCityRow<arrCity.count) {
        [self.pickerView selectRow:selectCityRow inComponent:1 animated:NO];
    }
    if (selectDistrictRow<arrDistrict.count) {
        [self.pickerView selectRow:selectDistrictRow inComponent:2 animated:NO];
    }
    
}

-(void)closePicker
{
    [super closePicker];
    if (self.LabelPCDPickerDelegate&&[self.LabelPCDPickerDelegate respondsToSelector:@selector(pickerClose)]) {
        [self.LabelPCDPickerDelegate pickerClose];
    }
}
#pragma mark -picker
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [arrProvince count];
    }
    else if (component==1)
    {
        return [arrCity count];
    }
    else if (component==2)
    {
        return [arrDistrict count];
    }
    
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        ProvinceModel *model=[arrProvince objectAtIndex:row];
        return model.provinceName;
    }
    else if (component==1)
    {
        CityModel *model=[arrCity objectAtIndex:row];
        return model.cityName;
    }
    else if (component==2)
    {
        DistrictModel *model=[arrDistrict objectAtIndex:row];
        return model.districtName;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        selectProvinceRow=row;
        selectCityRow=0;
        selectDistrictRow=0;
        [self loadCity];
        [self setPCDPickerSelectIndex];
    }
    else if (component==1)
    {
        selectCityRow=row;
        selectDistrictRow=0;
        [self loadCity];
        [self setPCDPickerSelectIndex];
    }
    else if (component==2)
    {
        selectDistrictRow=row;
    }
    
    [self responeData];
}

-(void)responeData
{
    if (self.LabelPCDPickerDelegate&&[self.LabelPCDPickerDelegate respondsToSelector:@selector(pickerSelect:didSelectCityModel:didSelectDistrictModel:)]) {
        
        _pModel= nil;
        if (selectProvinceRow>=0&&selectProvinceRow<arrProvince.count) {
            _pModel = [arrProvince objectAtIndex:selectProvinceRow];
        }
        
        _cModel=nil;
        
        if (selectCityRow>=0&&selectCityRow<arrCity.count) {
            _cModel = [arrCity objectAtIndex:selectCityRow];
        }
        
        _dModel=nil;
        
        if (selectDistrictRow>=0&&selectDistrictRow<arrDistrict.count) {
            _dModel = [arrDistrict objectAtIndex:selectDistrictRow];
        }
        
        [LabelPCDPickerDelegate pickerSelect:_pModel didSelectCityModel:_cModel didSelectDistrictModel:_dModel];
        self.textField.text=[NSString stringWithFormat:@"%@%@%@",_pModel.provinceName,_cModel.cityName,_dModel.districtName];
        
    }
}
@end
