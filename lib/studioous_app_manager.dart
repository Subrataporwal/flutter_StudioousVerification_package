library studioous_app_manager;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudioousVerification extends StatefulWidget {
  // Licence Key
  final String licenseKey;
  // Skip App Verification
  final bool skipVerification;

  /// App title, shown in the middle of screen in case of no image available
  final Text? title;

  /// Page background color
  final Color backgroundColor;

  ///  Background image for the entire screen
  final ImageProvider? backgroundImage;

  /// logo width as in radius
  final double logoWidth;

  /// Main image mainly used for logos and like that
  final Image logo;

  /// Loader color
  final Color loaderColor;

  /// Loading text
  final Text loadingText;

  /// Padding for long Loading text, default: EdgeInsets.all(0)
  final EdgeInsets loadingTextPadding;

  /// Background gradient for the entire screen
  final Gradient? gradientBackground;

  /// Whether to display a loader or not
  final bool showLoader;

  /// durationInSeconds to navigate after for time based navigation
  final int durationInSeconds;

  /// The page where you want to navigate if you have chosen time based navigation
  /// String or Widget
  final dynamic navigator;

  /// expects a function that returns a future, when this future is returned it will navigate
  /// Future<String> or Future<Widget>
  /// If both futureNavigator and navigator are provided, futureNavigator will take priority
  final Future<Object>? futureNavigator;

  const StudioousVerification({
    required this.licenseKey,
    super.key,
    this.title,
    required this.skipVerification,
    required this.backgroundColor,
    this.backgroundImage,
    required this.logoWidth,
    required this.logo,
    required this.loaderColor,
    required this.loadingText,
    required this.loadingTextPadding,
    this.gradientBackground,
    required this.showLoader,
    required this.durationInSeconds,
    this.navigator,
    this.futureNavigator,
  });

  @override
  State<StudioousVerification> createState() => _StudioousVerificationState();
}

class _StudioousVerificationState extends State<StudioousVerification> {
  void pageTimer() {
    if (widget.futureNavigator == null) {
      Timer(Duration(seconds: widget.durationInSeconds), () {
        if (widget.navigator is String) {
          Navigator.of(context).pushReplacementNamed(
            widget.navigator as String,
          );
        } else if (widget.navigator is Widget) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => widget.navigator as Widget));
        }
      });
    } else {
      widget.futureNavigator!.then((route) {
        if (route is String) {
          Navigator.of(context).pushReplacementNamed(route);
        } else if (route is Widget) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => route));
        }
      });
    }
  }

  Future<void> verificationFunc() async {
    if (widget.skipVerification == true) {
      pageTimer();
    } else {
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://app-verification.studioous.com/getData/?key=${widget.licenseKey}'));

      http.StreamedResponse response = await request.send();
      String responseData = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = json.decode(responseData);
      bool status = jsonData['status'];

      if (response.statusCode == 200) {
        if (status == true) {
          pageTimer();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LockedPage()));
        }
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  @override
  void initState() {
    verificationFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: widget.backgroundImage != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.backgroundImage!,
                    )
                  : null,
              gradient: widget.gradientBackground,
              color: widget.backgroundColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: widget.logoWidth,
                        child: widget.logo,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      if (widget.title != null) widget.title!
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.showLoader
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                widget.loaderColor,
                              ),
                            )
                          : Container(),
                      if (widget.loadingText.data!.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                      Padding(
                        padding: widget.loadingTextPadding,
                        child: widget.loadingText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LockedPage extends StatelessWidget {
  const LockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121113),
      appBar: AppBar(
        backgroundColor: const Color(0xffE71D36),
        title: const Text(
          "App Locked",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://cdn-icons-png.flaticon.com/512/10445/10445569.png",
              width: 200,
            ),
            const SizedBox(height: 50),
            const Text(
              "APP LOCKED",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 300,
              child: Text(
                "Resolve Payment Issue to Restore App Access.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 26,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
