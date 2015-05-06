//
//  RightMenuViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"


@interface NoteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageNote;
@property (weak, nonatomic) IBOutlet UIImageView *imageNote1;
-(void)setData:(bool)isNote;
@end


@interface SingerUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SetString;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *headerImages;
-(void)setData:(NSString *)username Set:(NSString *)set HeaderImg:(NSString *)url;
@end



@interface RightMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    bool isnibr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *IuputSercus;
@property (weak, nonatomic) IBOutlet UIButton *clearSerachText;
- (IBAction)HideKey:(id)sender;
- (IBAction)SerachTextChange:(id)sender;
- (IBAction)clearSerachTextForView:(id)sender;

@end
