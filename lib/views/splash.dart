import 'package:weather/consts/consts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather/views/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const WelcomeScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      color: primaryColor.withOpacity(.6),
      child: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/get-started.png'),
              const SizedBox(height: 40),
              LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.white, size: 90),
            ],
          ),
        ),
      ),
    ));
  }
}
