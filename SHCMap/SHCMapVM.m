//
//  SHCMapVM.m
//  Pods-SHCMap_Example
//
//  Created by 邵焕超 on 2018/3/28.
//

#import "SHCMapVM.h"

@interface SHCMapVM() <AMapSearchDelegate>

@property(nonatomic, strong)AMapPOISearchResponse *responsePOI;
@property(nonatomic, strong)AMapReGeocodeSearchResponse *responseRE;

@end

@implementation SHCMapVM

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.search = [AMapSearchAPI new];
    self.searchPoiArr = [NSMutableArray new];
    self.locationPoi = [AMapPOI new];
    self.locationPoi = [AMapPOI new];
    
    self.search.delegate = self;
  }
  return self;
}

//MARK: - 对外的方法
-(void)refreshMapViewData:(CLLocationCoordinate2D)location {
  [self refreshMapViewData:location name:@""];
}
-(void)refreshMapViewData:(CLLocationCoordinate2D)location name:(NSString *)name {
  _searchLocation = location;
  _searchName = name;
  
  [_searchPoiArr removeAllObjects];
  _searchPage = 1;
  
  if (_currtyType == SearchView) { _lastSelectCell = 0; }
  if (_currtyType == Move) { _lastSelectCell = -1; }
  
  switch (_currtyType) {
    case Select:     [self searchPoi: _searchLocation]; break;
    case Move:       [self reGeocod:  _searchLocation]; break;
    case SearchView: [self searchName:_searchName]; break;
  }
}

-(void)loadMapViewData {
  self.searchPage ++;
  switch (_currtyType) {
    case Select: [self searchPoi: _searchLocation]; break;
    case Move: [self searchPoi: _searchLocation]; break;
    case SearchView: [self searchName:_searchName]; break;
  }
}

// MARK: - 自定义的方法
/// 搜索POI（周边）
-(void)searchPoi:(CLLocationCoordinate2D)location {
  AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc] init];
  request.location = [AMapGeoPoint locationWithLatitude:location.latitude
                                              longitude:location.longitude];
  request.radius = 2000;
  request.sortrule = 0;
  request.types = @"商务住宅|科教文化服务|住宿服务|医疗保健服务";
  request.page = self.searchPage;
  request.requireExtension = YES;
  [self.search AMapPOIAroundSearch:request];
}

/// 逆向
-(void)reGeocod:(CLLocationCoordinate2D)location {
  // 同时搜索周边
  [self searchPoi:location];
  AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc] init];
  request.location = [AMapGeoPoint locationWithLatitude:location.latitude
                                              longitude:location.longitude];
  request.radius = 2000;
  request.requireExtension = YES;
  [self.search AMapReGoecodeSearch:request];
}

///关键字
-(void)searchName:(NSString *)name{
  if ([name isEqual: @""]) { return; }
  AMapPOIKeywordsSearchRequest * request = [[AMapPOIKeywordsSearchRequest alloc] init];
  request.city = self.searchCity;
  request.keywords = name;
  request.page = self.searchPage;
  request.requireExtension = YES;
  [self.search AMapPOIKeywordsSearch:request];
}

// MARK: - 地图搜索代理
/// 失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
  NSLog(@"Error:%@",error.description);
}

/// 附近
-(void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response{
  NSLog(@"%@",response.infos);
}

/// 逆向地理编码
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
  if (response.regeocode.pois.count != 0 && self.currtyType == Move) {
    self.responseRE = response;
    [self moveSearch];
  }
}

/// POI检索
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
  if ([self.searchCity isEqualToString:@""]) { self.searchCity = response.pois.firstObject.city; }
  if (self.currtyType == Move && self.searchPage == 1) {
    self.responsePOI = response;
    [self moveSearch];
    return;
  }
  [self.searchPoiArr addObjectsFromArray:response.pois];
  if (response.pois.count != 0) {
    [self.delegate mapVM:self poiArr:response.pois];
  }
  if (self.currtyType == SearchView && self.searchPage == 1 && response.pois.count == 0) {
    [self.delegate mapVM:self searchIsEmpty:YES];
  }
}

/// 滑动搜索的处理
-(void)moveSearch {
  if (self.responseRE == nil) { return; }
  if (self.responsePOI == nil) {return; }
  
  // 逆向的处理 -> 自制一个顶部poi数据
  AMapRoad *road = [[AMapRoad alloc] init]; // 道路
  if (self.responseRE.regeocode.aois.count != 0) {
    road = self.responseRE.regeocode.roads.firstObject;
  }
  
  AMapAOI *aoi = [[AMapAOI alloc] init]; // 兴趣区域
  if (self.responseRE.regeocode.roads.count != 0) {
    aoi = self.responseRE.regeocode.aois.firstObject;
  }
  
  AMapPOI *poi = self.responseRE.regeocode.pois.firstObject;
  poi.uid = @"sp0"; // 用户识别自制的POI
  poi.location.latitude = self.searchLocation.latitude;
  poi.location.longitude = self.searchLocation.longitude;

  NSString *str = (road.distance < 5) ? @"" : [NSString stringWithFormat:@"%ld米", (long)road.distance];
  if ([aoi.name isEqualToString:@""]) {
    poi.name = [road.name stringByAppendingString:str];
  }else {
    poi.name = [aoi.name stringByAppendingFormat:@" (%@%@)" ,road.name ,str];
  }
  
  self.locationPoi = poi; // 记录

  [self.searchPoiArr arrayByAddingObjectsFromArray: self.responsePOI.pois];
  [self.delegate mapVM:self searchIsEmpty: YES];
  
  self.responseRE = nil;
  self.responsePOI = nil;
}

@end
