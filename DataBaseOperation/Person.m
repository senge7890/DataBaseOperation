//
//  Person.m
//  DataBaseOperation
//
//  Created by 键盘上的舞者 on 4/7/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "Person.h"

@implementation Person

//重写
#pragma mark 解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
    }
    return self;
}

#pragma mark 编码

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_weight forKey:@"weight"];
}



@end
