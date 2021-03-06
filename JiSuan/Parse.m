//
//  Parse.m
//  JiSuan
//
//  Created by Jeremy_Luo on 11/1/14.
//  Copyright (c) 2014 JiSuan. All rights reserved.
//

#import "Parse.h"

@implementation Parse

+ (NSDictionary *) tokenizeAndParse: (NSString *)s
{
    NSMutableArray * tokens = [Parse tokenize:s];
    /*
    for (NSString * token in tokens)
    {
        NSLog(@"%@", token);
    }
    */
    NSArray * temp = [Parse expression:tokens atTop:true];
    if (temp)
    {
        return [temp objectAtIndex:0];
    }
    return nil;
}

+ (NSMutableArray *) tokenize: (NSString *)s
{
    NSString * separators = @"+-*/^%!(), ";

    NSInteger lengthOfSeparators = separators.length;
    NSMutableArray * tokens = [[NSMutableArray alloc] init];
    NSString * token = @"";
    // loop through every char, split string into tokens
    for (int i = 0; i < s.length; i++)
    {
        char c = [s characterAtIndex:i];
        BOOL separate = false;
        
        // loop through every separator
        for (int j = 0; j < lengthOfSeparators; j++)
        {
            if (c == [separators characterAtIndex:j])
            {
                [tokens addObject: token];
                token = @"";
                [tokens addObject: [[NSString alloc] initWithFormat:@"%c", c]];
                separate = true;
                break;
            }
        }
        
        // not a separator, this char belongs to next token
        if (!separate)
        {
            token = [token stringByAppendingString: [[NSString alloc] initWithFormat:@"%c", c]];
        }

    }
    // add the last token
    [tokens addObject: token];
    NSMutableArray * tks = [[NSMutableArray alloc] init];
    
    // delete whitespaces
    for (NSString * token in tokens)
    {
        if (![@"" isEqualToString:[token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
        {
            [tks addObject:token];
        }
    }

    return tks;
}



// priority 1
+ (NSArray *) leftExpression: (NSMutableArray *)tmp atTop: (BOOL)top
{
    // for number
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    
    if ([tokens count] > 0 && [Parse isNumber:[tokens objectAtIndex:0]])
    {
        double number = [[tokens objectAtIndex:0] doubleValue];
        [tokens removeObjectAtIndex:0];
        if (!top || [tokens count] == 0)
        {
            return @[ @{@"Number" : @[[NSNumber numberWithDouble:number]]},
                      tokens];
        }
    }

    // for (exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"(" isEqualToString: [tokens objectAtIndex:0]])
    {
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([tokens count] > 0 && [@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Paren" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    
    
    // for sqrt(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"sqrt" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Sqrt" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for abs(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"abs" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Abs" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for ceil(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"ceil" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Ceil" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for floor(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"floor" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Floor" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for round(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"round" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Round" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for sin(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"sin" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Sin" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for asin(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"asin" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Asin" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for cos(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"cos" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Cos" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for acos(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"acos" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Acos" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for tan(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"tan" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Tan" : @[tree]},
                              tokens ];
                }
            }
        }
    }
    
    // for atan(exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"atan" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@")" isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                if (!top || [tokens count] == 0)
                {
                    return @[ @{@"Atan" : @[tree]},
                              tokens ];
                }
            }
        }
    }

    
    // for rt(exp, exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"rt" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree1 = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@"," isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                temp = [Parse expression:tokens atTop:false];
                if (temp)
                {
                    NSDictionary * tree2 = [temp objectAtIndex:0];
                    tokens = [temp objectAtIndex:1];
                    if ([@")" isEqualToString: [tokens objectAtIndex:0]])
                    {
                        [tokens removeObjectAtIndex:0];
                        if (!top || [tokens count] == 0)
                        {
                            return @[ @{@"Rt" : @[tree1, tree2]},
                                      tokens ];
                        }
                    }
                }
            }
        }
    }
    
    // for max(exp, exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"max" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree1 = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@"," isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                temp = [Parse expression:tokens atTop:false];
                if (temp)
                {
                    NSDictionary * tree2 = [temp objectAtIndex:0];
                    tokens = [temp objectAtIndex:1];
                    if ([@")" isEqualToString: [tokens objectAtIndex:0]])
                    {
                        [tokens removeObjectAtIndex:0];
                        if (!top || [tokens count] == 0)
                        {
                            return @[ @{@"Max" : @[tree1, tree2]},
                                      tokens ];
                        }
                    }
                }
            }
        }
    }
    
    // for min(exp, exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"min" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree1 = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@"," isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                temp = [Parse expression:tokens atTop:false];
                if (temp)
                {
                    NSDictionary * tree2 = [temp objectAtIndex:0];
                    tokens = [temp objectAtIndex:1];
                    if ([@")" isEqualToString: [tokens objectAtIndex:0]])
                    {
                        [tokens removeObjectAtIndex:0];
                        if (!top || [tokens count] == 0)
                        {
                            return @[ @{@"Min" : @[tree1, tree2]},
                                      tokens ];
                        }
                    }
                }
            }
        }
    }
    
    // for log(exp, exp)
    tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    if ([@"log" isEqualToString: [tokens objectAtIndex:0]]
        && [@"(" isEqualToString: [tokens objectAtIndex:1]])
    {
        [tokens removeObjectAtIndex:0];
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse expression:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree1 = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if ([@"," isEqualToString: [tokens objectAtIndex:0]])
            {
                [tokens removeObjectAtIndex:0];
                temp = [Parse expression:tokens atTop:false];
                if (temp)
                {
                    NSDictionary * tree2 = [temp objectAtIndex:0];
                    tokens = [temp objectAtIndex:1];
                    if ([@")" isEqualToString: [tokens objectAtIndex:0]])
                    {
                        [tokens removeObjectAtIndex:0];
                        if (!top || [tokens count] == 0)
                        {
                            return @[ @{@"Log" : @[tree1, tree2]},
                                      tokens ];
                        }
                    }
                }
            }
        }
    }
    
    return nil;
}

