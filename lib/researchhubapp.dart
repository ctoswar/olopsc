import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/homecontent.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pdfdownloadservice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/html.dart' as universal_html;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart' hide PdfDocument; // Hide PdfDocument to avoid conflict
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' show ByteData, Uint8List, kIsWeb;
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import 'package:pdfx/pdfx.dart'; // Use PdfDocument from pdfx package
import 'package:firebase_auth/firebase_auth.dart';



class ResearchHubApp extends StatelessWidget {
  const ResearchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OLOPSC Research Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      routes: {
        '/main': (context) => MainPage(),
        '/ethical_code': (context) => EthicalCodePage(),
        '/writing_guidelines': (context) => WritingGuidelinesPage(),
        '/research_engines': (context) => ResearchEnginePage(),
        '/research_tools': (context) => ResearchToolsPage(),
        '/research_forms': (context) => ResearchFormsPage(),
        '/internal_resources': (context) => InternalResourcesPage(),
        '/research_outputs': (context) => ResearchOutputsPage(),
        '/home': (context) => const DeVeritateApp(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _savedItems = [];
  final List<String> _allFeatures = [
    'Ethical Code',
    'Writing Guide',
    'Research Tools',
    'Research Engines',
    'Research Forms',
    'Internal Resources',
    'Research Outputs',
    'Research Manual',
  ];
  List<String> _filteredFeatures = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredFeatures = List.from(_allFeatures);
    _loadSavedItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedItems = prefs.getStringList('savedItems') ?? [];
    });
  }

  Future<void> _saveItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!_savedItems.contains(item)) {
        _savedItems.add(item);
        prefs.setStringList('savedItems', _savedItems);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$item added to favorites')),
        );
      } else {
        _savedItems.remove(item);
        prefs.setStringList('savedItems', _savedItems);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$item removed from favorites')),
        );
      }
    });
  }

  void _filterFeatures(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFeatures = List.from(_allFeatures);
      } else {
        _filteredFeatures = _allFeatures
            .where((feature) => feature.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

 void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );

                // Navigate to login page
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/login',
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: $e')),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Account Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account Settings selected')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification Preferences'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification Preferences selected')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Theme Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Theme Settings selected')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('About section selected')),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Hub'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurfaceVariant,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _isSearching
          ? _buildSearchResults()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0, // Changed from 0.8 for better proportions
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildFeatureTile(
                        context,
                        'Ethical Code',
                        'S-RICE Values',
                        Icons.balance,
                        colorScheme.primary,
                        '/ethical_code',
                      ),
                      _buildFeatureTile(
                        context,
                        'Writing Guide',
                        '5-phase process',
                        Icons.edit_note,
                        colorScheme.secondary,
                        '/writing_guidelines',
                      ),
                      _buildFeatureTile(
                        context,
                        'Research Tools',
                        'Productivity tools',
                        Icons.build,
                        colorScheme.tertiary,
                        '/research_tools',
                      ),
                      _buildFeatureTile(
                        context,
                        'Research Engines',
                        'Search resources',
                        Icons.search,
                        colorScheme.error,
                        '/research_engines',
                      ),
                      _buildFeatureTile(
                        context,
                        'Research Forms',
                        'Templates & forms',
                        Icons.description,
                        colorScheme.primary,
                        '/research_forms',
                      ),
                      _buildFeatureTile(
                        context,
                        'Internal Resources',
                        'Support & facilities',
                        Icons.business,
                        colorScheme.secondary,
                        '/internal_resources',
                      ),
                      _buildFeatureTile(
                        context,
                        'Research Outputs',
                        'Publications & works',
                        Icons.library_books,
                        colorScheme.tertiary,
                        '/research_outputs',
                      ),
                      _buildFeatureTile(
                        context,
                        'Research Manual',
                        'Official guidelines',
                        Icons.menu_book,
                        colorScheme.error,
                        null,
                        isPdf: true,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              setState(() {
                _isSearching = true;
              });
              break;
            case 2:
              _showSavedItemsDialog();
              break;
            case 3:
              _showProfileDialog();
              break;
          }
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filteredFeatures = List.from(_allFeatures);
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search for resources, tools, guides...',
                    border: InputBorder.none,
                  ),
                  onChanged: _filterFeatures,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterFeatures('');
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredFeatures.length,
            itemBuilder: (context, index) {
              final feature = _filteredFeatures[index];
              final isSaved = _savedItems.contains(feature);
              
              return ListTile(
                title: Text(feature),
                leading: _getIconForFeature(feature),
                trailing: IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.red : null,
                  ),
                  onPressed: () => _saveItem(feature),
                ),
                onTap: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  
                  // Navigate to the appropriate route based on the feature
                  String route = '/${feature.toLowerCase().replaceAll(' ', '_')}';
                  if (feature == 'Research Manual') {
                    _showPdfDialog(context);
                  } else {
                    Navigator.pushNamed(context, route);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Icon _getIconForFeature(String feature) {
    switch (feature) {
      case 'Ethical Code':
        return const Icon(Icons.balance);
      case 'Writing Guide':
        return const Icon(Icons.edit_note);
      case 'Research Tools':
        return const Icon(Icons.build);
      case 'Research Engines':
        return const Icon(Icons.search);
      case 'Research Forms':
        return const Icon(Icons.description);
      case 'Internal Resources':
        return const Icon(Icons.business);
      case 'Research Outputs':
        return const Icon(Icons.library_books);
      case 'Research Manual':
        return const Icon(Icons.menu_book);
      default:
        return const Icon(Icons.info);
    }
  }

  void _showSavedItemsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saved Items'),
          content: SizedBox(
            width: double.maxFinite,
            child: _savedItems.isEmpty
                ? const Center(child: Text('No saved items yet'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _savedItems.length,
                    itemBuilder: (context, index) {
                      final item = _savedItems[index];
                      return ListTile(
                        leading: _getIconForFeature(item),
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _saveItem(item);
                            Navigator.of(context).pop();
                            _showSavedItemsDialog();
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          String route = '/${item.toLowerCase().replaceAll(' ', '_')}';
                          if (item == 'Research Manual') {
                            _showPdfDialog(context);
                          } else {
                            Navigator.pushNamed(context, route);
                          }
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileDialog() {
  // Get the current Firebase user
  final User? user = FirebaseAuth.instance.currentUser;
  final String userEmail = user?.email ?? 'No email found';
  final String displayName = user?.displayName ?? 'User';
  final String? photoURL = user?.photoURL;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
              child: photoURL == null ? const Icon(Icons.person, size: 40) : null,
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(userEmail),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Account Settings'),
              onTap: () {
                Navigator.of(context).pop();
                _showAccountSettingsDialog(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void _showAccountSettingsDialog(User? user) {
  // Make sure we have a user
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No user is currently logged in')),
    );
    return;
  }

  final TextEditingController displayNameController = TextEditingController(text: user.displayName);
  final emailController = TextEditingController(text: user.email);
  // We can't directly edit the Firebase email in this dialog, but we can display it

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Account Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null ? const Icon(Icons.person, size: 40) : null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'Cannot be changed directly',
                ),
                enabled: false, // Email can't be changed directly through this dialog
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Change Profile Picture'),
                onPressed: () => _updateProfilePicture(user),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                icon: const Icon(Icons.lock),
                label: const Text('Change Password'),
                onPressed: () => _showChangePasswordDialog(user.email!),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                icon: const Icon(Icons.email),
                label: const Text('Change Email'),
                onPressed: () => _showChangeEmailDialog(user),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Update the user's display name if it changed
              if (user.displayName != displayNameController.text) {
                try {
                  await user.updateDisplayName(displayNameController.text);
                  // Refresh the user to get the updated profile
                  await user.reload();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating profile: $e')),
                  );
                }
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<void> _updateProfilePicture(User user) async {
  try {
    // This would typically use image_picker package to select an image
    // For demonstration purposes, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture update functionality would be implemented here')),
    );
    
    // For actual implementation:
    // 1. Use image_picker to select an image
    // 2. Upload to Firebase Storage
    // 3. Get the download URL
    // 4. Update the user's photoURL with user.updatePhotoURL(downloadUrl)
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating profile picture: $e')),
    );
  }
}

void _showChangePasswordDialog(String email) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We will send a password reset email to:'),
            Text(
              email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset email sent')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error sending reset email: $e')),
                );
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      );
    },
  );
}

