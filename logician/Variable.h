//
//  Variable.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"

@interface Variable : Expression
{
	NSString *stringValue;
}

- (id)initWithStringValue:(NSString *)stringValueInit;

@end
