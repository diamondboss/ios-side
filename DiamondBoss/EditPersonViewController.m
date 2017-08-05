//
//  EditPersonViewController.m
//  DiamondBoss
//
//  Created by edz on 2017/5/11.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "EditPersonViewController.h"
#import "EditTableViewCell.h"
#import "MainViewController.h"
#import "DBLoginViewController.h"
#import "AnnimalmessageViewController.h"
#import "ChangeViewController.h"
#import "EditPanterTableViewCell.h"
#import "ASBirthSelectSheet.h"
#import "EditPersonSexSheet.h"


//oss图片上传
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonHMAC.h>
NSString * const AccessKey = @"LTAIiKifYSE1BkLH";
NSString * const SecretKey = @"g1ugTtAGmsICQsVt4tE6kTyI3T9x5r";

#import "UIImageView+WebCache.h"
#import <SDImageCache.h> 
#import "SDImageCache.h"

@interface EditPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIButton *imgbtn;
    OSSClient * client;
    UIImageView *img;
}
@property(nonatomic,strong)NSData *imageData;


@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSArray *dataAry;
@property (strong, nonatomic) NSArray *dataAry1;
@property (strong, nonatomic) NSArray *dataAry2;
@property (strong, nonatomic) NSArray *dataAry3;
@property (strong, nonatomic) NSArray *mesage1Ary;
@property (strong, nonatomic) NSArray *mesage2Ary;
@property (strong, nonatomic) NSArray *mesage3Ary;
@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) NSString *userOrpanter;

@property (strong, nonatomic) NSDictionary *userMessageDic;
@property (weak, nonatomic) IBOutlet UILabel *lblShowBirth;

@end

@implementation EditPersonViewController

