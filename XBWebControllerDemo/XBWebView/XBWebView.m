
//
//  XBWebView.m
//  testDemo
//
//  Created by chenxingbin on 2018/1/9.
//  Copyright © 2018年 chenxingbin. All rights reserved.
//

#import "XBWebView.h"

#define MainColor     UIColorFromRGB(0x1FB5EC)  //主色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface XBWebView()<WKNavigationDelegate>
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation XBWebView

#pragma mark ------life cycle----------
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        
        [self.scrollView addSubview:self.progressView];
       
         self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        
      
        
        NSLayoutConstraint *TopCos = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self.scrollView addConstraint:TopCos];
        
        // 3.1.2左边约束(基于父控件)
        NSLayoutConstraint *leftCos = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.scrollView addConstraint:leftCos];
        
        // 3.1.3右边约束(基于父控件)
//        NSLayoutConstraint *rightCos = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//        [self.scrollView addConstraint:rightCos];

        NSLayoutConstraint *widthCos = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.scrollView.frame.size.width];
        // 3.1.3.2判断约束条件的层级关系，并添加到对应的视图
        [self.progressView addConstraint:widthCos];

        
        // 3.1.4 高度约束(自身)
        NSLayoutConstraint *heightCos = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:1.5];
        // 3.1.3.2判断约束条件的层级关系，并添加到对应的视图
        [self.progressView addConstraint:heightCos];
        
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        self.navigationDelegate = self;
        
    }
    return self;
}

// 记得取消监听
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    [self removeObserver:self forKeyPath:@"title"];
    [self removeObserver:self forKeyPath:@"canGoBack"];
}



#pragma mark ------ wkWebView代理---
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
   
    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.webViewDelegate webView:self didFinishNavigation:navigation];
    }

   
}


#pragma mark ---------event--------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self && [keyPath isEqualToString:@"estimatedProgress"]){
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if (object == self&&[keyPath isEqualToString:@"title"]){
        if ([self.webViewDelegate respondsToSelector:@selector(webView:forTitle:)]) {
            [self.webViewDelegate webView:self forTitle:self.title];
        }
    }else if (object == self && [keyPath isEqualToString:@"canGoBack"]){
        if ([self.webViewDelegate respondsToSelector:@selector(webView:canGoBackChange:)]){
            int canGoBack = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
            [self.webViewDelegate webView:self canGoBackChange:canGoBack];
        }
    }
}


#pragma mark ---------private-------
-(void)loadRequestWithUrlStr:(NSString *)urlStr{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self loadRequest:request];
}



-(WKWebViewConfiguration *)getCookiesConfigus{
    NSDictionary *cookiesDict = @{};
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    webConfig.preferences = [[WKPreferences alloc] init];
    // 默认为0
    webConfig.preferences.minimumFontSize = 10;
    // 默认认为YES
    webConfig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    webConfig.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    //NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = '%@';",str];
    NSMutableString *cookieValue = [NSMutableString string];
    [cookiesDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [cookieValue appendFormat:@"document.cookie='%@=%@';\n", key, obj];
    }];
    
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    return webConfig;
}


#pragma mark --------getter setter----------
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.progressView.progressTintColor = lineColor;
}
-(UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = MainColor;
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

@end
