//
//  Tickets.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tickets : NSManagedObject

@property (nonatomic, retain) NSNumber * cdHistTicket;
@property (nonatomic, retain) NSNumber * cdPagamento;
@property (nonatomic, retain) NSNumber * cdTipoTicket;
@property (nonatomic, retain) NSString * deCodigoTicket;
@property (nonatomic, retain) NSString * deTicket;
@property (nonatomic, retain) NSNumber * flEntradaSaida;

@end
