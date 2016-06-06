//
//  NSString+ShoppingMallFinder.m
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "NSString+ShoppingMallFinder.h"

@implementation NSString (ShoppingMallFinder)

- (BOOL)isNULLString {
    
    return ([self isEqualToString:@"(null)"]
            ||[self isEqualToString:@"(NULL)"]
            ||[self isEqualToString:@"<null>"]
            ||[self isEqualToString:@"<NULL>"]
            ||[self isKindOfClass:[NSNull class]]
			|| (self.length == 0));
}

@end


@implementation NSMutableString (ShoppingMallFinder)

/**
 *  Append String with comma separator
 *
 *  @param newString Return append String
 */
- (void)appendStringWithCommaSeparator:(NSString *)newString {
    
    
    NSString *appensString = [self isNULLString] ? [NSString stringWithFormat:@"%@",newString] : [NSString stringWithFormat:@", %@",newString];
    
    [self appendString:appensString];
}
@end