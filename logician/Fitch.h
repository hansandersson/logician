//
//  Fitch.h
//  logician
//
//  Created by Hans Andersson on 11/08/04.
//  Copyright 2011 Hans Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"
#import "Expression.h"

@interface Fitch : NSObject
{
	NSMutableDictionary *premisesByDescription;
}

- (id)initWithPremises:(NSSet *)initPremises;
- (NSSet *)deductions;
- (NSArray *)proveConclusion:(Expression *)conclusion givenAssumptions:(NSSet *)assumptions;

@end
