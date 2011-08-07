//
//  Parser.m
//  logician
//
//  Created by Hans Andersson on 11/08/05.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import "Parser.h"

@implementation Parser

- (id)init
{
	if ((self = [super init]))
	{
		variablesByStringValue = [[NSMutableDictionary alloc] init];
		parsePosition = 0;
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

+ (LogicianParserInputMode)inputModeForString:(NSString *)string
{
	if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] == 0)
	{
		return LogicianParserInputModeVariable;
	}
	else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] length] == 0)
	{
		return LogicianParserInputModeConstant;
	}
	else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
	{
		return LogicianParserInputModeTermBreak;
	}
	else if ([string isEqualToString:@"["])
	{
		return LogicianParserInputModeSentence;
	}
	else if ([string isEqualToString:@"]"])
	{
		return LogicianParserInputModeSentenceClose;
	}
	
	return LogicianParserInputModeInvalid;
}


//returns nil if no data present
//returns variables for numeric input
//returns constants for alphabetic input
//returns sentences for nested inputs
- (Expression *)expressionWithString:(NSString *)sourceString
{
	while (!carryoverCharacter || [[self class] inputModeForString:carryoverCharacter] == LogicianParserInputModeTermBreak)
	{
		if ([[[[self class] sharedInputHandle] availableData] length] == 0)
		{
			return nil;
		}
		
		carryoverCharacter = [[[NSString alloc] initWithData:[[[self class] sharedInputHandle] readDataOfLength:1] encoding:NSUTF8StringEncoding] autorelease];
	}
	
	//we now have the first sensible character
	
	LogicianParserInputMode inputMode = LogicianParserInputModeExpression;
	
	NSMutableString *workingString = [NSMutableString string];
	
	while ((inputMode == LogicianParserInputModeExpression) || ([[self class] inputModeForString:carryoverCharacter] == inputMode))
	{
		switch ([[self class] inputModeForString:carryoverCharacter])
		{
			case LogicianParserInputModeSentenceClose:
				return nil;
				
			case LogicianParserInputModeSentence:
			{
				NSMutableArray *expressions = [NSMutableArray array];
				Expression *nextExpression;
				for (Parser *subparser = [[Parser alloc] init];
					 (nextExpression = [subparser expressionWithInteractiveInput]);
					 [expressions addObject:nextExpression], [subparser release], subparser = [[Parser alloc] init]);
				return [[[Sentence alloc] initWithExpressions:expressions] autorelease];
			}
			
			case LogicianParserInputModeConstant:
			case LogicianParserInputModeVariable:
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
		case LogicianParserInputModeConstant:
			return [Constant constantWithStringValue:workingString];
		
		case LogicianParserInputModeVariable:
			if (![variablesByStringValue objectForKey:workingString])
			{
				[variablesByStringValue setObject:[[[Variable alloc] initWithStringValue:[NSString stringWithFormat:@"%i", [variablesByStringValue count]]] autorelease] forKey:workingString];
			}
			return [variablesByStringValue objectForKey:workingString];
		
		default: return nil;
	}
}

@end
