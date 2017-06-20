//
//  NSNull+KIAdditions.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/14.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "NSNull+KIAdditions.h"

@implementation NSNull (KIAdditions)


//NSArray
- (id)objectAtIndex:(NSInteger)index{
    return nil;
}

//NSDictionary
- (id)objectForKey:(id)aKey{
    return nil;
}

- (NSString *)stringValueForKey:(id)key{
    return @"";
}


@end
