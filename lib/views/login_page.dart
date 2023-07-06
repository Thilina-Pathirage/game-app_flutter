import 'package:flutter/material.dart';
import 'package:gamerev/services/auth_services.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: AspectRatio(
                      aspectRatio: 16 / 7, // adjust this as needed
                      child: Image.asset('images/logo.png'),
                    )),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  cursorColor: Colors.deepOrange,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  cursorColor: Colors.deepOrange,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateEmail(_emailController.text) && _validatePassword(_passwordController.text) ) {
                      try {
                        await _authService.login(
                            _emailController.text, _passwordController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Login successful, Welcome to Dr.OWL!", style: TextStyle(color: Colors.black)),
                            backgroundColor: Color.fromARGB(255, 254, 216, 0),
                          ),
                        );
                        // Navigate to login page
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        // Signup failed, show error message or handle the error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login failed!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email and password is required!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                    }
                  },
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize:
                        const Size(150, 50), // adjust the button size as needed
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
