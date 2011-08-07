//
//  main.m
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"

int main (int argc, const char * argv[])
{	
	(void) argc;
	(void) argv;
	//NSScanner
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	/*NSString *filePath = [NSString stringWithUTF8String:argv[1]];
	
	NSError *error = nil;
	NSString *fileContents = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:&error];
	if (error) NSLog(@"%@", error);
	
	NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];*/
	
	while (true)
	{
		Parser *parser = [[Parser alloc] init];
		if ([[Parser sharedInputHandle] availableData])
		{
			Expression *expression = [parser expressionWithInteractiveInput];
			NSLog(@"%@", [expression stringValue]);
			[expression release];
		}
		[parser release];
	}

	[pool drain];
    return 0;
}

