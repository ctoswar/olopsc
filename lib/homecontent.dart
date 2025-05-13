import 'package:flutter/material.dart';
import 'package:flutter_application_1/bullentpoint.dart';
import 'package:flutter_application_1/contentsection.dart';
import 'package:flutter_application_1/researchhublogin.dart';
import 'package:flutter_application_1/sectionheader.dart' as sh;
import 'package:flutter_application_1/teammember.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Banner with parallax effect
          const ParallaxHeroBanner(),
          
          // Description Section
          ContentSection(
            backgroundColor: Colors.white,
            child: _buildWelcomeSection(context),
          ),
          
          // Mission & Vision Section with cards
          ContentSection(
            backgroundColor: Colors.grey.shade50,
            child: _buildPurposeSection(context),
          ),
          
          // Spotlight Section with hover effect
          SpotlightSection(context: context),
          
          // Awards Section with animated cards
          AwardsSection(context: context),

          // Research Hub Section with animated buttons
          ResearchHubSection(context: context),
          
          // Team Section with profile cards
          TeamSection(context: context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    // Get screen width for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth < 600 ? 28 : 34;
    double paragraphSize = screenWidth < 600 ? 14 : 16;
    double paddingHorizontal = screenWidth < 600 ? 16 : 40;

    return FadeInAnimation(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        child: Column(
          children: [
            Text(
              'Welcome to De Veritate',
              style: GoogleFonts.playfairDisplay(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to De Veritate, where truth and discovery converge. Inspired by the timeless principles of Thomas Aquinas, our innovative digital platform is dedicated to advancing research and fostering academic excellence at the OLOPSC Senior High School department.',
              style: GoogleFonts.raleway(fontSize: paragraphSize, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'Explore our website to learn more about our OLOPSC\'s research program, institutional goals, and partnerships. Discover the achievements and successes of our institution\'s students and staff, and stay updated on the latest announcements and research opportunities provided by the institution\'s research organization, Socorro.',
              style: GoogleFonts.raleway(fontSize: paragraphSize, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Join us on this journey of discovery and excellence.',
              style: GoogleFonts.raleway(fontSize: paragraphSize + 2, height: 1.5, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeSection(BuildContext context) {
    // Get screen width for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 800;

    return Column(
      children: [
        FadeInAnimation(
          child: Column(
            children: [
              Text(
                'Our Purpose',
                style: GoogleFonts.playfairDisplay(
                  fontSize: isSmallScreen ? 30 : 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
              const SizedBox(height: 10),
              const ScaleAnimation(
                child: SizedBox(
                  width: 80,
                  height: 3,
                  child: ColoredBox(color: Colors.amber),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        isSmallScreen
            ? Column(
                children: [
                  const SlideAnimation(
                    direction: SlideDirection.fromLeft,
                    child: MissionCard(),
                  ),
                  const SizedBox(height: 30),
                  const SlideAnimation(
                    direction: SlideDirection.fromRight,
                    child: VisionCard(),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: SlideAnimation(
                      direction: SlideDirection.fromLeft,
                      child: MissionCard(),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: SlideAnimation(
                      direction: SlideDirection.fromRight,
                      child: VisionCard(),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom
}

// Animation classes remain mostly the same
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  _FadeInAnimationState createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (!_isDisposed) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (!_isDisposed) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class SlideAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;

  const SlideAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.fromBottom,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    Offset beginOffset;
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        beginOffset = const Offset(-0.25, 0);
        break;
      case SlideDirection.fromRight:
        beginOffset = const Offset(0.25, 0);
        break;
      case SlideDirection.fromTop:
        beginOffset = const Offset(0, -0.25);
        break;
      case SlideDirection.fromBottom:
      beginOffset = const Offset(0, 0.25);
        break;
    }

    _animation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (!_isDisposed) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animation,
        child: widget.child,
      ),
    );
  }
}

// Parallax Hero Banner - Modified to be responsive
class ParallaxHeroBanner extends StatefulWidget {
  const ParallaxHeroBanner({super.key});

  @override
  _ParallaxHeroBannerState createState() => _ParallaxHeroBannerState();
}

class _ParallaxHeroBannerState extends State<ParallaxHeroBanner> {
  double offset = 0;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_updateOffset);
  }

  void _updateOffset() {
    if (mounted) {
      setState(() {
        offset = controller.offset * 0.2; // Reduced parallax effect factor
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updateOffset);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double bannerHeight = screenWidth < 600 ? 350.0 : 500.0;
    double titleSize = screenWidth < 600 ? 40.0 : 60.0;
    double subtitleSize = screenWidth < 600 ? 16.0 : 22.0;
    
    return SizedBox(
      height: bannerHeight,
      child: Stack(
        children: [
          // Background image with parallax effect
          Positioned(
            top: -offset,
            left: 0,
            right: 0,
            height: bannerHeight + 100,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/research_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo.withOpacity(0.7),
                  Colors.indigo.shade900.withOpacity(0.85),
                ],
              ),
            ),
          ),
          // Content
          Center(
            child: _buildHeroBannerContent(titleSize, subtitleSize),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBannerContent(double titleSize, double subtitleSize) {
    return FadeInAnimation(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'De Veritate',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const ScaleAnimation(
              delay: Duration(milliseconds: 300),
              child: SizedBox(
                width: 100,
                height: 2,
                child: ColoredBox(color: Colors.amber),
              ),
            ),
            const SizedBox(height: 20),
            FadeInAnimation(
              delay: const Duration(milliseconds: 600),
              child: Text(
                'Where potential unlocks truth and research shapes the future.',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: subtitleSize,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildDiscoverButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverButton() {
    return ScaleAnimation(
      delay: const Duration(milliseconds: 900),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResearchHubLoginPage()), 
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              'DISCOVER MORE',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Mission/Vision cards remain the same

// Spotlight section becomes responsive
class SpotlightSection extends StatelessWidget {
  final BuildContext context;
  
  const SpotlightSection({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    
    return ContentSection(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          sh.SectionHeader(
            title: 'Research Spotlight',
            subtitle: 'Highlighting exceptional research projects from our community',
            textColor: Colors.indigo.shade800,
            dividerColor: Colors.amber,
          ),
          const SizedBox(height: 40),
          
          // Responsive layout for the spotlight cards
          screenWidth > 1100 ? _buildDesktopLayout() : 
          screenWidth > 700 ? _buildTabletLayout() : _buildMobileLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: SlideAnimation(
            direction: SlideDirection.fromLeft,
            child: SpotlightCard(
              imagePath: 'assets/images/research_spotlight1.JPG',
              title: 'Sustainable Urban Development',
              author: 'Maria Garcia, Grade 12',
              snippet: 'An innovative approach to integrating green spaces within urban planning to create more sustainable and livable cities.',
            ),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: SlideAnimation(
            direction: SlideDirection.fromBottom,
            delay: Duration(milliseconds: 200),
            child: SpotlightCard(
              imagePath: 'assets/images/research_spotlight2.JPG',
              title: 'Quantum Computing Applications',
              author: 'John Santos, Grade 11',
              snippet: 'Exploring the potential of quantum computing in solving complex mathematical problems and its implications for future technology.',
            ),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: SlideAnimation(
            direction: SlideDirection.fromRight,
            child: SpotlightCard(
              imagePath: 'assets/images/research_spotlight3.JPG',
              title: 'Biodiversity Conservation',
              author: 'Anna Reyes, Grade 12',
              snippet: 'A comprehensive study on preserving local ecosystem biodiversity through community-based conservation strategies.',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: SlideAnimation(
                direction: SlideDirection.fromLeft,
                child: SpotlightCard(
                  imagePath: 'assets/images/research_spotlight1.JPG',
                  title: 'Sustainable Urban Development',
                  author: 'Maria Garcia, Grade 12',
                  snippet: 'An innovative approach to integrating green spaces within urban planning to create more sustainable and livable cities.',
                ),
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: SlideAnimation(
                direction: SlideDirection.fromRight,
                child: SpotlightCard(
                  imagePath: 'assets/images/research_spotlight2.JPG',
                  title: 'Quantum Computing Applications',
                  author: 'John Santos, Grade 11',
                  snippet: 'Exploring the potential of quantum computing in solving complex mathematical problems and its implications for future technology.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const SlideAnimation(
          direction: SlideDirection.fromBottom,
          child: SpotlightCard(
            imagePath: 'assets/images/research_spotlight3.JPG',
            title: 'Biodiversity Conservation',
            author: 'Anna Reyes, Grade 12',
            snippet: 'A comprehensive study on preserving local ecosystem biodiversity through community-based conservation strategies.',
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: const [
        SlideAnimation(
          direction: SlideDirection.fromLeft,
          child: SpotlightCard(
            imagePath: 'assets/images/research_spotlight1.JPG',
            title: 'Sustainable Urban Development',
            author: 'Maria Garcia, Grade 12',
            snippet: 'An innovative approach to integrating green spaces within urban planning to create more sustainable and livable cities.',
          ),
        ),
        SizedBox(height: 30),
        SlideAnimation(
          direction: SlideDirection.fromBottom,
          child: SpotlightCard(
            imagePath: 'assets/images/research_spotlight2.JPG',
            title: 'Quantum Computing Applications',
            author: 'John Santos, Grade 11',
            snippet: 'Exploring the potential of quantum computing in solving complex mathematical problems and its implications for future technology.',
          ),
        ),
        SizedBox(height: 30),
        SlideAnimation(
          direction: SlideDirection.fromRight,
          child: SpotlightCard(
            imagePath: 'assets/images/research_spotlight3.JPG',
            title: 'Biodiversity Conservation',
            author: 'Anna Reyes, Grade 12',
            snippet: 'A comprehensive study on preserving local ecosystem biodiversity through community-based conservation strategies.',
          ),
        ),
      ],
    );
  }
}

// SpotlightCard can remain the same as it already handles hover states well

// AwardsSection becomes responsive
class AwardsSection extends StatelessWidget {
  final BuildContext context;
  
  const AwardsSection({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 30.0 : 38.0;
    
    return ContentSection(
      backgroundColor: Colors.indigo.shade900,
      child: Column(
        children: [
          FadeInAnimation(
            child: Text(
              'Excellence Recognized',
              style: GoogleFonts.playfairDisplay(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const ScaleAnimation(
            child: SizedBox(
              width: 80,
              height: 3,
              child: ColoredBox(color: Colors.amber),
            ),
          ),
          const SizedBox(height: 20),
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Our students and faculty have been recognized for their outstanding contributions to research and academia.',
                style: GoogleFonts.raleway(
                  fontSize: screenWidth < 600 ? 14 : 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Award Cards with responsive layout
          _buildAwardCards(context),
        ],
      ),
    );
  }

  Widget _buildAwardCards(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth > 900) {
      // Desktop layout: three cards in a row
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildAwardCardsList(),
      );
    } else if (screenWidth > 600) {
      // Tablet layout: two cards in first row, one in second
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SlideAnimation(
                  direction: SlideDirection.fromLeft,
                  child: AwardCard(
                    icon: Icons.school,
                    title: 'Academic Excellence',
                    description: '25+ National Research Awards',
                  ),
                ),
              ),
              const SizedBox(width: 30),
              const Expanded(
                child: SlideAnimation(
                  direction: SlideDirection.fromRight,
                  child: AwardCard(
                    icon: Icons.public,
                    title: 'Global Recognition',
                    description: '15 International Publications',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 250, // Fixed width for the single card
            child: SlideAnimation(
              direction: SlideDirection.fromBottom,
              child: AwardCard(
                icon: Icons.groups,
                title: 'Community Impact',
                description: '40+ Community Research Projects',
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile layout: cards in column
      return Column(
        children: [
          const SlideAnimation(
            direction: SlideDirection.fromLeft,
            child: AwardCard(
              icon: Icons.school,
              title: 'Academic Excellence',
              description: '25+ National Research Awards',
            ),
          ),
          const SizedBox(height: 30),
          const SlideAnimation(
            direction: SlideDirection.fromBottom,
            child: AwardCard(
              icon: Icons.public,
              title: 'Global Recognition',
              description: '15 International Publications',
            ),
          ),
          const SizedBox(height: 30),
          const SlideAnimation(
            direction: SlideDirection.fromRight,
            child: AwardCard(
              icon: Icons.groups,
              title: 'Community Impact',
              description: '40+ Community Research Projects',
            ),
          ),
        ],
      );
    }
  }

  List<Widget> _buildAwardCardsList() {
    return [
      const SlideAnimation(
        direction: SlideDirection.fromLeft,
        child: AwardCard(
          icon: Icons.school,
          title: 'Academic Excellence',
          description: '25+ National Research Awards',
        ),
      ),
      const SizedBox(width: 30),
      const SlideAnimation(
        direction: SlideDirection.fromBottom,
        delay: Duration(milliseconds: 200),
        child: AwardCard(
          icon: Icons.public,
          title: 'Global Recognition',
          description: '15 International Publications',
        ),
      ),
      const SizedBox(width: 30),
      const SlideAnimation(
        direction: SlideDirection.fromRight,
        child: AwardCard(
          icon: Icons.groups,
          title: 'Community Impact',
          description: '40+ Community Research Projects',
        ),
      ),
    ];
  }
}

// ResearchHubSection becomes responsive
class ResearchHubSection extends StatelessWidget {
  final BuildContext context;
  
  const ResearchHubSection({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return ContentSection(
      backgroundColor: Colors.grey.shade50,
      child: Column(
        children: [
          sh.SectionHeader(
            title: 'Research Hub',
            subtitle: 'Access resources and tools to support your research journey',
            textColor: Colors.indigo.shade800,
            dividerColor: Colors.amber,
          ),
          const SizedBox(height: 40),
          _buildResearchHubGrid(context),
        ],
      ),
    );
  }

  Widget _buildResearchHubGrid(BuildContext context) {
    // Get screen width for responsive grid layout
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth > 1100) {
      // Desktop: 3 columns
      return _buildGrid(context, 3);
    } else if (screenWidth > 700) {
      // Tablet: 2 columns
      return _buildGrid(context, 2);
    } else {
      // Mobile: 1 column
      return _buildGrid(context, 1);
    }
  }
  
  Widget _buildGrid(BuildContext context, int crossAxisCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: _calculateChildAspectRatio(crossAxisCount),
        children: _buildHubCards(context),
      ),
    );
  }
  
  double _calculateChildAspectRatio(int crossAxisCount) {
    // Adjust card aspect ratio based on grid layout for better appearance
    switch (crossAxisCount) {
      case 1:
        return 1.5;  // More horizontal for single column
      case 2:
        return 1.2;  // Balanced for 2 columns
      case 3:
        return 1.0;  // More square for 3 columns
      default:
        return 1.0;
    }
  }

  List<Widget> _buildHubCards(BuildContext context) {
    return [
      SlideAnimation(
        direction: SlideDirection.fromLeft,
        child: ResearchHubCard(
          icon: Icons.book,
          title: 'Research Guides',
          description: 'Step-by-step guides for research methodologies and best practices',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
      SlideAnimation(
        direction: SlideDirection.fromBottom,
        child: ResearchHubCard(
          icon: Icons.library_books,
          title: 'Digital Library',
          description: 'Access to academic journals, books, and publications',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
      SlideAnimation(
        direction: SlideDirection.fromRight,
        child: ResearchHubCard(
          icon: Icons.video_library,
          title: 'Webinars & Workshops',
          description: 'Video tutorials and recorded sessions on research topics',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
      SlideAnimation(
        direction: SlideDirection.fromLeft,
        child: ResearchHubCard(
          icon: Icons.people,
          title: 'Mentorship',
          description: 'Connect with experienced mentors for guidance and support',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
      SlideAnimation(
        direction: SlideDirection.fromBottom,
        child: ResearchHubCard(
          icon: Icons.format_quote,
          title: 'Citation Tools',
          description: 'Resources for proper citation and reference management',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
      SlideAnimation(
        direction: SlideDirection.fromRight,
        child: ResearchHubCard(
          icon: Icons.calendar_today,
          title: 'Events Calendar',
          description: 'Upcoming research conferences, seminars, and deadlines',
          onExplore: () => _navigateToLogin(context),
        ),
      ),
    ];
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResearchHubLoginPage()),
    );
  }
}

// ResearchHubCard widget
class ResearchHubCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onExplore;

  const ResearchHubCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onExplore,
  });

  @override
  _ResearchHubCardState createState() => _ResearchHubCardState();
}

class _ResearchHubCardState extends State<ResearchHubCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isHovered 
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
              blurRadius: isHovered ? 15 : 10,
              offset: isHovered ? const Offset(0, 8) : const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isHovered ? Colors.indigo.shade300 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onExplore,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 48,
                    color: Colors.indigo.shade700,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  _buildExploreButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: isHovered
          ? Matrix4.translationValues(0, -5, 0)
          : Matrix4.translationValues(0, 0, 0),
      child: ElevatedButton(
        onPressed: widget.onExplore,
        style: ElevatedButton.styleFrom(
          backgroundColor: isHovered ? Colors.amber : Colors.indigo.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'EXPLORE',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// Mission Card
class MissionCard extends StatelessWidget {
  const MissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 28,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 12),
                Text(
                  'Our Mission',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'To foster a community of innovative thinkers dedicated to the pursuit of knowledge and truth through rigorous research methods and critical thinking.',
              style: GoogleFonts.raleway(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BulletPoint(
                  text: 'Promote academic excellence through quality research',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Develop critical thinking and analytical skills',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Cultivate ethical research practices and integrity',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Encourage interdisciplinary collaboration',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Vision Card
class VisionCard extends StatelessWidget {
  const VisionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 28,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 12),
                Text(
                  'Our Vision',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'To be a leading center of research excellence that inspires the next generation of scholars and contributes meaningful knowledge to society.',
              style: GoogleFonts.raleway(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BulletPoint(
                  text: 'Establish a recognized platform for student research',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Bridge academic research with real-world applications',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Create global connections and partnerships',
                ),
                SizedBox(height: 10),
                BulletPoint(
                  text: 'Foster innovation and discovery through research',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Award Card
class AwardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const AwardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  _AwardCardState createState() => _AwardCardState();
}

class _AwardCardState extends State<AwardCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? Colors.amber.withOpacity(0.5)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isHovered ? Colors.amber : Colors.indigo.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 30,
                  color: isHovered ? Colors.white : Colors.indigo.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.description,
                style: GoogleFonts.raleway(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SpotlightCard remains the same
class SpotlightCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String author;
  final String snippet;

  const SpotlightCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.snippet,
  });

  @override
  _SpotlightCardState createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using LayoutBuilder to get constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust card height based on available width
        double cardHeight = constraints.maxWidth * 0.8;
        // Maximum height cap
        cardHeight = cardHeight.clamp(260.0, 400.0);
        
        return MouseRegion(
          onEnter: (_) {
            setState(() => isHovered = true);
            _controller.forward();
          },
          onExit: (_) {
            setState(() => isHovered = false);
            _controller.reverse();
          },
          child: Container(
            height: cardHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isHovered ? 15 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image with zoom effect
                AnimatedScale(
                  scale: isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(isHovered ? 0.8 : 0.6),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.author,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Animated snippet that appears on hover
                      ClipRect(
                        child: SizedOverflowBox(
                          size: Size(constraints.maxWidth, isHovered ? 80.0 : 0.0),
                          alignment: Alignment.topLeft,
                          child: FadeTransition(
                            opacity: _animation,
                            child: SizedBox(
                              height: 80,
                              child: Text(
                                widget.snippet,
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

// Team Section with responsive layout
class TeamSection extends StatelessWidget {
  final BuildContext context;
  
  const TeamSection({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return ContentSection(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          sh.SectionHeader(
            title: 'Our Team',
            subtitle: 'Meet the dedicated team behind De Veritate',
            textColor: Colors.indigo.shade800,
            dividerColor: Colors.amber,
          ),
          const SizedBox(height: 40),
          _buildTeamGrid(context),
        ],
      ),
    );
  }

  Widget _buildTeamGrid(BuildContext context) {
    // Get screen width for responsive grid layout
    double screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth > 1100) {
      // Desktop: 4 columns
      return _buildMemberGrid(context, 4);
    } else if (screenWidth > 700) {
      // Tablet: 3 columns
      return _buildMemberGrid(context, 3);
    } else if (screenWidth > 450) {
      // Large mobile: 2 columns
      return _buildMemberGrid(context, 2);
    } else {
      // Small mobile: 1 column
      return _buildMemberGrid(context, 1);
    }
  }
  
  Widget _buildMemberGrid(BuildContext context, int crossAxisCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 30,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,  // Taller cards for team members
        children: _buildTeamMembers(),
      ),
    );
  }

  List<Widget> _buildTeamMembers() {
    return [
      const TeamMember(
        name: 'Portia Elize S. Oñate',
        position: 'Leader & Website Manager/Coordinator',
        imageUrl: 'assets/images/portia.jpg',
        role: 'Team Leader',
        photoUrl: 'assets/images/portia.jpg',
        description: 'Portia leads our team with intelligence and skill, coordinating website management and design while engaging audiences effectively.',
      ),
      const TeamMember(
        name: 'Sydney Wallace M. Ang',
        position: 'Assistant Leader & Content Curator',
        imageUrl: 'assets/images/sydney.jpg',
        role: 'Assistant Leader',
        photoUrl: 'assets/images/sydney.jpg',
        description: 'Sydney is the reliable right hand to our leader, curating content and managing research projects with sharp intuition and care.',
      ),
      const TeamMember(
        name: 'Duncan John D. Carpiso',
        position: 'Web Developer & Specialist',
        imageUrl: 'assets/images/duncan.jpg',
        role: 'Web Development',
        photoUrl: 'assets/images/duncan.jpg',
        description: 'A computer science graduate with expertise in data security and experience as an IT professor, Duncan specializes in web development and ensures our site\'s security and functionality.',
      ),
      const TeamMember(
        name: 'Ernest Iann S. Domingo',
        position: 'Assistant Web Analyst & Back-End Developer',
        imageUrl: 'assets/images/ernest.jpg',
        role: 'Back-End Development',
        photoUrl: 'assets/images/ernest.jpg',
        description: 'Iann supports website analysis and back-end development, applying his coding knowledge and quick problem-solving skills to maintain site performance.',
      ),
      const TeamMember(
        name: 'Marc Noe S. Fulgencio',
        position: 'Research Team Member',
        imageUrl: 'assets/images/marc.jpg',
        role: 'Research',
        photoUrl: 'assets/images/marc.jpg',
        description: 'Marc diligently researches our project needs, ensuring our findings are insightful and accurate.',
      ),
      const TeamMember(
        name: 'Elijah Jefferson M. Pascual',
        position: 'Content Analyst',
        imageUrl: 'assets/images/elijah.jpg',
        role: 'Content Analysis',
        photoUrl: 'assets/images/elijah.jpg',
        description: 'Elijah handles and analyzes content with precision, enhancing the quality and impact of our research.',
      ),
      const TeamMember(
        name: 'Xrijlov Ehricka P. Millare',
        position: 'Front-End Designer',
        imageUrl: 'assets/images/xrijlov.jpg',
        role: 'Front-End Design',
        photoUrl: 'assets/images/xrijlov.jpg',
        description: 'Ehricka focuses on crafting and editing our website\'s front-end design, creating a visually appealing and user-friendly experience.',
      ),
      const TeamMember(
        name: 'Anya Janina G. Lucinario',
        position: 'Website Development Specialist',
        imageUrl: 'assets/images/anya.jpg',
        role: 'Website Development',
        photoUrl: 'assets/images/anya.jpg',
        description: 'Anya reviews and reports feedback to identify bugs and streamline features, contributing to continuous website improvement.',
      ),
      const TeamMember(
        name: 'Lynniel B. Evangelista',
        position: 'Social Media Manager & Team Coordinator',
        imageUrl: 'assets/images/lynniel.jpg',
        role: 'Social Media',
        photoUrl: 'assets/images/lynniel.jpg',
        description: 'Lynniel coordinates team efforts and refines our social media strategy by connecting us with the right talent.',
      ),
      const TeamMember(
        name: 'Faith Daryll B. Estoque',
        position: 'Research Analyst',
        imageUrl: 'assets/images/faith.jpg',
        role: 'Research Analysis',
        photoUrl: 'assets/images/faith.jpg',
        description: 'Faith conducts detailed content analysis and offers valuable feedback, helping to elevate the effectiveness of our research.',
      ),
    ];
  }
}
