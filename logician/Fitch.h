//
//  Fitch.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Ultramentem & Vigorware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"
#import "Expression.h"

@interface Fitch : NSObject
{
	NSSet *rules;
}

- (id)initWithRules:(NSSet *)initRules;
- (NSArray *)proveConclusion:(Expression *)conclusion givenAssumptions:(NSSet *)assumptions;

@end
