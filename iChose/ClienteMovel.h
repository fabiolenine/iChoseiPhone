//
//  ClienteMovel.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Usuario;

@interface ClienteMovel : NSManagedObject

@property (nonatomic, retain) NSData * bdFoto;
@property (nonatomic, retain) NSString * deCelular;
@property (nonatomic, retain) NSString * deCEP;
@property (nonatomic, retain) NSString * deCPF;
@property (nonatomic, retain) NSString * deEmail;
@property (nonatomic, retain) NSString * deNome;
@property (nonatomic, retain) NSString * deSobreNome;
@property (nonatomic, retain) NSDate * dtNascimento;
@property (nonatomic, retain) NSDate * dtTimeStamp;
@property (nonatomic, retain) NSNumber * flGenero;
@property (nonatomic, retain) Usuario *rsusuario;

@end
