//
//  HistProdutos.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistProdutos : NSManagedObject

@property (nonatomic, retain) NSNumber * cdHistProduto;
@property (nonatomic, retain) NSNumber * cdTipoProduto;
@property (nonatomic, retain) NSString * deCodigo;
@property (nonatomic, retain) NSString * deProduto;

@end
