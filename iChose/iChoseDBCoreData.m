//
//  iChoseDBCoreData.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 18/11/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "iChoseDBCoreData.h"
#import "iChosemainAppDelegate.h"
#import <CoreData/CoreData.h>

@implementation iChoseDBCoreData

+ (Usuario *) newInstanceUsuario
{
    // AppDelegate da Aplicação.
    iChosemainAppDelegate *appDelegate = (iChosemainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Context para salvar/deletar/buscar objetos.
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError * error;
    
    if (context == nil)
    {
        NSLog(@"Lascou na newInstance de Usuario: %@, %@", error, [error userInfo]);
    }

    // Cria uma instância do Carro (inserindo no managed object context).
    Usuario *u = [NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:context];
    
    return u;
}

+ (ClienteMovel *) newInstanceClienteMovel
{
    // AppDelegate da Aplicação.
    iChosemainAppDelegate *appDelegate = (iChosemainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Context para salvar/deletar/buscar objetos.
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError * error;
    
    if (context == nil)
    {
        NSLog(@"Lascou na newInstance de Cliente Movel: %@, %@", error, [error userInfo]);
    }
    
    // Cria uma instância do Carro (inserindo no managed object context).
    ClienteMovel *cm = [NSEntityDescription insertNewObjectForEntityForName:@"ClienteMovel" inManagedObjectContext:context];
    
    return cm;
}

@end
