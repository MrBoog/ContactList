//
//  OPContactsDataProvider.h
//  OPay
//
//  Created by LiuHuan on 2019/4/23.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "OPContactsDataProviderProtocol.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  NOTE:
 *  The OPContactsDataProvider Only support iOS9+
 *  For iOS8: implement other OPContactsDataProviderProtocol
 */

NS_CLASS_AVAILABLE_IOS(9_0)
@interface OPContactsDataProvider : NSObject <OPContactsDataProviderProtocol>

@property (weak, nonatomic, nullable) id<OPContactsDataProviderDelegate> delegate;
@property (strong, nonatomic, readonly, nullable) NSOrderedSet<OPContactModel *> *contacts;

- (void)loadContacts;

@end

NS_ASSUME_NONNULL_END
