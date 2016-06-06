//
//  UIAlertController+ShoppingMallFinder.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertControllerHandler) (UIAlertAction  * _Nullable action);

@interface UIAlertController (ShoppingMallFinder)

/**
 *  Show the Alert View Controller
 *
 *  @param title              Alert Title
 *  @param message            Alert Message
 *  @param defaultButtonTitle Alert Default Button title
 *  @param cancelButtonTitle  Alert Cancle Button title
 *  @param defaultHandler     Alert Default Handler
 *  @param cancelHandler      Alert Cancel Handler
 *
 *  @return UIAlertController
 */

+ (nonnull UIAlertController *) showAlertControllerWithTitle:(nullable NSString *)title
                                      message:(nullable NSString *)message defaultButtonTitle:(nullable NSString *)defaultButtonTitle
                            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               defaultHandler:(nullable AlertControllerHandler)defaultHandler
                                cancelHandler:(nullable AlertControllerHandler)cancelHandler;
@end
