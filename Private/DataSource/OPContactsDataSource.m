//
//  OPContactsDataSource.m
//  OPay
//
//  Created by LiuHuan on 2019/4/23.
//  Copyright © 2019 Opera. All rights reserved.
//

#import "OPContactsDataSource.h"

@interface OPContactsDataSource ()

@property (strong, nonatomic) id<OPContactsDataProviderProtocol> provider;

@property (copy, nonatomic) OPContactsDataSourceSuccess success;
@property (copy, nonatomic) OPContactsDataSourceFailure failure;

@end

@implementation OPContactsDataSource

- (instancetype)initWithDataProvider:(id<OPContactsDataProviderProtocol>)provider {
    if (self = [super init]) {
        _provider = provider;
        _provider.delegate = self;
    }
    return self;
}

- (void)loadContactSuccess:(OPContactsDataSourceSuccess)success
                   failure:(OPContactsDataSourceFailure)faileure {
    self.success = success;
    self.failure = faileure;
    [self.provider loadContacts];
}

#pragma mark - OPContactsDataProviderDelegate

- (void)contactsDataProvider:(id<OPContactsDataProviderProtocol>)provider fetchCompletion:(NSOrderedSet<OPContactModel *> *)contacts {
    if (self.success) {
        self.success(contacts);
    }
}

- (void)contactsDataProvider:(id<OPContactsDataProviderProtocol>)provider fetchFailed:(NSError *)error {
    if (self.failure) {
        self.failure(error);
    }
}

@end
