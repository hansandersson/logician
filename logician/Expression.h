//
//  Expression.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expression : NSObject {}

- (NSDictionary *)dictionaryMappingTo:(Expression *)other;
- (Expression *)expressionMappedFrom:(NSDictionary *)map;

- (BOOL)isBound;

- (BOOL)isEqualTo:(id)object;

@end
