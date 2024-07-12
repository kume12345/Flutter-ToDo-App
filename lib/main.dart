
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_main.dart';
import 'package:todo_app/shared/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

BuildContext? appContext;
void main() => runApp(
      const MaterialAppBootstrapScreen(), // Wrap your app
    );

class MaterialAppBootstrapScreen extends StatelessWidget {
  const MaterialAppBootstrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return MaterialApp(
      title: "Contact App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              "Lets DO It Time Tracker",
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 140.0),
              child: Center(
                child: homePageLogo,
              ),
            ),
            homePageGreeting,
            homePageParagraph,
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ToDoMain()));
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.primary)),
                  child: const Text(
                    'Get started',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

const String assetName = 'images/todo_app_traineer.svg';
final Widget homePageLogo =
    SvgPicture.asset(assetName, width: 200, height: 200);
final Widget homePageGreeting = Container(
  margin: const EdgeInsets.only(top: 80.0),
  child: const Text(
    'Welcome to Lets DO IT',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  ),
);

final Widget homePageParagraph = Container(
  margin: const EdgeInsets.only(top: 30.0),
  width: 200,
  child: const Text(
    "Let’s DO IT will help you to stay organized and performe your task much faster .",
    style: TextStyle(
        color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12),
  ),
);
