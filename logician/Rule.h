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
    NSSet *substrates;
	NSSet *substitutions;
}

- (id)initWithSubstrates:(NSSet *)initPremises substitions:(NSSet *)deductions;

- (NSSet *)substrates;
- (NSSet *)substitutions;

- (NSSet *)deductionsWithGivens:(NSSet *)givens;

- (NSString *)description;

@end
