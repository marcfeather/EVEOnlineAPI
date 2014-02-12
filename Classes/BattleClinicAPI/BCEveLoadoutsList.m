//
//  BCEveLoadoutsList.m
//  EVEOnlineAPI
//
//  Created by Artem Shimanski on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BCEveLoadoutsList.h"
#import "BCGlobals.h"

@implementation BCEveLoadoutsListItem

- (id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.typeID = [aDecoder decodeIntegerForKey:@"typeID"];
		self.thumbsUp = [aDecoder decodeIntegerForKey:@"thumbsUp"];
		self.thumbsDown = [aDecoder decodeIntegerForKey:@"thumbsDown"];
		self.topicID = [aDecoder decodeIntegerForKey:@"topicID"];
		self.loadoutID = [aDecoder decodeIntegerForKey:@"loadoutID"];
		self.raceID = [aDecoder decodeIntegerForKey:@"raceID"];
		self.thumbsTotal = [aDecoder decodeIntegerForKey:@"thumbsTotal"];
		self.memberID = [aDecoder decodeIntegerForKey:@"memberID"];

		self.subject = [aDecoder decodeObjectForKey:@"subject"];
		self.posterTime = [aDecoder decodeObjectForKey:@"posterTime"];
		self.modifiedTime = [aDecoder decodeObjectForKey:@"modifiedTime"];
		self.author = [aDecoder decodeObjectForKey:@"author"];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInteger:self.typeID forKey:@"typeID"];
	[aCoder encodeInteger:self.thumbsUp forKey:@"thumbsUp"];
	[aCoder encodeInteger:self.thumbsDown forKey:@"thumbsDown"];
	[aCoder encodeInteger:self.topicID forKey:@"topicID"];
	[aCoder encodeInteger:self.loadoutID forKey:@"loadoutID"];
	[aCoder encodeInteger:self.raceID forKey:@"raceID"];
	[aCoder encodeInteger:self.thumbsTotal forKey:@"thumbsTotal"];
	[aCoder encodeInteger:self.memberID forKey:@"memberID"];
	
	if (self.subject)
		[aCoder encodeObject:self.subject forKey:@"subject"];
	if (self.posterTime)
		[aCoder encodeObject:self.subject forKey:@"posterTime"];
	if (self.modifiedTime)
		[aCoder encodeObject:self.subject forKey:@"modifiedTime"];
	if (self.author)
		[aCoder encodeObject:self.subject forKey:@"author"];
}
@end

@interface BCEveLoadoutsList()
@property(nonatomic, strong) BCEveLoadoutsListItem *currentItem;
@end

@implementation BCEveLoadoutsList

+ (id) eveLoadoutsListWithAPIKey:(NSString*) apiKey raceID:(NSInteger) raceID typeID:(NSInteger) typeID classID:(NSInteger) classID userID:(NSInteger) userID tags:(NSArray*) tags error:(NSError **)errorPtr progressHandler:(void(^)(CGFloat progress, BOOL* stop)) progressHandler {
	return [[BCEveLoadoutsList alloc] initWithAPIKey:apiKey raceID:raceID typeID:typeID classID:classID userID:userID tags:tags error:errorPtr progressHandler:progressHandler];
}

- (id) initWithAPIKey:(NSString*) apiKey raceID:(NSInteger) raceID typeID:(NSInteger) typeID classID:(NSInteger) classID userID:(NSInteger) userID tags:(NSArray*) tags error:(NSError **)errorPtr progressHandler:(void(^)(CGFloat progress, BOOL* stop)) progressHandler {
	NSMutableString *sTags = [NSMutableString string];
	int i = 0;
	for (NSString *tag in [tags sortedArrayUsingSelector:@selector(compare:)]) {
		[sTags appendFormat:@"<item xsi:type=\"xsd:string\">%@</item>", tag];
		i++;
	}
	
	NSString *s = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns1=\"urn:api\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:eveLoadoutsList><applicationKey xsi:type=\"xsd:string\">%@</applicationKey><race xsi:type=\"xsd:unsignedInt\">%d</race><type xsi:type=\"xsd:unsignedInt\">%d</type><class xsi:type=\"xsd:unsignedInt\">%d</class><user xsi:type=\"xsd:unsignedInt\">%d</user><tags SOAP-ENC:arrayType=\"xsd:string[%d]\" xsi:type=\"SOAP-ENC:Array\">%@</tags></ns1:eveLoadoutsList></SOAP-ENV:Body></SOAP-ENV:Envelope>",
				   apiKey,
				   raceID,
				   typeID,
				   classID,
				   userID,
				   i,
				   sTags];
	NSData *bodyData = [s dataUsingEncoding:NSUTF8StringEncoding];
	if (self = [super initWithURL:[NSURL URLWithString:BattleClinicAPIHost]
						 bodyData:bodyData
					  contentType:@"text/xml"
					   cachePolicy:NSURLRequestUseProtocolCachePolicy
							error:errorPtr
				  progressHandler:progressHandler]) {
	}
	return self;
}

#pragma mark NSXMLParserDelegate

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
	 attributes:(NSDictionary *)attributeDict {
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
	
	if ([elementName isEqualToString:@"loadouts"])
		self.loadouts = [NSMutableArray array];
	else if ([elementName isEqualToString:@"item"] && [[attributeDict valueForKey:@"xsi:type"] compare:@"tns:eveLoadoutsList" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
		self.currentItem = [[BCEveLoadoutsListItem alloc] init];
		[(NSMutableArray*) self.loadouts addObject:self.currentItem];
	}
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
	[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
	
	if ([elementName isEqualToString:@"typeID"])
		self.currentItem.typeID = [self.text integerValue];
	else if ([elementName isEqualToString:@"thumbsUp"])
		self.currentItem.thumbsUp = [self.text integerValue];
	else if ([elementName isEqualToString:@"thumbsDown"])
		self.currentItem.thumbsDown = [self.text integerValue];
	else if ([elementName isEqualToString:@"id_topic"])
		self.currentItem.topicID = [self.text integerValue];
	else if ([elementName isEqualToString:@"subject"])
		self.currentItem.subject = self.text;
	else if ([elementName isEqualToString:@"poster_time"])
		self.currentItem.posterTime = [NSDate dateWithTimeIntervalSince1970:[self.text floatValue]];
	else if ([elementName isEqualToString:@"modified_time"])
		self.currentItem.posterTime = [NSDate dateWithTimeIntervalSince1970:[self.text floatValue]];
	else if ([elementName isEqualToString:@"loadout_ID"])
		self.currentItem.loadoutID = [self.text integerValue];
	else if ([elementName isEqualToString:@"raceID"])
		self.currentItem.raceID = [self.text integerValue];
	else if ([elementName isEqualToString:@"thumbsTotal"])
		self.currentItem.thumbsTotal = [self.text integerValue];
	else if ([elementName isEqualToString:@"author"]) {
		if (!self.currentItem.author)
			self.currentItem.author = self.text;
	}
	else if ([elementName isEqualToString:@"id_member"])
		self.currentItem.memberID = [self.text integerValue];
}

@end