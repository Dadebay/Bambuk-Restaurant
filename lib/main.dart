import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
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
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:bamboo/values/firebase_messaging_service.dart';
import 'package:bamboo/values/local_notifications_service.dart';
import 'package:bamboo/webview_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_pages/bash sahypa/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);
  await FirebaseMessaging.instance.subscribeToTopic('ttf_channel');
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('');
  print('🔔 BACKGROUND MESSAGE RECEIVED 🔔');
  print('═══════════════════════════════════════════════════════════════');
  debugPrint("Handling a background message: ${message.messageId}");
  final String? title = message.notification?.title;
  final String? body = message.notification?.body;
  print("Message ID: ${message.messageId}");
  print("Title: $title");
  print("Body: $body");
  print("Data: ${message.data}");
  print('═══════════════════════════════════════════════════════════════');
  print('');
  debugPrint("Background Message Title: $title");
  debugPrint("Background Message Body (URL if present): $body");
  debugPrint("Background Message Data: ${message.data}");

  // Extract URL from data payload or body
  String? urlToLaunch = message.data['url'] as String?;

  if ((urlToLaunch == null || urlToLaunch.isEmpty) && body != null) {
    if (body.startsWith('http://') || body.startsWith('https://')) {
      urlToLaunch = body;
    }
  }

  print('');
  print('🔗 EXTRACTED URL (BACKGROUND) 🔗');
  print('═══════════════════════════════════════════════════════════════');
  print('URL: $urlToLaunch');
  print('═══════════════════════════════════════════════════════════════');
  print('');

  // Save notification to SharedPreferences, but do not show it manually
  if (title != null || body != null) {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    final newNotification = jsonEncode({
      'title': title,
      'body': body,
      'url': urlToLaunch,
      'date': DateTime.now().toIso8601String(),
    });
    notifications.add(newNotification);
    await prefs.setStringList('notifications', notifications);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RemoteMessage? _initialMessage;
  bool _initialMessageHandled = false;

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _setupInteractedMessage() {
    // Terminated state - uygulama kapalıyken bildirime tıklanmış
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('');
        print('🚀 INITIAL MESSAGE (TERMINATED STATE) 🚀');
        print('═══════════════════════════════════════════════════════════════');
        print('Message will be handled after app initialization');
        print('═══════════════════════════════════════════════════════════════');
        print('');
        _initialMessage = message;
      }
    });

    // Background state - uygulama arka planda iken bildirime tıklanmış
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('');
      print('📱 MESSAGE OPENED APP (BACKGROUND STATE) 📱');
      print('═══════════════════════════════════════════════════════════════');
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    String? urlToLaunch = message.data['url'];

    if ((urlToLaunch == null || urlToLaunch.isEmpty) &&
        message.notification?.body != null &&
        (message.notification!.body!.startsWith('http://') || message.notification!.body!.startsWith('https://'))) {
      urlToLaunch = message.notification!.body;
    }

    print('');
    print('🔗 HANDLING MESSAGE 🔗');
    print('═══════════════════════════════════════════════════════════════');
    print('URL: $urlToLaunch');
    print('═══════════════════════════════════════════════════════════════');
    print('');

    if (urlToLaunch != null && urlToLaunch.isNotEmpty) {
      debugPrint('Navigating to WebViewPage with: $urlToLaunch');
      // Biraz bekle ve sonra navigate et (GetX context hazır olması için)
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => WebViewPage(url: urlToLaunch!));
      });
    } else {
      debugPrint('No valid URL found. Navigating to Home');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => const MyHomePage());
      });
    }
  }

  // İlk frame render edildikten sonra initial message'ı handle et
  void _handleInitialMessageAfterBuild() {
    if (_initialMessage != null && !_initialMessageHandled) {
      _initialMessageHandled = true;
      print('');
      print('✅ HANDLING INITIAL MESSAGE NOW ✅');
      print('═══════════════════════════════════════════════════════════════');
      _handleMessage(_initialMessage);
    }
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

  @override
  Widget build(BuildContext context) {
    // İlk frame render edildikten sonra initial message'ı kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialMessageAfterBuild();
    });

    return GetMaterialApp(
      navigatorKey: navigatorKey,
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
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  int which_page = 1;

  final _pageController = PageController(initialPage: 0);
  late TabController _tabController;

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildNavigatorPage({
    required GlobalKey<NavigatorState> key,
    required Widget initialPage,
  }) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) {
        Widget page = initialPage;

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
      items: [
        const BottomNavigationBarItem(
          icon: Icon(IconlyLight.home),
          activeIcon: Icon(IconlyBold.home),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(IconlyLight.category),
          activeIcon: Icon(IconlyBold.category),
          label: "Category",
        ),
        BottomNavigationBarItem(
          icon: Consumer<ProvItem>(
            builder: (context, provItem, child) {
              if (provItem.items.isEmpty) {
                return child!;
              }
              return badges.Badge(
                badgeContent: Text(
                  provItem.items.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red, padding: EdgeInsets.all(5)),
                child: child!,
              );
            },
            child: const Icon(IconlyLight.buy),
          ),
          activeIcon: Consumer<ProvItem>(
            builder: (context, provItem, child) {
              if (provItem.items.isEmpty) {
                return child!;
              }
              return badges.Badge(
                badgeContent: Text(
                  provItem.items.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red, padding: EdgeInsets.all(5)),
                child: child!,
              );
            },
            child: const Icon(IconlyBold.buy),
          ),
          label: "Order",
        ),
        const BottomNavigationBarItem(
          icon: Icon(IconlyLight.heart),
          activeIcon: Icon(IconlyBold.heart),
          label: "Favorites",
        ),
        const BottomNavigationBarItem(
          icon: Icon(IconlyLight.profile),
          activeIcon: Icon(IconlyBold.profile),
          label: "Profile",
        ),
      ],
    );
  }

  void _onNavigationTap(BuildContext context, int index) {
    setState(() {
      selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );

    Provider.of<BottomProv>(context, listen: false).setPage(index);

    switch (index) {
      case 0:
        which_page = 1;
        break;
      case 1:
        which_page = 2;
        break;
      case 2:
        which_page = 3;
        break;
      case 3:
        which_page = 4;
        break;
      case 4:
        which_page = 5;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      onWillPop: () async {
        final currentNavigator = Provider.of<BottomProv>(context, listen: false).getCurrentNavigator();
        if (currentNavigator?.canPop() ?? false) {
          currentNavigator?.pop();
          return false;
        } else {
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    Constants.ruCykmak[Provider.of<Which_page>(context).dil],
                    style: const TextStyle(
                      fontFamily: gilroyMedium,
                      fontSize: 20,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        Constants.ruCykmakNo[Provider.of<Which_page>(context).dil],
                        style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: gilroyMedium),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                        exit(0);
                      },
                      child: Text(
                        Constants.ruCykmakYes[Provider.of<Which_page>(context).dil],
                        style: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: gilroyRegular),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;
        }
      },
      child: Scaffold(
        appBar: const PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox.shrink()),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              color: const Color(0xfff1fff9),
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff2cf420).withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: const Color(0xff2cf420), width: 2),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(0xff2cf420),
                unselectedLabelColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                controller: _tabController,
                labelStyle: const TextStyle(fontSize: 18, fontFamily: gilroyBold),
                unselectedLabelStyle: const TextStyle(fontSize: 18, fontFamily: gilroyMedium),
                onTap: (value) {
                  setState(() {
                    which_page = value;
                  });
                },
                tabs: [
                  Tab(text: Constants.tabBarName1[Provider.of<Which_page>(context).dil]),
                  Tab(text: Constants.tabBarName2[Provider.of<Which_page>(context).dil]),
                  Tab(text: Constants.tabBarName3[Provider.of<Which_page>(context).dil]),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: bottomBarPages,
                  ),
                  const Page2Content(),
                  const Page3Content(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _tabController.index == 0 ? _buildBottomNavigationBar(context) : const SizedBox.shrink(),
      ),
    );
  }
}

