//
//  Pagamento.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pagamento : NSManagedObject

@property (nonatomic, retain) NSNumber * cdPagamento;
@property (nonatomic, retain) NSString * deKeyAutorizacao;
@property (nonatomic, retain) NSDate * dtPagamento;
@property (nonatomic, retain) NSNumber * vlPago;

@end
