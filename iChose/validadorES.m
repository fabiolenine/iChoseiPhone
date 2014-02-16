//
//  validadorES.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 15/11/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "validadorES.h"

@implementation validadorES

NSString *validaEmail(NSString *emailString)
{
    NSString            *regExPattern   = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx          = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger           regExMatches    = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    //NSLog(@"%i", regExMatches);
    if (regExMatches == 0)
    {
        return @"No";
    }
    else
        return @"Yes";
}

NSString *validaCPF(NSString *cpf)
{
    NSInteger i, firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck;
    if(cpf == nil) return NO;
    
    if ([cpf length] != 14) return NO;
    
    NSString *cpfLimpo = filteredPhoneStringFromStringWithFilter(cpf, @"###########");
    
    if (([cpfLimpo isEqual:@"00000000000"]) || ([cpfLimpo isEqual:@"11111111111"]) || ([cpfLimpo isEqual:@"22222222222"])|| ([cpfLimpo isEqual:@"33333333333"])|| ([cpfLimpo isEqual:@"44444444444"])|| ([cpfLimpo isEqual:@"55555555555"])|| ([cpfLimpo isEqual:@"66666666666"])|| ([cpfLimpo isEqual:@"77777777777"])|| ([cpfLimpo isEqual:@"88888888888"])|| ([cpfLimpo isEqual:@"99999999999"])) return NO;
    
    firstSum = 0;
    for (i = 0; i <= 8; i++) {
        firstSum += [[cpfLimpo substringWithRange:NSMakeRange(i, 1)] intValue] * (10 - i);
    }
    
    if (firstSum % 11 < 2)
        firstDigit = 0;
    else
        firstDigit = 11 - (firstSum % 11);
    
    secondSum = 0;
    for (i = 0; i <= 9; i++) {
        secondSum = secondSum + [[cpfLimpo substringWithRange:NSMakeRange(i, 1)] intValue] * (11 - i);
    }
    
    if (secondSum % 11 < 2)
        secondDigit = 0;
    else
        secondDigit = 11 - (secondSum % 11);
    
    firstDigitCheck = [[cpfLimpo substringWithRange:NSMakeRange(9, 1)] intValue];
    secondDigitCheck = [[cpfLimpo substringWithRange:NSMakeRange(10, 1)] intValue];
    
    if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck))
        return @"Yes";
    return @"No";
}

NSString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter)
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}

@end
