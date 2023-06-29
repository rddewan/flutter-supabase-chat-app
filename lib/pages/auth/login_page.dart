

import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/dashboard_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {    
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {

      setState(() {
        _isLoading = true;
      });

      try {

        await supabase.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        _navigateToDashboard();
        
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

  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const DashboardPage()), 
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogIn'),
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
                  autofocus: true,
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
            
                const SizedBox(height: 16.0),
            
                TextFormField(            
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  autofocus: false,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
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
                      return 'password is empty';
                    }
                    if (value.length < 6) {
                    return 'password length must be 6 char or more';
                  }
                    return null;                      
                  },           
                ),

                const SizedBox(height: 16.0),
              
                FilledButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: const Text('LogIn'),
                ),
            
                const SizedBox(height: 8.0),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                    const Text("Don't have a account?"),
                  
                    //const SizedBox(width: 8.0,),
                  
                    TextButton(
                      onPressed: () {
                        
                          Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                  
                      },
                      child: const Text("Register"),                    
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}