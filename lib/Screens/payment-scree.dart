// ignore_for_file: must_be_immutable

import 'package:courses_app/Screens/home/home-screen.dart';
import 'package:courses_app/Screens/my%20enroll%20courses/model/enroll_courses_model.dart';
import 'package:courses_app/backend/firebase_functions.dart';
import 'package:courses_app/paymob/paymob_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen(
      {super.key, required this.totalPrice, required this.coursesModel});
  InAppWebViewController? _webViewController;
  final double totalPrice;
  EnrollCoursesModel coursesModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          PaymobManager()
              .getPaymentKey(totalPrice, "EGP")
              .then((String paymentKey) {
            _webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                  "https://accept.paymob.com/api/acceptance/iframes/845444?payment_token=$paymentKey",
                ),
              ),
            );
          });
        },
        onLoadStop: (controller, url) {
          if (url != null && url.queryParameters.containsKey('success')) {
            if (url.queryParameters['success'] == 'true') {
              FirebaseFunctions.learnersCourseNumber(
                  coursesModel.coursesModel.createdAt,
                  coursesModel.coursesModel.userId);
              FirebaseFunctions.addEnrollCourse(coursesModel!);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Payment Done"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Done");
            } else if (url.queryParameters['success'] == 'false') {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Payment Failed"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Failed");
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("Payment Canceled"),
                        actions: [
                          TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.routeName);
                              })
                        ]);
                  });
            }
          }
        },
      ),
    );
  }
}
