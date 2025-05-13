import 'package:flutter/material.dart';
import 'package:flutter_application_1/awardcard.dart';
import 'package:flutter_application_1/contentsection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildContentSection(
            Colors.white,
            _buildAnimatedText(
              'Discover the driving force behind De Veritate. Learn how Socorro, the research arm of Our Lady of Perpetual Succor College''s (OLOPSC), fuels our mission to advance knowledge and innovation. Explore our partnerships, PAASCU-accredited research practices, and the values that shape our pursuit of academic excellence.''',
            ),
          ),
          _buildGlassmorphicSection(
            'Why is the website named "De Veritate?"',
            'The website applies principles from St. Thomas Aquinas to understand truth better through a foundation which connects language and knowledge to faith and reason. Moreover, the platform enables the discovery of truth by analyzing fundamental aspects of truth detection, natural and moral law, and using facts to uncover real ethical knowledge that advances human life. Through analysis and empirical research, we cultivate intellectual virtues, critical thinking, and moral communication skills, aligning with Aquinas''s vision for a more enlightened society.''',
            Icons.lightbulb_outline,
          ),
          _buildContentSection(
            Colors.white,
            _buildSectionWithSlideIn(
              'What is Socorro?',
              "Socorro is a self-sustaining research organization that supports the research needs of Our Lady of Perpetual Succor College's faculty, students, and the public. It fosters a culture of research excellence and innovation, providing resources and expertise to advance knowledge and address real-world challenges. Through its initiatives, Socorro aims to promote collaboration, knowledge sharing, and community engagement, ultimately contributing to the betterment of society.",
              Icons.school,
            ),
          ),
          _buildParallaxSection(context),
          _buildContentSection(
            Colors.white,
            _buildAwardsCarousel(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
  return SizedBox(
    height: 380,
    child: Stack(
      children: [
        // Animated gradient background
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.shade800,
                  Colors.indigo.shade600,
                  Colors.blue.shade700,
                ],
              ),
            ),
          ),
        ),
        // Parallax image effect
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/research_banner.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Animated particles overlay (simulated with container)
        Positioned.fill(
          child: CustomPaint(
            painter: ParticlesPainter(),
          ),
        ),
        // Title with reveal animation
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ABOUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 8,
                ),
              ).animate()
                .fadeIn(duration: 800.ms, delay: 300.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
              const SizedBox(height: 10),
              const Text(
                'DE VERITATE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ).animate()
                .fadeIn(duration: 800.ms, delay: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 3,
                color: Colors.white.withOpacity(0.7),
              ).animate()
                .fadeIn(duration: 800.ms, delay: 900.ms)
                .scaleX(begin: 0, end: 1, curve: Curves.easeOutQuad),
            ],
          ),
        ),
        // Scroll indicator
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 36,
            ).animate(
              onPlay: (controller) => controller.repeat(),
            )
              .fadeIn(duration: 500.ms)
              .then()
              .moveY(begin: 0, end: 10, duration: 1000.ms)
              .then()
              .moveY(begin: 10, end: 0, duration: 1000.ms),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildContentSection(Color color, Widget child) {
    return ContentSection(
      backgroundColor: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: child,
      ),
    );
  }

  Widget _buildAnimatedText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, height: 1.8, color: Colors.grey.shade800),
      textAlign: TextAlign.center,
    ).animate()
      .fadeIn(duration: 800.ms, delay: 200.ms)
      .moveY(begin: 20, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildGlassmorphicSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.indigo,
                  size: 28,
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 400.ms),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .moveX(begin: 20, end: 0),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(fontSize: 16, height: 1.7, color: Colors.grey.shade700),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .moveY(begin: 20, end: 0),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .moveY(begin: 50, end: 0);
  }

  Widget _buildSectionWithSlideIn(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.indigo,
            ).animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.5, end: 0),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
            ).animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: -0.3, end: 0),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          width: 80,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blue],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 400.ms)
          .slideX(begin: -0.5, end: 0)
          .scaleX(begin: 0.3, end: 1),
        const SizedBox(height: 20),
        Text(
          content,
          style: TextStyle(fontSize: 16, height: 1.7, color: Colors.grey.shade700),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .moveY(begin: 30, end: 0),
      ],
    );
  }

  static const List<String> missionItems = [
  'Present insightful research articles addressing real-world problems',
  'Enhance research capacity building for students and teachers',
  'Boost research productivity and innovation',
  'Foster interdisciplinary collaboration and expertise',
  'Drive progress and improvement for the community',
];

