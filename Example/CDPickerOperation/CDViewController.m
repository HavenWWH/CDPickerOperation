//
//  CDViewController.m
//  CDPickerOperation
//
//  Created by 513433750@qq.com on 06/14/2019.
//  Copyright (c) 2019 513433750@qq.com. All rights reserved.
//

#import "CDViewController.h"
#import "CDPickerOperation.h"

@interface CDViewController ()

@end

@implementation CDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pick1:(id)sender {
    
    [CDPickerOperation creatPickTitile:@"选择年级" selectSting:@"一年级" itemsArray:@[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",] success:^(NSString *string) {
        
    }];
}

- (IBAction)pick2:(id)sender {
    
    [CDPickerOperation creatDataTitile:@"出生年月" selectSting:@"2011.11.11" success:^(NSString *string) {

        
    }];
}
@end
