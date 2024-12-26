// import 'package:bamboo/test/testing.dart';
import 'dart:io';

import 'package:bamboo/firebase_options.dart';
import 'package:bamboo/my_pages/categories.dart';
import 'package:bamboo/my_pages/my_cat_items.dart';
import 'package:bamboo/my_pages/my_favourites.dart';
import 'package:bamboo/my_pages4/verify.dart';
import 'package:bamboo/options_item.dart';
import 'package:bamboo/page1.dart';
import 'package:bamboo/page3.dart';
import 'package:bamboo/page4.dart';
import 'package:bamboo/page5.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/page1settings.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/providers/user_info.dart';
import 'package:bamboo/splash.dart';
import 'package:bamboo/values/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'my_pages/bash sahypa/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Messaging Background Handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Which_page()),
        ChangeNotifierProvider(create: (_) => Favourite()),
        ChangeNotifierProvider(create: (_) => BottomProv()),
        ChangeNotifierProvider(create: (_) => PageSettings()),
        ChangeNotifierProvider(create: (_) => UserInfo()),
        ChangeNotifierProvider(create: (_) => ProvItem()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Message: ${message.notification?.title}");
  FCMConfig().sendNotification(
    body: message.notification?.body ?? "",
    title: message.notification?.title ?? "",
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      // İzinleri talep et
      await FirebaseMessaging.instance.requestPermission();

      final firebaseMessaging = FirebaseMessaging.instance;

      // Platforma göre cihaz token'ını al
      String? deviceToken;
      if (Platform.isAndroid) {
        deviceToken = await firebaseMessaging.getToken();
      } else if (Platform.isIOS) {
        deviceToken = await firebaseMessaging.getAPNSToken();
      }

      // Eğer token alınmışsa logla ve topic'e abone ol
      if (deviceToken != null && deviceToken.isNotEmpty) {
        print("Device Token: $deviceToken");

        // Topic'e abone ol
        await firebaseMessaging.subscribeToTopic('ttf_channel');
        print("Subscribed to topic: ttf_channel");
      } else {
        print("Failed to fetch device token. Cannot subscribe to topic.");
      }

      // Foreground mesajlarını dinle
      FirebaseMessaging.onMessage.listen((message) {
        print("Foreground Message: ${message.notification?.title}");
        FCMConfig().sendNotification(
          body: message.notification?.body ?? "",
          title: message.notification?.title ?? "",
        );
      });
    } catch (e) {
      print("An error occurred during FCM initialization: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: child!,
      ),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: _buildRoutes(),
      home: const Splash(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => const MyHomePage(),
      '/splash': (context) => const Splash(),
      '/options_item': (context) => const OptionsItem(image: ''),
      '/verify': (context) => const Verify(phoneNumber: ""),
      '/page4': (context) => const Page4(),
    };
  }
}

// Ana sayfa widgetı
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(initialPage: 0);
  int which_page = 1;
  int selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _backPressed(GlobalKey<NavigatorState> navigatorKey) async {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.maybePop();
      return Future<bool>.value(false);
    }

    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sistemden çıkmak istiyor musunuz?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Hayır"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Evet"),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // Alt çubuk sayfaları
    final bottomBarPages = <Widget>[
      _buildNavigatorPage(
        key: Provider.of<BottomProv>(context).yourKey1,
        initialPage: const Page1(),
      ),
      _buildNavigatorPage(
        key: Provider.of<BottomProv>(context).yourKey2,
        initialPage: const Categories(),
      ),
      _buildNavigatorPage(
        key: Provider.of<BottomProv>(context).yourKey3,
        initialPage: const Page3(),
      ),
      _buildNavigatorPage(
        key: Provider.of<BottomProv>(context).yourKey4,
        initialPage: const MyFavourites(),
      ),
      _buildNavigatorPage(
        key: Provider.of<BottomProv>(context).yourKey5,
        initialPage: const Page5(),
      ),
    ];

    selectedIndex = Provider.of<BottomProv>(context).page;

    return WillPopScope(
      onWillPop: () => _backPressed(
        which_page != 1 ? Provider.of<BottomProv>(context, listen: false).yourKey : Provider.of<BottomProv>(context, listen: false).yourKey1,
      ),
      child: Scaffold(
        body: PageView(
          controller: Provider.of<BottomProv>(context).pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: bottomBarPages,
        ),
        extendBody: true,
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildNavigatorPage({
    required GlobalKey<NavigatorState> key,
    required Widget initialPage,
  }) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) {
        Widget page = initialPage;

        // Eklenen rotalar
        if (settings.name == '/options') {
          page = const OptionsItem(image: '');
        } else if (settings.name == '/my_cat_items') {
          page = const MyCatItems();
        } else if (settings.name == '/searchin') {
          page = const Search();
        }

        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      iconSize: 22,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.green,
      useLegacyColorScheme: true,
      currentIndex: selectedIndex,
      onTap: (index) => _onNavigationTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.home),
          activeIcon: Icon(IconlyBold.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.category),
          activeIcon: Icon(IconlyBold.category),
          label: "Category",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.buy),
          activeIcon: Icon(IconlyBold.buy),
          label: "Order",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.heart),
          activeIcon: Icon(IconlyBold.heart),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.profile),
          activeIcon: Icon(IconlyBold.profile),
          label: "Profile",
        ),
      ],
    );
  }

  void _onNavigationTap(BuildContext context, int index) {
    selectedIndex = index;
    final bottomProv = Provider.of<BottomProv>(context, listen: false);

    switch (index) {
      case 0:
        which_page = 1;
        bottomProv.set_page0();
        break;
      case 1:
        which_page = 2;
        bottomProv.setPage1();
        break;
      case 2:
        which_page = 3;
        bottomProv.setPage2();
        break;
      case 3:
        which_page = 4;
        bottomProv.setPage3();
        break;
      case 4:
        which_page = 5;
        setState(() => {});
        bottomProv.setPage4();
        break;
    }
  }
}
