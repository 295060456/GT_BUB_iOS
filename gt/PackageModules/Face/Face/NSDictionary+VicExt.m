//
//  NSDictionary+VicExt.m
//  Vicon
//
//  Created by HuHao on 15/10/2.
//  Copyright © 2015年 Vicon. All rights reserved.
//

#import "NSDictionary+VicExt.h"


@interface _VicXMLDictionaryParser : NSObject <NSXMLParserDelegate>
@end

@implementation _VicXMLDictionaryParser {
    NSMutableDictionary *_root;
    NSMutableArray *_stack;
    NSMutableString *_text;
}
@end

@implementation NSDictionary (VicExt)

- (id)objectOrNilForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]] && [self containsObjectForKey:key]) {
        return self[key];
    }
    return nil;
}

- (BOOL)containsObjectForKey:(id)key {
    return [[self allKeys] containsObject:key];
}


- (NSDictionary *)vic_appendKey:(NSString *)key value:(id)value{
    NSMutableDictionary *result = [self mutableCopy];
    if (key.length > 0) {
        if ([value isKindOfClass:[NSString class]]) {
            if ([value length] > 0) {
                [result addEntriesFromDictionary:@{key:value}];
            }
        }else if([value isKindOfClass:[NSArray class]]){
            if ([(NSArray *)value count] > 0) {
                [result addEntriesFromDictionary:@{key:value}];
            }
        }else if([value intValue]  > 0){
            [result addEntriesFromDictionary:@{key:value}];
        }
    }
    return result;
}

- (NSDictionary *)vic_appendKeyWithEmptyValue:(NSString *)key value:(id)value{
    NSMutableDictionary *result = [self mutableCopy];
    if (key.length > 0) {
        if ([value isKindOfClass:[NSString class]]) {
            if ([value length] > 0) {
                [result addEntriesFromDictionary:@{key:value}];
            }else{
                [result addEntriesFromDictionary:@{key:@""}];
            }
        }else if([value isMemberOfClass:[NSArray class]]){
            if ([(NSArray *)value count] > 0) {
                [result addEntriesFromDictionary:@{key:value}];
            }
        }else if(value){
            [result addEntriesFromDictionary:@{key:value}];
        }else{
            [result addEntriesFromDictionary:@{key:@""}];
        }
    }
    return result;
    
}

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}


@end
