//
//  validadorES.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 15/11/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface validadorES : NSObject

NSString *validaEmail(NSString *emailString);
NSString *validaCPF(NSString *cpf);
NSString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter);

@end
