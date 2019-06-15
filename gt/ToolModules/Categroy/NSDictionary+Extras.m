

//
//  NSDictionary+Extras.m
//  TestDemo
//
//  Created by AaltoChen on 15/10/31.
//  Copyright © 2015年 AaltoChen. All rights reserved.
//

#import "NSDictionary+Extras.h"

@implementation NSDictionary (Extras)
- (BOOL)hasObjectForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return NO;
    }
    return YES;
}

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return @"";
    } else if ([NSObject isNSStringClass:object]) {
        return object;
    } else if ([NSObject isNSNumberClass:object]) {
        return [object stringValue];
    }
    return @"";
}
- (NSNumber *)numberForKey:(id)key{
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return [NSNumber numberWithInt:0];
    } else if ([NSObject isNSStringClass:object]) {
        return [NSNumber numberWithLongLong:[object longLongValue]];
    } else if ([NSObject isNSNumberClass:object]) {
        return object;
    }
    return [NSNumber numberWithInt:0];
}

- (int)intForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if ([NSObject isNSStringClass:object]) {
        return [object intValue];
    } else if ([NSObject isNSNumberClass:object]) {
        return [object intValue];
    }
    return 0;
}

- (float)floatForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object floatValue];
        } else {
            return 0;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object floatValue];
    }
    return 0;
}

- (long)longForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return 0;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object longValue];
        } else {
            return 0;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object longValue];
    }
    return 0;
}

- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [NSObject isNSNullClass:object]) {
        return NO;
    } else if([NSObject isNSStringClass:object]) {
        if ([(NSString *)object match:@"\\d+"]) {
            return [object boolValue];
        } else {
            return NO;
        }
    } else if ([NSObject isNSNumberClass:object]) {
        return [object boolValue];
    }
    return NO;
}

- (NSArray *)arrayForKey:(id)key {
    id object = [self objectForKey:key];
    if ([NSObject isNSArrayClass:object]) {
        return object;
    }
    return [NSArray array];
}

- (BOOL)avaliableForKey:(id)key {
    if ([[self allKeys] containsObject:key]) {
        if ([self hasObjectForKey:key]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSDictionary *)replacedKeyName:(NSString *)orginName replaceKey:(NSString*)replaceKey
{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if ([self allKeys].count > 0) {
        for (int i = 0; i < [self allKeys].count; i++) {
            if ([orginName isEqualToString:[[self allKeys] objectAtIndex:i]]) {
                NSString *tempValue = [self objectForKey:orginName];
                [data setObject:tempValue forKey:replaceKey];
            }else{
                
                NSString *tempKey =[[self allKeys] objectAtIndex:i];
                NSString *tempValue = [self objectForKey:tempKey];
                [data setObject:tempValue forKey:tempKey];
            }
        }
    }
    return data;
}
@end

@implementation NSMutableDictionary (Extras)
- (BOOL) setObject:(id)value forKey:(NSString*)key toast:(NSString*) toastStr{
    if (HandleStringIsNull(key)) {
        if (value && [value isKindOfClass:[NSString class]] && ((NSString*)value).length>0) {
            [self setObject:value forKey:key];
            return NO;
        }else{
            [self setObject:@"" forKey:key];
            NSString *str;
            if ([toastStr isEqualToString:@"单笔固额"]) {
                str = [@"请选择" stringByAppendingString:toastStr];
            }else{
                str = [@"请输入" stringByAppendingString:toastStr];
            }
            Toast(str);
        }
    }
    return YES;
}
- (void) setXcObject:(id)value forKey:(NSString*)key{
    [self setObject:value?value:@"" forKey:key];
}
@end
