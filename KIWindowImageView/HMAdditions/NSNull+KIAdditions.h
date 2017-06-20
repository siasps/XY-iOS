//
//  NSNull+KIAdditions.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/14.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (KIAdditions)


//NSArray
- (id)objectAtIndex:(NSInteger)index;

//NSDictionary
- (id)objectForKey:(id)aKey;

- (NSString *)stringValueForKey:(id)key;


@end
