//
//  NSString+jsonParse.h.m
//  YoutubeParser
//
//  Created by 吉田 仙哉 on 2020/07/07.
//  Copyright © 2020 Hiddencode.me. All rights reserved.
//

#import "NSString+jsonParse.h"
#define PICOJSON_USE_INT64
#import <picojson.h>

// make NSMutableDictionary by picojson.
// genelate unescaped value.

// private jsonParse
@interface NSString (jsonParsePrivate)
+ (NSObject *)jsonNode:(const picojson::value&) v;
@end

@implementation NSString (jsonParsePrivate)
+ (NSObject *)jsonNode:(const picojson::value&) v {
    if (v.is<picojson::array>()){
        NSMutableArray *mary = [NSMutableArray array];
        auto a = v.get<picojson::array>();
        for (picojson::array::const_iterator i = a.begin(); i != a.end(); ++i) {
            [mary addObject:[NSString jsonNode:*i]];
        }
        return mary;
    }else
    if (v.is<picojson::object>()){
        NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
        auto o = v.get<picojson::object>();
        for (picojson::object::const_iterator i = o.begin(); i != o.end(); ++i) {
            NSString *newKey = [NSString stringWithUTF8String:i->first.c_str()];
            mdic[newKey] = [NSString jsonNode:i->second];
        }
        return mdic;
    }else
    if (v.is<int64_t>()) {
           return  [NSNumber numberWithLong:v.get<int64_t>()];
    }else
    if (v.is<bool>()){
           return  [NSNumber numberWithBool: v.get<bool>()?TRUE:FALSE];
    }else
    if (v.is<std::string>()){
           return [NSString stringWithUTF8String:v.get<std::string>().c_str()];
    }else
    if (v.is<double>()){
           return [NSNumber numberWithDouble:v.get<double>()];;
    }
    return nil;
}
@end


// main jsonParse
@implementation NSString (jsonParse)
+ (NSString*) URLDecode:(NSString*)text{
   return (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(CFStringRef)text,CFSTR(""),kCFStringEncodingUTF8));
}
- (NSMutableDictionary *)jsonParse {
    picojson::value v;
    std::string err = picojson::parse(v, [self UTF8String]);
    if (! err.empty()) {
        return nil;
    }
    return (NSMutableDictionary *)[NSString jsonNode:v];
}
@end

