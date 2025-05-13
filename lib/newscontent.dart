import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/contentsection.dart';
import 'package:flutter_application_1/modernfooterr.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NewsContent extends StatefulWidget {
  const NewsContent({super.key});

  @override
  _NewsContentState createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent> with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;
  final ScrollController _actualScrollController = ScrollController();
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _actualScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_actualScrollController.offset > _lastScrollPosition) {
      _scrollController.forward();
    } else {
      _scrollController.reverse();
    }
    _lastScrollPosition = _actualScrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _actualScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            controller: _actualScrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Parallax Hero Banner
                const ParallaxHeroBanner(),
                
                // News Description
                FadeInSection(
                  child: ContentSection(
                    backgroundColor: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          'Stay updated on the latest news and announcements',
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'From Our Lady of Perpetual Succor\'s research organization! Find the latest stories, achievements, and milestones showcasing research breakthroughs, award recognitions, and upcoming events.',
                          style: TextStyle(
                            fontSize: 16, 
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Success Stories Section
                FadeInSection(
                  child: ContentSection(
                    backgroundColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'Success Stories',
                          subtitle: 'S.Y. 2024 - 2025',
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Discover the inspiring stories of our researchers, students, and faculty who have achieved remarkable success in their academic and professional pursuits.',
                          style: TextStyle(
                            fontSize: 16, 
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimationLimiter(
                          child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),
                              children: const [
                                ModernNewsCard(
                                  title: 'Participation at the 8th International Conference',
                                  subtitle: 'Asian and Philippine Studies of Grade 12 STEM students',
                                  description: 'Read about our students\' participation in this prestigious conference.',
                                  actionText: 'READ MORE',
                                  icon: Icons.public,
                                  pdfAssetPath: 'assets/pdfs/article1.pdf',
                                ),
                                SizedBox(height: 15),
                                ModernNewsCard(
                                  title: 'The Publication of Socorro with ISSN',
                                  subtitle: 'Research Journal Publication',
                                  description: 'Learn about the latest publication from our research organization.',
                                  actionText: 'READ MORE',
                                  icon: Icons.library_books,
                                  pdfAssetPath: 'assets/pdfs/article2.pdf',
                                ),
                                SizedBox(height: 15),
                                ModernNewsCard(
                                  title: 'Tipulo Project',
                                  subtitle: 'Community Innovation',
                                  description: 'Discover the innovative Tipulo Project and its impact on our community.',
                                  actionText: 'READ MORE',
                                  icon: Icons.lightbulb,
                                  pdfAssetPath: 'assets/pdfs/article3.pdf',
                                ),
                                SizedBox(height: 15),
                                ModernNewsCard(
                                  title: 'Partnership of Socorro',
                                  subtitle: 'Collaboration with the Asian Society for Research Teachers',
                                  description: 'Explore our new partnership and its benefits for our community.',
                                  actionText: 'READ MORE',
                                  icon: Icons.handshake,
                                  pdfAssetPath: 'assets/pdfs/article4.pdf',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Award Recognitions Section
                FadeInSection(
                  child: ContentSection(
                    backgroundColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'Award Recognitions',
                          subtitle: 'Celebrating Excellence',
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Celebrate with us the outstanding achievements of our researchers, students, and faculty who have received prestigious awards and recognitions for their academic excellence and innovative research.',
                          style: TextStyle(
                            fontSize: 16, 
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Awards Timeline
                        const AwardsTimeline(),
                      ],
                    ),
                  ),
                ),
                
                // Announcements Section
                FadeInSection(
                  child: ContentSection(
                    backgroundColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'Important Announcements',
                          subtitle: 'Stay Informed',
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Mark your calendars and plan to attend these exciting events that foster collaboration, innovation, and growth within our research community!',
                          style: TextStyle(
                            fontSize: 16, 
                            height: 1.6,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimationLimiter(
                          child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),
                              children: const [
                                ModernAnnouncementCard(
                                  audience: 'For the Institution\'s Staff',
                                  content: 'Publication Award for International/National Peer-reviewed Non-ISI Journal: A new form of recognition arrives at the institution in the form of the Socorro Publication Award for original research articles published in reputable, peer-reviewed, national/international journals.',
                                  icon: Icons.emoji_events,
                                ),
                                SizedBox(height: 15),
                                ModernAnnouncementCard(
                                  audience: 'For the Institution\'s Stakeholders and Staff',
                                  content: 'SOCORRO\'s "SALIK Awards": Welcome a one-day event honoring teachers and students for their significant contributions to the institution through innovative research, the stakeholders will be more engaged, valued, empowered, and encouraged to fill in tomorrow\'s big shoes.',
                                  icon: Icons.celebration,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Footer
                const ModernFooter(),
              ],
            ),
          ),
          
          // Floating Action Button
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              return Positioned(
                right: 20,
                bottom: 20 - (_scrollController.value * 100),
                child: FloatingActionButton(
                  onPressed: () {
                    _actualScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: Colors.indigo,
                  child: const Icon(Icons.arrow_upward),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Parallax Hero Banner
class ParallaxHeroBanner extends StatelessWidget {
  const ParallaxHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          // Parallax Image
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/news_banner.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo.withOpacity(0.7),
                    Colors.indigo.shade900.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'News &',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Updates',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 80,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.indigo,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.indigo.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

// Modern News Card

class ModernNewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String actionText;
  final IconData icon;
  final String? pdfAssetPath; // Asset path for the PDF file
  
  const ModernNewsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.actionText,
    required this.icon,
    this.pdfAssetPath, // Optional parameter for PDF asset path
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // If PDF asset path is provided, show PDF preview
            if (pdfAssetPath != null && pdfAssetPath!.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPreviewScreen(
                    title: title,
                    pdfAssetPath: pdfAssetPath!,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.indigo,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          // Open PDF when clicking specifically on the READ MORE text
                          if (pdfAssetPath != null && pdfAssetPath!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFPreviewScreen(
                                  title: title,
                                  pdfAssetPath: pdfAssetPath!,
                                ),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              actionText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: Colors.indigo,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PDF Preview Screen for assets
class PDFPreviewScreen extends StatefulWidget {
  final String title;
  final String pdfAssetPath;

  const PDFPreviewScreen({
    super.key,
    required this.title,
    required this.pdfAssetPath,
  });

  @override
  _PDFPreviewScreenState createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  String? localPdfPath;
  bool isLoading = true;
  int? totalPages;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPDFFromAssets();
  }

  // Load PDF from assets to a temporary file
  Future<void> _loadPDFFromAssets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ByteData data = await rootBundle.load(widget.pdfAssetPath);
      final bytes = data.buffer.asUint8List();
      
      // Create a temporary file to store the PDF
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.pdfAssetPath.split('/').last}');
      await file.writeAsBytes(bytes);
      
      setState(() {
        localPdfPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            )
          else if (localPdfPath != null)
            Column(
              children: [
                Expanded(
                  child: PDFView(
                    filePath: localPdfPath!,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: false,
                    onRender: (_pages) {
                      setState(() {
                        totalPages = _pages;
                      });
                    },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    },
                    onPageError: (page, error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error on page $page: $error')),
                      );
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      // Controller can be used for additional features if needed
                    },
                    onPageChanged: (int? page, int? total) {
                      if (page != null) {
                        setState(() {
                          currentPage = page;
                        });
                      }
                    },
                  ),
                ),
                // Page indicator with navigation buttons
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  color: Colors.indigo.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page navigation
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 18),
                            color: Colors.indigo,
                            onPressed: currentPage <= 0 ? null : () {
                              // Go to previous page
                              if (currentPage > 0) {
                                setState(() {
                                  currentPage--;
                                });
                                // You would need to use the PDFViewController to navigate
                                // if you stored it in a variable from onViewCreated
                              }
                            },
                          ),
                          Text(
                            'Page ${currentPage + 1}',
                            style: TextStyle(
                              color: Colors.indigo.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (totalPages != null) 
                            Text(
                              ' of $totalPages',
                              style: TextStyle(
                                color: Colors.indigo.shade800,
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 18),
                            color: Colors.indigo,
                            onPressed: (totalPages == null || currentPage >= totalPages! - 1) 
                                ? null 
                                : () {
                                    // Go to next page
                                    if (totalPages != null && currentPage < totalPages! - 1) {
                                      setState(() {
                                        currentPage++;
                                      });
                                      // You would need to use the PDFViewController to navigate
                                      // if you stored it in a variable from onViewCreated
                                    }
                                  },
                          ),
                        ],
                      ),
                      // Download button (optional)
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        color: Colors.indigo,
                        onPressed: () {
                          // Toggle fullscreen or implement other functions
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            const Center(
              child: Text('Failed to load PDF'),
            ),
        ],
      ),
    );
  }
}

// Modern Announcement Card
class ModernAnnouncementCard extends StatelessWidget {
  final String audience;
  final String content;
  final IconData icon;
  
  const ModernAnnouncementCard({
    super.key,
    required this.audience,
    required this.content,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    audience,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Awards Timeline
class AwardsTimeline extends StatelessWidget {
  const AwardsTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 700),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            _buildYearSection(
              '2023-2024',
              [
                AwardInfo(
                  title: 'Best in Work Immersion (Grade 12)',
                  project: 'O-Rice Dryer: An Experimental Analysis on the Potency of Modern Artificial Oryza Sativa Grain Dryers for Local Farmers in Mambusao, Capiz during Post-Harvest Season.',
                  leader: 'Rafael Joshua L. Abot',
                  members: const [
                    'Bryan Joseph R. Andres',
                    'Khean E. Baranda',
                    'Jose Gabriel D. Elizaga',
                    'Justin C. Pabia',
                    'Orlando Paras',
                    'Earl Josh Santos',
                    'Kevin P. Soriente'
                  ],
                ),
                AwardInfo(
                  title: 'Outstanding Research Paper Award (Grade 12)',
                  project: 'E-Sclepius: A Digitalized Inventory Management System for Selected Drugstores under a Pharmaceutical Association in the Eastern National Capital Region',
                  leader: 'Gabriel Matthew P. Labariento',
                  members: const [
                    'Marshall Andrei P. Banga-an',
                    'Glenn Cyril V. Bongat',
                    'Niel M. Bongco',
                    'Gwyneth Suzanne Chase M. Catapang',
                    'Mikki Shayne P. Chua',
                    'Lorenz Ymmanuelle M. Corre',
                    'Jeurmane Lindley S. Cruz',
                    'Nashty Z. Rivera'
                  ],
                ),
              ],
            ),
            _buildYearSection(
              '2022-2023',
              [
                AwardInfo(
                  title: 'Best in Work Immersion (Grade 12)',
                  project: 'Georganic: The Efficacy of Musa Acuminata Colla Fertilizer as a Mitigator of Harmful Chemicals and Augmenter of Growth Among the Variety of Brassica Rapa Flora of a Certain Farm in the Municipality of Ilocos Sur.',
                  leader: 'Maven Kenrich L. Siguancia',
                  members: const [
                    'Carlos Guiller D. Orpilla',
                    'Jazmin Lorraine F. Alanis',
                    'Darren Harold Beltran',
                    'Luis Gabriel D. Cabrera',
                    'John Christopher A. De Guzman',
                    'Kyle Adrian Y. Liwanag',
                    'Lei Andrea A. Soleto'
                  ],
                ),
              ],
            ),
            _buildYearSection(
              '2021-2022',
              [
                AwardInfo(
                  title: 'Best in Work Immersion (Grade 12)',
                  project: 'Caripa Biodegradable Plastic: Exceptional Properties of Carcia Papaya Bioplastic as an Influenced by Different Levels of Plasticizers',
                  leader: 'Daniel John B. De Guzman',
                  members: const [
                    'Ram Jiro L. Aba',
                    'Denise Rhia M. Balagtas',
                    'Christian Dave D. Carlos',
                    'Aliyah B. Salvador',
                    'Alliyah Nicole S. Sanchez',
                    'Eirene Angelica DC. Santos',
                    'Franchesca M. Sanchez',
                    'Kurt Angelo S. Sarabusing',
                    'Kish Gwyneth Ira B. Sy'
                  ],
                ),
                AwardInfo(
                  title: 'Outstanding Research Paper Award (Grade 12)',
                  project: 'Tambalang Pataba: Growth Survival of Enhalus Acoroides Under Controlled Agriculture using Eucheuma Cottonii as Sole Fertilizer',
                  leader: 'Khadija H. Tan',
                  members: const [
                    'Jerez Gianni C. Chua',
                    'Beatriz S. Dela Cruz',
                    'Janela Tricia V. Delfin',
                    'Ysabella Nadine D. Guerrero',
                    'Vincent R. Lucea',
                    'Nicole Cleirol M. Pago',
                    'Bench Redzhekel Serote',
                    'Angela Filar Z. Tandog',
                    'John Rafael C. Volante'
                  ],
                ),
              ],
            ),
            _buildYearSection(
              '2020-2021',
              [
                AwardInfo(
                  title: 'Best in Work Immersion (Grade 12)',
                  project: 'Balay: A Conceptual Model of Low Cost and Sustainable Housing Among Residents in Barangay Sta. Elena, Marikina City',
                  leader: 'Mira Clarisse S. Ignacio',
                  members: const [
                    'Vincent Gale P. Adams',
                    'Jared Karll B. Austria',
                    'Justine Aaron L. Bemos',
                    'Jill Angela C. Buenavista',
                    'Annevela Maryze C. Dela Paz',
                    'Evanescence P. Naad',
                    'Josiah Floyd D. Rodil'
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildYearSection(String year, List<AwardInfo> awards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            year,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
          ),
        ),
        ...awards.map((award) => ModernAwardCard(award: award)),
        const SizedBox(height: 30),
      ],
    );
  }
}

// Award Info class
class AwardInfo {
  final String title;
  final String project;
  final String leader;
  final List<String> members;
  
  const AwardInfo({
    required this.title,
    required this.project,
    required this.leader,
    required this.members,
  });
}

// Modern Award Card
class ModernAwardCard extends StatefulWidget {
  final AwardInfo award;
  
  const ModernAwardCard({
    super.key,
    required this.award,
  });
  
  @override
  _ModernAwardCardState createState() => _ModernAwardCardState();
}

class _ModernAwardCardState extends State<ModernAwardCard> {
  bool _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.military_tech,
                        color: Colors.indigo,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        widget.award.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  widget.award.project,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(height: 0),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      Text(
                        'Team Members',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leader: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.award.leader,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Members:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...widget.award.members.map((member) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.indigo.shade300,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                member,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FadeIn Section
class FadeInSection extends StatefulWidget {
  final Widget child;
  final bool fade;
  
  const FadeInSection({
    super.key,
    required this.child,
    this.fade = true,
  });

  @override
  _FadeInSectionState createState() => _FadeInSectionState();
}

class _FadeInSectionState extends State<FadeInSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.fade ? _opacityAnimation.value : 1.0,
          child: Transform.translate(
            offset: Offset(0, widget.fade ? 30 * (1 - _opacityAnimation.value) : 0),
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Modern Footer
