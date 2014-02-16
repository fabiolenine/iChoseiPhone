//
//  ProcessLog.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 02/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Usuario;

@interface ProcessLog : NSManagedObject

@property (nonatomic, retain) NSString * idObject;
@property (nonatomic, retain) NSDate * dtTimeStamp;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * deProcesso;
@property (nonatomic, retain) NSNumber * flEnviado;
@property (nonatomic, retain) Usuario *rsusuarioproc;

@end
