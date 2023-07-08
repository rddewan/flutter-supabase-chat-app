
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/models/profiles.dart';
import 'package:flutter_supabase_app/pages/auth/login_page.dart';
import 'package:flutter_supabase_app/pages/chat/chat_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({ Key? key }) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String numberOfUsers = '0';
  Profile? _profile;
  bool isLoading = false;

  @override
  void initState() {    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getUserProfile();      
    });
  }

  void _getUserProfile() {
    supabase.from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', supabase.auth.currentUser?.id)
      .map((event) => event.map((e) => Profile.fromMap(e)).toList())
      .listen((event) {
        setState(() {
          _profile = event.first;
        });
        
      });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
              _navigateToLogInPage();
            }, 
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  if (_profile != null)... [
                    CircleAvatar(
                      radius: 60,
                      foregroundImage: NetworkImage(_profile!.avatar),
                    ),

                    Positioned(
                      right: -10,
                      bottom: 10,
                      child: IconButton.filled(
                        onPressed: () {
                          _pickProfileImage();

                        }, 
                        icon: const Icon(Icons.camera_enhance)),
                    ),
                    
                  ]
                  else ...[
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  ],        
                  
                ],
              ),
            ),

            Text(_profile?.userName ?? ''),  

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToChatPage();
        }, 
        label: const Text('Chat'),
        icon: const Icon(Icons.chat),
      ),
      
    );
  }

  void _pickProfileImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
   
    if (file != null) {

      final data = await file.readAsBytes();

      try {

        setState(() {
          isLoading = true;
        });

        supabase.storage.from('default')
          .uploadBinary(
            file.path.split('/').last, 
            data,
            fileOptions: const FileOptions(upsert: true)
          );

        await _getAvatarUrl(file.path.split('/').last);

        setState(() {
          isLoading = false;
        });
        
      } on PostgrestException catch (e) {
        if (!mounted) return;
        context.showSnackbar(message: e.message, backgroundColor: Colors.red);
        
      }

    } 
  }

  Future<void> _getAvatarUrl(String? name) async {
    if (name != null) {
      final url = supabase.storage
        .from('default')
        .getPublicUrl(name);

      await _updateProfileAvatarUrl(url);

    }

  }

  Future<void> _updateProfileAvatarUrl(String url) async {
    try {

      await supabase.from('profiles')
        .update({'avatar_url': url})
        .eq('id', supabase.auth.currentUser?.id);
      
    } on PostgrestException catch (e) {
      context.showSnackbar(message: e.message, backgroundColor: Colors.red);      
    }
  }

  void _navigateToLogInPage() {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const LoginPage()), 
      (route) => false,
    );
  }

  void _navigateToChatPage() {

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const ChatPage()),
    );

  }
}