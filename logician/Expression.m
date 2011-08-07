//
//  Expression.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Expression.h"


@implementation Expression

- (id)init
{
	return nil;
}

- (Expression *)expressionMappedFrom:(NSDictionary *)map
{
	if (!map)
	{
		return nil;
	}
	
	return self;
}

- (NSDictionary *)dictionaryMappingTo:(Expression *)other
{
	if (self == other)
	{
		return [NSDictionary dictionary];
	}
	
	return nil;
}

- (BOOL)isBound
{
	return YES;
}

- (NSString *)stringValue
{
	return [NSString string];
}

@end
