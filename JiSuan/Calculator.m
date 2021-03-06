//
//  Calculator.m
//  JiSuan
//
//  Created by Jeremy_Luo on 11/1/14.
//  Copyright (c) 2014 JiSuan. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

-(void)calculateService: (NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error
{
    //Test for strings on the pasteboard.
    NSArray *classes = [NSArray arrayWithObjects:[NSString class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    
    if(![pboard canReadObjectForClasses:classes options:options]){
        *error = NSLocalizedString(@"Error: couldn't calculate text.", @"pboard couldn't give string.");
        return;
    }
    
    //get and calculate string
    NSString *pboardString = [pboard stringForType:NSStringPboardType];
    NSString *newString = [Calculator calculate:pboardString];
    
    if(!newString){
        *error = NSLocalizedString(@"Error: couldn't calculate text.", @"self couldn't calculate.");
        return;
    }
    
    //write the result string onto the paste board
    [pboard clearContents];
    NSArray * output = @[[NSString stringWithFormat:@"%@%@%@", pboardString, @" = ", newString]];
    [pboard writeObjects:output];
}



+ (NSString *) calculate: (NSString *)s
{
    NSDictionary * tree = [Parse tokenizeAndParse:s];
    if (tree)
    {
        return [NSString stringWithFormat:@"%f", [Calculator evaluate: tree]];
    }
    return nil;
}

+ (double) evaluate: (NSDictionary *)e
{
    for (NSString * operator in [e allKeys])
    {
        NSArray * children = [e objectForKey:operator];
        if ([@"Number" isEqualToString:operator])
        {
            return [[children objectAtIndex:0] doubleValue];
        }
        else if ([@"Plus" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];

            return (e1 + e2);
        }
        else if ([@"Minus" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return (e1 - e2);
        }
        else if ([@"Mult" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return (e1 * e2);
        }
        else if ([@"Divide" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return (e1 / e2);
        }
        else if ([@"Mod" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return fmod(e1, e2);
        }
        else if ([@"Rt" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return pow(e1, 1.0/e2);
        }
        else if ([@"Pow" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return pow(e1, e2);
        }
        else if ([@"Max" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return fmax(e1, e2);
        }
        else if ([@"Min" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return fmin(e1, e2);
        }
        else if ([@"Log" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            double e2 = [Calculator evaluate:[children objectAtIndex:1]];
            return [Calculator log:e1 withBase:e2];
        }
        else if ([@"Paren" isEqualToString:operator])
        {
            return [Calculator evaluate:[children objectAtIndex:0]];
        }
        else if ([@"Sqrt" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return sqrt(e1);
        }
        else if ([@"Abs" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return fabs(e1);
        }
        else if ([@"Neg" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return -e1;
        }
        else if ([@"Ceil" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return ceil(e1);
        }
        else if ([@"Floor" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return floor(e1);
        }
        else if ([@"Round" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return round(e1);
        }
        else if ([@"Fac" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return [Calculator factorial:(int)e1];
        }
        else if ([@"Sin" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return sin(e1);
        }
        else if ([@"Asin" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return asin(e1);
        }
        else if ([@"Cos" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return cos(e1);
        }
        else if ([@"Acos" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return acos(e1);
        }
        else if ([@"Tan" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return tan(e1);
        }
        else if ([@"Atan" isEqualToString:operator])
        {
            double e1 = [Calculator evaluate:[children objectAtIndex:0]];
            return atan(e1);
        }
        
    }
    return MAXFLOAT;
}

+ (double) factorial: (int) x
{
    double result = 1;
    for ( ; x > 0; x--)
    {
        result *= x;
    }
    return result;
}

+ (double) log: (float)value withBase: (float)base
{
    return log10(value) / log10(base);
}

@end