void _showChangeEmailDialog(User user) {
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newEmailController,
              decoration: const InputDecoration(
                labelText: 'New Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (newEmailController.text.isEmpty || passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }
              
              try {
                // Re-authenticate the user first
                AuthCredential credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: passwordController.text,
                );
                
                await user.reauthenticateWithCredential(credential);
                // Then update the email
                await user.updateEmail(newEmailController.text);
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating email: $e')),
                );
              }
            },
            child: const Text('Update Email'),
          ),
        ],
      );
    },
  );
}

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Socorro Research Hub',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Access tools, resources, and guidelines to enhance your research journey',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          _buildSearchBar(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

 Widget _buildSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SearchBar(
      hintText: 'Search for resources, tools, guides...',
      leading: const Icon(Icons.search),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onTap: () {
        setState(() {
          _isSearching = true;
        });
      },
      onChanged: (_) {},
    ),
  );
}

 Widget _buildFeatureTile(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  Color color,
  String? routeName, {
  bool isPdf = false,
}) {
  final bool isSaved = _savedItems.contains(title);
  
  return Card(
    elevation: 0,
    color: color.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Stack(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isPdf) {
              _showPdfDialog(context);
            } else if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : color,
              size: 24,
            ),
            onPressed: () => _saveItem(title),
          ),
        ),
      ],
    ),
  );
}



void _showPdfDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Research Manual'),
        content: const Text('This would open the OLOPSC RESEARCH MANUAL_EDITED VER.pdf file.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening PDF file...')),
              );
              // TODO: Navigate to PDF viewer here
            },
            child: const Text('Open PDF'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await _downloadPdf(context, 'assets/OLOPSC RESEARCH MANUAL_EDITED VER.pdf');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
            },
            child: const Text('Download PDF'),
          ),
          TextButton(
            onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening PDF file...')),
            );
            Navigator.of(context).pop(); // Move pop after
          },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<String> _downloadPdf(BuildContext context, String assetPath) async {
  try {
    // Ask for permission on Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        return 'Permission denied to write to storage.';
      }
    }

    // Load the asset file
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Get app documents or downloads directory
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final filePath = '${directory!.path}/OLOPSC RESEARCH MANUAL_EDITED VER.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return 'PDF saved to: $filePath';
  } catch (e) {
    return 'Failed to download PDF: $e';
  }
}


  Widget _buildDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'OLOPSC',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Research Hub',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'RESEARCH RESOURCES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.balance),
            title: const Text('Ethical Code'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Ethical Code') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Ethical Code') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Ethical Code'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ethical_code');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Writing Guidelines'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Writing Guide') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Writing Guide') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Writing Guide'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/writing_guidelines');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Research Engines'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Research Engines') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Research Engines') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Research Engines'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/research_engines');
            },
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Research Tools'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Research Tools') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Research Tools') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Research Tools'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/research_tools');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Research Forms'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Research Forms') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Research Forms') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Research Forms'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/research_forms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Internal Resources'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Internal Resources') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Internal Resources') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Internal Resources'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/internal_resources');
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Research Outputs'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Research Outputs') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Research Outputs') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Research Outputs'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/research_outputs');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Research Manual'),
            trailing: IconButton(
              icon: Icon(
                _savedItems.contains('Research Manual') ? Icons.favorite : Icons.favorite_border,
                color: _savedItems.contains('Research Manual') ? Colors.red : null,
                size: 18,
              ),
              onPressed: () => _saveItem('Research Manual'),
            ),
            onTap: () {
              Navigator.pop(context);
              _showPdfDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              _showContactDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.contact_support,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Contact Us'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VISIT OUR CAMPUS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('Gen. Ordoñez St., Concepción Uno, Marikina City, Philippines 1807'),
              const SizedBox(height: 16),
              const Text(
                'CONTACT NUMBER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('+63.960.563.0970'),
              const SizedBox(height: 16),
              const Text(
                'EMAIL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('Head of Research: elvin.mutuc@olopsc.edu.ph'),
            ],
          ),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Send Email'),
              onPressed: () {
                _launchEmail('elvin.mutuc@olopsc.edu.ph');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Research Hub Inquiry&body=Hello, I would like to inquire about...',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching email: $e')),
      );
    }
  }
}

class EthicalCodePage extends StatelessWidget {
  const EthicalCodePage({super.key});