-(void)viewWillAppear:(BOOL)animated
{
    _userOrpanter = [[NSUserDefaults standardUserDefaults] objectForKey:@"userOrpanter"];
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}
- (void)popTo{
    MainViewController *con = [[MainViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _userOrpanter = [[NSUserDefaults standardUserDefaults] objectForKey:@"userOrpanter"];
    self.view.backgroundColor = UIColorRGB(237, 237, 237);
    if ([_userOrpanter isEqualToString:@"1"]) {
        self.title = @"个人资料";
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSDictionary *dict = nil;
        dict = @{@"partnerId":str};
        NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftPartnerQueryInfo];
        [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                _userMessageDic = [NSDictionary dictionary];
                _userMessageDic = response[@"data"];
                [[NSUserDefaults standardUserDefaults]setObject:_userMessageDic[@"name"] forKey:@"USERNAME"];

                _dataAry = @[@"头像",@"昵称",@"年龄"];
                _dataAry1 = @[@"性别",@"住址",@"行业",@"备注"];
                _dataAry2 = @[@"宠物信息"];
                _mesage1Ary = @[@"",_userMessageDic[@"name"],_userMessageDic[@"age"]];
                
                [[NSUserDefaults standardUserDefaults]setObject:_userMessageDic[@"name"] forKey:@"USERNAME"];

                if ([response[@"data"][@"sex"] intValue] == 1){
                    _mesage2Ary = @[@"男",_userMessageDic[@"address"],_userMessageDic[@"industry"],_userMessageDic[@"remark"]];
                }else{
                    _mesage2Ary = @[@"女",_userMessageDic[@"address"],_userMessageDic[@"industry"],_userMessageDic[@"remark"]];
                }
                [self creatUITable];
            }
        } fail:^(NSError *error) {
       
        }];
    }else{
        self.title = @"编辑资料";
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSDictionary *dict = nil;
        dict = @{@"UserId":str};
        NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftQueryInfo];
        [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                

                _userMessageDic = [NSDictionary dictionary];
                _userMessageDic = response[@"data"];
                
                [[NSUserDefaults standardUserDefaults]setObject:_userMessageDic[@"name"] forKey:@"USERNAME"];

                _dataAry = @[@"头像",@"昵称",@"年龄"];
                _dataAry1 = @[@"性别",@"住址",@"行业",@"备注"];
                _dataAry2 = @[@"宠物信息"];
                _mesage1Ary = @[@"",_userMessageDic[@"name"],_userMessageDic[@"age"]];
                if ([response[@"data"][@"sex"] intValue] == 1){
                    _mesage2Ary = @[@"男",_userMessageDic[@"address"],_userMessageDic[@"industry"],_userMessageDic[@"remark"]];
                }else{
                    _mesage2Ary = @[@"女",_userMessageDic[@"address"],_userMessageDic[@"industry"],_userMessageDic[@"remark"]];
                }
               [self creatUITable];
            }
        } fail:^(NSError *error) {
            
        }];
    }
}
- (void)creatUITable{
    //半透明条(导航条/tabBar) 对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth , kScreenHeight - 50)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator =NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = UIColorRGB(237, 237, 237);
    [self.myTableView registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"EditPanterTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditPanterTableViewCell"];
    [self.view addSubview:self.myTableView];
}
#pragma mark - tableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_userOrpanter isEqualToString:@"1"]) {
        return 3;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 10)];
    [headerView setBackgroundColor:UIColorRGB(237, 237, 237)];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataAry.count;
    }else if (section == 1) {
        return _dataAry1.count;
    }else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([_userOrpanter isEqualToString:@"1"]){
            EditPanterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditPanterTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.leftLbl.text = _dataAry[indexPath.row];
            cell.edituserlbl.text = _mesage1Ary[indexPath.row];
            if (indexPath.row == 0) {
                img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 5, 40, 40)];
                NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
                NSString *urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
                [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,str]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
                img.layer.masksToBounds = YES;
                img.layer.cornerRadius = 20;
                [cell addSubview:img];
            }
            return cell;
        }else{
            EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.leftLbl.text = _dataAry[indexPath.row];
            cell.edituserlbl.text = _mesage1Ary[indexPath.row];
            if (indexPath.row == 0) {
                cell.edituserlbl.text = @"";
                img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 5, 40, 40)];
                NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
                NSString *urlString = [KPictureUrl stringByAppendingString:KPictureUserUrl];
                [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,str]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
                img.layer.masksToBounds = YES;
                img.layer.cornerRadius = 20;
                [cell addSubview:img];

                imgbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 5, 40, 40)];
                imgbtn.layer.masksToBounds = YES;
                imgbtn.layer.cornerRadius = 20;
                [imgbtn addTarget:self action:@selector(upImage) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:imgbtn];
            }
            return cell;
        }

    }else if (indexPath.section == 1) {
        if ([_userOrpanter isEqualToString:@"1"]){
            EditPanterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditPanterTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.leftLbl.text = _dataAry1[indexPath.row];
            cell.edituserlbl.text = _mesage2Ary[indexPath.row];
            return cell;
        }else{
            EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.leftLbl.text = _dataAry1[indexPath.row];
            cell.edituserlbl.text = _mesage2Ary[indexPath.row];
            return cell;
        }
    }else {
        if ([_userOrpanter isEqualToString:@"1"]) {
            
            static NSString *identifer=@"cell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.backgroundColor = UIColorRGB(237, 237, 237);
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 40)];
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
            btn.backgroundColor = DMBSColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [btn addTarget:self action:@selector(tiijao) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            return cell;

        }else{
            if (indexPath.section == 2) {
                EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.leftLbl.text = _dataAry2[indexPath.row];
                cell.edituserlbl.text = _mesage1Ary[indexPath.row];
                return cell;
            }else{
                static NSString *identifer=@"cell";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
                if (cell==nil) {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                }
                cell.backgroundColor = UIColorRGB(237, 237, 237);
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 40)];
                [btn setTitle:@"退出登录" forState:UIControlStateNormal];
                btn.backgroundColor = DMBSColor;
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [btn addTarget:self action:@selector(tiijao) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                return cell;
            }
        }
    }
}

#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_userOrpanter isEqualToString:@"1"]) {
        
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                //填写昵称
                ChangeViewController *changeVC =[[ChangeViewController alloc]init];
                changeVC.name = @"昵称";
                changeVC.dic = _userMessageDic;
                GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:changeVC];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
            }
            if (indexPath.row == 2) {
                ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
                datesheet.GetSelectDate = ^(NSString *dateStr) {
                    [self chooseAgeBtn2:dateStr];
                };
                [self.view addSubview:datesheet];
                [self.myTableView reloadData];
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                EditPersonSexSheet *datesheet = [[EditPersonSexSheet alloc] initWithFrame:self.view.bounds];
                datesheet.GetSelectDate = ^(NSString *dateStr) {
                    if ([dateStr isEqualToString:@"男"]){
                        dateStr = @"1";
                    }else{
                        dateStr = @"0";
                    }
                    [self chooseAgeBtn1:dateStr];
                };
                [self.view addSubview:datesheet];
                [self.myTableView reloadData];
            }else{
                ChangeViewController *changeVC =[[ChangeViewController alloc]init];
                changeVC.dic = _userMessageDic;
                if (indexPath.row == 1) {
                    changeVC.name = @"住址";
                }
                if (indexPath.row == 2) {
                    changeVC.name = @"行业";
                }
                if (indexPath.row == 3) {
                    changeVC.name = @"备注";
                }
                GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:changeVC];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
            }
        }
        
        if (indexPath.section == 2) {
            //宠物信息
            AnnimalmessageViewController *animal =[[AnnimalmessageViewController alloc]init];
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:animal];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
        }
    }
}

