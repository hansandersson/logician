//
//  Console.m
//  logician
//
//  Created by Hans Andersson on 11/08/05.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Console.h"

@implementation Console

- (id)init
{
	if ((self = [super init]))
	{
		variablesByStringValue = [[NSMutableDictionary alloc] init];
		carryoverCharacter = nil;
	}
	return self;
}

- (void)dealloc
{
	[variablesByStringValue release];
	[super dealloc];
}

+ (NSFileHandle *)sharedInputHandle
{
	if (!sharedInputHandle)
	{
		sharedInputHandle = [[NSFileHandle fileHandleWithStandardInput] retain];
	}
	return sharedInputHandle;
}

+ (LogicianConsoleInputMode)inputModeForString:(NSString *)string
{
	if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] == 0)
	{
		return LogicianConsoleInputModeVariable;
	}
	else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] length] == 0)
	{
		return LogicianConsoleInputModeConstant;
	}
	else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
	{
		return LogicianConsoleInputModeTermBreak;
	}
	else if ([string isEqualToString:@"["])
	{
		return LogicianConsoleInputModeSentence;
	}
	else if ([string isEqualToString:@"]"])
	{
		return LogicianConsoleInputModeSentenceClose;
	}
	
	return LogicianConsoleInputModeInvalid;
}


//returns nil if no data present
//returns variables for numeric input
//returns constants for alphabetic input
//returns sentences for nested inputs
- (Expression *)expressionWithInteractiveInput
{
	while (!carryoverCharacter || [[self class] inputModeForString:carryoverCharacter] == LogicianConsoleInputModeTermBreak)
	{
		if ([[[[self class] sharedInputHandle] availableData] length] == 0)
		{
			return nil;
		}
		
		carryoverCharacter = [[[NSString alloc] initWithData:[[[self class] sharedInputHandle] readDataOfLength:1] encoding:NSUTF8StringEncoding] autorelease];
	}
	
	//we now have the first sensible character
	
	LogicianConsoleInputMode inputMode = LogicianConsoleInputModeExpression;
	
	NSMutableString *workingString = [NSMutableString string];
	
	while ((inputMode == LogicianConsoleInputModeExpression) || ([[self class] inputModeForString:carryoverCharacter] == inputMode))
	{
		switch ([[self class] inputModeForString:carryoverCharacter])
		{
			case LogicianConsoleInputModeSentenceClose:
				return nil;
				
			case LogicianConsoleInputModeSentence:
			{
				NSMutableArray *expressions = [NSMutableArray array];
				Expression *nextExpression;
				for (Console *subconsole = [[Console alloc] init];
					 (nextExpression = [subconsole expressionWithInteractiveInput]);
					 [expressions addObject:nextExpression], [subconsole release], subconsole = [[Console alloc] init]);
				return [[[Sentence alloc] initWithExpressions:expressions] autorelease];
			}
			
			case LogicianConsoleInputModeConstant:
			case LogicianConsoleInputModeVariable:
			{
				[workingString appendString:carryoverCharacter];
			}	break;
			
			default: break;
		}
		
		if ([[[[self class] sharedInputHandle] availableData] length] > 0)
		{
			carryoverCharacter = [[[NSString alloc] initWithData:[[[self class] sharedInputHandle] readDataOfLength:1] encoding:NSUTF8StringEncoding] autorelease];
		}
		else
		{
			break;
		}
	}
	
	switch ([[self class] inputModeForString:carryoverCharacter])
	{
		case LogicianConsoleInputModeConstant:
			return [Constant constantWithStringValue:workingString];
		
		case LogicianConsoleInputModeVariable:
			if (![variablesByStringValue objectForKey:workingString])
			{
				[variablesByStringValue setObject:[[[Variable alloc] init] autorelease] forKey:workingString];
			}
			return [variablesByStringValue objectForKey:workingString];
		
		default: return nil;
	}
}

@end
