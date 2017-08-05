//
//  CommnuityViewControler.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/8.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "CommnuityViewControler.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "PlaceAroundTableView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MainViewController.h"

@interface CommnuityViewControler ()<MAMapViewDelegate, PlaceAroundTableViewDeleagate>

@property (nonatomic, strong) MAMapView            *mapView;
@property (nonatomic, strong) AMapSearchAPI        *search;
@property (nonatomic, strong) PlaceAroundTableView *tableview;
@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL                  isLocated;

@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;
@property (nonatomic, assign) NSInteger             searchPage;

@property (nonatomic, strong) UISegmentedControl    *searchTypeSegment;
@property (nonatomic, copy) NSString               *currentType;
@property (nonatomic, copy) NSArray                *searchTypes;

@end

@implementation CommnuityViewControler

#pragma mark - Utility
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
    self.title = @"选择小区";
}
- (void)popTo{
    MainViewController *con = [[MainViewController alloc]init];
    [self.navigationController pushViewController:con animated:NO];
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    
    request.radius   = 1000;
    request.types = self.currentType;
    request.sortrule = 0;
    request.page     = self.searchPage;
    request.keywords = @"小区";
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone)
    {
        [self actionSearchAroundAt:self.mapView.centerCoordinate];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - TableViewDelegate

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    
    [self.mapView setCenterCoordinate:location animated:YES];
    
    [NSThread sleepForTimeInterval:0.5];
    MainViewController *con = [[MainViewController alloc]init];
    
    [self.navigationController pushViewController:con animated:NO];
}

- (void)didPositionCellTapped
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    
    [NSThread sleepForTimeInterval:0.5];
    MainViewController *con = [[MainViewController alloc]init];
    
    [self.navigationController pushViewController:con animated:NO];
}

- (void)didLoadMorePOIButtonTapped
{
    self.searchPage++;
    [self searchPoiWithCenterCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - userLocation

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
        [self actionSearchAroundAt:userLocation.location.coordinate];
    }
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone)
    {
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }
    else
    {
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

#pragma mark - Handle Action

- (void)actionSearchAroundAt:(CLLocationCoordinate2D)coordinate
{
    [self searchReGeocodeWithCoordinate:coordinate];
    [self searchPoiWithCenterCoordinate:coordinate];
    
    self.searchPage = 1;
    [self centerAnnotationAnimimate];
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

- (void)actionTypeChanged:(UISegmentedControl *)sender
{
    self.currentType = self.searchTypes[sender.selectedSegmentIndex];
    [self actionSearchAroundAt:self.mapView.centerCoordinate];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/2)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.isLocated = NO;
}

- (void)initSearch
{
    self.searchPage = 1;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self.tableview;
}

- (void)initTableview
{
    self.tableview = [[PlaceAroundTableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-64, CGRectGetWidth(self.view.bounds), kScreenHeight/2 + 64)];
    self.tableview.delegate = self;
    
    [self.view addSubview:self.tableview];
}

- (void)initCenterView
{
    self.centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
    self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
    
    [self.mapView addSubview:self.centerAnnotationView];
}

- (void)initLocationButton
{
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
    
    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.bounds) - 40, CGRectGetHeight(self.mapView.bounds) - 50, 32, 32)];
    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.locationBtn.backgroundColor = [UIColor whiteColor];
    
    self.locationBtn.layer.cornerRadius = 3;
    [self.locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    
    [self.view addSubview:self.locationBtn];
}

//- (void)initSearchTypeView
//{
//    self.searchTypes = @[@"住宅"];
//    self.currentType = self.searchTypes.firstObject;
//    
//    self.searchTypeSegment = [[UISegmentedControl alloc] initWithItems:self.searchTypes];
//    self.searchTypeSegment.frame = CGRectMake(0, CGRectGetHeight(self.mapView.bounds), CGRectGetWidth(self.mapView.bounds), 32);
//    self.searchTypeSegment.layer.cornerRadius = 3;
//    self.searchTypeSegment.backgroundColor = [UIColor whiteColor];
//    self.searchTypeSegment.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    self.searchTypeSegment.selectedSegmentIndex = 0;
//    [self.searchTypeSegment addTarget:self action:@selector(actionTypeChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.searchTypeSegment setTintColor:DMBSColor];
//    [self.view addSubview:self.searchTypeSegment];
//    
//}

/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"8c1e6b6219874f14b5ae722eef8ff834";
    
    [self initTableview];
    
    [self initSearch];
    [self initMapView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initCenterView];
    [self initLocationButton];
//    [self initSearchTypeView];
    
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
}

@end