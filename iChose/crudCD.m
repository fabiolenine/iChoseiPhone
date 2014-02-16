//
//  crudCD.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 09/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "crudCD.h"
#import "Usuario.h"
#import "ClienteMovel.h"
#import "iChoseDBCoreData.h"
#import "iChosemainAppDelegate.h"
#import <CoreData/CoreData.h>

@implementation crudCD

NSString *salvarCadastroUsuarioDB(NSString *senha, NSString *conta, NSString *objectid, NSString *nome, NSString *sobrenome, NSString *genero, NSDate *datanascimento, NSString *celular, NSString *email, NSString *cep, NSString *cpf, NSData *foto)
{
    // Melhorar esse trecho.
    NSNumber *generoBool;
    
    if ([genero isEqualToString:@"0"]) {
        generoBool = [NSNumber numberWithInt:0];
    }
    else
    {
        generoBool = [NSNumber numberWithInt:1];
    }
    //
    
    // Salvar e comitar.
    
    iChosemainAppDelegate *appDelegate = (iChosemainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError * error;
    
    if (context == nil)
    {
        NSLog(@"Sai do CRUD, negativo.");
        return @"No";
    }
    
    Usuario *usuario =          [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Usuario"
                                 inManagedObjectContext:context];
    
    usuario.deSenhaUsuario  = senha;
    usuario.deUsuario       = conta;
    usuario.dtTimeStamp     = [NSDate date];
    usuario.idObject        = objectid;
    
    ClienteMovel *clienteMovel = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ClienteMovel"
                                  inManagedObjectContext:context];
    
    clienteMovel.deNome         = nome;
    clienteMovel.dtTimeStamp    = [NSDate date];
    clienteMovel.deSobreNome    = sobrenome;
    clienteMovel.flGenero       = generoBool;
    clienteMovel.dtNascimento   = datanascimento;
    clienteMovel.deCelular      = celular;
    clienteMovel.deEmail        = email;
    clienteMovel.deCEP          = cep;
    clienteMovel.deCPF          = cpf;
    clienteMovel.bdFoto         = foto;
    clienteMovel.rsusuario = usuario;
    usuario.rscliente = clienteMovel;
    
    if (![context save:&error])
    {
        NSLog(@"Sai do CRUD, negativo.");
        return @"No";
    }
    else
    {
        NSLog(@"Sai do CRUD, positivo.");
        return @"Yes";
    }
    
}

@end
