//
//  XBWebViewController.h
//  testDemo
//
//  Created by chenxingbin on 2018/1/9.
//  Copyright © 2018年 chenxingbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWebView.h"

@interface XBWebViewController : UIViewController

@property (nonatomic,strong) XBWebView *webView;

@property (nonatomic,copy) NSString *urlStr;

@end
