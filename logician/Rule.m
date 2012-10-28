//
//  Rule.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
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
	NSMutableSet *substratesUnsatisfied = [NSMutableSet setWithCapacity:[substrates count]];
	for (Expression *substrate in substrates)
	{
		NSSet *satisfactions = [givens filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedGiven, NSDictionary *bindings) {
			(void) bindings;
			return [[evaluatedGiven description] isEqualToString:[substrate description]];
		}]];
		
		if ([satisfactions count] == 0)
		{
			[substratesUnsatisfied addObject:substrate];
		}
	}
	
	NSSet *substratesImpossible = [substratesUnsatisfied filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedSubstrate, NSDictionary *bindings) {
		(void) bindings;
		return [evaluatedSubstrate isBound];
	}]];
	
	if ([substratesImpossible count] > 0)
	{
		return [NSSet set];
	}
	else if ([substratesUnsatisfied count] == 0)
	{
		return substitutions;
	}
	
	NSMutableSet *deductions = [NSMutableSet set];
	
	for (Expression *substrateUnsatisfied in substratesUnsatisfied)
	{
		for (Expression *given in givens)
		{
			NSMutableDictionary *constraintsModified = [[constraints mutableCopy] autorelease];
			NSDictionary *constraintsAddition = [substrateUnsatisfied dictionaryMappingTo:given];
			BOOL areConstraintsConsistent = !!constraintsAddition && [constraintsAddition count] > 0;
			
			if (areConstraintsConsistent)
			{
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
			}
			
			if (areConstraintsConsistent)
			{
				NSMutableSet *substratesConstrained = [NSMutableSet setWithCapacity:[substratesUnsatisfied count]];
				for (Expression *substrate in substratesUnsatisfied)
				{
					Expression *substrateConstrained = [substrate expressionMappedFrom:constraintsModified];
					[substratesConstrained addObject:substrateConstrained];
				}
				
				NSMutableSet *substitutionsConstrained = [NSMutableSet setWithCapacity:[substitutions count]];
				for (Expression *substitution in substitutions)
				{
					Expression *substitutionConstrained = [substitution expressionMappedFrom:constraintsModified];
					[substitutionsConstrained addObject:substitutionConstrained];
				}
				
				[deductions unionSet:[self deductionsWithGivens:givens substrates:substratesConstrained substitutions:substitutionsConstrained constraints:constraintsModified]];
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
