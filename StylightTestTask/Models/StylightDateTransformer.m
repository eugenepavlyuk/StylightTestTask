//
//  StylightDateTransformer.m
//  StylightTestTask
//
//  Created by Eugene Pavluk on 2/18/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "StylightDateTransformer.h"

@implementation StylightDateTransformer

- (BOOL)transformValue:(id)inputValue
               toValue:(id *)outputValue
               ofClass:(Class)outputValueClass
                 error:(NSError **)error
{
    if ([inputValue isKindOfClass:[NSNumber class]])
    {
        NSNumber *inputNumber = (NSNumber*)inputValue;
        
        NSNumber *modifiedDate = inputNumber;
        
        NSTimeInterval timeInterval = [modifiedDate doubleValue];
        
        *outputValue = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    return YES;
}

@end
