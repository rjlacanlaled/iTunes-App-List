//
//  ArraySorter.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "ArraySorter.h"

@implementation ArraySorter
+ (NSArray *)sortArray: (NSArray *)anArray forKeyPath: (NSString *)keyPath isAscending: (BOOL)isAscending {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:keyPath
                                        ascending:isAscending
                                        selector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [anArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}

+ (NSArray *)sortArrayByNumber: (NSArray *)anArray forKeyPath: (NSString *)keyPath isAscending: (BOOL)isAscending {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:keyPath
                                        ascending:isAscending
                                        selector:nil];
    
    return [anArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}
@end
