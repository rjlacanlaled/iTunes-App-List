//
//  ArraySorter.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import <Foundation/Foundation.h>

@interface ArraySorter : NSObject
// Sorts an array with Object as main category
+ (NSArray *)sortArray: (NSArray *)anArray forKeyPath: (NSString *)keyPath isAscending: (BOOL)isAscending;
// Sorts an array with number as main category
+ (NSArray *)sortArrayByNumber: (NSArray *)anArray forKeyPath: (NSString *)keyPath isAscending: (BOOL)isAscending;
@end

