//
//  Variable.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Variable.h"

@implementation Variable

- (id)initWithStringValue:(NSString *)stringValueInit
{
	if ((self = [self init]))
	{
		stringValue = [stringValueInit copy];
	}
	return self;
}

- (void)dealloc
{
	[stringValue release];
	[super dealloc];
}

- (NSDictionary *)dictionaryMappingTo:(Expression *)other
{
	return [NSDictionary dictionaryWithObject:other forKey:[self description]];
}

- (Expression *)expressionMappedFrom:(NSDictionary *)map
{
	if (!map)
	{
		return nil;
	}
	
	if ([map objectForKey:[self description]])
	{
		return [map objectForKey:[self description]];
	}
	
	return self;
}

- (BOOL)isBound
{
	return NO;
}

- (NSString *)description
{
	return stringValue;
}

@end
