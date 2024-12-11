import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

import '../../api/authentication.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _formEmailController = TextEditingController();

  final TextEditingController _formPasswordController = TextEditingController();

  bool _loginButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.go('/intro'),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff063c8),
        body: (Stack(
          children: [
            Positioned(
              top: -32,
              right: -196,
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  color: Color(0xfff172cd),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -250,
              bottom: -16,
              child: Container(
                width: 500,
                height: 500,
                decoration: const BoxDecoration(
                  color: Color(0xfff172cd),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: Image.asset('assets/images/cat2.png'),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Image.asset('assets/images/dkpp-putih.png', height: 40,),
            ),
            Positioned(
            bottom: 64,
            right: 16,
            child: ElevatedButton(
                onPressed: _loginButtonDisabled ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    
                    try {
                      setState(() {
                        _loginButtonDisabled = true;
                      });
                      await Authentication().login(_formEmailController.text, _formPasswordController.text);
                      // print(await Authentication().getToken());
                      _formEmailController.text = '';
                      _formPasswordController.text = '';
                      if (!context.mounted) return;
                      context.go('/');
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                    } finally {
                      setState(() {
                        _loginButtonDisabled = false;
                      });
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => _loginButtonDisabled ? Colors.grey : Colors.yellow),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(_loginButtonDisabled ? 'Loading' : 'Masuk'),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 96, bottom: 64),
                  child: Image.asset('assets/images/lamanhati-putih.png', width: 200,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: "Belum ada akun? "),
                          TextSpan(
                            text: "buat baru.",
                            style: const TextStyle(color: Colors.yellow),
                            recognizer: TapGestureRecognizer()..onTap = () => context.go("/register")
                          ),
                        ]
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Form(
                      key: _formKey,
                      child: Column(
                      children: [
                        TextFormField(
      
                          controller: _formEmailController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                            label: const Text("Email"),
                            isDense: true
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          controller: _formPasswordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold,
      
                            ),
                            filled: true,
                            prefixIcon: const Icon(Icons.lock),
                            label: const Text("Password"),
                            isDense: true
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon diisi';
                            }
                            return null;
                          },
                        ),
                        
                      ],
                    ),)
                    ],
                  )
                ),
              ],
            ),
            
          ]
        )),
      ),
    );
  }
}

