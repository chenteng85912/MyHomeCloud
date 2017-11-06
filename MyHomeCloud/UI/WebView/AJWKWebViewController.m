//
//  TYKYWebViewController.m
//  webhall
//
//  Created by tjsoft on 2017/6/7.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "AJWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface AJWKWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;//网页
@property (nonatomic, strong) UIProgressView *progressView;//进度条
@property (nonatomic, strong) UIButton *closeBtn;   //关闭按钮

@end

@implementation AJWKWebViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    
    self.navigationItem.titleView = [[CTAutoRunLabel alloc]
                                     initWithFrame:CGRectMake(0, 0, dWidth-120, 44)
                                     labelText:self.title
                                          font:16
                                     textColor:[UIColor whiteColor]
                                 textAlignment:NSTextAlignmentCenter
                                         speed:2];

    [self makeLeftCloseBtn];
    
    [self loadRequest];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
        return NO;
    }
    return YES;
}

- (void)makeLeftCloseBtn{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn addTarget:self action:@selector(backToPreVC) forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backBtn setImage:LOADIMAGE(@"back") forState:UIControlStateNormal];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];

    self.navigationItem.leftBarButtonItems = @[backItem,fix,closeItem];

}
- (void)closeAction{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    POPVC;
}
- (void)loadRequest
{
    debugLog(@"网页链接地址:%@",_urlPath);

    NSURL *url = [[NSURL alloc] initWithString:_urlPath];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.wkWebView loadRequest:request];
}
//中文转码
- (NSString *)URLEncodedString:(NSString *)urlStr
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlStr,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"网页加载进度:%f",self.wkWebView.estimatedProgress);
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            WeakSelf;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
        if (self.wkWebView.canGoBack) {
            self.closeBtn.hidden = NO;
        }else{
            self.closeBtn.hidden = YES;
            
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    debugLog(@"开始加载网页");
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    debugLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    if (webView.canGoBack) {
        self.closeBtn.hidden = NO;
    }else{
        self.closeBtn.hidden = YES;
        
    }

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
//    debugLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    if (webView.canGoBack) {
        self.closeBtn.hidden = NO;
    }else{
        self.closeBtn.hidden = YES;
        
    }
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    
//    debugLog(@"%@",navigationAction.request.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//    if (webView.canGoBack) {
//        self.closeBtn.hidden = NO;
//    }else{
//        self.closeBtn.hidden = YES;
//        
//    }
//    //不允许跳转
//    //decisionHandler(WKNavigationActionPolicyCancel);
//}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    debugLog(@"加载失败");
    self.progressView.hidden = YES;
}


#pragma mark - event response

#pragma mark - private methods
- (void)backToPreVC{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else{
        [self closeAction];
    }

}
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - getters and setters
- (UIProgressView *)progressView{
    if (_progressView ==nil) {
        _progressView =[[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, dWidth, 2)];
        _progressView.backgroundColor = [UIColor blueColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}
- (WKWebView *)wkWebView{
    if (_wkWebView==nil) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, dWidth, dHeight-64)];
        _wkWebView.navigationDelegate = self;
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _wkWebView;
}
- (UIButton *)closeBtn{
    if (_closeBtn ==nil) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_closeBtn setImage:LOADIMAGE(@"close") forState:UIControlStateNormal];
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;

    }
    return _closeBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