  // PDF generation methods
  pw.Widget _buildPdfPrinciple(String title, String description, List<String> values) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, 
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(description),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: PdfColors.grey100,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('The Value of Truth', 
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...values.map((value) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('• '),
                        pw.Expanded(child: pw.Text(value)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI Building methods
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'S-RICE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          Text(
            'Code of Ethical Conduct',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'The Code of Ethical Conduct in Research provides guidelines, strategies, and principles to uphold the highest ethical standards in scholarly and educational research. It aims to uphold standardized ethical practices among stakeholders and corresponds with the institution\'s core values—S-RICE (Spirituality, Responsibility, Integrity, Caring Culture, and Excellence) to contribute to national development.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinciple(
    BuildContext context,
    String title,
    String description,
    List<String> values,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'The Value of Truth',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...values.map((value) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildCommitmentSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Commitment',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'By adhering to these ethical principles, we strive to maintain the highest standards of integrity, responsibility, and excellence in all our research endeavors. We are committed to conducting research that benefits society while respecting the rights and dignity of all participants.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
        ),
      ],
    ),
  );
}


  // Dialog methods
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('About S-RICE Values'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'S-RICE stands for Spirituality, Responsibility, Integrity, Caring Culture, and Excellence. These core values form the foundation of our research ethics framework.',
                ),
                SizedBox(height: 16),
                Text(
                  'These principles guide all research activities at Our Lady of Perpetual Succor College and ensure that our research contributes positively to society while upholding the highest ethical standards.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.download,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Download Ethics Code PDF'),
            ],
          ),
          content: const Text(
            'Would you like to download the complete Code of Ethical Conduct document for offline reference?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              onPressed: () {
                Navigator.of(context).pop();
                // Show a loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating PDF, please wait...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                // Generate and download the PDF
                _generateAndDownloadPdf(context).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PDF downloaded and opened'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating PDF: $error'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  // PDF generation and download - FIXED METHOD
  Future<void> _generateAndDownloadPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();
      
      // Create PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text('S-RICE: Code of Ethical Conduct', 
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Paragraph(
                text: 'The Code of Ethical Conduct in Research provides guidelines, strategies, and principles to uphold the highest ethical standards in scholarly and educational research. It aims to uphold standardized ethical practices among stakeholders and corresponds with the institution\'s core values—S-RICE (Spirituality, Responsibility, Integrity, Caring Culture, and Excellence) to contribute to national development.',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              
              // Spirituality section
              _buildPdfPrinciple(
                'Spirituality',
                'The College, guided by Catholic beliefs and Marian Spirituality, upholds truth in every aspect of life. This commitment extends to your research endeavors, where Socorro seeks to sustain the highest standards of integrity, honesty, and transparency.',
                [
                  'Ensure that all pertinent data/s present in the manuscript are accurate and timely.',
                  'Keep detailed and complete records of research undertakings.',
                  'Promptly declare any conflict of interest in any engagement in the process, specifically in presenting research results.',
                  'Ensure that the research results are accessible to the public once the research concludes.',
                ],
              ),
              pw.SizedBox(height: 16),
              
              // Responsibility section
              _buildPdfPrinciple(
                'Responsibility',
                'The institution is committed to educating young minds like you to value knowledge, promoting a love for research, and instilling responsibility to share factual information that informs decision-making and policy development, ultimately benefiting the community.',
                [
                  'Emphasize to the public and authorities any hazard observed from the paper that threatens human and environmental safety.',
                  'Inform and educate the public on the scientific knowledge acquired, specifically on the new information/s on human practices, attitudes, events, and other phenomena that provide significant benefits to the local community.',
                  'Avoid misleading or exaggerated statements in the research manuscript.',
                  'Conduct research that serves the needs of the local community.',
                  'Prioritize the well-being of the local community and individuals impacted by the research.',
                  'Seek the involvement of the local community.',
                  'Engage with local communities to identify and address potential issues that may affect them.',
                  'Observe safety practices in all research activities.',
                  'Avoid deliberate violation of regulations governing research.',
                  'Refrain from causing harm, stress, or pain to any animal in any experiment that does not contribute any substantial benefit to human society that has not been discovered already.',
                  'For experiments on animals that cannot be avoided, it is the duty of the researcher/s to treat them humanely, minimize their pain, and undertake curative measures thereafter.',
                  'Dispose of laboratory waste responsibly to prevent environmental harm.',
                  'Identify potential risks or threats that may affect the public\'s interest in your paper.',
                ],
              ),
              pw.SizedBox(height: 16),
              
              // Integrity section
              _buildPdfPrinciple(
                'Integrity',
                'Stakeholders should discuss and agree on the fair distribution of ownership of research and its products. Ownership should be assigned based on these discussions. Additionally, researchers must cite credible sources to ensure the validity and credibility of their work.',
                [
                  'Discuss with stakeholders to determine the fair distribution of legal ownership of the research and/or its product.',
                  'Fairly distribute the legal ownership of the research and/or its product among the stakeholders.',
                  'Acknowledge or cite the authors of reliable and timely sources in the manuscript to enhance the paper\'s credibility.',
                ],
              ),
              pw.SizedBox(height: 16),
              
              // Caring Culture section
              _buildPdfPrinciple(
                'Caring Culture',
                'The institution\'s code of ethical conduct ensures that all research participants and consumers are treated with respect, dignity, and fairness, regardless of their cultural, individual, or role differences. It also prioritizes the protection of participants\' confidentiality, autonomy, and welfare, safeguarding their rights throughout the research process.',
                [
                  'Respect cultural, individual, and role differences among research participants and consumers, including those based on age, sex, gender, identity, sexual orientation, nationality, ethnicity, disability, language, or socioeconomic status.',
                  'Eliminate the research practices and reports that hold biases on the aforementioned factors.',
                  'Protect the participant\'s privacy and confidentiality.',
                  'Ensure that informed consent is obtained from all human participants of an experiment or study.',
                  'Ensure and or issue a parental consent form and assent form to all minor human participants for any experiment or study.',
                  'Maintain the participants\' autonomy, especially students and subordinates, by refraining from offering inducements that may serve to coerce them into participating.',
                  'Safeguard the rights and welfare of persons and communities whose status and vulnerabilities may impact autonomous decision-making.',
                  'The participants have the right to withdraw from the study at any time for any reason, with no negative repercussions from such withdrawal.',
                ],
              ),
              pw.SizedBox(height: 16),
              
              // Excellence section
              _buildPdfPrinciple(
                'Excellence',
                'The institution prioritizes research that addresses pressing community concerns, fostering informed decision-making and empowering the local populace to tackle existing and future challenges. Socorro ensures that your research is grounded in rigorous analysis and interpretation of relevant data, leveraging timely and credible literature from local and international sources.',
                [
                  'Address the pressing needs and concerns of the modern community, enhancing local knowledge and decision-making capacity to effectively tackle current and emerging challenges.',
                  'Analyze and interpret data accurately, drawing from relevant and up-to-date literature and research from both local and international sources.',
                ],
              ),
              pw.SizedBox(height: 16),
              
              // Commitment section
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Our Commitment', 
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'By adhering to these ethical principles, we strive to maintain the highest standards of integrity, responsibility, and excellence in all our research endeavors. We are committed to conducting research that benefits society while respecting the rights and dignity of all participants.',
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      if (kIsWeb) {
      // Convert PDF to bytes
      final bytes = await pdf.save();
      
      // Use universal_html for web download
      final blob = universal_html.Blob([bytes], 'application/pdf');
      final url = universal_html.Url.createObjectUrlFromBlob(blob);
      
      // Create anchor element for download
      final anchor = universal_html.AnchorElement(href: url)
        ..setAttribute('download', 's_rice_ethical_code.pdf')
        ..style.display = 'none';
      
      universal_html.document.body?.children.add(anchor);
      anchor.click();
      
      // Clean up
      universal_html.document.body?.children.remove(anchor);
      universal_html.Url.revokeObjectUrl(url);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF downloaded successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } 
    // For mobile platforms
    else {
      // Your existing code for mobile platforms
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/s_rice_ethical_code.pdf');
      await file.writeAsBytes(await pdf.save());
      
      // Open the PDF file
      final result = await OpenFile.open(file.path);
      
      if (result.type != ResultType.done) {
        throw Exception('Could not open PDF: ${result.message}');
      }
    }
  } catch (e) {
    // Re-throw to be caught by the calling function
    rethrow;
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About S-RICE',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showDownloadDialog(context),
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spirituality principle
                  _buildPrinciple(
                    context,
                    'Spirituality',
                    'The College, guided by Catholic beliefs and Marian Spirituality, upholds truth in every aspect of life. This commitment extends to your research endeavors, where Socorro seeks to sustain the highest standards of integrity, honesty, and transparency.',
                    [
                      'Ensure that all pertinent data/s present in the manuscript are accurate and timely.',
                      'Keep detailed and complete records of research undertakings.',
                      'Promptly declare any conflict of interest in any engagement in the process, specifically in presenting research results.',
                      'Ensure that the research results are accessible to the public once the research concludes.',
                    ],
                    Icons.lightbulb_outline,
                    Colors.purple,
                  ),
                  
                  // Responsibility principle
                  _buildPrinciple(
                    context,
                    'Responsibility',
                    'The institution is committed to educating young minds like you to value knowledge, promoting a love for research, and instilling responsibility to share factual information that informs decision-making and policy development, ultimately benefiting the community.',
                    [
                      'Emphasize to the public and authorities any hazard observed from the paper that threatens human and environmental safety.',
                      'Inform and educate the public on the scientific knowledge acquired, specifically on the new information/s on human practices, attitudes, events, and other phenomena that provide significant benefits to the local community.',
                      'Avoid misleading or exaggerated statements in the research manuscript.',
                      'Conduct research that serves the needs of the local community.',
                      'Prioritize the well-being of the local community and individuals impacted by the research.',
                      'Seek the involvement of the local community.',
                    ],
                    Icons.account_balance,
                    Colors.blue,
                  ),
                  
                  // Integrity principle
                  _buildPrinciple(
                    context,
                    'Integrity',
                    'Stakeholders should discuss and agree on the fair distribution of ownership of research and its products. Ownership should be assigned based on these discussions. Additionally, researchers must cite credible sources to ensure the validity and credibility of their work.',
                    [
                      'Discuss with stakeholders to determine the fair distribution of legal ownership of the research and/or its product.',
                      'Fairly distribute the legal ownership of the research and/or its product among the stakeholders.',
                      'Acknowledge or cite the authors of reliable and timely sources in the manuscript to enhance the paper\'s credibility.',
                    ],
                    Icons.verified_user,
                    Colors.green,
                  ),
                  
                  // Caring Culture principle
                  _buildPrinciple(
                    context,
                    'Caring Culture',
                    'The institution\'s code of ethical conduct ensures that all research participants and consumers are treated with respect, dignity, and fairness, regardless of their cultural, individual, or role differences. It also prioritizes the protection of participants\' confidentiality, autonomy, and welfare, safeguarding their rights throughout the research process.',
                    [
                      'Respect cultural, individual, and role differences among research participants and consumers, including those based on age, sex, gender, identity, sexual orientation, nationality, ethnicity, disability, language, or socioeconomic status.',
                      'Eliminate the research practices and reports that hold biases on the aforementioned factors.',
                      'Protect the participant\'s privacy and confidentiality.',
                      'Ensure that informed consent is obtained from all human participants of an experiment or study.',
                    ],
                    Icons.favorite,
                    Colors.red,
                  ),
                  
                  // Excellence principle
                  _buildPrinciple(
                    context,
                    'Excellence',
                    'The institution prioritizes research that addresses pressing community concerns, fostering informed decision-making and empowering the local populace to tackle existing and future challenges. Socorro ensures that your research is grounded in rigorous analysis and interpretation of relevant data, leveraging timely and credible literature from local and international sources.',
                    [
                      'Address the pressing needs and concerns of the modern community, enhancing local knowledge and decision-making capacity to effectively tackle current and emerging challenges.',
                      'Analyze and interpret data accurately, drawing from relevant and up-to-date literature and research from both local and international sources.',
                    ],
                    Icons.star,
                    Colors.amber,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Commitment section
                  _buildCommitmentSection(context),
                  
                  const SizedBox(height: 40),

                  Center(
                    child: FilledButton.icon(
                      onPressed: () => _showDownloadDialog(context),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Download Code of Ethics PDF'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, 
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDownloadDialog(context),
        icon: const Icon(Icons.download),
        label: const Text('Get PDF'),
        tooltip: 'Download Ethics Code PDF',
      ),
    );
  }
}

class WritingGuidelinesPage extends StatelessWidget {
  const WritingGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Research Writing Guidelines',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'The research writing process includes five phases, from creating a proposal to finalizing the manuscript. It involves drafting chapters, following ethical guidelines, analyzing data with expert guidance, and presenting findings through an oral defense. The final phases include addressing feedback, proofreading, and submitting hardbound copies for archival purposes.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Phases cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildPhaseCard(
                    context,
                    phaseNumber: '1',
                    title: 'Creating the Research Proposal',
                    description: 'This phase serves as a structured guide for creating a research proposal. It includes defining the research title, briefly introducing the topic and the problem, outlining specific research questions, and explaining the research paradigm or theoretical framework. Moreover, it requires citing relevant literature, stating the purpose, providing a timetable for completion, and listing references in APA 7th Edition format.',
                    steps: [
                      'A proposal draft that includes the two forms of Title Proposal, Inverted Triangulation, and Research Matrices A and B.',
                    ],
                  ),
                  _buildPhaseCard(
                    context,
                    phaseNumber: '2',
                    title: 'Developing the Manuscript',
                    description: 'Phase II involves regular consultations with the research adviser to develop the research manuscript, drafting specific chapters or sections, and presenting the initial work through a colloquium. This phase prepares students for the Midterm grading period and sets the stage for further research development.',
                    steps: [
                      'Draft Chapters I, II, and III (for Practical Research II, Inquiries, Investigation, and Immersion, and Research Capstone Project)',
                      'Draft Introduction and Methodology parts (for Practical Research I)',
                      'Prepare for and present initial work through a colloquium',
                    ],
                  ),
                  _buildPhaseCard(
                    context,
                    phaseNumber: '3',
                    title: 'Refining and Analyzing',
                    description: 'Phase III involves refining the research manuscript, adhering to ethical standards, and utilizing available resources for data analysis. The finalized manuscript is then reviewed by the Research Adviser, leading to a final defense with a panel of reactors.',
                    steps: [
                      'Apply the protocol dictated by the OLOPSC Code of Ethical Standards.',
                      'Utilize resources from the Socorro Repository.',
                      'Conduct data analysis, seeking statistical guidance as needed.',
                      'Finalize the manuscript, including Chapters IV and V.',
                      'Prepare for the final defense with a panel of reactors.',
                    ],
                  ),
                  _buildPhaseCard(
                    context,
                    phaseNumber: '4',
                    title: 'Final Defense',
                    description: 'This phase involves preparing for the oral examination, also known as the final defense, under the guidance of the Research Adviser. The group will present their research to a panel of reactors, receive feedback, and complete the necessary documentation.',
                    steps: [
                      'Prepare for the oral examination under the guidance of the Research Adviser',
                      'Ensure all required materials are ready, including:',
                      '- Complete manuscript',
                      '- PowerPoint presentation',
                      'Present research to a panel of reactors',
                      'Obtain feedback from the panel',
                      'Complete and submit the necessary documentation',
                    ],
                  ),
                  _buildPhaseCard(
                    context,
                    phaseNumber: '5',
                    title: 'Revisions and Submission',
                    description: 'After the final defense, the group incorporates feedback and submits a revised copy of the research paper. The paper then undergoes proofreading and further revisions before being approved and submitted to the relevant centers in hardbound copies.',
                    steps: [
                      'Incorporate suggestions from the defense and submit a revised copy within 1 week.',
                      'Obtain research adviser\'s review and recommendation for proofreading.',
                      'Incorporate revisions from the proofreader and resubmit the paper to the research adviser.',
                      'Obtain final approval from the research adviser.',
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for quick navigation or other functionality
        },
        tooltip: 'Get Help',
        child: Icon(Icons.help_outline),
      ),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context, {
    required String phaseNumber,
    required String title,
    required String description,
    required List<String> steps,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              phaseNumber,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          childrenPadding: EdgeInsets.all(16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Key Steps:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}


class ResearchEngine {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final String url;
  final List<String> categories;

  ResearchEngine({
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.url,
    required this.categories,
  });
}

class ResearchEnginePage extends StatefulWidget {
  const ResearchEnginePage({super.key});

  @override
  State<ResearchEnginePage> createState() => _ResearchEnginePageState();
}

class _ResearchEnginePageState extends State<ResearchEnginePage> {
  String searchQuery = '';
  String selectedCategory = 'All';
  
  final List<ResearchEngine> allEngines = [
    ResearchEngine(
      title: 'ERIC (Educational Resources Information Center)',
      description: 'ERIC is a comprehensive database featuring over a million resources, including articles, reports, and conference papers on all aspects of education. Sponsored by the U.S. Department of Education, ERIC is produced by the Institute of Education Sciences.',
      icon: Icons.school,
      buttonText: 'Browse Now',
      url: 'https://eric.ed.gov/',
      categories: ['Education'],
    ),
    ResearchEngine(
      title: 'Google Scholar',
      description: 'Google Scholar is an academic search engine that includes full text or metadata of scholarly literature. The results returned by Google Scholar are typically more relevant and reliable than most search engines.',
      icon: Icons.search,
      buttonText: 'Browse Now',
      url: 'https://scholar.google.com/',
      categories: ['Education', 'Science', 'Technology', 'Medical'],
    ),
    ResearchEngine(
      title: 'DOAJ (Directory of Open Access Journals)',
      description: 'This directory is a unique and extensive index of open-access journals from around the world, driven by the growing community. It is also committed to providing quality content that is open online for everyone to use.',
      icon: Icons.book_online,
      buttonText: 'Browse Now',
      url: 'https://doaj.org/',
      categories: ['Open Access', 'Education'],
    ),
    ResearchEngine(
      title: 'Philippine E-Journals',
      description: 'The Philippine E-Journal is a growing library of local scholarly publications made available to people all over via a single web-based platform. It is hosted by C&E Publishing Inc., a leading distributor of integrated information-based solutions and a top educational publisher in the Philippines.',
      icon: Icons.public,
      buttonText: 'Browse Now',
      url: 'https://ejournals.ph/',
      categories: ['Education', 'Open Access'],
    ),
    ResearchEngine(
      title: 'SpringerLink',
      description: 'SpringerLink delivers fast and accurate access to the depth and breadth of the online collection of journals, eBooks, reference books, and other resources. It is also a platform that has hundreds of thousands of researchers worldwide.',
      icon: Icons.menu_book,
      buttonText: 'Browse Now',
      url: 'https://link.springer.com/',
      categories: ['Science', 'Technology', 'Medical'],
    ),
    ResearchEngine(
      title: 'DeepDyve',
      description: 'DeepDyve is a comprehensive database of over 150 million articles alongside your private research archive. It works directly with academic publishers and their partners to make full-text articles available to all users.',
      icon: Icons.dataset,
      buttonText: 'Browse Now',
      url: 'https://www.deepdyve.com/',
      categories: ['Science', 'Technology', 'Medical'],
    ),
    ResearchEngine(
      title: 'Royal Society of Chemistry',
      description: 'The Royal Society of Chemistry published 580 peer-reviewed journals that cover the core chemical sciences, including related fields such as biology, biophysics, energy and environment, engineering, materials, medicine, and physics. Their repository also provides quality journals that researchers can use.',
      icon: Icons.science,
      buttonText: 'Browse Now',
      url: 'https://www.rsc.org/',
      categories: ['Science'],
    ),
    ResearchEngine(
      title: 'The Nature Publishing Group',
      description: 'The group aims to serve the research community by publishing its most significant discoveries and findings that advance knowledge and address some of the most significant challenges we may face as a society. The journals publish primary research, reviews, interviews, critical comments, news, and analysis.',
      icon: Icons.eco,
      buttonText: 'Browse Now',
      url: 'https://www.nature.com/',
      categories: ['Science', 'Medical'],
    ),
    ResearchEngine(
      title: 'Elsevier',
      description: 'Elsevier is the world\'s leading scientific publisher and data analytics company and has been serving global research and healthcare communities for more than 140 years. The company serves academic and government institutions and top research and development-intensive corporations.',
      icon: Icons.analytics,
      buttonText: 'Browse Now',
      url: 'https://www.elsevier.com/',
      categories: ['Science', 'Medical', 'Technology'],
    ),
    ResearchEngine(
      title: 'New Scientist',
      description: 'The latest science and technology news from around the world are explored with New Scientist. The New Scientist publishes exclusive articles and expert analyses on the most recent developments in space, physics, health, technology, the environment, and more.',
      icon: Icons.newspaper,
      buttonText: 'Browse Now',
      url: 'https://www.newscientist.com/',
      categories: ['Science', 'Technology'],
    ),
  ];

  List<ResearchEngine> get filteredEngines {
    return allEngines.where((engine) {
      // Filter by search query
      final matchesSearch = searchQuery.isEmpty || 
        engine.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        engine.description.toLowerCase().contains(searchQuery.toLowerCase());
      
      // Filter by category
      final matchesCategory = selectedCategory == 'All' || 
        engine.categories.contains(selectedCategory);
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Research Engines',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'As a researcher, you\'ll find that the Research Hub\'s collection of Research Engines provides a comprehensive and curated repository of reliable sources, including academic journals, books, and reputable websites. This robust collection enables you to efficiently search, access, and utilize high-quality information, facilitating informed decision-making and advancing knowledge discovery.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search research engines...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            
            // Category chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All', selectedCategory == 'All'),
                    _buildCategoryChip('Education', selectedCategory == 'Education'),
                    _buildCategoryChip('Open Access', selectedCategory == 'Open Access'),
                    _buildCategoryChip('Science', selectedCategory == 'Science'),
                    _buildCategoryChip('Medical', selectedCategory == 'Medical'),
                    _buildCategoryChip('Technology', selectedCategory == 'Technology'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Status text for search results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filteredEngines.isEmpty 
                  ? 'No results found' 
                  : 'Showing ${filteredEngines.length} of ${allEngines.length} research engines',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(height: 8),
            
            // Research Engines List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: filteredEngines.map((engine) => _buildSearchEngineCard(
                  context,
                  title: engine.title,
                  description: engine.description,
                  icon: engine.icon,
                  buttonText: engine.buttonText,
                  url: engine.url,
                )).toList(),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for quick bookmark or save functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorites feature coming soon!')),
          );
        },
        tooltip: 'Save Favorites',
        child: Icon(Icons.bookmark_border),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              selectedCategory = label;
            });
          }
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildSearchEngineCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required String url,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Add to favorites or bookmark
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to favorites: $title')),
                    );
                  },
                  icon: Icon(Icons.favorite_border),
                  label: Text('Save'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Open the search engine
                    _launchURL(url, context);
                  },
                  icon: Icon(Icons.open_in_new),
                  label: Text(buttonText),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch URLs
  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

