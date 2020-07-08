//
//  NSString+jsonParse.h.h
//  YoutubeParser
//
//  Created by 吉田 仙哉 on 2020/07/07.
//  Copyright © 2020 Hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (jsonParse)
+ (NSString*) URLDecode:(NSString*)text;
- (NSMutableDictionary *)jsonParse;
@end
