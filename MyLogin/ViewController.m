//
//  ViewController.m
//  MyLogin
//
//  Created by Kulakshi Fernando on 10/1/20.
//  Copyright © 2020 Kulakshi. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()

@end

@implementation ViewController

NSString * FBUserId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.permissions = @[@"public_profile", @"email"];
    loginButton.delegate = self;
    // Optional: Place the button in the center of your view.
    if ([FBSDKAccessToken currentAccessToken]) {
        [self getFBUserDetails];
    }else{
        loginButton.center = self.view.center;
        [self.view addSubview:loginButton];
    }
}



- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if(result){
        if(!result.isCancelled){
            
            if ([FBSDKAccessToken currentAccessToken]) {
                FBUserId = result.token.userID;
                [self getFBUserDetails];
            }
        }
    }
    
    if(error){
        NSLog(@"Error: %@", error);
    }
    
}

-(void) getFBUserDetails{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user: %@", result);
            NSLog(@"fetched user name: %@", result[@"name"]);
        }else{
            NSLog(@"fetched user name error:%@", error);
        }
    }];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"me?fields=picture",FBUserId] parameters:nil HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user picture: %@", result);
            NSLog(@"fetched user picture url: %@", result[@"picture"][@"data"][@"url"]);
        }else{
            NSLog(@"fetched user picture error:%@", error);
        }
    }];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"me?fields=email",FBUserId] parameters:nil HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user email: %@", result);
        }else{
            NSLog(@"fetched user email error:%@", error);
        }
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
}


@end
