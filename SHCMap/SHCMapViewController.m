//
//  SHCMapViewController.m
//  Pods-SHCMap_Example
//
//  Created by 邵焕超 on 2018/3/27.
//

#import "SHCMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SHCMapVM.h"

CGFloat const Mapheight = 200;

@interface SHCMapViewController () <MAMapViewDelegate, SHCMapVMDelegate, UITableViewDelegate, UITableViewDataSource>

//@property(nonatomic, retain)UINavigationController *navigation;
@property(nonatomic, retain)UIImageView *icon;
@property(nonatomic, retain)UISearchBar *searchView;
@property(nonatomic, retain)MAMapView   *mapView;
@property(nonatomic, retain)UIButton    *goLocation;
@property(nonatomic, retain)UITableView *tableView;

@property(nonatomic, strong)SHCMapVM *viewModel;

@end

@implementation SHCMapViewController
// MARK: - 初始化方法
-(void)ShowMapView:(CLLocationCoordinate2D)location name:(NSString *)name isNeedCheckMartets:(BOOL)isNeedCheckMartets isPrsent:(BOOL)isPrsent{
  self.viewModel.newUserLocation = location;
  self.viewModel.userName = name;
  self.viewModel.isNeedCheckMartets = &(isNeedCheckMartets);
  self.viewModel.isPrsent = &(isPrsent);
}

// MARK: - 系统方法
- (void)viewDidLoad {
  [super viewDidLoad];
  [self buildUI];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.viewModel.searchPoiArr.count != 0) { return; }
  /// 没定位
  if ([self isLocationNil: self.viewModel.newUserLocation]) {
    // 增加一个关闭定位进来判断
    if ([self isLocationNil: self.mapView.userLocation.coordinate]) {
      self.viewModel.searchCity = @"广州";
      CLLocationCoordinate2D location = CLLocationCoordinate2DMake(23.129112, 113.264385);
      [self.viewModel refreshMapViewData:location];
      [self.mapView setCenterCoordinate:location animated:true];
    }else {
      [self.viewModel refreshMapViewData:self.mapView.userLocation.coordinate];
    }
    return;
  }
  // 有定位
  self.viewModel.currtyType = Select;
  self.viewModel.lastSelectCell = -1;
  [self.viewModel refreshMapViewData:self.viewModel.newUserLocation];
  [self.mapView setCenterCoordinate:self.viewModel.newUserLocation animated:true];
}

// MARK: - 自定义方法
-(void)addOntAnnotation:(BOOL) isMove {
  if (_viewModel.searchPoiArr.count == 0) { return; }
  AMapPOI *poi = _viewModel.searchPoiArr.firstObject;
  CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(poi.location.latitude,
                                                          poi.location.longitude);
  if (isMove) { [_mapView setCenterCoordinate:c2d animated:true]; }
}

-(void)goLocationEvent {
  NSLog(@"haha");
}

-(BOOL)isLocationNil:(CLLocationCoordinate2D) c2d {
  if (c2d.latitude == 0 && c2d.longitude == 0){ return true;
  }else { return false; }
}

-(void)emptySearchView {
  _searchView.text = @"";
  [self endEditingKey: true];
}

-(void)endEditingKey:(BOOL) isExit {
  [self.view endEditing:isExit];
}

-(void)pageInTabelView:(int) page{
  // 第一页数据回去TableView顶部
  if (page == 1){
    _tableView.contentOffset = CGPointMake(0, 0);
    [_tableView reloadData];
  }else {
    [_tableView reloadData];
  }
}

// MARK: - UI设置
-(void)buildUI {
  [self.view addSubview: self.mapView];
  [self.view addSubview: self.tableView];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.mapView addSubview: self.icon];
  [self.mapView addSubview: self.searchView];
  [self.mapView addSubview: self.goLocation];
  
  self.viewModel = [SHCMapVM new];
  self.viewModel.delegate = self;
}

-(UIImageView *)icon {
  if (_icon == nil) {
    _icon = [UIImageView new];
    _icon.frame = CGRectMake(self.mapView.frame.size.width / 2 - 5, Mapheight / 2 - 5, 10, 10);
    _icon.backgroundColor = [UIColor redColor];
  }
  return _icon;
}

-(UISearchBar *)searchView {
  if (_searchView == nil) {
    _searchView = [UISearchBar new];
    _searchView.frame = CGRectMake(5, 0, self.mapView.frame.size.width, 20);
    _searchView.backgroundColor = [UIColor redColor];
  }
  return _searchView;
}

-(UIButton *)goLocation {
  if (_goLocation == nil) {
    _goLocation = [UIButton new];
    _goLocation.frame = CGRectMake(self.mapView.frame.size.width - 10, Mapheight-10, 10, 10);
    _goLocation.backgroundColor = [UIColor redColor];
    [_goLocation addTarget:self
                    action:@selector(goLocationEvent)
          forControlEvents:UIControlEventTouchUpInside];
  }
  return _goLocation;
}

-(MAMapView *)mapView {
  if (_mapView == nil) {
    _mapView = [[MAMapView alloc] init];
    _mapView.frame = CGRectMake(0, [self navigaBar], [self screenWidth], Mapheight);
    _mapView.delegate = self;
    _mapView.showsCompass = false;
    _mapView.showsUserLocation = true;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.distanceFilter = 10.0;
    _mapView.zoomLevel = 15;
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    
  }
  return _mapView;
}

-(UITableView *)tableView {
  if (_tableView == nil) {
    _tableView = [UITableView new];
    _tableView.frame = CGRectMake(0, self.mapView.frame.origin.y + Mapheight, [self screenWidth], [self screenHeight] - (self.mapView.frame.origin.y + Mapheight));
    _tableView.backgroundColor = [UIColor yellowColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cell"];
  }
  return _tableView;
}

// MARK: - 常量属性
-(CGFloat)screenWidth {
  return [UIScreen mainScreen].bounds.size.width;
}
-(CGFloat)screenHeight {
  return [UIScreen mainScreen].bounds.size.height;
}
-(CGFloat)navigaBar {
  return UIApplication.sharedApplication.statusBarFrame.size.height + 44;
}

// MARK: - delegate
/// tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _viewModel.searchPoiArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  cell.textLabel.text = _viewModel.searchPoiArr[indexPath.item].name;
  return cell;
}
/// 地图代理
-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
  
}

/// ViewModel代理
- (void)mapVM:(SHCMapVM *)soure poiArr:(NSArray<AMapPOI *> *)bpoiArr{
  switch (_viewModel.currtyType) {
    case Select: break;
    case Move:
      [self addOntAnnotation:false];
      [self emptySearchView];
      break;
    case SearchView:
      [self addOntAnnotation:true];
      break;
  }
  [self pageInTabelView:_viewModel.searchPage];
}
- (void)mapVM:(SHCMapVM *)soure searchIsEmpty:(BOOL)isEmpty{
  // -- 空白页
  [self pageInTabelView: _viewModel.searchPage];
}
- (void)mapVM:(SHCMapVM *)soure errorStr:(NSString *)answer{
  NSLog(@"%@", answer);
}

@end