class ResearchToolsPage extends StatelessWidget {
  // Define tool URLs in a Map for easy maintenance
  final Map<String, String> toolUrls = {
    'IBM SPSS': 'https://www.ibm.com/products/spss-statistics',
    'RStudio': 'https://posit.co/products/open-source/rstudio/',
    'Statcrunch': 'https://www.statcrunch.com/',
    'JASP': 'https://jasp-stats.org/',
    'GraphPad Prism': 'https://www.graphpad.com/scientific-software/prism/',
    'Jamovi': 'https://www.jamovi.org/',
    'Mendeley': 'https://www.mendeley.com/',
    'Zotero': 'https://www.zotero.org/',
    'EndNote': 'https://endnote.com/',
    'Citavi': 'https://www.citavi.com/',
    'Citationsy': 'https://citationsy.com/',
    'RefWorks': 'https://refworks.proquest.com/',
  };

  ResearchToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
          'Research Tools',
          style: TextStyle(color: Colors.white),
        ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            // Custom tab bar with modern styling
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Text(
                      'Discover powerful online tools to streamline your research workflow, from statistical analysis to organizing citations.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.white,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.bar_chart),
                          text: 'Statistics Tools',
                        ),
                        Tab(
                          icon: Icon(Icons.format_quote),
                          text: 'Citation Tools',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _buildStatisticsToolsTab(context),
                  _buildCitationToolsTab(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show dialog to suggest a new tool
            _showSuggestToolDialog(context);
          },
          tooltip: 'Suggest Tool',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Method to show suggestion dialog
  void _showSuggestToolDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suggest a Research Tool'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Tool Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Website URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Brief Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you would handle the suggestion submission
                // For now, just close the dialog
                Navigator.of(context).pop();
                
                // Show a thank you message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your suggestion!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsToolsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Statistics & Data Analysis Tools'),
            const SizedBox(height: 16),
            
            _buildToolCard(
              context,
              title: 'IBM SPSS',
              description: 'A statistical application for data analysis, predictive modeling, and more sophisticated statistical testing. It is widely applied in research, social science, and business analytics.',
              icon: Icons.analytics,
              category: 'Advanced Analysis',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'RStudio',
              description: 'An open-source tool commonly employed in data science and statistical computing. It offers an easy-to-use interface for R programming and accommodates a range of statistical learning methods.',
              icon: Icons.code,
              category: 'Programming',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'Statcrunch',
              description: 'A web-based statistical computer application from Pearson Education, StatCrunch was first designed for college statistics classes. As a full-featured statistics package, it is used for research and other uses in statistical analysis.',
              icon: Icons.auto_graph,
              category: 'Educational',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'JASP',
              description: 'A free and open-source statistics program that offers standard analysis procedures in classical and Bayesian statistics. JASP is designed to be easy to use and provides professional statistical reporting.',
              icon: Icons.view_quilt,
              category: 'Free & Open Source',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'GraphPad Prism',
              description: 'A powerful statistical analysis and graphing software designed specifically for scientific research. It combines scientific graphing, comprehensive curve fitting, statistics, and data organization.',
              icon: Icons.stacked_line_chart,
              category: 'Scientific',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'Jamovi',
              description: 'A free and open statistical software built on R, providing a user-friendly interface for common statistical analyses. Jamovi offers both descriptive and inferential statistics tools.',
              icon: Icons.insights,
              category: 'User-Friendly',
              buttonText: 'Open Tool',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCitationToolsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Citation & Reference Management'),
            const SizedBox(height: 16),
            
            _buildToolCard(
              context,
              title: 'Mendeley',
              description: 'A reference manager that helps organize research papers, generate citations, and collaborate with other researchers.',
              icon: Icons.folder_shared,
              category: 'Reference Manager',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'Zotero',
              description: 'A free, open-source reference management software to help collect, organize, cite, and share research sources.',
              icon: Icons.library_books,
              category: 'Open Source',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'EndNote',
              description: 'A commercial reference management software package used to manage bibliographies and references when writing academic papers.',
              icon: Icons.bookmarks,
              category: 'Commercial',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'Citavi',
              description: 'A reference management and knowledge organization tool that helps researchers organize literature, quotes, and notes.',
              icon: Icons.fact_check,
              category: 'Knowledge Organization',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'Citationsy',
              description: 'A simple citation tool supporting APA, MLA, Harvard, and Chicago styles for books, websites, and journals.',
              icon: Icons.format_quote,
              category: 'Easy Citation',
              buttonText: 'Open Tool',
            ),
            _buildToolCard(
              context,
              title: 'RefWorks',
              description: 'A web-based reference management service popular in academic institutions, allowing users to manage citations and format bibliographies.',
              icon: Icons.cloud_done,
              category: 'Cloud-Based',
              buttonText: 'Open Tool',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String category,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Show tutorials or documentation
                    _showHelpDialog(context, title);
                  },
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Help'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
                Row(
                  children: [
                    // Added a copy button for additional functionality 
                    IconButton(
                      icon: const Icon(Icons.content_copy, size: 20),
                      tooltip: 'Copy URL',
                      onPressed: () async {
                        final url = toolUrls[title];
                        if (url != null) {
                          await Clipboard.setData(ClipboardData(text: url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Try with multiple methods
                        _launchToolWebsite(context, title);
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text(buttonText),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Future<void> _launchToolWebsite(BuildContext context, String toolName) async {
  final String? urlString = toolUrls[toolName];

  if (urlString == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Website URL is not available'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  final Uri url = Uri.parse(urlString);

  try {
    // Try opening in external application
    if (await canLaunchUrl(url)) {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    }

    // Try opening with platform default
    if (await canLaunchUrl(url)) {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
      if (launched) return;
    }

    // Both attempts failed, try Google search for the tool name
    final Uri googleSearchUrl = Uri.parse('https://www.google.com/search?q=$toolName');

    if (await canLaunchUrl(googleSearchUrl)) {
      await launchUrl(googleSearchUrl, mode: LaunchMode.externalApplication);
      return;
    }

    // If Google search fails too, show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unable to open the website or Google Search.'),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    print('Error launching URL: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e. Unable to launch any URLs.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
  // Enhanced method with fallback options for Android
 void _launchToolWebsiteWithFallback(BuildContext context, String toolName) async {
  final String? urlString = toolUrls[toolName];
  
  if (urlString == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Website for $toolName is not available'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  final Uri url = Uri.parse(urlString);
  
  try {
    // This will open the URL and show the app chooser on Android
    // The key is using LaunchMode.externalApplication with the appropriate flags
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
      
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening $toolName in browser'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // If we can't launch the URL, show the fallback dialog
      _showUrlFallbackDialog(context, toolName, urlString);
    }
  } catch (e) {
    print('Error launching URL: $e');
    _showUrlFallbackDialog(context, toolName, urlString);
  }
}
  // Fallback dialog when all launch attempts fail
  void _showUrlFallbackDialog(BuildContext context, String toolName, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open $toolName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unable to open the website automatically. You can:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('1. Copy the URL below'),
              const Text('2. Open your browser manually'),
              const Text('3. Paste and navigate to the URL'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        url,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.content_copy),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: url));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('URL copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to show help dialog
  void _showHelpDialog(BuildContext context, String toolName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help for $toolName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Getting Started:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'This will display tutorials, documentation, and help resources for $toolName. For now, this is a placeholder that you can customize with specific help content for each tool.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Need more help?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visit the official website by clicking the "Open Tool" button to access comprehensive documentation and support resources.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open the tool website
                _launchToolWebsite(context, toolName);
              },
              child: const Text('Go to Website'),
            ),
          ],
        );
      },
    );
  }
}

class ResearchFormsPage extends StatelessWidget {
  const ResearchFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Research Forms and Templates',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Access our collection of customizable research forms and templates to streamline your research process.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Form categories with modern cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFormCategory(
                    context,
                    'Proposal Forms',
                    Icons.description_outlined,
                    [
                      'Research Proposal Template',
                      'Title Proposal Form',
                      'Institutional Review Board (IRB) Application',
                      'Research Budget Template',
                      'Timeline and Milestones Template',
                    ],
                  ),
                  _buildFormCategory(
                    context,
                    'Data Collection Forms',
                    Icons.data_array_outlined,
                    [
                      'Survey Questionnaire Template',
                      'Interview Guide Template',
                      'Focus Group Discussion Guide',
                      'Observation Protocol Form',
                      'Data Collection Consent Form',
                      'Parental Consent Form',
                      'Assent Form for Minors',
                    ],
                  ),
                  _buildFormCategory(
                    context,
                    'Analysis and Reporting Forms',
                    Icons.analytics_outlined,
                    [
                      'Data Analysis Plan Template',
                      'Statistical Analysis Report Template',
                      'Research Findings Summary Template',
                      'Research Manuscript Template',
                      'APA 7th Edition Formatting Guide',
                    ],
                  ),
                  _buildFormCategory(
                    context,
                    'Validation and Ethics Forms',
                    Icons.verified_outlined,
                    [
                      'Expert Validation Form',
                      'Content Validation Checklist',
                      'Ethics Review Checklist',
                      'Conflict of Interest Disclosure Form',
                      'Data Privacy Compliance Form',
                    ],
                  ),
                  _buildFormCategory(
                    context,
                    'Presentation and Documentation',
                    Icons.slideshow_outlined,
                    [
                      'Research Defense Presentation Template',
                      'Research Poster Template',
                      'Research Executive Summary Template',
                      'Certificate of Originality',
                      'Approval Sheet Template',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCategory(
    BuildContext context,
    String title,
    IconData iconData,
    List<String> forms,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final formName = forms[index];
              // Convert form name to a file name format (lowercase, hyphens instead of spaces)
              final fileName = formName.toLowerCase().replaceAll(' ', '-');
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    formName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blueGrey),
                          tooltip: 'Preview',
                          onPressed: () {
                            // Preview PDF
                            _previewPdf(context, formName, fileName);
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          icon: Icon(Icons.download_outlined, color: Theme.of(context).primaryColor),
                          tooltip: 'Download',
                          onPressed: () {
                            // Download PDF
                            _downloadPdf(context, formName, fileName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // Preview the PDF document
  void _previewPdf(BuildContext context, String formName, String fileName) async {
    try {
      // Check if the file exists
      try {
        await rootBundle.load('assets/pdfs/$fileName.pdf');
        // If no exception is thrown, file exists, navigate to PDF viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(
              title: formName,
              pdfAssetPath: 'assets/pdfs/$fileName.pdf',
            ),
          ),
        );
      } catch (e) {
        // File doesn't exist, show Coming Soon message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Coming Soon'),
              content: Text('$formName will be available for preview soon. We\'re currently updating our template library.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred');
    }
  }

  // Download the PDF document
  void _downloadPdf(BuildContext context, String formName, String fileName) async {
    try {
      // First check if file exists
      try {
        final ByteData data = await rootBundle.load('assets/pdfs/$fileName.pdf');
        final List<int> bytes = data.buffer.asUint8List();
        
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
                SizedBox(width: 12),
                Text('Downloading $formName...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // Handle different platforms
        Directory? directory;

        if (kIsWeb) {
          html.AnchorElement(href: 'assets/pdfs/$fileName.pdf')
            ..setAttribute('download', '$fileName.pdf')
            ..click();
        } else if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          directory = await getDownloadsDirectory();
        }

        if (directory == null) {
          throw Exception('Download complete');
        }

        // Ensure directory exists
        await directory.create(recursive: true);

        // Create file path
        String path = '${directory.path}/$fileName.pdf';
        final File file = File(path);
        await file.writeAsBytes(bytes);

        scaffold.showSnackBar(
          SnackBar(
            content: Text('$formName downloaded successfully'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                OpenFile.open(path);
              },
            ),
          ),
        );
      } catch (e) {
        // File doesn't exist, show Coming Soon message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$formName will be available for download soon'),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'GOT IT',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Simple PDF Viewer Page
class PdfViewerPage extends StatefulWidget {
  final String title;
  final String pdfAssetPath;

  const PdfViewerPage({Key? key, required this.title, required this.pdfAssetPath}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final ByteData data = await rootBundle.load(widget.pdfAssetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(bytes), // Using PdfDocument from pdfx package
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Coming Soon! This document will be available shortly.";
      });
    }
  }

 Future<void> _downloadPdf() async {
  try {
    // Ask for permission on Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
        }
        return;
      }
    }

    // Load PDF from asset
    final ByteData data = await rootBundle.load(widget.pdfAssetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Get storage directory
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final filePath = '${directory!.path}/${widget.title.replaceAll(" ", "_")}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to: $filePath')),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }
}

  @override
  void dispose() {
    // Only dispose controller if it was successfully initialized
    if (!_isLoading && _errorMessage == null) {
      _pdfController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf, // Trigger the download function
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_bottom,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "We're currently updating our template library.",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : PdfViewPinch(
                  controller: _pdfController,
                  scrollDirection: Axis.vertical,
                ),
    );
  }
}
class InternalResourcesPage extends StatelessWidget {
  const InternalResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with gradient background
            Container(
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Internal Resources',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Explore the comprehensive range of internal resources available to support your research endeavors at Our Lady of Perpetual Succor.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Resource sections with modern cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildResourceSection(
                    context,
                    'Research Funding',
                    Icons.attach_money_outlined,
                    'The institution offers various funding opportunities to support research projects across disciplines. These grants are designed to facilitate innovative research that aligns with institutional priorities and contributes to academic and societal advancement.',
                    [
                      'Faculty Research Grants',
                      'Student Research Fellowships',
                      'Collaborative Research Funding',
                      'Conference Travel Grants',
                      'Publication Support Fund',
                    ],
                  ),
                  _buildResourceSection(
                    context,
                    'Research Facilities',
                    Icons.business_outlined,
                    'Access state-of-the-art facilities designed to support various types of research. Our specialized laboratories and research spaces are equipped with modern technology to facilitate high-quality research outcomes.',
                    [
                      'Science and Technology Laboratories',
                      'Computer Research Laboratory',
                      'Social Sciences Research Center',
                      'Education Innovation Lab',
                      'Health Sciences Research Facility',
                      'Business Research and Development Center',
                    ],
                  ),
                  _buildResourceSection(
                    context,
                    'Research Training',
                    Icons.school_outlined,
                    'Enhance your research skills through specialized training programs offered by the institution. These programs cover various aspects of research methodology, data analysis, and scholarly writing.',
                    [
                      'Research Methodology Workshops',
                      'Statistical Analysis Training',
                      'Scholarly Writing Seminars',
                      'Research Ethics Training',
                      'Grant Writing Workshops',
                      'Publication Strategy Sessions',
                    ],
                  ),
                  _buildResourceSection(
                    context,
                    'Research Support Services',
                    Icons.support_outlined,
                    'Benefit from comprehensive support services designed to assist researchers at every stage of their research journey, from conceptualization to publication and dissemination.',
                    [
                      'Research Advisory Services',
                      'Statistical Consultation',
                      'Editorial Support Services',
                      'Research Ethics Review',
                      'Data Management Support',
                      'Intellectual Property Guidance',
                      'Research Dissemination Assistance',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceSection(
    BuildContext context,
    String title,
    IconData iconData,
    String description,
    List<String> resources,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    resources[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        _showComingSoonDialog(context);
                      },
                    ),
                  ),
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  // New method to show the Coming Soon dialog
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Coming Soon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Text(
            "We're currently updating our template library.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ResearchOutputsPage extends StatelessWidget {
  const ResearchOutputsPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
                  title: Text(
            'Research Outputs',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
  indicatorColor: Colors.white,
  indicatorWeight: 3,
  labelColor: Colors.white,       // Makes selected tab text white
  unselectedLabelColor: Colors.white.withOpacity(0.7), // Makes unselected tab text slightly transparent white
  labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  unselectedLabelStyle: TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
  ),
  tabs: [
    Tab(text: 'Publications'),
    Tab(text: 'Conferences'),
    Tab(text: 'Awards'),
  ],
),
        ),
        body: TabBarView(
          children: [
            _buildPublicationsTab(context),
            _buildConferencesTab(context),
            _buildAwardsTab(context),
          ],
        ),
      ),
    );
  }

 void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text('To be made available by the institution soon.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }


  Widget _buildPublicationsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with gradient background
          Container(
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Publications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Explore the scholarly publications produced by our faculty and students. These works represent our commitment to advancing knowledge across various disciplines.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildPublicationCard(
                  context,
                  'PRACTICAL RESEARCH 11',
                  'Grade 11 Students',
                  'OLOPSC Senior High Students ',
                  '2021-2022',
                  'Explore the world of qualitative research through our Grade 11 students'' abstracts, which delve into themes, experiences, and perceptions. These studies showcase their budding research skills and creative approaches.',
                  'assets/pdfs/experiences_of_contract_of_service_filipino_employ.pdf',
                ),
                _buildPublicationCard(
                  context,
                  'Research Capstone Project',
                  'Grade 12 Students',
                  'OLOPSC Senior High Students ',
                  '2023-2024',
                  'Our Grade 12 students'' capstone projects are showcased in this section, featuring quantitative research that investigates real-world problems and phenomena. These studies demonstrate their mastery of statistical analysis and research design.',
                  'assets/pdfs/digital_ebook_repository.pdf',
                ),
                _buildPublicationCard(
                  context,
                  'PRACTICAL RESEARCH 12 & INQUIRIES, INVESTIGATION, AND IMMERSION',
                  'Grade 12 Students',
                  'OLOPSC Senior High Students',
                  '2023-2024',
                  'This section highlights innovative quantitative research studies that tackle complex issues and provide actionable insights. Our Grade 12 students'' research abstracts in this section demonstrate their expertise in research design, implementation, and analysis.',
                  'assets/pdfs/practical_research_12_inquiries_investigation_and_.pdf',
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationCard(
    BuildContext context,
    String title,
    String authors,
    String journal,
    String year,
    String abstract,
    String pdfPath,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.black54,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    authors,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 16,
                  color: Colors.black54,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '$journal ($year)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abstract',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    abstract,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // PDF preview thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red[700],
                      size: 36,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'PDF Preview',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.download_outlined),
                  label: Text('PDF'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _downloadPdf(context, title, _generatePdfFileName(title));
                  },
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.visibility_outlined),
                  label: Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _openPdfViewer(context, title, pdfPath);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to open PDF viewer
  void _openPdfViewer(BuildContext context, String title, String pdfPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(title: title, pdfAssetPath: pdfPath),
      ),
    );
  }


 Widget _buildConferencesTab(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Conference Presentations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Discover the research presented by our faculty and students at various academic conferences, showcasing our contribution to scholarly discourse.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer with new styling
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blueAccent, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Disclaimer: To be made available by the institution soon',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Conference cards
              _buildConferenceCard(
                context,
                'Educational Innovations in the Post-Pandemic Era',
                'National Conference on Educational Technology',
                'Manila, Philippines',
                'April 2023',
                'Dr. Liza Reyes, Prof. Marco Santos',
                'This presentation explored innovative teaching methodologies developed during the pandemic and their continued relevance in post-pandemic education.',
                'assets/pdfs/educational_innovations.pdf',
              ),
              _buildConferenceCard(
                context,
                'Mental Health Support Systems for College Students',
                'International Conference on Student Wellbeing',
                'Singapore',
                'November 2022',
                'Dr. Patricia Lim, Dr. Anthony Cruz',
                'This research presented findings on effective mental health support systems for college students, with specific recommendations for implementation in Philippine higher education institutions.',
                'assets/pdfs/mental_health_support.pdf',
              ),
              _buildConferenceCard(
                context,
                'Community-Based Disaster Preparedness: Lessons from Philippine Experiences',
                'Asia-Pacific Conference on Disaster Management',
                'Tokyo, Japan',
                'August 2022',
                'Engr. Jose Bautista, Dr. Maria Gonzales',
                'This presentation shared insights from community-based disaster preparedness initiatives in the Philippines, highlighting successful approaches and challenges faced.',
                'assets/pdfs/disaster_preparedness.pdf',
              ),
              _buildConferenceCard(
                context,
                'Enhancing Critical Thinking Skills Through Problem-Based Learning',
                'Southeast Asian Teaching and Learning Conference',
                'Bangkok, Thailand',
                'February 2022',
                'Dr. Ricardo Torres, Prof. Elena Santos',
                'This research demonstrated the effectiveness of problem-based learning approaches in developing critical thinking skills among undergraduate students.',
                'assets/pdfs/critical_thinking.pdf',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildConferenceCard(
    BuildContext context,
    String title,
    String conference,
    String location,
    String date,
    String presenters,
    String abstract,
    String slidesPath,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          conference,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Text(
                        location,
                        style: TextStyle(fontSize: 14),
                      ),
                      Spacer(),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: Colors.black54,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    presenters,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abstract',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    abstract,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Slides preview thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.slideshow,
                      color: Colors.orange[700],
                      size: 36,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Slides Preview',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.download_outlined),
                  label: Text('Slides'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _downloadPdf(context, "$title - Slides", _generatePdfFileName("$title-slides"));
                  },
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.visibility_outlined),
                  label: Text('Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _openPdfViewer(context, "$title - Slides", slidesPath);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildAwardsTab(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Research Awards',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Celebrate the achievements of our researchers who have received recognition for their outstanding contributions to their respective fields.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer with new styling
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blueAccent, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Disclaimer: To be made available by the institution soon',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Award cards
              _buildAwardCard(
                context,
                'Outstanding Research in Environmental Science',
                'National Research Council of the Philippines',
                '2023',
                'Dr. Elena Martinez',
                'Awarded for groundbreaking research on urban water conservation techniques applicable to Philippine cities.',
                'assets/pdfs/environmental_science_award.pdf',
              ),
              _buildAwardCard(
                context,
                'Best Student Research Paper',
                'Philippine Association of Research Scholars',
                '2023',
                'Juan Dela Cruz, Maria Santos, and Pedro Reyes',
                'Recognized for innovative research on renewable energy implementation in rural communities.',
                'assets/pdfs/student_research_award.pdf',
              ),
              _buildAwardCard(
                context,
                'Excellence in Educational Research',
                'Department of Education',
                '2022',
                'Dr. Roberto Lim',
                'Awarded for significant contribution to understanding and improving learning outcomes in K-12 education.',
                'assets/pdfs/educational_research_award.pdf',
              ),
              _buildAwardCard(
                context,
                'Innovation in Health Research',
                'Philippine Council for Health Research and Development',
                '2022',
                'Dr. Ana Gonzales and Dr. Carlos Mendoza',
                'Recognized for developing accessible healthcare technologies for underserved communities.',
                'assets/pdfs/health_research_award.pdf',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildAwardCard(
    BuildContext context,
    String title,
    String awardingBody,
    String year,
    String recipients,
    String description,
    String certificatePath,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.amber[800],
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.amber[800]!, width: 1),
                        ),
                        child: Text(
                          year,
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          awardingBody,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recipients,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            // Certificate preview thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[700]!, width: 1),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_membership,
                      color: Colors.amber[700],
                      size: 36,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Certificate Preview',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.visibility_outlined),
                  label: Text('View Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _openPdfViewer(context, "$title - Certificate", certificatePath);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _generatePdfFileName(String title) {
    return title.toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '')
      .substring(0, min(title.length, 50));
  }

  // PDF Download Method
  void _downloadPdf(BuildContext context, String formName, String fileName) async {
    try {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2, 
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                ),
              ),
              SizedBox(width: 12),
              Text('Downloading $formName...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Load PDF from assets
      final ByteData data = await rootBundle.load('assets/pdfs/$fileName.pdf');
      final List<int> bytes = data.buffer.asUint8List();

      // Handle different platforms
      Directory? directory;

      if (kIsWeb) {
        html.AnchorElement(href: 'assets/pdfs/$fileName.pdf')
          ..setAttribute('download', '$fileName.pdf')
          ..click();
      } else if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        throw Exception('Download directory not found');
      }

      // Ensure directory exists
      await directory.create(recursive: true);

      // Create file path
      String path = '${directory.path}/$fileName.pdf';
      final File file = File(path);
      await file.writeAsBytes(bytes);

      scaffold.showSnackBar(
        SnackBar(
          content: Text('$formName downloaded successfully'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'OPEN',
            textColor: Colors.white,
            onPressed: () {
              OpenFile.open(path);
            },
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Download failed: $e');
    }
  }

  // Error SnackBar method
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}



