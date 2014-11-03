//
//  The MIT License (MIT)
//  Copyright (c) 2014 Lemberg Solutions Limited
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "DCBof+DC.h"
#import "DCEvent+DC.h"
#import "NSManagedObject+DC.h"
#import "NSDate+DC.h"
#import "DCFavoriteEvent+DC.h"
#import "DCMainProxy.h"
#import "NSDictionary+DC.h"

const NSString * kDCBof_bofEvents_key = @"bofsEvents";

@implementation DCBof (DC)

#pragma mark - ManagedObjectUpdateProtocol

+ (void)updateFromDictionary:(NSDictionary *)events inContext:(NSManagedObjectContext *)context;
{
    
    for (NSDictionary * day in events[kDCEvent_days_key])
    {
        NSDate * date = [NSDate fabricateWithEventString:day[kDCEvent_date_key]];
        for (NSDictionary * event in day[kDCBof_bofEvents_key])
        {
            DCBof * bofInstance = (DCBof*)[[DCMainProxy sharedProxy] objectForID:[event[kDCEvent_eventId_key] intValue]
                                                                         ofClass:[DCBof class]
                                                                       inContext:context];
            
            if (!bofInstance) // create
            {
                bofInstance = [DCBof createManagedObjectInContext:context];
                //(DCBof*)[[DCMainProxy sharedProxy] createObjectOfClass:[DCBof class]];
            }
            if ([event[kDCParseObjectDeleted] intValue]==1) // remove
            {
                [[DCMainProxy sharedProxy] removeItem:bofInstance];
                DCFavoriteEvent * favorite = (DCFavoriteEvent*)[[DCMainProxy sharedProxy] objectForID:[event[kDCEvent_eventId_key] intValue]
                                                                                              ofClass:[DCFavoriteEvent class]
                                                                                            inContext:context];
                if (favorite) // in case when event was in favorites - remove from there
                {
                    [[DCMainProxy sharedProxy] removeItem:favorite];
                }
            }
            else // update
            {
                [bofInstance updateFromDictionary:event forData:date];//DCBof parseEventFromDictionaty:event toObject:bofInstance forDate:date];
            }
        }
    }

}


@end
