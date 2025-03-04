// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// import '../../../../core/utils/app_colors.dart';
//
//
// class CustomPinCodeField extends StatelessWidget {
//   final Function(String) onChanged;
//   final BuildContext appContext;
//
//   const CustomPinCodeField({
//     super.key,
//     required this.onChanged,
//     required this.appContext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//       child: PinCodeTextField(
//         autoFocus: true,
//         appContext: appContext,
//         length: 6,
//         onChanged: onChanged,
//         textStyle: TextStyle(
//           fontSize: 16.sp,
//           fontWeight: FontWeight.bold,
//         ),
//         pinTheme: PinTheme(
//           shape: PinCodeFieldShape.box,
//           borderRadius: BorderRadius.circular(8),
//           fieldHeight: 45,
//           fieldWidth: 45,
//           activeFillColor: AppColors.white,
//           inactiveFillColor: AppColors.white,
//           selectedFillColor: AppColors.white,
//           activeColor: AppColors.white,
//           inactiveColor: AppColors.grayHintText,
//           selectedColor: AppColors.primaryColor,
//         ),
//         cursorColor: AppColors.primaryColor,
//         animationDuration: Duration(milliseconds: 150),
//         enableActiveFill: true,
//         keyboardType: TextInputType.number,
//       ),
//     );
//   }
// }
