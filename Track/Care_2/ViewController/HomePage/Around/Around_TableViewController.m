//
//  Around_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-18.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "Around_TableViewController.h"
#import "AddCare_ViewController.h"
#import "Around_TableViewCell.h"
#import "LookAtTheMap_ViewController.h"
#import "OperationQueue.h"
#import "Fence_TableViewCell.h"
#import "LookFenceMap_ViewController.h"
#import "OperationQueue.h"
#import "MD5.h"


typedef void (^GainCareSuc)(void);
@interface Around_TableViewController () {
    UITableView *_tableView;
    UILabel *messageLabel;
    
    NSArray *ascKeys;
    DeviceModel *delDev;
    ASIHTTPRequest *req;
    ASIHTTPRequest *req1;
    ASIHTTPRequest  *req2;
    ASIHTTPRequest  *req3;
    BOOL isCare_;
    GainCareSuc careSucBlock_;
}

@end

@implementation Around_TableViewController
@synthesize devModel;
@synthesize careDevDic;
@synthesize fenceDevArr;
@synthesize devArr;
-(void)dealloc {
    [req clearDelegatesAndCancel];
    [req1 clearDelegatesAndCancel];
    [req2 clearDelegatesAndCancel];
    [req3 clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"在身边", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    _tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 7)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"Around_TableViewCell" bundle:nil] forCellReuseIdentifier:@"AroundCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"Fence_TableViewCell" bundle:nil] forCellReuseIdentifier:@"FenceCell"];
    fenceDevArr=[NSMutableArray array];
    devArr=[NSMutableArray array];
    _Code_ShowLoading
}

-(void)viewWillAppear:(BOOL)animated {
    __block typeof(self) self_=self;
    NSLog(@"viewWillAppear");
    [devArr removeAllObjects];
    [fenceDevArr removeAllObjects];
    [self gainCareDevice];
    [self setGainCareSuc:^{
        [self_ gainFenceDevice];
    }];
}

