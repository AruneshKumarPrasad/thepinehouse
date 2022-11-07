import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Global/global.dart';
import 'Screens/form_screen.dart';
import 'Screens/profiles_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeMode _themeMode = ThemeMode.light;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  bool checkDarkTheme() {
    return _themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The PineHouse',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.light,
          scaffoldBackgroundColor: GlobalTraits.bgGlobalColor,
          iconTheme: IconThemeData(
            color: GlobalTraits.bgGlobalColorDark,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: GlobalTraits.bgGlobalColorDark,
            ),
          )
          /* light theme settings */
          ),
      darkTheme: ThemeData(
          fontFamily: 'OpenSans',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: GlobalTraits.bgGlobalColorDark,
          iconTheme: IconThemeData(
            color: GlobalTraits.bgGlobalColor,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: GlobalTraits.bgGlobalColor,
            ),
          )
          /* dark theme settings */
          ),
      themeMode: _themeMode,
      home: MyHomePage(
        darkMode: _themeMode == ThemeMode.dark,
        changeDarkMode: changeTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.darkMode, this.changeDarkMode})
      : super(key: key);
  final bool darkMode;
  final dynamic changeDarkMode;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late bool _darkModeEnabled;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _darkModeEnabled = widget.darkMode;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AnimatedDefaultTextStyle(
            style: _darkModeEnabled
                ? const TextStyle(fontSize: 32, color: Colors.white)
                : const TextStyle(fontSize: 32, color: Colors.black),
            duration: const Duration(milliseconds: 500),
            child: AnimatedCrossFade(
              firstChild: const Text("Profiles"),
              secondChild: const Text("Welcome!"),
              duration: const Duration(milliseconds: 250),
              crossFadeState: _currentIndex == 1
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.darkMode) {
                    widget.changeDarkMode(ThemeMode.light);
                    _darkModeEnabled = false;
                  } else {
                    widget.changeDarkMode(ThemeMode.dark);
                    _darkModeEnabled = true;
                  }
                });
              },
              child: AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _darkModeEnabled
                      ? GlobalTraits.neuShadowsCircularDark
                      : GlobalTraits.neuShadowsCircular,
                  color: _darkModeEnabled
                      ? GlobalTraits.bgGlobalColorDark
                      : GlobalTraits.bgGlobalColor,
                ),
                duration: const Duration(milliseconds: 200),
                child: _darkModeEnabled
                    ? Icon(
                        Icons.light_mode,
                        color: GlobalTraits.bgGlobalColor,
                      )
                    : Icon(
                        Icons.dark_mode,
                        color: GlobalTraits.bgGlobalColorDark,
                      ),
              ),
            )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: <Widget>[
          FormScreen(darkModeEnabled: _darkModeEnabled),
          ProfilesScreen(darkModeEnabled: _darkModeEnabled),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: 100,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: _darkModeEnabled
                ? GlobalTraits.neuShadowsDark
                : GlobalTraits.neuShadows,
            color: _darkModeEnabled
                ? GlobalTraits.bgGlobalColorDark
                : GlobalTraits.bgGlobalColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              });
            },
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            selectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              color: _darkModeEnabled
                  ? GlobalTraits.bgGlobalColor
                  : GlobalTraits.bgGlobalColorDark,
            ),
            selectedIconTheme: IconThemeData(
              size: 25,
              color: _darkModeEnabled
                  ? GlobalTraits.bgGlobalColor
                  : GlobalTraits.bgGlobalColorDark,
            ),
            unselectedIconTheme: const IconThemeData(size: 20),
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_justify),
                label: 'Form',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Profiles',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
