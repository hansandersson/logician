//
//  Parser.h
//  logician
//
//  Created by Hans Andersson on 11/08/05.
//  Copyright 2011 Hans Andersson. All rights reserved.
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

@interface Parser : NSObject
{
	NSString *remainderString;
	NSMutableDictionary *variablesByStringValue;
}

+ (LogicianParserInputMode)inputModeForString:(NSString *)string;

- (Expression *)expressionWithString:(NSString *)string;
- (NSSet *)expressionsWithString:(NSString *)string;

- (NSString *)remainderString;

@end
