//
//  OPContactPicker.m
//  OPay
//
//  Created by LiuHuan on 2019/5/10.
//  Copyright © 2019 Opera. All rights reserved.
//

#import "OPContactPicker.h"
#import <ContactsUI/ContactsUI.h>
#import "OPPhoneNumberPickerController.h"

@interface OPContactPicker () <OPPhoneNumberPickerControllerDelegate, CNContactPickerDelegate>

@property (strong, nonatomic) OPPhoneNumberPickerController *phoneNumberPickerController;
@property (strong, nonatomic) CNContactPickerViewController *contactPickerController;

@end

@implementation OPContactPicker

- (void)presentPickerControllerBy:(UIViewController *)viewController
                         animated:(BOOL)animated
                       completion:(void (^ __nullable)(void))completion {
    if (!viewController) {
        return;
    }
    [self __presentContactPickerByController:viewController animated:animated completion:completion];
}

- (void)__presentPhoneNumberPickerByController:(UIViewController *)viewController
                                      animated:(BOOL)animated
                                    completion:(void (^ __nullable)(void))completion {
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:self.phoneNumberPickerController];
    [viewController presentViewController:navigationVC animated:animated completion:completion];
}

- (void)__presentContactPickerByController:(UIViewController *)viewController
                                  animated:(BOOL)animated
                                completion:(void (^ __nullable)(void))completion {
    [viewController presentViewController:self.contactPickerController animated:animated completion:completion];
}

- (OPPhoneNumberPickerController *)phoneNumberPickerController {
    if (!_phoneNumberPickerController) {
        _phoneNumberPickerController = [[OPPhoneNumberPickerController alloc] init];
        _phoneNumberPickerController.delegate = self;
    }
    return _phoneNumberPickerController;
}

- (CNContactPickerViewController *)contactPickerController {
    if (!_contactPickerController) {
        _contactPickerController = [[CNContactPickerViewController alloc] init];
        _contactPickerController.delegate = self;
        _contactPickerController.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    }
    return _contactPickerController;
}

- (void)__didSelectContact:(OPContactModel *)contact {
    if (self.delegate && [self.delegate respondsToSelector:@selector(op_contactPicker:didSelectContact:)]) {
        [self.delegate op_contactPicker:self didSelectContact:contact];
    }
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    OPContactModel *contact = [[OPContactModel alloc] init];

    CNPhoneNumber *phone = [contactProperty.value dynamicCast:[CNPhoneNumber class]];
    if (phone) {
        contact.phoneNumber = phone.stringValue;
    } else {
        CNLabeledValue<CNPhoneNumber *> *phoneNumber = contactProperty.contact.phoneNumbers.firstObject;
        contact.phoneNumber = phoneNumber.value.stringValue;
    }
    contact.fullName = [CNContactFormatter stringFromContact:contactProperty.contact style:CNContactFormatterStyleFullName];
    [self __didSelectContact:contact];
}

#pragma mark - OPPhoneNumberPickerControllerDelegate

- (void)phoneNumberPicker:(OPPhoneNumberPickerController *)picker
         didSelectContact:(OPContactModel *)contact {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self __didSelectContact:contact];
}

@end
