import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/location/widgets/dynamic_text_color.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/features/location/domain/models/prediction_model.dart';
import 'package:sixam_mart/features/location/domain/models/zone_response_model.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/location/widgets/web_landing_page_shimmer_widget.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/features/location/screens/pick_map_screen.dart';
import 'package:sixam_mart/features/location/widgets/landing_card_widget.dart';
import 'package:sixam_mart/features/location/widgets/registration_card_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart' as intl;

class WebLandingPage extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  const WebLandingPage({super.key, required this.fromSignUp, required this.fromHome, required this.route});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {
  final TextEditingController _controller = TextEditingController();
  final PageController _pageController = PageController();
  AddressModel? _address;
  Timer? _timer;
  bool? _isRtl;

  @override
  void initState() {
    super.initState();

    if(Get.find<SplashController>().moduleList == null) {
      if (kDebugMode) {
        print('-------call from web landing page------------');
      }
      Get.find<SplashController>().getModules(headers: {'Content-Type': 'application/json; charset=UTF-8', AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isRtl = intl.Bidi.isRtlLanguage(Get.locale!.languageCode);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<SplashController>(
        builder: (splashController) {
          return splashController.landingModel == null ? const WebLandingPageShimmerWidget() : Column(children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              ),
              child: Row(children: [
                const SizedBox(width: 40),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(splashController.landingModel?.fixedHeaderTitle ?? '', style: robotoBold.copyWith(fontSize: 35)),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    splashController.landingModel?.fixedHeaderSubTitle ?? '',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                  ),
                ])),
                Expanded(child: ClipPath(clipper: CustomPath(isRtl: _isRtl), child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    right: _isRtl! ? const Radius.circular(0) : const Radius.circular(Dimensions.radiusDefault),
                    left: _isRtl! ? const Radius.circular(Dimensions.radiusDefault) : const Radius.circular(0),
                  ),
                  child: CustomImage(
                    image: '${splashController.landingModel != null ? splashController.landingModel!.fixedHeaderImageFullUrl : ''}',
                    height: 270, fit: BoxFit.cover,
                  ),
                ))),
              ]),
            ),
            const SizedBox(height: 20),

            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Opacity(opacity: 0.05, child: SizedBox(
                  height: 130, width: context.width,
                  child: CustomAssetImageWidget(Images.landingBg, height: 130, width: context.width, fit: BoxFit.fill),
                )),
              ),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ),
                child: Row(children: [
                  Expanded(flex: 3, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const CustomAssetImageWidget(Images.landingChooseLocation, height: 70, width: 70),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          splashController.landingModel?.fixedLocationTitle ?? '', textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    ]),
                  )),
                  Expanded(flex: 7, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Row(children: [
                      Expanded(child:TypeAheadField<PredictionModel>(
                        // textFieldBuilder: (context, controller) {
                        //   return TextField(
                        //     controller: controller,
                        //     textInputAction: TextInputAction.search,
                        //     textCapitalization: TextCapitalization.words,
                        //     keyboardType: TextInputType.streetAddress,
                        //     decoration: InputDecoration(
                        //       hintText: 'search_location'.tr,
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: BorderSide(
                        //           color: Theme.of(context).primaryColor.withAlpha(77),
                        //           width: 1,
                        //         ),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //         borderSide: BorderSide(
                        //           color: Theme.of(context).primaryColor.withAlpha(77),
                        //           width: 1,
                        //         ),
                        //       ),
                        //     ),
                        //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //       fontSize: Dimensions.fontSizeLarge,
                        //     ),
                        //   );
                        // },
                        suggestionsCallback: (pattern) async {
                          return await Get.find<LocationController>().searchLocation(context, pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on),
                                Expanded(
                                  child: Text(
                                    suggestion.description ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onSelected: (PredictionModel suggestion) async {
                          _controller.text = suggestion.description ?? '';
                          _address = await Get.find<LocationController>().setLocation(
                            suggestion.placeId,
                            suggestion.description,
                            null,
                          );
                        },
                      )


                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      CustomButton(
                        width: 150, height: 60, fontSize: Dimensions.fontSizeDefault,
                        buttonText: 'set_location'.tr,
                        onPressed: () async {
                          if(_address != null && _controller.text.trim().isNotEmpty) {
                            Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
                            ZoneResponseModel response = await Get.find<LocationController>().getZone(
                              _address!.latitude, _address!.longitude, false,
                            );
                            if(response.isSuccess) {
                              if(!AuthHelper.isGuestLoggedIn() && !AuthHelper.isLoggedIn()) {
                                Get.find<AuthController>().guestLogin().then((response) {
                                  if(response.isSuccess) {
                                    Get.find<ProfileController>().setForceFullyUserEmpty();
                                    Get.find<LocationController>().saveAddressAndNavigate(
                                      _address, widget.fromSignUp, widget.route, widget.route != null, ResponsiveHelper.isDesktop(Get.context),
                                    );
                                  }
                                });
                              } else {
                                Get.find<LocationController>().saveAddressAndNavigate(
                                  _address, widget.fromSignUp, widget.route, widget.route != null, ResponsiveHelper.isDesktop(Get.context),
                                );
                              }
                            }else {
                              Get.back();
                              showCustomSnackBar('service_not_available_in_current_location'.tr);
                            }
                          }else {
                            showCustomSnackBar('pick_an_address'.tr);
                          }
                        },
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      CustomButton(
                        width: 160, height: 60, fontSize: Dimensions.fontSizeDefault,
                        buttonText: 'pick_from_map'.tr,
                        onPressed: () {
                          if(ResponsiveHelper.isDesktop(Get.context)) {

                            showGeneralDialog(context: context, pageBuilder: (_,__,___) {
                              return SizedBox(
                                height: 300, width: 300,
                                child: PickMapScreen(
                                  fromSignUp: widget.fromSignUp, canRoute: widget.route != null, fromAddAddress: false, route: widget.route
                                    ?? (widget.fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation), fromLandingPage: true,
                                ),
                              );
                            });
                          }else {
                            Get.toNamed(RouteHelper.getPickMapRoute(
                              widget.route ?? (widget.fromSignUp ? RouteHelper.signUp : RouteHelper.accessLocation), widget.route != null,
                            ));
                          }
                        }
                        // onPressed: (){
                        //   Get.dialog(const PickMapScreen(fromSignUp: false, canRoute: false, fromAddAddress: false, route: null ));
                        // }
                      ),
                    ]),
                  )),
                ]),
              ),
            ]),
            const SizedBox(height: 40),

            Text(
              splashController.landingModel?.fixedModuleTitle ?? '',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
            ),
            Text(
              splashController.landingModel?.fixedModuleSubTitle ?? '',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: 40),

            GetBuilder<SplashController>(builder: (splashController) {
              if(splashController.moduleList != null && _timer == null) {
                _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                  int index = splashController.moduleIndex >= splashController.moduleList!.length-1 ? 0 : splashController.moduleIndex+1;
                  splashController.setModuleIndex(index);
                  _pageController.animateToPage(index, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
                });
              }
              return splashController.moduleList != null ? SizedBox(height: 450, child: Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: splashController.moduleList!.length,
                  onPageChanged: (int index) => splashController.setModuleIndex(index >= splashController.moduleList!.length ? 0 : index),
                  itemBuilder: (context, index) {
                    index = splashController.moduleIndex >= splashController.moduleList!.length ? 0 : splashController.moduleIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 80),
                          Text(
                            splashController.moduleList![index].moduleName ?? '',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Expanded(child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            child: HtmlWidget(
                              splashController.moduleList![index].description ?? '',
                              key: Key(widget.route.toString()),
                              textStyle: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                              onTapUrl: (String url){
                                return launchUrlString(url);
                              },
                            ),
                          )),
                        ])),
                        CustomImage(
                          image: '${splashController.moduleList![index].thumbnailFullUrl}',
                          height: 450, width: 450,
                        ),
                      ]),
                    );
                  },
                ),
                Positioned(top: 0, left: 0, child: SizedBox(height: 75, child: Container(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: splashController.moduleList!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              splashController.setModuleIndex(index);
                              _pageController.animateToPage(index, duration: const Duration(seconds: 2), curve: Curves.easeInOut);
                            },
                            child: CustomImage(
                              image: '${splashController.moduleList![index].iconFullUrl}',
                              height: 45, width: 45,
                            ),
                          ),
                          SizedBox(width: 45, child: Divider(
                            color: splashController.moduleIndex == index ? Theme.of(context).primaryColor : Colors.transparent,
                            thickness: 2,
                          )),
                        ]),
                      );
                    },
                  ),
                ))),
              ])) : const SizedBox();
            }),
            const SizedBox(height: 40),

            (splashController.landingModel?.availableZoneStatus == 1 && splashController.landingModel!.availableZoneList!.isNotEmpty) ? Row(children: [

              Expanded(
                flex: 2,
                child: CustomImage(
                  height: 350,
                  image: '${splashController.landingModel?.availableZoneImageFullUrl}',
                ),
              ),
              const SizedBox(width: 100),

              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 350,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    DynamicTextColor(dynamicText: splashController.landingModel?.availableZoneTitle ?? ''),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Text(
                      splashController.landingModel?.availableZoneShortDescription ?? '',
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: List.generate(splashController.landingModel?.availableZoneList?.length ?? 0, (index) {

                            var modules = splashController.landingModel?.availableZoneList?[index].modules ?? [];
                            var modulesText = modules.join(', ');

                            return  Padding(
                              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                              child: MouseRegion(
                                onEnter: (_) => splashController.setHover(index, true),
                                onExit: (_) => splashController.setHover(index, false),
                                child: CustomToolTip(
                                  content: SizedBox(
                                    width: 200,
                                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        splashController.landingModel?.availableZoneList?[index].displayName ?? '',
                                        style: robotoBold.copyWith(color: Theme.of(context).cardColor),
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),

                                      Text(
                                        modulesText.isEmpty ? 'no_modules_are_available'.tr : '$modulesText ${'modules_are_available'.tr}',
                                        style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ]),
                                  ),
                                  preferredDirection: AxisDirection.up,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.6), width: 1),
                                      boxShadow: splashController.hoverStates[index] ? [const BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)] : [],
                                    ),
                                    child: Text(
                                      splashController.landingModel?.availableZoneList?[index].displayName ?? '',
                                      style: robotoBold.copyWith(color: splashController.hoverStates[index] ? Theme.of(context).primaryColor :  Theme.of(context).textTheme.bodyMedium!.color!),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                  ]),
                ),
              ),
            ]) : const SizedBox(),
            SizedBox(height: (splashController.landingModel?.availableZoneStatus == 1 && splashController.landingModel!.availableZoneList!.isNotEmpty) ? 40 : 0),

            Row(children: _generateChooseUsList(splashController)),
            SizedBox(height: AppConstants.whyChooseUsList.isNotEmpty ? 40 : 0),

            splashController.landingModel?.joinSellerStatus == 1 ? RegistrationCardWidget(isStore: true, splashController: splashController) : const SizedBox(),
            SizedBox(height: splashController.landingModel != null && splashController.landingModel!.joinSellerStatus == 1 ? 40 : 0),

            splashController.landingModel != null && (splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' || splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1')
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              CustomImage(
                image: '${splashController.landingModel!.downloadUserAppImageFullUrl}',
                width: 500,
              ),
              Column(children: [
                Text(
                  splashController.landingModel!.downloadUserAppTitle ?? '', textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  splashController.landingModel!.downloadUserAppSubTitle ?? '', textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  splashController.landingModel != null && splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' ? InkWell(
                    onTap: () async {
                      String url = splashController.landingModel?.downloadUserAppLinks?.playstoreUrl ?? '';
                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }
                    },
                    child: Image.asset(Images.landingGooglePlay, height: 45),
                  ) : const SizedBox(),
                  SizedBox(width: splashController.landingModel != null && (splashController.landingModel!.downloadUserAppLinks!.playstoreUrlStatus == '1' && splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1')
                      ? Dimensions.paddingSizeLarge : 0),

                  splashController.landingModel != null && splashController.landingModel!.downloadUserAppLinks!.appleStoreUrlStatus == '1' ? InkWell(
                    onTap: () async {
                      String url = splashController.landingModel!.downloadUserAppLinks!.appleStoreUrl ?? '';
                      if(await canLaunchUrlString(url)){
                        launchUrlString(url);
                      }
                    },
                    child: Image.asset(Images.landingAppStore, height: 45),
                  ) : const SizedBox(),
                ]),
              ]),
            ]) : const SizedBox(),
            const SizedBox(height: 40),

            splashController.landingModel?.joinDeliveryManStatus == 1 ? RegistrationCardWidget(isStore: false, splashController: splashController) : const SizedBox(),
            SizedBox(height: splashController.landingModel?.joinDeliveryManStatus == 1 ? 40 : 0),

          ]);
        }
      ))),
    );
  }

  List<Widget> _generateChooseUsList(SplashController splashController) {
    List<Widget> chooseUsList = [];
    for(int index=0; index < (splashController.landingModel != null && splashController.landingModel!.specialCriterias!.length > 4 ? 4 : splashController.landingModel!.specialCriterias!.length); index++) {
      chooseUsList.add(Expanded(child: Row(children: [
        Expanded(child: LandingCardWidget(
          icon: '${splashController.landingModel!.specialCriterias![index].imageFullUrl}',
          title: splashController.landingModel!.specialCriterias![index].title ?? '',
        )),
        SizedBox(width: index != splashController.landingModel!.specialCriterias!.length-1 ? 30 : 0),
      ])));
    }
    return chooseUsList;
  }

}

class CustomPath extends CustomClipper<Path> {
  final bool? isRtl;
  CustomPath({required this.isRtl});

  @override
  Path getClip(Size size) {
    final path = Path();
    if(isRtl!) {
      path..moveTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width*0.7, 0)
        ..lineTo(0, 0)
        ..close();
    }else {
      path..moveTo(0, size.height)
        ..lineTo(size.width*0.3, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
