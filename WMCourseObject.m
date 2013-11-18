//
//  WMCourseObject.m
//  WMActualCourseUpdate
//
//  Created by Derek Schumacher on 10/15/13.
//  Copyright (c) 2013 Schumacher Enterprises. All rights reserved.
//

#import "WMCourseObject.h"


@implementation WMCourseObject

-(int) loadData:(NSString *)title withObjectContext:(NSManagedObjectContext *)context
{
    self.managedObjectContext = context;//Do this to keep the context for when the saveData method gets called
    
    //Pull the course object with this title out of memory:
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    //TODO: Make sure this actually works
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.courseTitle like %@",self.courseTitle];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        //NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        
        Course *foundObject = array[0];
        //Load the data:
        self.courseTitle = foundObject.courseTitle;
        self.courseWeights[0] = foundObject.homeworkWeight;
        self.courseWeights[1] = foundObject.testWeight;
        self.courseWeights[2] = foundObject.essayWeight;
        self.courseWeights[3] = foundObject.quizWeight;
        self.courseWeights[4] = foundObject.otherWeight;
        self.courseWeights[5] = foundObject.atendanceWeight;
        self.courseWeights[6] = foundObject.finalWeight;
        
        self.gradeValues[0] = foundObject.aPlusValue;
        self.gradeValues[1] = foundObject.aValue;
        self.gradeValues[2] = foundObject.aMinusValue;
        self.gradeValues[3] = foundObject.bPlusValue;
        self.gradeValues[4] = foundObject.bValue;
        self.gradeValues[5] = foundObject.bMinusValue;
        self.gradeValues[6] = foundObject.cPlusValue;
        self.gradeValues[7] = foundObject.cValue;
        self.gradeValues[8] = foundObject.cMinusValue;
        self.gradeValues[9] = foundObject.dPlusValue;
        self.gradeValues[10] = foundObject.dValue;
        self.gradeValues[11] = foundObject.dMinusValue;
        
        self.semesterTitle = foundObject.semesterTitle;
    }
    else {
        //deal with error:
       
    }
    
    return SUCCESS;
}

-(int) saveData
{
    //Create a new instance of a Course object (subclass of NSManagedObject):
    Course *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    [newCourse setCourseTitle:self.courseTitle];
    [newCourse setProfName:self.profName];
    
    //Store the items in the grades array (grading scale): This order needs to be maintained in both saving, and loading by you, the programmer when you use this object:
    [newCourse setAPlusValue:self.gradeValues[0]];
    [newCourse setAValue:self.gradeValues[1]];
    [newCourse setAMinusValue:self.gradeValues[2]];
    [newCourse setBPlusValue:self.gradeValues[3]];
    [newCourse setBValue:self.gradeValues[4]];
    [newCourse setBMinusValue:self.gradeValues[5]];
    [newCourse setCPlusValue:self.gradeValues[6]];
    [newCourse setCValue:self.gradeValues[7]];
    [newCourse setCMinusValue:self.gradeValues[8]];
    [newCourse setDPlusValue:self.gradeValues[9]];
    [newCourse setDValue:self.gradeValues[10]];
    [newCourse setDMinusValue:self.gradeValues[11]];
    
    //Store the items in the courseWeights array (course weights): This order needs to be maintained in both saving and loading by you, the programmer when you use this object:
    [newCourse setHomeworkWeight:self.courseWeights[0]];
    [newCourse setTestWeight:self.courseWeights[1]];
    [newCourse setEssayWeight:self.courseWeights[2]];
    [newCourse setQuizWeight:self.courseWeights[3]];
    [newCourse setOtherWeight:self.courseWeights[4]];
    [newCourse setAtendanceWeight:self.courseWeights[5]];
    [newCourse setFinalWeight:self.courseWeights[6]];
    [newCourse setNumCredits:self.numCredits];
    
    //Set the semester Title:
    [newCourse setSemesterTitle:self.semesterTitle];
    
    
    //Save the instance of a Course Object:
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Could not save Error:%@", [error localizedDescription]);
        return FAILURE;
    }
    [self.managedObjectContext save:&error];
    return SUCCESS;
}
@end
