//
//  DCTTextFieldValidatorViewController.m
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTTextFieldValidatorViewController.h"
#import "DCTTextFieldValidator.h"

@implementation DCTTextFieldValidatorViewController
@synthesize validator;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	__weak DCTTextFieldValidatorViewController *weakSelf = self;
	
	validator.returnPressedHandler = ^ {
		[weakSelf login:weakSelf];		
	};
}

- (IBAction)login:(id)sender {
	[[[UIAlertView alloc] initWithTitle:@"Login" message:@"This is where you'd handle the login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
