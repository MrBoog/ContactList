//
//  OPPhoneNumberPickerController.m
//  OPay
//
//  Created by LiuHuan on 2019/4/24.
//  Copyright © 2019 Opera. All rights reserved.
//

#import "OPPhoneNumberPickerController.h"
#import "OPContactsDataSource.h"
#import "OPContactsDataProvider.h"

@interface OPPhoneNumberPickerController ()

@property (strong, nonatomic) OPContactsDataSource *contactDataSource;
@property (strong, nonatomic) NSOrderedSet<OPContactModel *> *allContacts;
@property (copy, nonatomic) NSString *errorHint;

@end

@implementation OPPhoneNumberPickerController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        id<OPContactsDataProviderProtocol> provider = nil;
        if (@available(iOS 9, *)) {
            provider = [[OPContactsDataProvider alloc] init];
        } else {
            //TODO: provider for iOS8
        }
        _contactDataSource = [[OPContactsDataSource alloc] initWithDataProvider:provider];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(__backButtonItemToDismissModal)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)__backButtonItemToDismissModal {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self __fetchContacts];
}

- (void)__fetchContacts {
    __weak __typeof(self) weakSelf = self;
    [self.contactDataSource loadContactSuccess:^(NSOrderedSet<OPContactModel *> * _Nonnull contacts) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.allContacts = contacts;
        [strongSelf.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (error.code == OPContactsDataProviderAuthenticationError) {
            strongSelf.errorHint = NSLocalizedString(@"No contacts access, open Settings app to fix this", nil);
        }
        [strongSelf.tableView reloadData];
    }];
}

- (NSString *)__displayTitleForContact:(OPContactModel *)contact {
    if (contact.fullName.length) {
        return contact.fullName;
    }
    return nil;
}

- (NSString *)__displaySubtitleForContact:(OPContactModel *)contact {
    if (contact.fullName.length && contact.phoneNumber.length) {
        return contact.phoneNumber;
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.allContacts) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneNumberPicker:didSelectContact:)]) {
        OPContactModel *contact = [self.allContacts objectAtIndex:indexPath.row];
        [self.delegate phoneNumberPicker:self didSelectContact:contact];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allContacts) {
        return self.allContacts.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (self.allContacts) {
        OPContactModel *contact = [self.allContacts objectAtIndex:indexPath.row];
        cell.textLabel.text = [self __displayTitleForContact:contact];
        cell.detailTextLabel.text = [self __displaySubtitleForContact:contact];
    } else {
        cell.textLabel.text = self.errorHint;
    }
    return cell;
}

@end
