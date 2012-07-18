//
//  ViewController.h
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCTTextFieldValidator/DCTTextFieldValidator.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet DCTTextFieldValidator *validator;
- (IBAction)login:(id)sender;
@end
