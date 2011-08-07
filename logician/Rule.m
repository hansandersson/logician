//
//  Rule.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Rule.h"

@interface Rule (Private)
+ (NSSet *)deductionsWithGivens:(NSSet *)givens premises:(NSSet *)premises constraints:(NSMutableDictionary *)constraints conclusion:(Expression *)conclusion;
@end

@implementation Rule

- (id)init
{
    return nil;
}

- (id)initWithSubstrates:(NSSet *)initSubstrates substitions:(NSSet *)initSubstitutions
{
	if (!initSubstrates || !initSubstitutions) return nil;
	
	if ((self = [super init]))
	{
		substrates = [initSubstrates copy];
		substitutions = [initSubstitutions retain];
	}
	
	return self;
}

- (NSSet *)substrates
{
	return substrates;
}

- (NSSet *)substitutions
{
	return substitutions;
}

- (NSSet *)deductionsWithGivens:(NSSet *)givens
{
	return [[self class] deductionsWithGivens:givens premises:substrates constraints:[NSDictionary dictionary] conclusion:nil];
}

+ (NSSet *)deductionsWithGivens:(NSSet *)givens premises:(NSSet *)premises constraints:(NSMutableDictionary *)constraints conclusion:(Expression *)conclusion
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
				[deductions unionSet:[self deductionsWithGivens:givens premises:premisesModified constraints:constraintsModified conclusion:conclusion]];
			}
		}
	}
	
	return deductions;
}

- (NSString *)description
{
	NSMutableArray *substrateDescriptions = [NSMutableArray arrayWithCapacity:[substrates count]];
	for (Expression *substrate in substrates)
	{
		[substrateDescriptions addObject:[substrate description]];
	}
	
	NSMutableArray *substitutionDescriptions = [NSMutableArray arrayWithCapacity:[substitutions count]];
	for (Expression *substitution in substitutions)
	{
		[substitutionDescriptions addObject:[substitution description]];
	}
	
	return [NSString stringWithFormat:@"%@ : %@", [substrateDescriptions componentsJoinedByString:@" "], [substitutionDescriptions componentsJoinedByString:@" "]];
}

- (void)dealloc
{
	[substrates release];
	[substitutions release];
    [super dealloc];
}

@end
