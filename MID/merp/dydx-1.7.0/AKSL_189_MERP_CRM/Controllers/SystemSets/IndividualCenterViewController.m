//
//  IndividualCenterViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "IndividualCenterViewController.h"
#import "SystemMainCell.h"
#import "SystemHeadCell.h"
#import "SystemUserNameCell.h"

@interface IndividualCenterViewController ()
{
    NSDictionary *dataDic;
    NSArray *typeArray;
    UITextField *_text;

}


@end

@implementation IndividualCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.btnSubmit setHidden:YES];
    [self.tableICData registerNib:[UINib nibWithNibName:@"SystemMainCell" bundle:nil] forCellReuseIdentifier:@"sysCell"];
    
    [self.tableICData registerNib:[UINib nibWithNibName:@"SystemHeadCell" bundle:nil] forCellReuseIdentifier:@"sysheadCell"];
    [self.tableICData registerNib:[UINib nibWithNibName:@"SystemUserNameCell" bundle:nil] forCellReuseIdentifier:@"nameCell"];
    [self setData];
    // Do any additional setup after loading the view from its nib.
    self.tableICData.dataSource = self;
    self.tableICData.delegate = self;


    
}
-(void)setData
{
    // NSString *str = @"{\"data\":[{\"gerenzhongxin\":\"个人中心\"},{\"xiugaimima\":\"修改密码\"},{\"yijianfankui\":\"意见反馈\"},{\"guanyuruanjian\":\"关于软件\"},{\"ruanjiangengxin\":\"软件更新:1.6.0\"},{\"qingchuhuancun\":\"清除缓存\"}]}";
    //NSString *str = @"{\"touxiang\":{\"img\":\"test_hader.jpg\"},\"mingzi\":{\"name\":\"糜风波\"},\"dianhua\":{\"phoneNum\":\"18990289797\"},\"xingbie\":{\"sex\":\"男\"},\"xiaoxiliebiao\":{\"message\":\"\"},\"type\":[{\"type\":\"touxiang\",\"name\":\"头像\"},{\"type\":\"mingzi\",\"name\":\"名字\"},{\"type\":\"dianhua\",\"name\":\"电话\"},{\"type\":\"xingbie\",\"name\":\"性别\"},{\"type\":\"xiaoxiliebiao\",\"name\":\"消息列表\"}]}";
   // NSString *str = @"{\"touxiang\":[\"test_hader.jpg\"],\"mingzi\":[\"糜风波\"],\"dianhua\":[\"18990289797\"],\"xingbie\":[\"男\"],\"xiaoxiliebiao\":[\"\"],\"type\":[{\"type\":\"touxiang\",\"name\":\"头像\"},{\"type\":\"mingzi\",\"name\":\"名字\"},{\"type\":\"dianhua\",\"name\":\"电话\"},{\"type\":\"xingbie\",\"name\":\"性别\"},{\"type\":\"xiaoxiliebiao\",\"name\":\"消息列表\"}]}";
    NSString *str = @"{\"touxiang\":[\"test_hader.jpg\"],\"mingzi\":[\"糜风波\"],\"dianhua\":[\"18990289797\"],\"xingbie\":[\"男\"],\"xiaoxiliebiao\":[\"\"],\"type\":[[{\"type\":\"touxiang\",\"name\":\"头像\"}],[{\"type\":\"mingzi\",\"name\":\"名字\"},{\"type\":\"dianhua\",\"name\":\"电话\"}],[{\"type\":\"xingbie\",\"name\":\"性别\"}],[{\"type\":\"xiaoxiliebiao\",\"name\":\"消息列表\"}]]}";
    dataDic = [str JSONValueNewMy];
    
    typeArray = [dataDic objectForKey:@"type"];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [typeArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = 0;
    if ([typeArray count] == 0) {
        index = 0;
    }
    else if (section == 0) {
        index = [[typeArray objectAtIndex:0] count];
    }
    else if (section == 1) {
        index = [[typeArray objectAtIndex:1] count];
    }
    else if (section == 2)
    {
        index = [[typeArray objectAtIndex:2] count];
    }
    else if (section == 3)
    {
        index = [[typeArray objectAtIndex:3] count];
    }
    return index;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath section];
    id cellx;
    if (index == 0)
    {
        SystemHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysheadCell"];
        if(!cell)
        {
            cell = [[SystemHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysheadCell"];
        }
        cell.lblName.text = [[[typeArray objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSString *str = [[dataDic objectForKey:[[[typeArray objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"type"]] lastObject];
        cell.imgHead.image = [UIImage imageNamed:str];
        cell.imgHead.layer.cornerRadius = 25;
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblName.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    else if (index == 1)
    {
            SystemUserNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
            if(!cell)
            {
                cell = [[SystemUserNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell"];
            }
        cell.textName.userInteractionEnabled = NO;
        if ([[[[typeArray objectAtIndex:1] objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:@"名字"]) {
            cell.textName.userInteractionEnabled = YES;
        }
            cell.lblName.text = [[[typeArray objectAtIndex:1] objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.textName.text = [[dataDic objectForKey:[[[typeArray objectAtIndex:1] objectAtIndex:indexPath.row] objectForKey:@"type"]] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textName.delegate = self;
        cell.lblName.font = [UIFont systemFontOfSize:14];
        cell.textName.textColor = [UIColor grayColor];
        cell.textName.font = [UIFont systemFontOfSize:14];
        
            cellx = cell;
    }
 
 
    else if (index == 2)
    {
        SystemMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
        if(!cell)
        {
            cell = [[SystemMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysCell"];
        }
        cell.lblsystemName.text = [[[typeArray objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.lblsysValue.text = [[dataDic objectForKey:[[[typeArray objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"type"]] lastObject];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblsystemName.font = [UIFont systemFontOfSize:14];
        cell.lblsysValue.textColor = [UIColor grayColor];
        cell.lblsysValue.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    else if (index == 3)
    {
        SystemMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
        if(!cell)
        {
            cell = [[SystemMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysCell"];
        }
        
        cell.lblsystemName.text = [[[typeArray objectAtIndex:3] objectAtIndex:indexPath.row] objectForKey:@"name"];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblsystemName.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    return cellx;

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _text = textField;
    [self.btnSubmit setHidden:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath section];
    if (index == 0) {
        index = 58;
    }
    else
    {
        index = 44;
    }
    return index;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0 alpha:0.1];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0 alpha:0.1];
    return view;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath section];
    
    if (index == 0 && indexPath.row == 0) {
        UIActionSheet *acion = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                           delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册" , nil];
        [acion showInView:self.view];
    }
    else if (index == 2 && indexPath.row == 0)
    {
        UIActionSheet *acion = [[UIActionSheet alloc] initWithTitle:@"性别选择"
                                                           delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女" , nil];
        [acion showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"上传头像"]) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                showMessageBox(@"当前无照相机");
                return;
            }
            [self presentViewController:picker animated:YES completion:Nil];
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         
            imagePicker.delegate = self;
           
            [self  presentViewController:imagePicker animated:YES completion:^{
               
            }];

        }
    }
    else if ([actionSheet.title isEqualToString:@"性别选择"])
    {
        if (buttonIndex == 0) {
            //男
        }
        else if (buttonIndex == 1)
        {
            //女
        }
    }
    
}
/*
 
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
	}
	else
	{
		return;
	}
}
// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender {
    [_text resignFirstResponder];
    [self.btnSubmit setHidden:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_text resignFirstResponder];
}
@end
