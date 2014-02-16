//
//  crudCD.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 09/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface crudCD : NSObject

NSString *salvarCadastroUsuarioDB(NSString *senha, NSString *conta, NSString *objectid, NSString *nome, NSString *sobrenome, NSString *genero, NSDate *datanascimento, NSString *celular, NSString *email, NSString *cep, NSString *cpf, NSData *foto);

@end
