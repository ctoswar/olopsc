import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/aboutuscontent.dart';
import 'package:flutter_application_1/contactcontent.dart';
import 'package:flutter_application_1/homecontent.dart';
import 'package:flutter_application_1/newscontent.dart';
import 'package:flutter_application_1/researchhubapp.dart';
import 'package:flutter_application_1/researchhublogin.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DeVeritateApp());
}

class DeVeritateApp extends StatelessWidget {
  const DeVeritateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De Veritate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ResponsiveLayout(
        mobileLayout: MobileHomePage(),
        webLayout: WebHomePage(),
      ),
      routes: {
        '/login': (context) => const ResearchHubLoginPage(),
        '/researchhub': (context) => ResearchHubApp(),
        
      },
    );
  }
}

// Responsive layout wrapper
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget webLayout;
  
  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.webLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 900 as breakpoint for web vs mobile layout
        if (constraints.maxWidth > 900) {
          return webLayout;
        }
        return mobileLayout;
      },
    );
  }
}

// Base HomePage state that will be shared between mobile and web layouts
abstract class BaseHomePageState<T extends StatefulWidget> extends State<T> 
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  
  // Use const for static content
  static const List<String> titles = ['Home', 'About Us', 'News', 'Contact'];
  static const List<IconData> icons = [Icons.home, Icons.info, Icons.article, Icons.contact_mail];
  
  late TabController _tabController;
  late List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    // Lazy initialize content
    _pages = [
      const HomeContent(),
      const AboutUsContent(),
      const NewsContent(),
      const ContactContent(),
    ];
    
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  
  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.index != _selectedIndex) {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // Getters for child classes
  int get selectedIndex => _selectedIndex;
  TabController get tabController => _tabController;
  List<Widget> get pages => _pages;
  
  // Common tab styling methods
 Widget buildTab(int index, {bool isCompact = false}) {
  final isSelected = _selectedIndex == index;
  
  return Tab(
    height: 40,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 8.0 : 12.0), // Reduced from 16.0 to 12.0
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuart,
            transform: Matrix4.identity()
              ..scale(isSelected ? 1.0 : 0.85),
            transformAlignment: Alignment.center,
            child: AnimatedRotation(
              turns: isSelected ? 0.05 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                child: Icon(
                  icons[index],
                  size: isSelected ? 20 : 18, // Reduced sizes a bit
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
          
          if (!isCompact) SizedBox(width: isCompact ? 4 : 6), // Reduced width
          
          // Animated text - hide text in compact mode
          if (!isCompact)
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13, // Reduced from 14 to 13
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                letterSpacing: isSelected ? 0.6 : 0.4, // Reduced letter spacing
              ),
              child: Text(titles[index]),
            ),
        ],
      ),
    ),
  );
}


  
  // Logo widget shared between layouts
  Widget buildLogo({double height = 42}) {
    return Image.asset(
      'assets/images/olops.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
  
  // Research hub button shared between layouts
 Widget buildResearchHubButton({bool isCompact = false}) {
  return TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0, end: 1),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: child,
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Material(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 8 : 12, 
              vertical: isCompact ? 6 : 8
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.science, size: 18, color: Colors.white),  // Added explicit color
                SizedBox(width: isCompact ? 4 : 6),
                if (!isCompact)
                  const Text(
                    'Research Hub',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,  // Added explicit color
                    ),
                  )
                else
                  const Text(
                    'Hub',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white,  // Added explicit color
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  // Gradient background builder
  Widget buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade800,
            Colors.indigo.shade900.withBlue(150),
          ],
        ),
      ),
    );
  }
}

// Mobile-specific layout
class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  _MobileHomePageState createState() => _MobileHomePageState();
}

class _MobileHomePageState extends BaseHomePageState<MobileHomePage> {
  
  Widget _buildMobileTabBar() {
  return Container(
    height: 56,
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.12),
    ),
    child: TabBar(
      controller: tabController,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      splashBorderRadius: BorderRadius.circular(12),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return states.contains(MaterialState.focused)
              ? null
              : Colors.transparent;
        },
      ),
      dividerColor: Colors.transparent,
      isScrollable: true, // Add this to make the tab bar scrollable
      padding: EdgeInsets.zero, // Reduce padding
      tabs: List.generate(BaseHomePageState.titles.length, (index) {
        // Use compact tabs on small screens
        return buildTab(index, isCompact: MediaQuery.of(context).size.width < 360);
      }),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: buildGradientBackground(),
                titlePadding: EdgeInsets.only(left: 16.0, bottom: isSmallScreen ? 72.0 : 76.0),
                title: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: innerBoxIsScrolled ? 0.0 : 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: buildLogo(height: isSmallScreen ? 36 : 42),
                ),
                centerTitle: false,
              ),
              title: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: innerBoxIsScrolled ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLogo(height: 32),
                    const SizedBox(width: 8),
                    if (!isSmallScreen)
                      const Text(
                        'De Veritate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
              centerTitle: false,
              actions: [
               buildResearchHubButton(isCompact: true),
               const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: _buildMobileTabBar(),
              ),
              elevation: 0,
              stretch: true,
              expandedHeight: 120,
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: pages,
        ),
      ),
    );
  }
}

// Web-specific layout
class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends BaseHomePageState<WebHomePage> {
  
  Widget _buildWebTabBar() {
  final screenWidth = MediaQuery.of(context).size.width;
  final isNarrowWeb = screenWidth < 1100;
  
  return Container(
    height: 64,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.12),
    ),
    child: TabBar(
      controller: tabController,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      splashBorderRadius: BorderRadius.circular(16),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return states.contains(MaterialState.focused)
              ? null
              : Colors.transparent;
        },
      ),
      dividerColor: Colors.transparent,
      isScrollable: isNarrowWeb, // Make tabs scrollable on narrow web views
      padding: EdgeInsets.zero, // Reduce padding
      tabs: List.generate(BaseHomePageState.titles.length, (index) {
        return buildTab(index, isCompact: isNarrowWeb);
      }),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: buildGradientBackground(),
                titlePadding: const EdgeInsets.only(left: 40.0, bottom: 80.0),
                title: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: innerBoxIsScrolled ? 0.0 : 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildLogo(height: 48),
                      const SizedBox(width: 16),
                      const Text(
                        'De Veritate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: false,
              ),
              title: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: innerBoxIsScrolled ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLogo(height: 38),
                    const SizedBox(width: 12),
                    const Text(
                      'De Veritate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              actions: [
                // Research Hub Button with animation
               buildResearchHubButton(isCompact: screenWidth < 1100),
                SizedBox(width: screenWidth * 0.02), 
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: _buildWebTabBar(),
              ),
              elevation: 0,
              stretch: true,
              expandedHeight: 160,
            ),
          ];
        },
        body: Padding(
          // Add some padding on very wide screens for better readability
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 1400 ? (screenWidth - 1400) / 2 : 0
          ),
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: pages,
          ),
        ),
      ),
    );
  }
}