//
//  OPContactsDataSource.h
//  OPay
//
//  Created by LiuHuan on 2019/4/23.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPContactsDataProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OPContactsDataSourceSuccess)(NSOrderedSet<OPContactModel *> *contacts);
typedef void (^OPContactsDataSourceFailure)(NSError *error);

@interface OPContactsDataSource : NSObject <OPContactsDataProviderDelegate>

- (instancetype)initWithDataProvider:(id <OPContactsDataProviderProtocol>)provider;

- (void)loadContactSuccess:(nullable OPContactsDataSourceSuccess)success
                   failure:(OPContactsDataSourceFailure)faileure;

@end

NS_ASSUME_NONNULL_END
