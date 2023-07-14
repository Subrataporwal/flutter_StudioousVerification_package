
# Studioous Verification

Its a Studioous Flutter Verification Package Where We can put a Checkpoint on Flutter App Made By Studioous Team and Check Weather the Payment for the related Project is Recived Or Not.


## Authors

- [@Subrataporwal](https://www.github.com/Subrataporwal)


## Installation

Add ths Code In pubspec.yaml in Flutter Project

```yaml
dependencies:
  studioous_app_manager:
    git:
      url: https://github.com/Subrataporwal/flutter_StudioousVerification_package
      ref: main
```
    
## Deployment

Add This Code In Your Flutter main.dart

```dart
import 'package:studioous_app_manager/studioous_app_manager.dart';
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudioousVerification(
        licenseKey: "----License Key Here----",
        // If Your Want to Skip Verification.
        skipVerification: false,
        backgroundColor: Colors.black,
        logoWidth: 100,
        logo: Image.asset("assets/logo.png"),
        loaderColor: Colors.white,
        loadingText: Text(
          "AI Flirting App",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        loadingTextPadding: const EdgeInsets.all(20),
        showLoader: true,
        durationInSeconds: 2,
        // Add Your Home Screen Router Here
        navigator: const HomeScreen(),
      ),
    );
  }
}
```

