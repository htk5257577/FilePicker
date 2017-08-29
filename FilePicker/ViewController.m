//
//  ViewController.m
//  FilePicker
//
//  Created by 胡焘坤 on 2017/8/28.
//  Copyright © 2017年 胡焘坤. All rights reserved.
//

#import "ViewController.h"
#import "FilePickerViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseFileButtonClicked:(id)sender {
    FilePickerViewController *picker = [[FilePickerViewController alloc] init];
    picker.onFinishButtonClicked = ^(NSString * str){
        self.label.text = str;
    };
    [self presentViewController:picker animated:YES completion:nil];
}

@end
