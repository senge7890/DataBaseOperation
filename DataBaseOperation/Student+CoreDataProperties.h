//
//  Student+CoreDataProperties.h
//  DataBaseOperation
//
//  Created by 键盘上的舞者 on 4/7/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *weight;

@end

NS_ASSUME_NONNULL_END
