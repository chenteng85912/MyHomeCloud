//
//  AJOtherViewController.m
//  MyHomeCloud
//
//  Created by tjsoft on 2017/5/20.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "AJOtherViewController.h"

@interface AJOtherViewController ()
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation AJOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _content.layoutManager.allowsNonContiguousLayout = NO;

    _content.attributedText = [self addLineSpace:[self secretStr]];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (NSString *)secretStr{
    return @"隐私政策\n安家易app尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务， 安家易app会按照本隐私权政策的规定使用和披露您的个人信息。但安家易app将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可的情况下，安家易app不会将这些信息对外披露或向第三方提供。安家易app会不时更新本隐私权政策。 您在同意安家易app服务使用协议之时，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于安家易app服务使用协议不可分割的一部分。\n1. 适用范围\n(a) 在您使用安家易app网络服务，或访问安家易app平台网页时，安家易app自动接收并记录的您的浏览器和计算机上的信息，包括但不限于您的IP地址、浏览器的类型、使用的语言、访问日期和时间、软硬件特征信息及您需求的网页记录等数据；\n(b) 安家易app通过合法途径从商业伙伴处取得的用户个人数据。\n2. 信息使用\n(a) 安家易app不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息，除非事先得到您的许可，或该第三方和安家易app（含安家易app关联公司）单独或共同为您提供服务，且在该服务结束后，其将被禁止访问包括其以前能够访问的所有这些资料。\n(b) 安家易app亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播您的个人信息。任何安家易app平台用户如从事上述活动，一经发现，我司有权立即终止与该用户的服务协议。\n(c) 为服务用户的目的，安家易app可能通过使用您的个人信息，向您提供您感兴趣的信息，包括但不限于向您发出产品和服务信息，或者与我司合作伙伴共享信息以便他们向您发送有关其产品和服务的信息（后者需要您的事先同意）。\n3. 信息披露  在如下情况下，安家易app将依据您的个人意愿或法律的规定全部或部分的披露您的个人信息：\n(a) 经您事先同意，向第三方披露；\n(b) 为提供您所要求的产品和服务，而必须和第三方分享您的个人信息；\n(c) 根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n(d) 如您出现违反中国有关法律、法规或者安家易app服务协议或相关规则的情况，需要向第三方披露；\n(e) 如您是适格的知识产权投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；\n(f) 在安家易app平台上创建的某一交易中，如交易任何一方履行或部分履行了交易义务并提出信息披露请求的，安家易app有权决定向该用户提供其交易对方的联络方式等必要信息，以促成交易的完成或纠纷的解决。\n(g) 其它安家易app根据法律、法规或者网站政策认为合适的披露。\n4. 信息存储和交换\n安家易app收集的有关您的信息和资料将保存在安家易app及（或）其关联公司的服务器上，这些信息和资料可能传送至您所在国家、地区或安家易app收集信息和资料所在地的境外并在境外被访问、存储和展示。\n5. 信息安全\n安家易app帐号均有安全保护功能，请妥善保管您的用户名及密码信息。安家易app将通过对用户密码进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您注意在信息网络上不存在“完善的安全措施”。";
}
- (NSMutableAttributedString *)addLineSpace:(NSString *)text{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;//行距
    paragraphStyle.firstLineHeadIndent = 32.f;//段首缩进
    
    NSDictionary *attribs = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    
    return attributedString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
