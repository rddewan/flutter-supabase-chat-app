

import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;

  @override
  void initState() {    
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _signUp() async {

    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {

      try {

          setState(() {
            _isLoading = true;
          });

          final isEmailExist = await supabase.from('profiles')
            .select('email')
            .eq('email', _emailController.text)
            .limit(1)
            .maybeSingle();

          if (isEmailExist != null && isEmailExist['email'].toString().isNotEmpty) {
            throw const AuthException('email already exist');
          }

          final isUserNameExist = await supabase.from('profiles')
            .select('username')
            .eq('username', _usernameController.text)
            .limit(1)
            .maybeSingle();

          if (isUserNameExist != null && isUserNameExist['username'].toString().isNotEmpty) {
            throw const AuthException('username already exist');
          }

          await supabase.auth.signUp(
            email: _emailController.text,
            password: _passwordController.text,
            data: {'username': _usernameController.text.toLowerCase()}
          );

          setState(() {
            _isLoading = false;
          });

          _navigateToLoginPage();
          
        } on AuthException catch (e) {
          context.showSnackbar(message: e.message,backgroundColor: Colors.red);
          setState(() {
            _isLoading = false;
          });
          
        }
        catch (e) {
          context.showSnackbar(message: e.toString(),backgroundColor: Colors.red);
          setState(() {
            _isLoading = false;
          });
          
        }   
    }


  }

  void _navigateToLoginPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                if (_isLoading)... [
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                ],
                
                const SizedBox(height: 16.0),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  autofocus: false,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 1,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),                
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email is empty';
                    }
                    return null;   
                  },           
                ),

                const SizedBox(height: 24.0),

                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  autofocus: false,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your user name',
                    labelText: 'User Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 1,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),                
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'user name is empty';
                    }
                    final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(value);
                    if (!isValid) {
                      return '3-24 long with alphanumeric or underscore';
                    }
                    return null;                    
                  },           
                ),

                const SizedBox(height: 24.0),                

                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  maxLines: 1,
                  autofocus: false,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 1,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),                
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 6) {
                      return 'password length must be 6 char or more';
                    }
                    return null;
                  },           
                ),

                const SizedBox(height: 24.0),

                FilledButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: const Text('Register'),
                ),

                TextButton(
                  onPressed: () {
                    _navigateToLoginPage();
                  },
                  child: const Text('I already have an account'),
                )



              ],
            ),
          ),
        ),
      ),
    );
  }
}