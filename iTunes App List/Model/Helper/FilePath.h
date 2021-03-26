//
//  FilePath.h
//  
//
//  Created by RJ Lacanlale on 1/23/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilePath : NSObject
// Creates a custom file path from the documents directory
+ (NSString *)filepathWithFilename:(NSString*)filename;
@end

NS_ASSUME_NONNULL_END
