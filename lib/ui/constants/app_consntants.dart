import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const mHomeIcon = Icons.home_outlined;
const mSearchIcon = Icons.search;
const mUserIcon = Icons.person;
const mFeedsIcon = Icons.rss_feed;
const mCartIcon = Icons.shopping_cart_outlined;
const mRemoveCartIcon = Icons.remove_shopping_cart_outlined;
const mAddCartIcon = Icons.add_shopping_cart_outlined;
const mEmailIcon = Icons.email;
const mPhoneIcon = Icons.phone;
const mShippingAddress = Icons.local_shipping_outlined;
const mJoinDateIcon = Icons.date_range_rounded;
const mCloseIcon = Icons.cancel_outlined;
const mTrailingIcon = Icons.keyboard_arrow_right;
const mWishListIcon = Icons.favorite_border_outlined;
const mWishListIconFill = Icons.favorite;
const mCameraIcon = Icons.add_photo_alternate;
const mIconDelete = CupertinoIcons.multiply_square_fill;
const mIconAdd = Icons.add_circle;
const mIconRemove = Icons.remove_circle_sharp;
const mTrashIcon = Icons.delete_outline;
const mEditIcon = Icons.edit_note_outlined;

class MyButtonStyle {
  static ButtonStyle disabledButton = ButtonStyle(
    backgroundColor:
        WidgetStateProperty.resolveWith((states) => Colors.grey[500]),
    foregroundColor:
        WidgetStateProperty.resolveWith((states) => Colors.black),
  );
}
