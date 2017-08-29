//
//  FilePickerViewController.h
//  FilePicker
//
//  Created by 胡焘坤 on 2017/8/28.
//  Copyright © 2017年 胡焘坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilePickerViewController : UIViewController
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy) void (^onFinishButtonClicked)(NSString *);
@end
