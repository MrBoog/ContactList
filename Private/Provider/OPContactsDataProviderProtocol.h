//
//  OPContactsDataProviderProtocol.h
//  OPay
//
//  Created by LiuHuan on 2019/4/23.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPContactsDataProviderDelegate.h"
#import "OPContactModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OPContactsDataProviderError) {
    OPContactsDataProviderUnknownError = 0,
    OPContactsDataProviderAuthenticationError,
};
static NSString *const OPContactsDataProviderErrorDomain = @"com.opay.contacts.dataProvider";

@protocol OPContactsDataProviderProtocol <NSObject>

@property (weak, nonatomic, nullable) id<OPContactsDataProviderDelegate> delegate;
@property (strong, nonatomic, readonly, nullable) NSOrderedSet<OPContactModel *> *contacts;

- (void)loadContacts;

@end

NS_ASSUME_NONNULL_END
