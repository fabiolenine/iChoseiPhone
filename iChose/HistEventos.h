//
//  HistEventos.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistEventos : NSManagedObject

@property (nonatomic, retain) NSNumber * cdHistEvento;
@property (nonatomic, retain) NSString * deEvento;
@property (nonatomic, retain) NSDate * dtEvento;

@end
