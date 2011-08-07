//
//  Console.h
//  logician
//
//  Created by Hans Andersson on 11/08/05.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Variable.h"
#import "Constant.h"
#import "Sentence.h"

typedef enum
{
	LogicianConsoleInputModeInvalid = -1,
	LogicianConsoleInputModeExpression = 0,
	LogicianConsoleInputModeConstant = 1,
	LogicianConsoleInputModeVariable = 2,
	LogicianConsoleInputModeSentence = 3,
	LogicianConsoleInputModeTermBreak = 4,
	LogicianConsoleInputModeSentenceClose = 5
} LogicianConsoleInputMode;

NSFileHandle *sharedInputHandle;

@interface Console : NSObject
{
	LogicianConsoleInputMode currentInputMode;
	NSMutableDictionary *variablesByStringValue;
	NSString *carryoverCharacter;
}

+ (NSFileHandle *)sharedInputHandle;
+ (LogicianConsoleInputMode)inputModeForString:(NSString *)string;

- (Expression *)expressionWithInteractiveInput;

@end
