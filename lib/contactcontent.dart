import 'package:flutter/material.dart';
import 'package:flutter_application_1/contentsection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactContent extends StatelessWidget {
  const ContactContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Animated Hero Banner
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.indigo,
              image: const DecorationImage(
                image: AssetImage('assets/contact_banner.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.indigo,
                  BlendMode.darken,
                ),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOut),
                  
                  const SizedBox(height: 10),
                  
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .scaleX(begin: 0, end: 1, duration: 600.ms, curve: Curves.easeOut),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'We\'d love to hear from you',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 800.ms),
                ],
              ),
            ),
          ),
          
          // Contact Info Section
          ContentSection(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                // Contact Info Cards - Column Layout
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      _buildContactInfoCard(
                        icon: Icons.location_on,
                        title: 'VISIT OUR CAMPUS',
                        content: 'Gen. Ordoñez St., Concepción Uno, Marikina City',
                        delay: 0,
                        onTap: () {
                          _launchMaps('Gen. Ordoñez St., Concepción Uno, Marikina City, Philippines');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildContactInfoCard(
                        icon: Icons.phone,
                        title: 'CALL US',
                        content: '+63.960.563.0970',
                        delay: 200,
                        onTap: () {
                          _launchPhone('+63.960.563.0970');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildContactInfoCard(
                        icon: Icons.email,
                        title: 'EMAIL US',
                        content: 'elvin.mutuc@olopsc.edu.ph',
                        delay: 400,
                        onTap: () {
                          _launchEmail('elvin.mutuc@olopsc.edu.ph');
                        },
                      ),
                    ],
                  ),
                ),
                
                // Contact Form with animation
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmailContactForm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required int delay,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.indigo,
                  size: 26,
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
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    )
    .animate(delay: Duration(milliseconds: delay))
    .fadeIn(duration: 600.ms)
    .slideX(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }
  
  void _launchMaps(String address) async {
    final url = Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=$address');
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  
  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

// Email Contact Form
class EmailContactForm extends StatefulWidget {
  const EmailContactForm({super.key});

  @override
  _EmailContactFormState createState() => _EmailContactFormState();
}

class _EmailContactFormState extends State<EmailContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String emailBody = '''
Name: ${_nameController.text}
Email: ${_emailController.text}
Message: ${_messageController.text}
''';

        // Compose email with subject and body
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'elvin.mutuc@olopsc.edu.ph',
          query: 'subject=${Uri.encodeComponent(_subjectController.text)}&body=${Uri.encodeComponent(emailBody)}',
        );

        if (await canLaunch(emailUri.toString())) {
          await launch(emailUri.toString());
          
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Email App Opened'),
              content: const Text('Your message has been prepared. Please send it from your email app.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          
          // Clear form
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
          
        } else {
          // Show error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open email app. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send us a message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          )
          .animate(delay: 600.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.1, end: 0, duration: 600.ms),
          
          const SizedBox(height: 8),
          
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(2),
            ),
          )
          .animate(delay: 800.ms)
          .fadeIn(duration: 600.ms)
          .scaleX(begin: 0, end: 1, duration: 600.ms),
          
          const SizedBox(height: 20),
          
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixIcon: Icon(Icons.subject),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Your Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixIcon: Icon(Icons.message),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.send, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'SEND MESSAGE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 400.ms)
    .fadeIn(duration: 800.ms)
    .slideY(begin: 0.2, end: 0, duration: 800.ms);
  }
}