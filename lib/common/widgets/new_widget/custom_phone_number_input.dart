import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/countries.dart';

import '../../../util/app_colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';

class CustomPhoneNumberInput extends StatelessWidget {
  const CustomPhoneNumberInput({
    super.key,
    required this.onChanged,
    required this.onCountryChanged,
    required this.hintText,
    this.borderWidth = 1.0,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = AppColors.primaryColor,
    this.borderRadius = 8.0,
    this.fillColor = Colors.white,
    this.suffixIcon,
    this.yourPrefixIcon,
  });

  final void Function(PhoneNumber) onChanged;
  final void Function(Country)? onCountryChanged;
  final String hintText;
  final double borderWidth;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;
  final Color fillColor;
  final Widget? suffixIcon;
  final Widget? yourPrefixIcon;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(10),
        hintStyle: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: AppColors.grayHintText,
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: borderWidth,
          ),
        ),
        prefixIcon: yourPrefixIcon != null
            ? SizedBox(
          width: 24,
          height: 24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: yourPrefixIcon,
          ),
        )
            : null,
        suffixIcon: suffixIcon != null
            ? SizedBox(
          width: 24,
          height: 24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: suffixIcon,
          ),
        )
            : null,
      ),
      initialCountryCode: 'EG',
      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      dropdownTextStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      pickerDialogStyle: PickerDialogStyle(
        countryNameStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        countryCodeStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      ),
      onChanged: (PhoneNumber number) => onChanged(number),
      onCountryChanged: (country) => onCountryChanged?.call(country),
    );
  }
}
