//
//  UserSetting_TableViewController.m
//  Q2_local
//
//  Created by Vecklink on 14-7-8.
//  Copyright (c) 2014年 Joe. All rights reserved.
//

#import "UserSetting_TableViewController.h"

#import "NetManger.h"

@interface UserSetting_TableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

    IBOutlet UIView *avatarView;
    __weak IBOutlet UIView *avatarSheetView;
    
    IBOutlet UIView *sexView;
    __weak IBOutlet UIView *sexSheetView;

    UITableView *_tableView;
    
    UIImageView *avatarImageView;
    NSArray *itemKeyArray;              //tableView行title
    
    NSMutableDictionary *userInfoDic;   //tableView数据
    
    ASIHTTPRequest *req;
}

- (IBAction)onSelectAvatarButtonPressed:(UIButton *)sender;
//选择头像Sheet
- (IBAction)onTakeAPictureButtonPressed:(UIButton *)sender;
- (IBAction)onSelectTheLocalPictureButtonPressed:(UIButton *)sender;
//选择性别Sheet
- (IBAction)onSexButtonPressed:(UIButton *)sender;
- (IBAction)onCancelButtonPressed:(UIButton *)sender;

@end

@implementation UserSetting_TableViewController

-(void)dealloc {
    [avatarView removeFromSuperview];
    [sexView removeFromSuperview];
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"个人信息", nil);
    [self setBackButton];
    
    _tableView = (UITableView *)self.view;
    _tableView.bounces = NO;
    _tableView.backgroundColor = _Color_background;
    
    itemKeyArray = [NSArray arrayWithObjects:
                    NSLocalizedString(@"头像", nil),
                    NSLocalizedString(@"昵称", nil),
                    NSLocalizedString(@"帐号", nil),
                    NSLocalizedString(@"性别", nil), nil];
    if (!userInfoDic) {
        userInfoDic = [NSMutableDictionary dictionary];
        [self refreshUserInfoDic];
    }
    
    
    
    [avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroundHideSheet:)]];
    avatarView.alpha = 0;
    avatarView.hidden = YES;
    [self.navigationController.view addSubview:avatarView];
    
    [sexView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroundHideSheet:)]];
    sexView.alpha = 0;
    sexView.hidden = YES;
    [self.navigationController.view addSubview:sexView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshUserInfoDic];
    [_tableView reloadData];
}

