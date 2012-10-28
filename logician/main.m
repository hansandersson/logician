//
//  main.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "Rule.h"
#import "Fitch.h"

void parseLine(NSString *line, NSMutableSet *premises, NSMutableSet *conclusions);

int main (const int argc, const char *argv[])
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//Get premises
	NSMutableSet *premises = [NSMutableSet set];
	NSMutableSet *conclusions = [NSMutableSet set];
	
	NSAutoreleasePool *filesPool = [[NSAutoreleasePool alloc] init];
	for (int a = 1; a < argc; a++)
	{
		NSString *filePath = [NSString stringWithCString:argv[a] encoding:NSUTF8StringEncoding];
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
		if (fileHandle)
		{
			NSString *fileContents = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
			NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			
			for (NSString *line in lines)
			{
				parseLine(line, premises, conclusions);
			}
			
			[fileContents release];
		}
	}
	[filesPool drain];
	
	for (Expression *premise in premises)
	{
		printf(". %s\n", [[premise description] cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	
	for (Expression *conclusion in conclusions)
	{
		printf("? %s\n", [[conclusion description] cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	
	for (NSString *inputString = nil;
		 !inputString || [inputString length] > 0;
		 printf("∾ "), inputString = [[[[NSMutableString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding] autorelease] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
	{
		parseLine(inputString, premises, conclusions);
	}
	
	NSSet *deductions = [[[[Fitch alloc] initWithPremises:premises] autorelease] deductions];
	for (Expression *deduction in deductions)
	{
		printf(", %s\n", [[deduction description] cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	
	[pool drain];
    return 0;
}

void parseLine(NSString *line, NSMutableSet *premises, NSMutableSet *conclusions)
{
	NSAutoreleasePool *linePool = [[NSAutoreleasePool alloc] init];
	if ([line length] > 0)
	{
		Parser *lineParser = [[Parser alloc] init];
		
		NSString *directive = [line substringToIndex:1];
		NSString *statement = [line substringFromIndex:1];
		
		if ([directive isEqualToString:@"."])
		{
			NSArray *components = [statement componentsSeparatedByString:@":"];
			
			if ([components count] == 1)
			{
				[premises unionSet:[lineParser expressionsWithString:statement]];
			}
			else
			{
				Rule *rule = [[Rule alloc] initWithSubstrates:[lineParser expressionsWithString:[components objectAtIndex:0]] substitions:[lineParser expressionsWithString:[components objectAtIndex:1]]];
				NSLog(@"%@", rule);
				[premises addObject:rule];
				[rule release];
			}
		}
		else if ([directive isEqualToString:@"?"])
		{
			[conclusions unionSet:[lineParser expressionsWithString:statement]];
		}
		else if (![directive isEqualToString:@"\""])
		{
			[premises unionSet:[lineParser expressionsWithString:line]];
		}
		
		[lineParser release];
	}
	[linePool drain];
}
