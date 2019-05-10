//
//  OPContactsDataProviderDelegate.h
//  OPay
//
//  Created by LiuHuan on 2019/4/24.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OPContactsDataProviderProtocol;
@class OPContactModel;
@protocol OPContactsDataProviderDelegate <NSObject>

- (void)contactsDataProvider:(id <OPContactsDataProviderProtocol>)provider fetchCompletion:(NSOrderedSet<OPContactModel *> *)contacts;

- (void)contactsDataProvider:(id <OPContactsDataProviderProtocol>)provider fetchFailed:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
