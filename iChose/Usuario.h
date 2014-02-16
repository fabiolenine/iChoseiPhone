//
//  Usuario.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClienteMovel;

@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * deSenhaUsuario;
@property (nonatomic, retain) NSString * deUsuario;
@property (nonatomic, retain) NSDate * dtTimeStamp;
@property (nonatomic, retain) NSString * idObject;
@property (nonatomic, retain) ClienteMovel *rscliente;
@property (nonatomic, retain) NSSet *rsprocesso;
@end

@interface Usuario (CoreDataGeneratedAccessors)

- (void)addRsprocessoObject:(NSManagedObject *)value;
- (void)removeRsprocessoObject:(NSManagedObject *)value;
- (void)addRsprocesso:(NSSet *)values;
- (void)removeRsprocesso:(NSSet *)values;

@end
