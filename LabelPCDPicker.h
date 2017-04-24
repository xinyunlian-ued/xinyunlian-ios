//
//  LabelPCDPicker.h
//  focustoresaojie
//
//  Created by quanzhen on 2017/3/30.
//  Copyright © 2017年 qz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelPicker.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "DistrictModel.h"
#import "XMLDictionary.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@protocol LabelPCDPickerDelegate <NSObject>
-(void)pickerSelect:(ProvinceModel *)provinceModel didSelectCityModel:(CityModel *)cityModel didSelectDistrictModel:(DistrictModel *)districtModel;
-(void)pickerClose;

@end

@interface LabelPCDPicker : LabelPicker<BMKGeoCodeSearchDelegate>
{
    id<LabelPCDPickerDelegate> LabelPCDPickerDelegate;
    NSMutableArray *arrDistrict;
    NSMutableArray *arrCity;
    NSMutableArray *arrProvince;
    NSArray *ProvinceList;
    NSInteger selectCityRow;
    NSInteger selectProvinceRow;
    NSInteger selectDistrictRow;
    BMKGeoCodeSearch *search;
    float latitude;
    float longitude;
    
    NSString *cityName;
    NSString *provinceName;
    NSString *districtName;
}
@property (nonatomic,strong)id<LabelPCDPickerDelegate> LabelPCDPickerDelegate;
@property (nonatomic,retain) ProvinceModel *pModel;
@property (nonatomic,retain) CityModel *cModel;
@property (nonatomic,retain) DistrictModel *dModel;
@end
