//
//  AWFeedbackItem.h
//  AlfredWorkflow
//
//  Created by Daniel Shannon on 5/24/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWFeedbackItem : NSObject {
    @private
    NSArray * __strong tags_;
    NSDictionary * __strong attrib_;
}

+ (id)itemWithObjectsAndKeys:(id)o, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithObjects:(NSArray *)obj forKeys:(NSArray *)key;

- (NSString *)xml;


@property (copy) NSString      *title;
@property (copy) NSString      *subtitle;
// additional properties to support modifier subtitles
@property (copy) NSString		*subShift;
@property (copy) NSString		*subFn;
@property (copy) NSString		*subCtrl;
@property (copy) NSString		*subAlt;
@property (copy) NSString		*subCmd;

@property (copy) NSString      *uid;
@property (strong) NSNumber      *valid;
@property (copy) NSString      *autocomplete;
@property (copy) NSString      *icon;
@property (strong) NSNumber      *fileicon;
@property (strong) NSNumber      *filetype;
@property (copy) NSString      *arg;
@property (copy) NSString      *type;

@end
