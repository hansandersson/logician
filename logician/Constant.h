//
//  Constant.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

NSMutableDictionary *constantsByStringValue;

@interface Constant : Expression
{
    NSString *stringValue;
}

+ (Constant *)constantWithStringValue:(NSString *)stringValue;

@end
