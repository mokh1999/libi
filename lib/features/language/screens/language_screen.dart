import 'package:sixam_mart/common/nWidget/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/features/language/screens/web_language_screen.dart';
import 'package:sixam_mart/features/language/widgets/language_card_widget.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_colors.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_app_bar.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';


class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;

  const ChooseLanguageScreen({super.key, this.fromMenu = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: (widget.fromMenu || ResponsiveHelper.isDesktop(context))
          ? CustomAppBar(title: 'language'.tr, backButton: true)
          : null,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: Theme.of(context).cardColor,
      body:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return ResponsiveHelper.isDesktop(context)
            ? const WebLanguageScreen()
            :
            //  //⭐  content language screen

            SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: height * 0.52,
                        decoration: BoxDecoration(color: AppColors.orange),
                        child: Stack(
                          children: [
                            CustomImageView(
                              imagePath: Images.nBackgroundSplash,
                              fit: BoxFit.fitWidth,
                              width: width,
                            ),

                            //⭐  logo container
                            Center(
                              child: Container(
                                height: height * 0.33,
                                width: width * 0.65,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color:
                                        AppColors.white.withValues(alpha: 0.3)),
                                child: Center(
                                  child: CustomImageView(
                                    imagePath: Images.nLogo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //⭐   choose language

                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                Dimensions.paddingSizeExtraLarge,
                              ),
                              topRight: Radius.circular(
                                Dimensions.paddingSizeExtraLarge,
                              ),
                            )),
                        height: height * 0.48,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              // const Align(
                              //   alignment: Alignment.center,
                              //   child: CustomAssetImageWidget(
                              //     Images.languageBg,
                              //     height: 210,
                              //     width: 210,
                              //     fit: BoxFit.contain,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Text('choose_your_language'.tr,
                                    style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Text(
                                    'choose_your_language_to_proceed'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    itemCount:
                                        localizationController.languages.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeLarge),
                                    itemBuilder: (context, index) {
                                      return LanguageCardWidget(
                                        languageModel: localizationController
                                            .languages[index],
                                        localizationController:
                                            localizationController,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeDefault,
                                    horizontal:
                                        Dimensions.paddingSizeExtraLarge),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child: CustomButton(
                                  buttonText: 'next'.tr,
                                  onPressed: () {
                                    if (localizationController
                                            .languages.isNotEmpty &&
                                        localizationController
                                                .selectedLanguageIndex !=
                                            -1) {
                                      localizationController.setLanguage(Locale(
                                        AppConstants
                                            .languages[localizationController
                                                .selectedLanguageIndex]
                                            .languageCode!,
                                        AppConstants
                                            .languages[localizationController
                                                .selectedLanguageIndex]
                                            .countryCode,
                                      ));
                                      if (widget.fromMenu) {
                                        Navigator.pop(context);
                                      } else {
                                        Get.offNamed(
                                            RouteHelper.getOnBoardingRoute());
                                      }
                                    } else {
                                      showCustomSnackBar(
                                          'select_a_language'.tr);
                                    }
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
