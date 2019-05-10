//
//  OPContactsDataProvider.m
//  OPay
//
//  Created by LiuHuan on 2019/4/23.
//  Copyright © 2019 Opera. All rights reserved.
//

#import "OPContactsDataProvider.h"

typedef void (^OPContactsDataProviderFetchCompletionBlock)(NSOrderedSet<OPContactModel *> *contacts);
typedef void (^OPContactsDataProviderFetchFailedBlock)(NSError *error);

@interface OPContactsDataProvider ()
@property (strong, nonatomic, nullable) NSOrderedSet<OPContactModel *> *contacts;
@end

@implementation OPContactsDataProvider

- (void)loadContacts {
    CNAuthorizationStatus status = [self __authorizationStatus];
    if (status == CNAuthorizationStatusNotDetermined) {
        [self __triggerUserAuthentication];
    } else if (status == CNAuthorizationStatusAuthorized) {
        __weak typeof(self) weakSelf = self;
        [self __fetchContactsWithSuccess:^(NSOrderedSet<OPContactModel *> *contacts) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.contacts = contacts;
            if (self.delegate && [self.delegate respondsToSelector:@selector(contactsDataProvider:fetchCompletion:)]) {
                [self.delegate contactsDataProvider:self
                                    fetchCompletion:self.contacts];
            }
        } failure:^(NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(contactsDataProvider:fetchFailed:)]) {
                [self.delegate contactsDataProvider:self
                                        fetchFailed:error];
            }
        }];
    } else if (status == CNAuthorizationStatusRestricted ||
               status == CNAuthorizationStatusDenied) {
        NSError *err = [NSError errorWithDomain:OPContactsDataProviderErrorDomain
                                           code:OPContactsDataProviderAuthenticationError
                                       userInfo:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(contactsDataProvider:fetchFailed:)]) {
            [self.delegate contactsDataProvider:self
                                    fetchFailed:err];
        }
    } else {
        NSError *err = [NSError errorWithDomain:OPContactsDataProviderErrorDomain
                                           code:OPContactsDataProviderUnknownError
                                       userInfo:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(contactsDataProvider:fetchFailed:)]) {
            [self.delegate contactsDataProvider:self
                                    fetchFailed:err];
        }
    }
}

#pragma mark - private

- (void)__fetchContactsWithSuccess:(OPContactsDataProviderFetchCompletionBlock)success
                           failure:(OPContactsDataProviderFetchFailedBlock)failure {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError *error;
    
    NSMutableArray *keysToFetch = [NSMutableArray arrayWithObjects:[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                                   CNContactPhoneNumbersKey,
                                   nil];

    NSMutableArray<CNContact *> *cnContacts = [[NSMutableArray alloc] init];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    fetchRequest.sortOrder = CNContactSortOrderUserDefault;
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if (error) {
            failure(error);
            *stop = YES;
            return;
        }
        [cnContacts addObject:contact];
    }];
    
    NSMutableOrderedSet<OPContactModel *> *opContacts = [[NSMutableOrderedSet alloc] initWithCapacity:cnContacts.count];
    for (CNContact *cnContact in cnContacts) {
        [opContacts addObject:[self __contactForCNContact:cnContact]];
    }
    success(opContacts);
}

- (OPContactModel *)__contactForCNContact:(CNContact *)cnContact {
    OPContactModel *contact = [[OPContactModel alloc] init];
    //TODO: Only get the first phoneNumbers for now..
    CNLabeledValue<CNPhoneNumber *> *phoneNumber = cnContact.phoneNumbers.firstObject;
    contact.phoneNumber = phoneNumber.value.stringValue;
    contact.fullName = [CNContactFormatter stringFromContact:cnContact style:CNContactFormatterStyleFullName];
    return contact;
}

- (void)__triggerUserAuthentication {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self loadContacts];
            }
        });
    }];
}

- (CNAuthorizationStatus)__authorizationStatus {
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}

@end
