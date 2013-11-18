//
//  Grades.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 11/10/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grades : NSManagedObject

@property (nonatomic, retain) NSString * assignmentName;
@property (nonatomic, retain) NSString * assignmentScore;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic, retain) NSString * maxPoints;
@property (nonatomic, retain) NSString * assignmentType;

@end
