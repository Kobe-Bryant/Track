//
//  GiveFeedbackViewController.m
//  Care
//
//  Created by Vecklink on 14-6-21.
//
//

#import "GiveFeedback_ViewController.h"

@interface GiveFeedback_ViewController ()<UITextViewDelegate> {
    
    __weak IBOutlet UIImageView *textViewBackgroundImageView;

    __weak IBOutlet UITextView *feedbackTextView;
    __weak IBOutlet UILabel *descriptionLabel;
    
    ASIHTTPRequest *req;
}

@end

@implementation GiveFeedback_ViewController

- (void)dealloc
{
    [req clearDelegatesAndCancel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"意见反馈", nil);
    [self setBackButton];
    [self setSubmitButton];
    
    textViewBackgroundImageView.image = [[UIImage imageNamed:@"02_textField_long"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    descriptionLabel.text = NSLocalizedString(@"感谢您对乐卡提出宝贵的意见。", nil);
}

//导航栏返回按钮（宏）
_Method_SetBackButton(nil, NO)


-(void)viewDidAppear:(BOOL)animated {
    [feedbackTextView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    descriptionLabel.hidden = YES;
    [textViewBackgroundImageView setImage:[[UIImage imageNamed:@"02_textField_long_selected"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([feedbackTextView.text isEqualToString:@""]) {
        descriptionLabel.hidden = NO;
    }
    [textViewBackgroundImageView setImage:[[UIImage imageNamed:@"02_textField_long"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [feedbackTextView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) {
        return YES;
    }
    
    char ch = [string characterAtIndex:0];
    if (3==strlen([string UTF8String])
        || ((ch > 47)&&(ch < 58))
        || ((ch > 64)&&(ch < 91))
        || ((ch > 96)&&(ch < 123))){
    } else {
        //特殊字符不给输入
        return NO;
    }
    
    
    NSString *textString = textField.text;
    int cn=0, letters=0, num=0, other=0;
    
    for (int i=0; i<textField.text.length; i++) {
        char ch = [textString characterAtIndex:i];
        NSString *temp = [textString substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            cn++;
        }else if((ch > 64)&&(ch < 91)){
            letters++;
        }else if((ch > 96)&&(ch < 123)){
            letters++;
        }else if((ch > 47)&&(ch < 58)){
            num++;
        }else{
            other++;
        }
    }
    
    int len=0;
    if (cn || other) {
        len = 7;
    } else {
        len = 20;
    }
    if (([textField.text length] + [string length] - range.length) > len) {
        return NO;
    }
    
    return YES;
}

_Method_SetSubmitButton(NSLocalizedString(@"提交", nil), (@selector(onSubmitButtonPressed)), _StringWidth(NSLocalizedString(@"提交", nil)))

-(void)onSubmitButtonPressed {
    [feedbackTextView resignFirstResponder];
    
    if ([feedbackTextView.text isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有输入反馈意见", nil)];
        [alertView show];
        return;
    }
    NSLog(@"提交反馈");
    
    NSMutableDictionary *signInfo = [NSMutableDictionary dictionary];
    [signInfo setValue:_Interface_user_feedback forKey:@"method"];
    [signInfo setValue:[MD5 base64EncodedStringFrom:[feedbackTextView.text dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"feedback"];
    [signInfo setValue:[UserData Instance].uid forKey:@"uid"];
    [signInfo setValue:[UserData Instance].sessionId forKey:@"session"];
    
    NSString *baseFeedback = [signInfo[@"feedback"] stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    baseFeedback = [baseFeedback stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    [signInfo setValue:baseFeedback forKey:@"feedback"];
    
    NSString *sign = [MD5 createSignWithDictionary:signInfo];
    NSString *urlStr = [MD5 createUrlWithDictionary:signInfo Sign:sign];
    
    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [req addRequestHeader:[MD5 getUserAgent] value:@"User-Agent"];
    req.delegate = self;
    [req startAsynchronous];
    _Code_ShowLoading
}

#pragma mark - ASIHTTPRequestDelegate
//  ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    _Code_HiddenLoading
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:nil];
    _Code_HTTPResponseCheck(jsonDic, {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] initStyleZeroWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"提交成功", nil)];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    })
}
_Method_RequestFailed()

@end
