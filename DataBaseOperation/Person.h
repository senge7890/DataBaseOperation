//
//  Person.h
//  DataBaseOperation
//
//  Created by 键盘上的舞者 on 4/7/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *weight;

@end
