import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screen/loging_screen.dart';
import 'package:whatsapp_ui/features/auth/screen/otp_screen.dart';

import 'common/widgets/error.dart';
import 'features/landing/screens/landing_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
               ));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