/*
 * '!'
 */
+ (NSArray *) priority2: (NSMutableArray *)tmp atTop: (BOOL)top
{
    // for exp!
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    NSArray * temp = [Parse leftExpression:tokens atTop:false];
    
    if (temp)
    {
        NSDictionary * tree1 = [temp objectAtIndex:0];
        tokens = [temp objectAtIndex:1];
        //if ([tokkens count] > )
        if ([tokens count] > 0 && [@"!" isEqualToString: [tokens objectAtIndex:0]])
        {
            [tokens removeObjectAtIndex:0];
            return @[ @{@"Fac" : @[tree1]},
                      tokens];
        }
        // no !
        else
        {
            return temp;
        }
    }
    
    return nil;
}

/*
 * '^'
 */
+ (NSArray *) priority3: (NSMutableArray *)tmp atTop: (BOOL)top
{
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    
    NSArray * temp = [Parse priority2:tokens atTop:false];
    
    //parsed left correctly
    if (temp)
    {
        NSDictionary * tree1 = [temp objectAtIndex:0];
        tokens = [temp objectAtIndex:1];
        
        // for ^
        NSMutableArray * tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"^" isEqualToString: [tk objectAtIndex:0]])
        {
            [tk removeObjectAtIndex:0];
            temp = [Parse priority3:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Pow" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // no exponential
        else
        {
            return temp;
        }
    }
    return nil;
}

/*
 * negative '-'
 */
+ (NSArray *) priority4: (NSMutableArray *)tmp atTop: (BOOL)top
{
    // for -exp
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    
    if ([@"-" isEqualToString: [tokens objectAtIndex:0]])
    {
        [tokens removeObjectAtIndex:0];
        NSArray * temp = [Parse priority4:tokens atTop:false];
        if (temp)
        {
            NSDictionary * tree = [temp objectAtIndex:0];
            tokens = [temp objectAtIndex:1];
            if (!top || [tokens count] == 0)
            {
                return @[ @{@"Neg" : @[tree]},
                          tokens];
            }
        }
    }
    // no negative
    else
    {
        NSArray * temp = [Parse priority3:tokens atTop:false];
        if (temp)
        {
            return temp;
        }
    }
    
    return nil;
}

/*
 * '*' '/' '%'
 */
+ (NSArray *) priority5: (NSMutableArray *)tmp atTop: (BOOL)top
{
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    
    NSArray * temp = [Parse priority4:tokens atTop:false];
    
    //parsed priority4 correctly
    if (temp)
    {
        NSDictionary * tree1 = [temp objectAtIndex:0];
        tokens = [temp objectAtIndex:1];
        
        // for *
        NSMutableArray * tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"*" isEqualToString: [tk objectAtIndex:0]])
        {
            [tk removeObjectAtIndex:0];
            temp = [Parse priority5:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Mult" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // for /
        tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"/" isEqualToString: [tk objectAtIndex:0]])
        {
            [tk removeObjectAtIndex:0];
            temp = [Parse priority5:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Divide" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // for %
        tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"%" isEqualToString: [tk objectAtIndex:0]])
        {
            [tk removeObjectAtIndex:0];
            temp = [Parse priority5:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Mod" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // no * / or %
        else
        {
            return temp;
        }
        
    }
    return nil;
}

/*
 * '+' '-'
 */
// priority 6
+ (NSArray *) expression: (NSMutableArray *)tmp atTop: (BOOL)top
{
    NSMutableArray * tokens = [[NSMutableArray alloc] initWithArray:tmp copyItems:YES];
    
    NSArray * temp = [Parse priority5:tokens atTop:false];
    
    // parse priority5 correctly
    if (temp)
    {
        NSDictionary * tree1 = [temp objectAtIndex:0];
        tokens = [temp objectAtIndex:1];
        
        // for +
        NSMutableArray * tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"+" isEqualToString: [tk objectAtIndex:0]])
        {
            [tk removeObjectAtIndex:0];
            temp = [Parse expression:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Plus" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // for -
        tk = [[NSMutableArray alloc] initWithArray:tokens copyItems:YES];
        if ([tk count] > 0 && [@"-" isEqualToString: [tk objectAtIndex:0]])
        {
            
            //[tk removeObjectAtIndex:0];
            temp = [Parse expression:tk atTop:false];
            if (temp)
            {
                NSDictionary * tree2 = [temp objectAtIndex:0];
                tk = [temp objectAtIndex:1];
                return @[ @{@"Plus" : @[tree1, tree2]},
                          tk];
            }
        }
        
        // no + or -
        else
        {
            return temp;
        }
    }
    
    return nil;
}

+ (BOOL) isNumber: (NSString *) s
{
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^(-((0|[1-9][0-9]*)(\.[0-9]+)?)|((0|[1-9][0-9]*)(\.[0-9]+)?))$'"];
    if([numberPredicate evaluateWithObject:s])
        return true;
    return false;
}







@end
