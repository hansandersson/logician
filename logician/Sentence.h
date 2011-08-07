//
//  Sentence.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "Variable.h"

@interface Sentence : Expression
{
    NSArray *expressions;
}

- (id)initWithExpressions:(NSArray *)expressions;

- (NSArray *)expressions;
- (NSArray *)variables;

@end
