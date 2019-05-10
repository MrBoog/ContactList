//
//  OPPhoneNumberPickerController.h
//  OPay
//
//  Created by LiuHuan on 2019/4/24.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPContactModel.h"

/**
 * Add desc before use it.
 * Privacy - Contacts Usage Description
 * This allows OPay to let you choose contacts from your contact list.
 */
NS_ASSUME_NONNULL_BEGIN
@protocol OPPhoneNumberPickerControllerDelegate;
@interface OPPhoneNumberPickerController : UITableViewController

@property (weak, nonatomic) id<OPPhoneNumberPickerControllerDelegate> delegate;

@end


@protocol OPPhoneNumberPickerControllerDelegate <NSObject>

- (void)phoneNumberPicker:(OPPhoneNumberPickerController *)picker
         didSelectContact:(OPContactModel *)contact;

@end

NS_ASSUME_NONNULL_END
