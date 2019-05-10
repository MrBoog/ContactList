//
//  OPContactPicker.h
//  OPay
//
//  Created by LiuHuan on 2019/5/10.
//  Copyright © 2019 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OPContactPickerDelegate;
@interface OPContactPicker : NSObject

@property (weak, nonatomic) id<OPContactPickerDelegate> delegate;

- (void)presentPickerControllerBy:(UIViewController *)viewController
                         animated:(BOOL)animated
                       completion:(void (^ __nullable)(void))completion;
@end

@protocol OPContactPickerDelegate <NSObject>

- (void)op_contactPicker:(OPContactPicker *)picker didSelectContact:(OPContactModel *)contact;

@end

NS_ASSUME_NONNULL_END
