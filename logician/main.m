//
//  main.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "Rule.h"

int main (int argc, const char * argv[])
{	
	(void) argc;
	(void) argv;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableSet *premises = [NSMutableSet set];
	
	for (NSString *inputString = nil; !inputString || [inputString length] > 0; )
	{
		printf("∾ ");
		inputString = [[[[NSMutableString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding] autorelease] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
		for (NSString *statementString in [inputString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]])
		{
			if (![statementString isEqualToString:@""])
			{
				Parser *parser = [[Parser alloc] init];
				
				NSArray *statementComponents = [statementString componentsSeparatedByString:@":"];
				
				NSSet *expressions = [parser expressionsWithString:[statementComponents objectAtIndex:0]];
				
				if ([statementComponents count] == 2)
				{
					NSSet *conclusions = [parser expressionsWithString:[statementComponents objectAtIndex:1]];
					
					Rule *rule = [[[Rule alloc] initWithSubstrates:expressions substitions:conclusions] autorelease];
					[premises addObject:rule];
					printf("  %s\n", [[rule description] cStringUsingEncoding:NSUTF8StringEncoding]);
				}
				else
				{
					[premises unionSet:expressions];
					for (Expression *expression in expressions)
					{
						printf("  %s\n", [[expression description] cStringUsingEncoding:NSUTF8StringEncoding]);
					}
				}
				
				[parser release];
			}
		}
		[localPool drain];
	}
	
	[pool drain];
    return 0;
}

