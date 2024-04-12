import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

import '../../api/authentication.dart';

class Registerpage extends StatefulWidget {
  Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _formNameController = TextEditingController();
  final TextEditingController _formPhoneController = TextEditingController();
  final TextEditingController _formIdCardController = TextEditingController();
  final TextEditingController _formAddressController = TextEditingController();
  final TextEditingController _formEmailController = TextEditingController();
  final TextEditingController _formPasswordController = TextEditingController();

  bool _formPrivacyPolicyState = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.go('/intro'),
      child: Scaffold(
        backgroundColor: Color(0xfff063c8),
        body: SafeArea(
          child: (Stack(
            children: [
              Positioned(
                top: -32,
                right: -196,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
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
                  decoration: BoxDecoration(
                    color: Color(0xfff172cd),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Image.asset('assets/images/dkpp-putih.png'),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset('assets/images/lamanhati-putih.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('DAFTAR AKUN BARU', style: TextStyle(color: Color(0xff8898aa), fontWeight: FontWeight.w600),),
                            const SizedBox(height: 16,),
                            Form(
                              key: _formKey,
                              child: Column(
                              children: [
                                TextFormField(
                                  controller: _formNameController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.person),
                                    label: Text("Nama"),
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
                                  controller: _formPhoneController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.phone),
                                    label: Text("Nomor Telepon"),
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
                                  controller: _formIdCardController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.badge),
                                    label: Text("No KTP"),
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
                                  controller: _formAddressController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.home),
                                    label: Text("Alamat"),
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
                                  controller: _formEmailController,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(Icons.email),
                                    label: Text("Email"),
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
                                    prefixIcon: Icon(Icons.lock),
                                    label: Text("Password"),
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
                                Row(children: [
                                  Checkbox(value: _formPrivacyPolicyState, onChanged: (state) => setState(() {
                                    _formPrivacyPolicyState = state ?? false;
                                  })),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(text: "I agree with the ", style: TextStyle(color: Colors.black)),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()..onTap = () => {}
                                        ),
                                      ]
                                    ),
                                  ),
                                ],),
                                const SizedBox(height: 16,),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (_formPrivacyPolicyState) {
                                        try {
                                          debugPrint("Submitted Register!");
                                          await Authentication().register(_formEmailController.text, _formPasswordController.text, _formNameController.text, _formIdCardController.text, _formPhoneController.text, _formAddressController.text);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registrasi Berhasil. Silahkan login")));
                                          if (!context.mounted) return;
                                          context.go('/login');
                                        } catch (error) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                                        }
                                        
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Setujui Privacy Policy untuk melanjutkan")));
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    
                                    backgroundColor: MaterialStateProperty.resolveWith((states) => Color(0xffff6392)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('Buat Akun', style: TextStyle(color: Colors.white),),
                                  ),
                                )
                              ],
                              ),
                            )
                            ],
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
              
            ]
          )),
        ),
      ),
    );
  }
}

