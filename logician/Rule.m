//
//  Rule.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Rule.h"

@interface Rule (Private)
+ (NSSet *)deductionsWithGivens:(NSSet *)givens premises:(NSSet *)premises constraints:(NSDictionary *)constraints;
@end

@implementation Rule

- (id)init
{
    return nil;
}

- (id)initWithPremises:(NSSet *)initPremises conclusion:(Expression *)initConclusion
{
	if (!initPremises || !initConclusion) return nil;
	
	if ((self = [super init]))
	{
		premises = [initPremises copy];
		conclusion = [conclusion retain];
	}
	
	return self;
}

- (NSSet *)premises
{
	return premises;
}

- (Expression *)conclusion
{
	return conclusion;
}

- (NSSet *)deductionsWithGivens:(NSSet *)givens
{
	return [[self class] deductionsWithGivens:givens premises:premises constraints:[NSDictionary dictionary]];
}

+ (NSSet *)deductionsWithGivens:(NSSet *)givens premises:(NSSet *)premises constraints:(NSMutableDictionary *)constraints towardConclusion:(Expression *)conclusion
{
	if ([conclusion isBound])
	{
		BOOL isConclusionJustified = YES;
		for (Expression *premise in premises)
		{
			if (![premise isBound])
			{
				isConclusionJustified = NO;
				break;
			}
		}
		if (isConclusionJustified)
		{
			return [NSMutableSet setWithObject:conclusion];
		}
	}
	
	NSMutableSet *deductions = [NSMutableSet set];
	
	for (Expression *premiseMaster in premises)
	{
		for (Expression *given in givens)
		{
			NSMutableDictionary *constraintsModified = [[constraints mutableCopy] autorelease];
			NSDictionary *constraintsAddition = [premiseMaster dictionaryMappingTo:given];
			BOOL areConstraintsConsistent = !!constraintsAddition;
			
			for (id key in [constraintsAddition allKeys])
			{
				if (![constraintsModified objectForKey:key])
				{
					[constraintsModified setObject:[constraintsAddition objectForKey:key] forKey:key];
				}
				else if ([constraintsModified objectForKey:key] != [constraintsAddition objectForKey:key])
				{
					areConstraintsConsistent = NO;
					break;
				}
			}
			
			if (areConstraintsConsistent)
			{
				NSMutableSet *premisesModified = [NSMutableSet setWithCapacity:[premises count]];
				for (Expression *premiseSlave in premises)
				{
					[premisesModified addObject:[premiseSlave expressionMappedFrom:constraints]];
				}
				[deductions unionSet:[self deductionsWithGivens:givens premises:premisesModified constraints:constraintsModified]];
			}
		}
	}
	
	return deductions;
}

- (void)dealloc
{
	[premises release];
	[conclusion release];
    [super dealloc];
}

@end