_Method_SetBackButton({
    if(![UserData Instance].nickName || [[UserData Instance].nickName isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有设置昵称", nil)];
        [alertView show];
        return;
    }
    
    
    
    //修改用户信息
    
    
    
    if(![UserData Instance].avatarUrl)
    {
       
        NetManger *net=[[NetManger alloc] init];
        [net uploadFile:[UserData Instance].avatarData];
        [net setUploadFileSuc:^(NSString *url) {
            
        [UserData Instance].avatarUrl=url;
            
            NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
            [signInfo setValue:_Interface_user_updateinfo forKey:@"method"];
            [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
            [signInfo setValue:[UserData Instance].nickName
                        forKey:@"nickname"];
            [signInfo setValue:[NSNumber numberWithInt:[UserData Instance].sex] forKey:@"sex"];
            [signInfo setValue:[NSNumber numberWithInt:0] forKey:@"provId"];
            [signInfo setValue:[NSNumber numberWithInt:0] forKey:@"cityId"];
            [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
            [signInfo setValue:[UserData Instance].avatarUrl forKey:@"avatar"];
            [signInfo setValue:@"-" forKey:@"signature"];
            
            NSString *sign = [MD5 createSignWithDictionary:signInfo];
            NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
            
            req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
            [req setUsername:_Interface_user_updateinfo];
            req.delegate = self.navigationController;
            [req startAsynchronous];
        }];
        
    }else
    {
        NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
        [signInfo setValue:_Interface_user_updateinfo forKey:@"method"];
        [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
        [signInfo setValue:[UserData Instance].nickName
                    forKey:@"nickname"];
        [signInfo setValue:[NSNumber numberWithInt:[UserData Instance].sex] forKey:@"sex"];
        [signInfo setValue:[NSNumber numberWithInt:0] forKey:@"provId"];
        [signInfo setValue:[NSNumber numberWithInt:0] forKey:@"cityId"];
        [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
        [signInfo setValue:[UserData Instance].avatarUrl forKey:@"avatar"];
        [signInfo setValue:@"-" forKey:@"signature"];
        
        NSString *sign = [MD5 createSignWithDictionary:signInfo];
        NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
        
        req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
        [req setUsername:_Interface_user_updateinfo];
        req.delegate = self.navigationController;
        [req startAsynchronous];
    }
    [self performSelectorInBackground:@selector(saveCustomObject:) withObject:[UserData Instance]];
    
    [self.navigationController popViewControllerAnimated:YES];
}, YES)
-(void)saveCustomObject:(UserData *)obj {
    [[UserData Instance] saveCustomObject:obj];
}

-(void)refreshUserInfoDic {
    [userInfoDic setValue:[UIImage imageNamed:@"2_avatar_child_88"] forKey:itemKeyArray[0]];
    [userInfoDic setValue:[UserData Instance].nickName forKey:itemKeyArray[1]];
    [userInfoDic setValue:[UserData Instance].uid forKey:itemKeyArray[2]];
    [userInfoDic setValue:([UserData Instance].sex ? NSLocalizedString(@"男", nil) : NSLocalizedString(@"女", nil)) forKey:itemKeyArray[3]];
}

//隐藏CustomActionSheetView
-(void)touchBackgroundHideSheet:(UITapGestureRecognizer *)tap {
    if (tap.view == avatarView && [tap locationInView:tap.view].y<avatarSheetView.frame.origin.y) {
        [self hideSheet:avatarSheetView];
    } else if ([tap locationInView:tap.view].y<sexSheetView.frame.origin.y) {
        [self hideSheet:sexSheetView];
    }
}
-(void)hideSheet:(UIView *)v {
    [UIView animateWithDuration:0.25 animations:^{
        v.center = CGPointMake(160, 568+v.bounds.size.height);
        v.superview.alpha = 0;
    } completion:^(BOOL finished) {
        v.superview.hidden = YES;
    }];
}


- (IBAction)onSelectAvatarButtonPressed:(UIButton *)bt {
    avatarImageView.image = bt.imageView.image;
    [UserData Instance].avatarData = UIImagePNGRepresentation(bt.imageView.image);
   [self hideSheet:avatarSheetView];
}
//avatarSheetView
//拍照
- (IBAction)onTakeAPictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    [self hideSheet:avatarSheetView];
}
//选择本地图片
- (IBAction)onSelectTheLocalPictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
    [self hideSheet:avatarSheetView];
}

//sexSheetView
//选择性别
- (IBAction)onSexButtonPressed:(UIButton *)bt {
    [UserData Instance].sex = ([bt.titleLabel.text isEqualToString:NSLocalizedString(@"男", nil)] ? 1 : 0);
    [self refreshUserInfoDic];
    [_tableView reloadData];
    [self hideSheet:sexSheetView];

}
//取消
- (IBAction)onCancelButtonPressed:(UIButton *)bt {
    [self hideSheet:bt.superview];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return 1;
    } else {
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section || indexPath.row) {
        return 48;
    }
    return 72;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 13, 100, 21)];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = 100;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(157, 13, 120, 21)];
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.font = [UIFont boldSystemFontOfSize:14];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.tag = 101;
        [cell addSubview:detailLabel];
        
        if (!indexPath.section) {
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_background_selected"]]];
            
            if (!indexPath.row) {
                titleLabel.frame = CGRectMake(19, 25, 100, 21);
                [detailLabel removeFromSuperview];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(217, 5, 60, 60)];
                imgView.layer.cornerRadius = 7;
                imgView.layer.masksToBounds = YES;
                avatarImageView = imgView;
                [cell addSubview:imgView];
            }
        } else {
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background"]]];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"03_set_cell_sub_background_selected"]]];
        }
    }
    
    avatarImageView.image = [UIImage imageWithData:[UserData Instance].avatarData];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:101];
    if (!indexPath.section) {
        titleLabel.text = itemKeyArray[indexPath.row];
        if (indexPath.row) {
            detailLabel.text = userInfoDic[itemKeyArray[indexPath.row]];
        }
    } else {
        titleLabel.text = itemKeyArray[indexPath.row+3];
        detailLabel.text = userInfoDic[itemKeyArray[indexPath.row+3]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 0: {   //头像
                avatarView.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    avatarView.alpha = 1;
                    avatarSheetView.center = CGPointMake(160, [UIScreen mainScreen].bounds.size.height-avatarSheetView.bounds.size.height/2);
                }];
            }   break;
            case 1: {   //昵称
                ModifyUserName_ViewController *userSettingVC = [[ModifyUserName_ViewController alloc] initWithNibName:@"ModifyUserName_ViewController" bundle:nil];
                userSettingVC.obj = [UserData Instance];
                [self.navigationController pushViewController:userSettingVC animated:YES];
            }   break;
            case 2: {   //帐号
                
            }
        }
    } else {
        switch (indexPath.row) {
            case 0: {   //性别
                sexView.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    sexView.alpha = 1;
                    sexSheetView.center = CGPointMake(160, [UIScreen mainScreen].bounds.size.height-sexSheetView.bounds.size.height/2);
                }];
            }   break;
        }
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage  *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [UserData Instance].avatarData = UIImageJPEGRepresentation(img, 0.5);
        
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        NSString *imagePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        [UserData Instance].avatarData = [NSData dataWithContentsOfFile:imagePath];
    }
    
    NetManger *net=[[NetManger alloc] init];
    [net uploadFile:[UserData Instance].avatarData];
    [net setUploadFileSuc:^(NSString *url) {
       
        [UserData Instance].avatarUrl=url;
        NSLog(@"url = %@",url);
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        avatarImageView.image = [UIImage imageWithData:[UserData Instance].avatarData];
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
