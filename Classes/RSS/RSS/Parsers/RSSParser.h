//
//  RSSParser.h
//  RSS
//
//  Created by Mr. Depth on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSFeed.h"

@interface RSSParser : NSObject<NSXMLParserDelegate>
@property (nonatomic, strong) RSSFeed *feed;
@property (nonatomic, strong) NSError *error;

- (BOOL) parseXMLData:(NSData*) data;
- (BOOL) parseXMLString:(NSString*) string;

@end
