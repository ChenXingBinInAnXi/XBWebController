
//
//  XBWebViewController.m
//  testDemo
//
//  Created by chenxingbin on 2018/1/9.
//  Copyright © 2018年 chenxingbin. All rights reserved.
//

#import "XBWebViewController.h"


@interface XBWebViewController()<CXBWebViewDelegate>

@end

@implementation XBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequestWithUrlStr:self.urlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark --------------delegate-------------
-(void)webView:(XBWebView *)webView forTitle:(NSString *)title{
    self.navigationItem.title = title;
}



#pragma mark ------------getter setter------------
-(XBWebView *)webView{
    if (_webView == nil) {
        _webView = [[XBWebView alloc] initWithFrame:self.view.bounds];
        _webView.webViewDelegate = self;
    }
    return _webView;
}
-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
}

@end
