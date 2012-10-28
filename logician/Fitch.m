//
//  Fitch.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "Fitch.h"


@implementation Fitch

- (id)init
{
   	return nil;
}

- (id)initWithPremises:(NSSet *)initPremises
{	
	if ((self = [super init]))
	{
		premisesByDescription = [[NSMutableDictionary alloc] initWithCapacity:[initPremises count]];
		for (Expression *premise in initPremises)
		{
			[premisesByDescription setObject:premise forKey:[premise description]];
		}
	}
	return self;
}

- (NSSet *)deductions
{
	NSArray *rulesArray = [[premisesByDescription allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedExpression, NSDictionary *bindings) {
		(void) bindings;
		return [evaluatedExpression isKindOfClass:[Rule class]];
	}]];
	
	NSSet *rules = [NSSet setWithArray:rulesArray];
	
	NSArray *factsArray = [[premisesByDescription allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedExpression, NSDictionary *bindings) {
		(void) bindings;
		return [evaluatedExpression isKindOfClass:[Expression class]];
	}]];
	
	NSMutableSet *facts = [NSMutableSet setWithArray:factsArray];
	
	NSMutableDictionary *factsByDescription = [NSMutableDictionary dictionary];
	for (Expression *fact in facts)
	{
		[factsByDescription setObject:fact forKey:[fact description]];
	}

	NSMutableSet *deductions;
	do
	{
		deductions = [NSMutableSet set];
		for (Rule *rule in rules)
		{
			NSLog(@"%@", rule);
			[deductions unionSet:[rule deductionsWithGivens:facts]];
		}
		
		[deductions filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedDeduction, NSDictionary *bindings) {
			(void) bindings;
			if (![factsByDescription objectForKey:[evaluatedDeduction description]])
			{
				[factsByDescription setObject:evaluatedDeduction forKey:[evaluatedDeduction description]];
				return YES;
			}
			else
			{
				return NO;
			}
		}]];
		
		[facts unionSet:deductions];
	}
	while ([deductions count] > 0);
	
	return [facts filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedFact, NSDictionary *bindings) {
		(void) bindings;
		return ![premisesByDescription objectForKey:[evaluatedFact description]];
	}]];
}

- (NSArray *)proveConclusion:(Expression *)conclusion givenAssumptions:(NSSet *)assumptions
{
	(void) conclusion;
	(void) assumptions;
	return nil;
}

- (void)dealloc
{
	[premisesByDescription release];
    [super dealloc];
}

@end
