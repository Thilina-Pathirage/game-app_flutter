import 'package:flutter/material.dart';
import 'package:gamerev/routes.dart';
import './services/auth_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return 
    
    // MaterialApp(
    //   theme: Theme.of(context).copyWith(
    //     // Change this color to the desired color
    //     highlightColor: Colors.deepOrange,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   title: 'Game Reviews',
    //   initialRoute: '/home',
    //   onGenerateRoute: Routes.generateRoute,
    // );

    Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder<bool>(
        future: _authService.isTokenExpired(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && !snapshot.data!) {
              return MaterialApp(
                theme: Theme.of(context).copyWith(
                  // Change this color to the desired color
                  highlightColor: Colors.deepOrange,
                ),
                debugShowCheckedModeBanner: false,
                title: 'Game Reviews',
                initialRoute: '/home',
                onGenerateRoute: Routes.generateRoute,
              );
            } else {
              return MaterialApp(
                theme: ThemeData(
                  //primaryColor: const Color.fromARGB(255, 231, 77, 21),
                  primaryColor: Colors.deepOrange,
                ),
                debugShowCheckedModeBanner: false,
                title: 'Game Reviews',
                initialRoute: '/',
                onGenerateRoute: Routes.generateRoute,
              );
            }
          } else {
            // Show a loading indicator while checking token expiration
            return LoadingAnimationWidget.halfTriangleDot(
              color: Colors.deepOrange,
              size: 40,
            );
          }
        },
      ),
    );
  }
}
