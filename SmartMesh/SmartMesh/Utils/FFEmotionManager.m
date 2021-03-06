//
//  FFEmotionManager.m
//  SmartMesh
//
//  Created by Rain on 17/12/07.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import "FFEmotionManager.h"
#import "FFEmotion.h"

@implementation FFEmotionManager

static NSMutableArray * _emojiEmotions,*_custumEmotions,*gifEmotions;

+ (NSArray *)emojiEmotion
{
    if (_emojiEmotions) {
        return _emojiEmotions;
    }
    _emojiEmotions = [NSMutableArray array];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
    _emojiEmotions  = [FFEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    return _emojiEmotions;
}

+ (NSArray *)customEmotion
{
    if (_custumEmotions) {
        return _custumEmotions;
    }
    _custumEmotions = [NSMutableArray array];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"normal_face.plist" ofType:nil];
    _custumEmotions = [FFEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    return _custumEmotions;
}

+ (NSArray *)gifEmotion
{
    return nil;
}

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSString *regEmj  = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";// [微笑]、［哭］等自定义表情处理
    NSError *error    = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regEmj options:NSRegularExpressionCaseInsensitive error:&error];
    if (!expression) {
        return attributeStr;
    }
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, message.length)];
    NSArray *resultArray = [expression matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *match in resultArray) {
        NSRange range    = match.range;
        NSString *subStr = [message substringWithRange:range];
        NSArray *faceArr = [FFEmotionManager customEmotion];
        for (FFEmotion *face in faceArr) {
            if ([face.face_name isEqualToString:subStr]) {
                NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
                attach.image               = [UIImage imageNamed:face.face_name];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                [imagDic setObject:imgStr forKey:@"image"];
                
                DDYLog(@"%@::::%@",face.face_name,NSStringFromRange(range));
                [imagDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [mutableArray addObject:imagDic];
            }
        }
    }
    for (int i =(int) mutableArray.count - 1; i >=0; i --) {
        NSRange range2;
        [mutableArray[i][@"range"] getValue:&range2];
        [attributeStr replaceCharactersInRange:range2 withAttributedString:mutableArray[i][@"image"]];
    }
    return attributeStr;
}

@end
