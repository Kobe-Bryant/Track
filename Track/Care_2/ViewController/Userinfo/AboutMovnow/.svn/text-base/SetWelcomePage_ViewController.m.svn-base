//
//  SetWelcomePage_ViewController.m
//  Care
//
//  Created by Vecklink on 14-6-20.
//
//

#import "SetWelcomePage_ViewController.h"

@interface SetWelcomePage_ViewController () {
    
    __weak IBOutlet UIImageView *imgView;
}

@end

@implementation SetWelcomePage_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_Is_En_Language) {
        imgView.image = [UIImage imageNamed:@"en_welcome_page"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
