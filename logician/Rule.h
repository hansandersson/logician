//
//  Rule.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

@interface Rule : NSObject
{
    NSSet *premises;
	Expression *conclusion;
}

- (id)initWithPremises:(NSSet *)initPremises conclusion:(Expression *)conclusion;

- (NSSet *)premises;
- (Expression *)conclusion;

- (NSSet *)deductionsWithGivens:(NSSet *)givens;

@end