- (void)tiijao{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PhoneNumber"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ISUSER"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isuser"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cummunity"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userOrpanter"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedCommunty"];

    //退出登录
    DBLoginViewController *loginvc = [[DBLoginViewController alloc]init];
    [self.navigationController pushViewController:loginvc animated:YES];
}

- (void)chooseAgeBtn1:(NSString *)str{
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdateInfo];
    NSDictionary *dict = nil;
    dict = @{@"userId":[NSString stringWithFormat:@"%@",_userMessageDic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_userMessageDic[@"phoneNumber"]],@"name":_userMessageDic[@"name"],@"age":[NSString stringWithFormat:@"%@",_userMessageDic[@"age"]],@"sex":str,@"address":_userMessageDic[@"address"],@"industry":_userMessageDic[@"industry"],@"remark":_userMessageDic[@"remark"]};
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            EditPersonViewController *edit = [[EditPersonViewController alloc]init];
            [self.navigationController pushViewController:edit animated:NO];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)chooseAgeBtn2:(NSString *)str{
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdateInfo];
    NSDictionary *dict = nil;
    NSString *dataStr = nil;
    dataStr = [str substringWithRange:NSMakeRange(0, 2)];

    dict = @{@"userId":[NSString stringWithFormat:@"%@",_userMessageDic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_userMessageDic[@"phoneNumber"]],@"name":_userMessageDic[@"name"],@"age":dataStr,@"sex":[NSString stringWithFormat:@"%@",_userMessageDic[@"sex"]],@"address":_userMessageDic[@"address"],@"industry":_userMessageDic[@"industry"],@"remark":_userMessageDic[@"remark"]};
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            EditPersonViewController *edit = [[EditPersonViewController alloc]init];
            [self.navigationController pushViewController:edit animated:NO];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark oss上传图片
/**
 *  按钮事件
 */
- (void)upImage
{
    [self loadImagePicker];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  压缩图片尺寸
 *
 *  @param image   图片
 *  @param newSize 大小
 *
 *  @return 真实图片
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  进入相册方法
 */
-(void)loadImagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    [self presentViewController:picker animated:YES completion:NULL];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *avatar = info[UIImagePickerControllerOriginalImage];
    //处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(avatar)) {
        //返回为png图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        [imgbtn setImage:imagenew forState:UIControlStateNormal];
        self.imageData = UIImagePNGRepresentation(imagenew);
    }else {
        //返回为JPEG图像。
        UIImage *imagenew = [self imageWithImageSimple:avatar scaledToSize:CGSizeMake(200, 200)];
        [imgbtn setImage:imagenew forState:UIControlStateNormal];
        self.imageData = UIImageJPEGRepresentation(imagenew, 0.1);
    }
    NSString *endpoint = @"oss-cn-shanghai.aliyuncs.com";
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey
                                                                                                            secretKey:SecretKey];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = @"zfxue-test";
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSString *objectKeys = [NSString stringWithFormat:@"user/avatar/%@.jpg",str];

    put.objectKey = objectKeys;
    //put.uploadingFileURL = [NSURL fileURLWithPath:fullPath];
    put.uploadingData = self.imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:@"zfxue-test"
                                        withObjectKey:objectKeys];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
            NSString *urlstr = [KPictureUrl stringByAppendingString:KPictureUserUrl];
            NSString *imgstr = [NSString stringWithFormat:@"%@%@.jpg",urlstr,str];
            [[SDImageCache sharedImageCache] removeImageForKey:imgstr fromDisk:YES withCompletion:nil];
            
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
/**
 *  返回当前时间
 *
 *  @return <#return value description#>
 */
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    NSLog(@"%@", timeNow);
    return timeNow;
}

@end
