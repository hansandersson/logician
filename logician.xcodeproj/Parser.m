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
	}
	return self;
}

- (void)dealloc
{
	[variablesByStringValue release];
	[remainderString release];
	[super dealloc];
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

- (NSSet *)expressionsWithString:(NSString *)remainderStringNew
{
	[remainderString autorelease];
	remainderString = [[remainderStringNew stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
	
	NSMutableSet *expressions = [NSMutableSet set];
	while ([remainderString length] > 0)
	{
		Expression *expression = [self expressionWithString:remainderString];
		[expressions addObject:expression];
	}
	
	return expressions;
}


//returns nil if no data present
//returns variables for numeric input
//returns constants for alphabetic input
//returns sentences for nested inputs
- (Expression *)expressionWithString:(NSString *)remainderStringNew
{
	[remainderString autorelease];
	remainderString = [[remainderStringNew stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
	
	if (!remainderString || [remainderString length] == 0)
	{
		return nil;
	}
	
	//we now have the first sensible character
	
	LogicianParserInputMode inputMode = LogicianParserInputModeExpression;
	
	NSMutableString *workingString = [NSMutableString string];
	
	for (NSString *character = [remainderString substringToIndex:1];
		 (inputMode == LogicianParserInputModeExpression) || ([[self class] inputModeForString:character] == inputMode);
		 inputMode = [[self class] inputModeForString:character], character = [remainderString substringToIndex:1])
	{
		[remainderString autorelease];
		remainderString = [[remainderString substringFromIndex:1] retain];
		
		switch ([[self class] inputModeForString:character])
		{
			case LogicianParserInputModeSentenceClose:
			{
				return nil;
			}
				
			case LogicianParserInputModeSentence:
			{
				NSMutableArray *expressions = [NSMutableArray array];
				for (Expression *nextExpression;
					 (nextExpression = [self expressionWithString:remainderString]);
					 [expressions addObject:nextExpression]);
				
				return [[[Sentence alloc] initWithExpressions:expressions] autorelease];
			}
			
			case LogicianParserInputModeConstant:
			case LogicianParserInputModeVariable:
			{
				[workingString appendString:character];
			}	break;
			
			default: break;
		}
		
		if ([remainderString length] == 0)
		{
			break;
		}
	}
	
	switch ([[self class] inputModeForString:workingString])
	{
		case LogicianParserInputModeConstant:
		{
			return [Constant constantWithStringValue:workingString];
		}
		
		case LogicianParserInputModeVariable:
			if (![variablesByStringValue objectForKey:workingString])
			{
				[variablesByStringValue setObject:[[[Variable alloc] initWithStringValue:[NSString stringWithFormat:@"%i", [variablesByStringValue count]]] autorelease] forKey:workingString];
			}
			
			return [variablesByStringValue objectForKey:workingString];
		
		default:
		{
			return nil;
		}
	}
}

- (NSString *)remainderString
{
	return remainderString;
}

@end
