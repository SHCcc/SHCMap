//
//  SHCMapVM.h
//  Pods-SHCMap_Example
//
//  Created by 邵焕超 on 2018/3/28.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@class SHCMapVM;

@protocol SHCMapVMDelegate <NSObject>
- (void)mapVM:(SHCMapVM *)soure poiArr:(NSArray<AMapPOI *> *)bpoiArr;
- (void)mapVM:(SHCMapVM *)soure searchIsEmpty:(BOOL)isEmpty;
- (void)mapVM:(SHCMapVM *)soure errorStr:(NSString *)answer;
@end

@interface SHCMapVM : NSObject
/// 地图类型
enum MapType{
  Select,
  Move,
  SearchView
};

@property(nonatomic, weak)id <SHCMapVMDelegate> delegate;

@property(nonatomic, strong)AMapSearchAPI *search;
/// 当前地图类型
@property(nonatomic, assign)enum MapType currtyType;
/// 搜索结果
@property(nonatomic, strong)NSMutableArray<AMapPOI *> *searchPoiArr;

//  --- 标记属性
/// 是否判断存在市场,默认判断
@property(nonatomic, assign)BOOL isNeedCheckMartets;
/// 是否model出来
@property(nonatomic, assign)BOOL isPrsent;
/// 创建时是否有经纬度
@property(nonatomic, assign)CLLocationCoordinate2D newUserLocation;
/// 创建时是否有名字
@property(nonatomic, copy)NSString *userName;
/// 当前位置的POI -> 存储自制的POI
@property(nonatomic, strong)AMapPOI *locationPoi;
/// 搜索城市 -> 用户当前城市
@property(nonatomic, copy)NSString *searchCity;
/// 搜索的位置 -> 大头针位置
@property(nonatomic, assign)CLLocationCoordinate2D searchLocation;
/// 搜索的名字
@property(nonatomic, copy)NSString *searchName;
/// 搜索结果的页数
@property(nonatomic, assign)int searchPage;
/// 选中的cell
@property(nonatomic, assign)int lastSelectCell;

- (void)refreshMapViewData:(CLLocationCoordinate2D)location;
- (void)refreshMapViewData:(CLLocationCoordinate2D)location name:(NSString *)name;
- (void)loadMapViewData;
@end