_Method_SetBackButton(nil, NO)
-(void)setSubmitButton {
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 2, 45, 44);
    [submitButton setImage:[UIImage imageNamed:@"01_btn_nav_add"] forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"01_btn_nav_add_selected"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(onAddCareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    submitButton.imageEdgeInsets = (UIEdgeInsets){0,20,0,-20};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
}

//-(void)dealloc {
////    [req clearDelegatesAndCancel];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sing_ind"object:nil];
//}


-(void)onAddCareButtonPressed {
    AddCare_ViewController *addCareVC = [[AddCare_ViewController alloc] initWithNibName:@"AddCare_ViewController" bundle:nil];
    addCareVC.dev=devModel;
    addCareVC.isCareDev=isCare_;
    addCareVC.fenceNum=fenceDevArr.count;
    addCareVC.fenceDevArr=(NSArray *)fenceDevArr;
    [self.navigationController pushViewController:addCareVC animated:YES];

    [[OperationQueue Instance] setSingle:devModel];
   
}

-(void)refreshTableView {
    
    NSLog(@"refresh");
    if (!devArr.count) {
        if (!messageLabel) {
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 260, 150)];
            messageLabel.numberOfLines = 0;
            messageLabel.text = NSLocalizedString(@"您还没有关爱的对象哦，点击右上角可以添加关爱", nil);
            messageLabel.textColor = [UIColor grayColor];
            messageLabel.font = [UIFont systemFontOfSize:15];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [_tableView addSubview:messageLabel];
        }else
        {
            messageLabel.hidden=NO;
        }
    }else
    {
        if(messageLabel)
        {
            messageLabel.hidden=YES;
        }
    }
    
    if(fenceDevArr.count ==3 && isCare_)
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
    }else
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }

    
    
    [_tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return devArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DeviceModel *model=(DeviceModel *)devArr[indexPath.row];
    
    NSLog(@"type=%d",model.type);
    
    if(model.type == 1)
    {
        // 关爱设备
        
        Around_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AroundCell"];
        
        [cell refreshCellWithDevObj:model];
        [cell setOnCancelCareButtonPressed:^(DeviceModel *devObj) {
            delDev = devObj;
            //解除关爱
            NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
            [signInfo setValue:_Interface_tracker_clearcare forKey:@"method"];
            [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
            [signInfo setValue:devObj.bindIMEI forKey:@"eqid"];
            [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
            
            NSString *sign = [MD5 createSignWithDictionary:signInfo];
            NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
            
            req1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [req1 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
            req1.tag = 31;
            req1.delegate = self;
            [req1 startAsynchronous];
        }];
        [cell setOnLookMapButtonPressed:^(DeviceModel *devObj) {
            [[OperationQueue Instance] setSingle:devObj];
            
                            LookAtTheMap_ViewController *lookMapVC = [[LookAtTheMap_ViewController alloc] initWithNibName:@"LookAtTheMap_ViewController" bundle:nil];
                lookMapVC.dev = devObj;
                lookMapVC.type = 0;
                [self.navigationController pushViewController:lookMapVC animated:YES];
        }];
        return cell;
    }
    else
    {
        // 围栏设备
        Fence_TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FenceCell"];
        [cell refreshCellWithDevObj:model];
        [cell setOnCancelCareButtonPressed:^(DeviceModel *devObj) {
            [self removefenceWithDeviceModel:devObj];
        }];
        [cell setOnLookMapButtonPressed:^(DeviceModel *devObj) {
            
            
                LookFenceMap_ViewController *lookFenceMapVC = [[LookFenceMap_ViewController alloc]init];
                lookFenceMapVC.device = devObj;
                [[OperationQueue Instance] setSingle:devObj];
                [self.navigationController pushViewController:lookFenceMapVC animated:YES];
            
            
//            LookFenceMap_ViewController *lookFenceMapVC = [[LookFenceMap_ViewController alloc]init];
//            lookFenceMapVC.device = devObj;
//            [[OperationQueue Instance] setSingle:devObj];
//            [self.navigationController pushViewController:lookFenceMapVC animated:YES];
        }];
        return cell;
    }
   
}

#pragma mark 取消围栏设备
-(void)removefenceWithDeviceModel:(DeviceModel *)model
{
    delDev=model;
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_removefence forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:model.bindIMEI forKey:@"eqId"];
    [signInfo setValue:model.fenceId forKey:@"fenceId"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];    
    req2 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req2 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req2.tag = 32;
    req2.delegate = self;
    [req2 startAsynchronous];
}


#pragma mark 获取围栏设备列表

-(void)gainFenceDevice
{
    
    //查看围栏设备设备列表
    NSMutableDictionary *signInfo1 = [NSMutableDictionary dictionary];
    [signInfo1 setValue:_Interface_tracker_getfences forKey:@"method"];
    [signInfo1 setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo1 setValue:[UserData Instance].sessionId forKey:@"session"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo1];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo1 Sign:sign];
    
    req3 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req3 addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req3.tag = 33;
    req3.delegate = self;
    [req3 startAsynchronous];
}


#pragma mark 获取关爱设备
-(void)gainCareDevice
{
    //查看关爱设备列表
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_tracker_mycare forKey:@"method"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.tag = 30;
    req.delegate = self;
    [req startAsynchronous];
}


-(void)setGainCareSuc:(GainCareSuc)suc
{
    careSucBlock_=[suc copy];
}


#pragma mark - observeValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"nowDist"])
    {
        [self refreshTableView];
    }
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSLog(@"Response :%@", [request responseString]);
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        if (request.tag == 30) {
            
            for (NSDictionary *devDic in jsonDic[@"list"]) {
                if([devDic[@"eqId"] isEqualToString:devModel.bindIMEI])
                {
                    NSLog(@"获取关爱设备列表成功！");
                    DeviceModel *devObj = [UserData Instance].deviceDic[devDic[@"eqId"]];
                    DeviceModel *model=[[DeviceModel alloc] init];
                    model.bindIMEI=devModel.bindIMEI;
                    model.avatar=devObj.avatar;
                    model.nickName=devObj.nickName;
//                    model.careDist=devObj.careDist;
                    model.careDist = [[devDic objectForKey:@"careDist"] intValue];
                    NSLog(@"%d+++++",model.careDist);
                    model.type=1;
                    isCare_=YES;
                    careDevDic=[NSDictionary dictionaryWithObject:model forKey:devObj.bindIMEI];
                    [devArr addObject:model];
                }
            }
            careSucBlock_();
            
            
        }else if (request.tag==33)
        {
           
            for (NSDictionary *devDic in jsonDic[@"fences"]) {
                
                if([devDic[@"eqId"] isEqualToString:devModel.bindIMEI])
                {
                     NSLog(@"获取围栏设备列表成功！");
                    DeviceModel *devObj = [UserData Instance].deviceDic[devDic[@"eqId"]];
                    DeviceModel *model=[[DeviceModel alloc] init];
                    NSLog(@"devModel.bindIMEI=%@",devModel.bindIMEI);
                    model.bindIMEI=devModel.bindIMEI;
                    model.avatar=devObj.avatar;
                    model.nickName=devObj.nickName;
                    model.lat=[devDic[@"lat"] doubleValue];
                    model.lng=[devDic[@"lnt"] doubleValue];
                    model.fenceType=[devDic[@"type"] intValue];
                    model.fenceId=devDic[@"fenceId"];
                    model.fenceDist=[devDic[@"dist"] intValue];
                    model.type=2;
                    [fenceDevArr addObject:model];
                     [devArr addObject:model];
                }
                
                
            }
            [self refreshTableView];
        }else if (request.tag == 31)
        {
            [devArr removeObject:delDev];
            isCare_=NO;
            careDevDic=nil;
            [self refreshTableView];
        }
        else if (request.tag == 32) {
            [devArr removeObject:delDev];
            [fenceDevArr removeObject:delDev];
            [self refreshTableView];
        }
        
        
    })
}
_Method_RequestFailed()

@end
