//
//  UIAlertController+ShoppingMallFinder.m
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//



#import "UIAlertController+ShoppingMallFinder.h"

@implementation UIAlertController (ShoppingMallFinder)



+ (UIAlertController *) showAlertControllerWithTitle:(nullable NSString *)title
                                      message:(nullable NSString *)message defaultButtonTitle:(nullable NSString *)defaultButtonTitle
                             cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               defaultHandler:(AlertControllerHandler)defaultHandler
                               cancelHandler:(AlertControllerHandler)cancelHandler
{
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    if(defaultButtonTitle.length) {
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:defaultButtonTitle
                                   style:UIAlertActionStyleDefault
                                   handler:defaultHandler];
        
        [alertController addAction:okAction];

    }
    
    if(cancelButtonTitle.length) {
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:cancelButtonTitle
                                       style:UIAlertActionStyleCancel
                                       handler:cancelHandler];
        
        [alertController addAction:cancelAction];
    }
    
    return alertController;
}


@end
