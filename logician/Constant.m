//
//  Constant.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Constant.h"

@interface Constant (Private)
- (id)initWithStringValue:(NSString *)initStringValue;
@end

@implementation Constant

+ (void)initialize
{
	constantsByStringValue = [[NSMutableDictionary alloc] init];
}

+ (Constant *)constantWithStringValue:(NSString *)stringValue
{
	if (!stringValue) return nil;
	
	if (![constantsByStringValue objectForKey:stringValue])
	{
		[constantsByStringValue setObject:[[[Constant alloc] initWithStringValue:stringValue] autorelease] forKey:stringValue];
	}
	return [constantsByStringValue objectForKey:stringValue];
}

- (id)initWithStringValue:(NSString *)initStringValue
{
	if (!initStringValue) return nil;
	
	if ([constantsByStringValue objectForKey:initStringValue]) return nil;
	
    if ((self = [super init]))
	{
        stringValue = [initStringValue copy];
		[constantsByStringValue setObject:self forKey:stringValue];
    }
    
	return self;
}

- (NSString *)stringValue
{
	return stringValue;
}

- (void)dealloc
{
	[stringValue release];
    [super dealloc];
}

@end
