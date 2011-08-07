//
//  Sentence.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Sentence.h"


@implementation Sentence

- (id)initWithExpressions:(NSArray *)initExpressions
{
	if (!initExpressions) return nil;
	
    if ((self = [super init]))
	{
        expressions = [initExpressions copy];
    }
    return self;
}

- (NSArray *)expressions
{
	return expressions;
}

- (NSDictionary *)dictionaryMappingTo:(Expression *)other
{
	if (![other isKindOfClass:[self class]] || [[self expressions] count] != [[(Sentence *)other expressions] count])
	{
		return nil;
	}
	
	NSMutableDictionary *map = [NSMutableDictionary dictionary];
	
	for (NSUInteger e = 0; e < [[self expressions] count]; e++)
	{
		Expression *left = [[self expressions] objectAtIndex:e];
		Expression *right = [[(Sentence *)other expressions] objectAtIndex:e];
		NSDictionary *mapAddition = [left dictionaryMappingTo:right];
		if (!mapAddition) return nil;
		
		for (id key in [mapAddition allKeys])
		{
			if (![map objectForKey:key])
			{
				[map setObject:[mapAddition objectForKey:key] forKey:key];
			}
			else if ([map objectForKey:key] != [mapAddition objectForKey:key])
			{
				return nil;
			}
		}
	}
	
	return map;
}

- (Expression *)expressionMappedFrom:(NSDictionary *)map
{
	NSMutableArray *derivedExpressions = [NSMutableArray arrayWithCapacity:[[self expressions] count]];
	
	for (Expression *nextExpression in [self expressions])
	{
		Expression *nextDerivedExpression = [nextExpression expressionMappedFrom:map];
		if (!nextDerivedExpression)
		{
			return nil;
		}
		[derivedExpressions addObject:nextDerivedExpression];
	}
	
	return [[[[self class] alloc] initWithExpressions:derivedExpressions] autorelease];
}

- (NSArray *)variables
{
	return [[self expressions] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Expression *evaluatedObject, NSDictionary *bindings) { (void) bindings; return [evaluatedObject isKindOfClass:[Variable class]]; }]];
}

- (BOOL)isBound
{
	for (Expression *expression in expressions)
	{
		if (![expression isBound])
		{
			return NO;
		}
	}
	return YES;
}

- (NSString *)stringValue
{
	NSMutableArray *expressionStringValues = [NSMutableArray arrayWithCapacity:[expressions count]];
	for (Expression *expression in expressions)
	{
		[expressionStringValues addObject:[expression stringValue]];
	}
	
	return [NSString stringWithFormat:@"[ %@ ]", [expressionStringValues componentsJoinedByString:@" "]];
}

- (void)dealloc
{
	[expressions release];
    [super dealloc];
}

@end
