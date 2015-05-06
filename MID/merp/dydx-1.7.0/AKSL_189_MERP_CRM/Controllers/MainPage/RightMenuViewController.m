//
//  RightMenuViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "RightMenuViewController.h" 
#import "EMAsyncImageView.h"
#import "ChatViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface RightMenuViewController ()

@end

@implementation SingerUserCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setData:(NSString *)username Set:(NSString *)set HeaderImg:(NSString *)url{
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
   UIView * view =  [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithRed:0.314 green:0.314 blue:0.314 alpha:1];
    self.selectedBackgroundView = view;
    
}

@end

@implementation NoteListCell

bool isNoteHidden;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)setData:(bool)isNote{
    isNoteHidden = isNote;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    _imageNote.hidden =isNoteHidden ;
    _imageNote.layer.cornerRadius = 15;
    _imageNote1.layer.cornerRadius = 15;
    _name.text = isNoteHidden?@"通知":@"发放通知";
}

@end

@implementation RightMenuViewController

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
    // Do any additional setup after loading the view from its nib.
    _clearSerachText.titleLabel.backgroundColor = [UIColor clearColor];
    _clearSerachText.layer.cornerRadius = 9;
    isnibr = NO;
//    UINib *nib = [UINib nibWithNibName:@"SingerUserCell" bundle:nil];
//    UINib *nib1 = [UINib nibWithNibName:@"NoteListCell" bundle:nil];
//    [_tableView registerNib:nib1 forCellReuseIdentifier:@"NoteListCell"];
//    [_tableView registerNib:nib forCellReuseIdentifier:@"SingerUserCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_tableView setContentOffset:CGPointMake(0, 0)];
    [_tableView selectRowAtIndexPath:nil animated:NO scrollPosition:0];
}
//Table DataSoucre
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 [_IuputSercus resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)return 1;
    if(section == 1)return 1;
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 1;
    }
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(!isnibr){
    UINib *nib = [UINib nibWithNibName:@"SingerUserCell" bundle:nil];
    UINib *nib1 = [UINib nibWithNibName:@"NoteListCell" bundle:nil];
    [tableView registerNib:nib1 forCellReuseIdentifier:@"NoteListCell"];
    [tableView registerNib:nib forCellReuseIdentifier:@"SingerUserCell"];
    }
    switch (indexPath.section) {
        case 0:
             cell = [tableView dequeueReusableCellWithIdentifier:@"NoteListCell"];
            [((NoteListCell *)cell) setData:indexPath.row == 0];
             break;
        case 1:
            cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 250, 1)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:0.525 green:0.714 blue:0.094 alpha:1];
            cell.contentView.backgroundColor =[UIColor colorWithRed:0.525 green:0.714 blue:0.094 alpha:1];
            cell.textLabel.text =@"";//"您有40位联系人";
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font  = [UIFont fontWithName:@"HelveticaNeue" size:15];
            cell.textLabel.textColor = [UIColor colorWithRed:0.969 green:1.000 blue:1.000 alpha:1];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SingerUserCell"];
            break;
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_IuputSercus resignFirstResponder];
    if(indexPath.section != 0)return;
    ChatViewController * chart = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    [chart setTitleLabelString:@"通知"];
    [self.mm_drawerController.navigationController pushViewController:chart animated:YES];
 
    [self.mm_drawerController closeDrawerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HideKey:(id)sender {
    [_IuputSercus resignFirstResponder];
}

- (IBAction)SerachTextChange:(id)sender {
    
    UITextField * textField = sender;
    if(textField.text.length){
        _clearSerachText.hidden = NO;
    }else{
        _clearSerachText.hidden = YES;
    }
}

- (IBAction)clearSerachTextForView:(id)sender {
    [_IuputSercus resignFirstResponder];
    _IuputSercus.text =@"";
    _clearSerachText.hidden =YES;
}
@end
