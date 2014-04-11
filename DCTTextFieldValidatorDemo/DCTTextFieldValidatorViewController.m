//
//  DCTTextFieldValidatorViewController.m
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 11/04/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTTextFieldValidatorViewController.h"

@interface DCTTextFieldValidatorViewController ()
@property (nonatomic, strong) IBOutlet DCTTextFieldValidator *validator;
@end

@implementation DCTTextFieldValidatorViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	__weak DCTTextFieldValidatorViewController *weakSelf = self;

	self.validator.returnHandler = ^ {
		[weakSelf login:weakSelf];
	};
}

- (IBAction)login:(id)sender {
	[[[UIAlertView alloc] initWithTitle:@"Login" message:@"This is where you'd handle the login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end