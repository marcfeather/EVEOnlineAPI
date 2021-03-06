//
//  EVEDBIndustryActivityProbability.h
//  NCDatabase
//
//  Created by Артем Шиманский on 17.09.14.
//
//

#import "EVEDBObject.h"

@interface EVEDBIndustryActivityProbability : EVEDBObject
@property(nonatomic) int32_t typeID;
@property(nonatomic) int32_t activityID;
@property(nonatomic) int32_t productTypeID;
@property(nonatomic) float probability;
@end
