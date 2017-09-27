//
//  FilePickerViewController.h
//  FilePicker
//
//  Created by 胡焘坤 on 2017/8/28.
//  Copyright © 2017年 胡焘坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChooseMode)
{
    Single = 0,
    Mutiple
};

@interface FilePickerViewController : UIViewController
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, assign)ChooseMode mode;
@property (nonatomic, copy) void (^onFinishButtonClicked)(id);
@end
