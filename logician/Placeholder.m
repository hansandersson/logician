//
//  Placeholder.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import "Placeholder.h"

@implementation Placeholder

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

@end
