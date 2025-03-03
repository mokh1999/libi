import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sixam_mart/common/nWidget/custom_image.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBodyModel? body;
  const SplashScreen({super.key, required this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();

    //⭐animation settings
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    //⭐ animation curve
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    //⭐ start animation
    _animationController.forward();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);

      if(!firstTime) {
        isConnected ? ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar() : const SizedBox();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(isConnected ? 'connected'.tr : 'no_connection'.tr, textAlign: TextAlign.center),
        ));
        if(isConnected) {
          Get.find<SplashController>().getConfigData(notificationBody: widget.body);
        }
      }

      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if((AuthHelper.getGuestId().isNotEmpty || AuthHelper.isLoggedIn()) && Get.find<SplashController>().cacheModule != null) {
      Get.find<CartController>().getCartDataOnline();
    }
    // _route();
    Get.find<SplashController>().getConfigData(notificationBody: widget.body);

  }
  @override
  void dispose() {
    // //⭐ dispose animation
    _animationController.dispose();
    _onConnectivityChanged?.cancel();
    super.dispose();
  }


  // void _route() {
  //   Get.find<SplashController>().getConfigData().then((isSuccess) {
  //     if(isSuccess) {
  //       Timer(const Duration(seconds: 1), () async {
  //         double? minimumVersion = _getMinimumVersion();
  //         bool isMaintenanceMode = Get.find<SplashController>().configModel!.maintenanceMode!;
  //         bool needsUpdate = AppConstants.appVersion < minimumVersion!;
  //
  //         if(needsUpdate || isMaintenanceMode) {
  //           Get.offNamed(RouteHelper.getUpdateRoute(needsUpdate));
  //         }else {
  //           if(widget.body != null) {
  //             _forNotificationRouteProcess(widget.body);
  //           }else {
  //             _handleUserRouting();
  //           }
  //         }
  //       });
  //     }
  //   });
  // }
  //
  // double? _getMinimumVersion() {
  //   if (GetPlatform.isAndroid) {
  //     return Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
  //   } else if (GetPlatform.isIOS) {
  //     return Get.find<SplashController>().configModel!.appMinimumVersionIos;
  //   }
  //   return 0;
  // }
  //
  // void _forNotificationRouteProcess(NotificationBodyModel? notificationBody) {
  //   final notificationType = notificationBody?.notificationType;
  //
  //   final Map<NotificationType, Function> notificationActions = {
  //     NotificationType.order: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(widget.body!.orderId, fromNotification: true)),
  //     NotificationType.block: () => Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.notification)),
  //     NotificationType.unblock: () => Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.notification)),
  //     NotificationType.message: () =>  Get.toNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationID: widget.body!.conversationId, fromNotification: true)),
  //     NotificationType.otp: () => null,
  //     NotificationType.add_fund: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
  //     NotificationType.referral_earn: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
  //     NotificationType.cashback: () => Get.toNamed(RouteHelper.getWalletRoute(fromNotification: true)),
  //     NotificationType.loyalty_point: () => Get.toNamed(RouteHelper.getLoyaltyRoute(fromNotification: true)),
  //     NotificationType.general: () => Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true)),
  //   };
  //
  //   notificationActions[notificationType]?.call();
  // }
  //
  // Future<void> _forLoggedInUserRouteProcess() async {
  //   Get.find<AuthController>().updateToken();
  //   if (AddressHelper.getUserAddressFromSharedPref() != null) {
  //     if(Get.find<SplashController>().module != null) {
  //       await Get.find<FavouriteController>().getFavouriteList();
  //     }
  //     Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
  //   } else {
  //     Get.find<LocationController>().navigateToLocationScreen('splash', offNamed: true);
  //   }
  // }
  //
  // void _newlyRegisteredRouteProcess() {
  //   if(AppConstants.languages.length > 1) {
  //     Get.offNamed(RouteHelper.getLanguageRoute('splash'));
  //   }else {
  //     Get.offNamed(RouteHelper.getOnBoardingRoute());
  //   }
  // }
  //
  // void _forGuestUserRouteProcess() {
  //   if (AddressHelper.getUserAddressFromSharedPref() != null) {
  //     Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
  //   } else {
  //     Get.find<LocationController>().navigateToLocationScreen('splash', offNamed: true);
  //   }
  // }
  //
  // Future<void> _handleUserRouting() async {
  //   if (AuthHelper.isLoggedIn()) {
  //     _forLoggedInUserRouteProcess();
  //   } else if (Get.find<SplashController>().showIntro() == true) {
  //     _newlyRegisteredRouteProcess();
  //   } else if (AuthHelper.isGuestLoggedIn()) {
  //     _forGuestUserRouteProcess();
  //   } else {
  //     await Get.find<AuthController>().guestLogin();
  //     _forGuestUserRouteProcess();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>().initSharedData();
    if(AddressHelper.getUserAddressFromSharedPref() != null && AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
      Get.find<AuthController>().clearSharedAddress();
    }

    final double width=MediaQuery.sizeOf(context).width;
    return Scaffold(

      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: CustomImageView(
                  imagePath: Images.nLogo,
                  width: width * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ) : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }
}
