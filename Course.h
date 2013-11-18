//
//  Course.h
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 11/17/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * aMinusValue;
@property (nonatomic, retain) NSString * aPlusValue;
@property (nonatomic, retain) NSString * atendanceWeight;
@property (nonatomic, retain) NSString * aValue;
@property (nonatomic, retain) NSString * bMinusValue;
@property (nonatomic, retain) NSString * bPlusValue;
@property (nonatomic, retain) NSString * bValue;
@property (nonatomic, retain) NSString * cMinusValue;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic, retain) NSString * cPlusValue;
@property (nonatomic, retain) NSNumber * currentGrade;
@property (nonatomic, retain) NSString * cValue;
@property (nonatomic, retain) NSString * dMinusValue;
@property (nonatomic, retain) NSString * dPlusValue;
@property (nonatomic, retain) NSString * dValue;
@property (nonatomic, retain) NSString * essayWeight;
@property (nonatomic, retain) NSString * finalWeight;
@property (nonatomic, retain) NSString * homeworkWeight;
@property (nonatomic, retain) NSString * numCredits;
@property (nonatomic, retain) NSString * otherWeight;
@property (nonatomic, retain) NSString * profName;
@property (nonatomic, retain) NSString * quizWeight;
@property (nonatomic, retain) NSString * semesterTitle;
@property (nonatomic, retain) NSString * testWeight;
@property (nonatomic, retain) NSNumber * hasF;

@end
