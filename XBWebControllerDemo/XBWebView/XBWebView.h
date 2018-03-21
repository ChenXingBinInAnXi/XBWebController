//
//  XBWebView.h
//  testDemo
//
//  Created by chenxingbin on 2018/1/9.
//  Copyright © 2018年 chenxingbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@protocol CXBWebViewDelegate;

@interface XBWebView : WKWebView

@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic,weak) id<CXBWebViewDelegate> webViewDelegate;

-(void)loadRequestWithUrlStr:(NSString *)urlStr;

@end








@protocol CXBWebViewDelegate <NSObject>

@optional
-(void)webView:(XBWebView *)webView forTitle:(NSString *)title;
- (void)webView:(XBWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
-(void)webView:(XBWebView *)webView canGoBackChange:(BOOL)canGoBack;

@end
