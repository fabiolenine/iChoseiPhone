//
//  CartaoCredito.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CartaoCredito : NSManagedObject

@property (nonatomic, retain) NSNumber * cdTipoOperacao;
@property (nonatomic, retain) NSString * deCodSeg;
@property (nonatomic, retain) NSString * deNomeCartao;
@property (nonatomic, retain) NSString * deNumeroCartao;
@property (nonatomic, retain) NSString * deTitulo;

@end
