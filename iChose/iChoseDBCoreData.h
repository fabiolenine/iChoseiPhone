//
//  iChoseDBCoreData.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 18/11/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"
#import "ClienteMovel.h"

@interface iChoseDBCoreData : NSObject

+ (Usuario *) newInstanceUsuario;
+ (ClienteMovel *) newInstanceClienteMovel;

@end