class Page2Content extends StatefulWidget {
  const Page2Content({super.key});

  @override
  State<Page2Content> createState() => _Page2ContentState();
}

class _Page2ContentState extends State<Page2Content> {
  String bodyText = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://bambukresto.com.tm:4443/api/v1/pages/2'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];

        int languageCode = Provider.of<Which_page>(context, listen: false).dil;
        String bodyKey = 'body_tm';
        print(languageCode);
        if (languageCode == 1) {
          bodyKey = 'body_ru';
        } else if (languageCode == 2) {
          bodyKey = 'body_en';
        }

        String bodyHtml = data[bodyKey] ?? data['body_tm'] ?? "No content available.";

        setState(() {
          bodyText = bodyHtml;
          isLoading = false;
        });
      } else {
        setState(() {
          bodyText = 'Failed to load data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        bodyText = 'Error: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: bodyText,
                style: {
                  "body": Style(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    fontFamily: 'GilroyMedium',
                    lineHeight: const LineHeight(2.0),
                    fontSize: FontSize.xLarge,
                  ),
                  "p": Style(
                    margin: Margins.all(1),
                    padding: HtmlPaddings.all(1),
                  ),
                  "span": Style(
                    fontFamily: 'GilroyMediumBam',
                    fontSize: FontSize.large,
                  ),
                },
              ),
            ),
          );
  }
}

class Page3Content extends StatefulWidget {
  const Page3Content({super.key});

  @override
  State<Page3Content> createState() => _Page3ContentState();
}

class _Page3ContentState extends State<Page3Content> {
  String bodyText = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://bambukresto.com.tm:4443/api/v1/pages/3'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];

        int languageCode = Provider.of<Which_page>(context, listen: false).dil;
        String bodyKey = 'body_tm';
        print(languageCode);
        if (languageCode == 1) {
          bodyKey = 'body_ru';
        } else if (languageCode == 2) {
          bodyKey = 'body_en';
        }

        String bodyHtml = data[bodyKey] ?? data['body_tm'] ?? "No content available.";

        setState(() {
          bodyText = bodyHtml;
          isLoading = false;
        });
      } else {
        setState(() {
          bodyText = 'Failed to load data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        bodyText = 'Error: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: bodyText,
                style: {
                  "body": Style(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    fontFamily: 'GilroyMedium',
                    lineHeight: const LineHeight(2.0),
                    fontSize: FontSize.xLarge,
                  ),
                  "p": Style(
                    margin: Margins.all(1),
                    padding: HtmlPaddings.all(1),
                  ),
                  "span": Style(
                    fontFamily: 'GilroyMediumBam',
                    fontSize: FontSize.large,
                  ),
                },
              ),
            ),
          );
  }
}