Widget _buildParallaxSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.indigo.shade900, Colors.indigo.shade700],
      ),
      image: DecorationImage(
        image: const AssetImage('assets/about_banner.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.indigo.withOpacity(0.85),
          BlendMode.multiply,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OUR MISSION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        const Text(
          'Research Excellence & Innovation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 200.ms)
          .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 30),
        ...List.generate(missionItems.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    missionItems[index],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms + (index * 200).ms)
            .slideX(begin: 0.2, end: 0);
        }),
      ],
    ),
  );
}

  Widget _buildAwardsCarousel() {
    const List<Map<String, String>> awards = [
      {
        'title': 'BEST RESEARCH PAPER AWARD (GRADE 12)',
        'description': 'The Best Research Paper Award is an honor given to outstanding research papers submitted by grade 12 students of Our Lady of Perpetual Succor College.'
      },
      {
        'title': 'BEST IN WORK IMMERSION (GRADE 12)',
        'description': 'The award is given to outstanding research papers submitted by grade 12 STEM students.'
      },
      {
        'title': 'PUBLICATION AWARD FOR INTERNATIONAL/NATIONAL PEER-REVIEWED NON-ISI JOURNAL',
        'description': 'The Publication Award recognizes faculty members for publishing original research.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RECOGNITION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Colors.indigo,
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          'Awards & Achievements',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 200.ms)
          .slideX(begin: -0.2, end: 0),
        const SizedBox(height: 30),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: awards.length,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 20),
                child: AwardCard(
                  title: awards[index]['title']!,
                  description: awards[index]['description']!,
                ),
              ).animate()
                .fadeIn(duration: 800.ms, delay: 300.ms + (index * 200).ms)
                .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }

Widget _buildFooter() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
    color: Colors.indigo.shade900,
    child: Column(
      children: [
        const Text(
          'DE VERITATE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ).animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 12),
        Text(
          'Research Excellence & Innovation',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 200.ms)
          .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterIcon(Icons.mail_outline, 'mailto:info@olopsc.edu.ph'),
            const SizedBox(width: 20),
            _buildFooterIcon(Icons.facebook, 'https://www.facebook.com/olopsc.official/'),
            const SizedBox(width: 20),
            _buildFooterIcon(Icons.school_outlined, 'https://www.olopsc.edu.ph'),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          height: 1,
          color: Colors.white.withOpacity(0.1),
        ),
        const SizedBox(height: 30),
        Text(
          '© ${DateTime.now().year} Our Lady of Perpetual Succor College''s . All rights reserved.''',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildFooterIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 2000.ms,
        ),
    );
  }
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

// Custom painter for animated particles effect
class ParticlesPainter extends CustomPainter {
  const ParticlesPainter();
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final random = DateTime.now().millisecondsSinceEpoch;
    
    // Create a pseudo-random pattern of dots
    for (int i = 0; i < 100; i++) {
      final x = ((random + i * 37) % 100) / 100 * size.width;
      final y = ((random + i * 17) % 100) / 100 * size.height;
      final radius = ((random + i) % 4) / 10 + 0.5;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Extension for responsive dimensions
extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  // Responsive width based on screen percentage
  double getResponsiveWidth(double percentage) => screenWidth * (percentage / 100);
  
  // Responsive height based on screen percentage
  double getResponsiveHeight(double percentage) => screenHeight * (percentage / 100);
  
  // Check if device is in portrait mode
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  
  // Check if device is a tablet (simplified)
  bool get isTablet => screenWidth > 600;
}

// Add animation extensions for staggered reveal animations
extension StaggeredAnimations on Widget {
  Widget staggeredFadeIn({required int index, double delay = 0.2}) {
    return animate()
      .fadeIn(delay: (index * 200 + delay * 1000).ms)
      .slideY(begin: 0.2, end: 0, delay: (index * 200 + delay * 1000).ms);
  }
  
  Widget shimmerEffect() {
    return animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: 2000.ms,
      color: Colors.white.withOpacity(0.2),
    );
  }
}