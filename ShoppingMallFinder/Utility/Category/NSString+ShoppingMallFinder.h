//
//  NSString+ShoppingMallFinder.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ShoppingMallFinder)

/**
 *  Check null String
 *
 *  @return if null String then 'Yes' else 'No'
 */
- (BOOL)isNULLString;

@end


@interface NSMutableString (ShoppingMallFinder)

/**
 *  Append String with comma separator
 *
 *  @param newString Return append String
 */
- (void)appendStringWithCommaSeparator:(NSString *)newString;
    
@end