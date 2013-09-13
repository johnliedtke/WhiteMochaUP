//
//  Grade.h
//  ParseStarterProject
//
//  Created by Derek Schumacher on 8/9/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grade : NSManagedObject

@property (nonatomic, retain) NSString * courseScore;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic, retain) NSString * gradeType;
@property (nonatomic, retain) NSString * maxPoints;
@property (nonatomic, retain) NSString * assignmentName;
@end

