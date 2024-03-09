import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ideamagix/ui/home/home_page.dart';
import 'package:ideamagix/ui/splash/splash_page.dart';

import 'model/product_response.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}


List<ProductResponse> cartList = [];