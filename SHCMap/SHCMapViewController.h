//
//  SHCMapViewController.h
//  Pods-SHCMap_Example
//
//  Created by 邵焕超 on 2018/3/27.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface SHCMapViewController : UIViewController
/**
 初始化方法
 
 @param location 位置
 @param name 名字
 @param isNeedCheckMartets 是否存在市场
 @param isPrsent 是否model出来
 */
-(void)ShowMapView:(CLLocationCoordinate2D)location name:(NSString *)name isNeedCheckMartets:(BOOL)isNeedCheckMartets isPrsent:(BOOL)isPrsent;
  
@end
