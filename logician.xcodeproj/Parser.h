//
//  Parser.h
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
	LogicianParserInputModeInvalid = -1,
	LogicianParserInputModeExpression = 0,
	LogicianParserInputModeConstant = 1,
	LogicianParserInputModeVariable = 2,
	LogicianParserInputModeSentence = 3,
	LogicianParserInputModeTermBreak = 4,
	LogicianParserInputModeSentenceClose = 5
} LogicianParserInputMode;

NSFileHandle *sharedInputHandle;

@interface Parser : NSObject
{
	LogicianParserInputMode currentInputMode;
	NSMutableDictionary *variablesByStringValue;
	NSUInteger *parsePosition;
}

+ (NSFileHandle *)sharedInputHandle;
+ (LogicianParserInputMode)inputModeForString:(NSString *)string;

- (Expression *)expressionWithInteractiveInput;

@end
