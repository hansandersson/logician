//
//  Rule.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Rule.h"

@interface Rule (Private)
+ (NSSet *)deductionsWithGivens:(NSSet *)givens substrates:(NSSet *)substrates substitutions:(NSSet *)substitutions constraints:(NSMutableDictionary *)constraints;
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
	return [[self class] deductionsWithGivens:givens substrates:substrates substitutions:substitutions constraints:[NSDictionary dictionary]];
}

+ (NSSet *)deductionsWithGivens:(NSSet *)givens substrates:(NSSet *)substrates substitutions:(NSSet *)substitutions constraints:(NSMutableDictionary *)constraints
{
	/*if ([conclusion isBound])
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
	}*/
	
	NSMutableSet *deductions = [NSMutableSet set];
	
	if ([substitutions count] == 0 || [substrates count] == 0)
	{
		return deductions;
	}
	
	for (Expression *substrate in substrates)
	{
		for (Expression *given in givens)
		{
			NSMutableDictionary *constraintsModified = [[constraints mutableCopy] autorelease];
			NSDictionary *constraintsAddition = [substrate dictionaryMappingTo:given];
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
				NSMutableSet *substratesModified = [NSMutableSet setWithCapacity:[substrates count]];
				for (Expression *substrateModifiable in substrates)
				{
					Expression *substrateModified = [substrateModifiable expressionMappedFrom:constraintsModified];
					if (![substrateModified isBound])
					{
						[substratesModified addObject:[substrateModifiable expressionMappedFrom:constraintsModified]];
					}
				}
				
				NSMutableSet *substitutionsModified = [NSMutableSet setWithCapacity:[substitutions count]];
				for (Expression *substitutionModifiable in substitutions)
				{
					Expression *substitutionModified = [substitutionModifiable expressionMappedFrom:constraintsModified];
					if (![substitutionModified isBound])
					{
						[substitutionsModified addObject:substitutionModified];
					}
					else
					{
						[deductions addObject:substitutionModified];
					}
				}
				
				[deductions unionSet:[self deductionsWithGivens:givens substrates:substratesModified substitutions:substitutionsModified constraints:constraintsModified]];
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
