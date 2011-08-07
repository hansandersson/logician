//
//  Fitch.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Fitch.h"


@implementation Fitch

- (id)init
{
   	return nil;
}

- (id)initWithRules:(NSSet *)initRules
{
	if (!initRules) return nil;
	
	if ((self = [super init]))
	{
		rules = [initRules copy];
	}
	return self;
}

- (NSArray *)proveConclusion:(Expression *)conclusion givenAssumptions:(NSSet *)assumptions
{
	(void) conclusion;
	(void) assumptions;
	return nil;
}

- (void)dealloc
{
	[rules release];
    [super dealloc];
}

@end
