//
//  HistCompras.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistCompras : NSManagedObject

@property (nonatomic, retain) NSNumber * cdHistEvento;
@property (nonatomic, retain) NSNumber * cdHistProduto;
@property (nonatomic, retain) NSDate * dtCompra;
@property (nonatomic, retain) NSNumber * nuQuantidade;
@property (nonatomic, retain) NSNumber * vlUnitario;

@end
