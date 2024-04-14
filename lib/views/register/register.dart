import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

import '../../api/authentication.dart';
import '../../api/regions.dart';
import '../../models/addressarea.dart';

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

  Future<List<Kecamatan>>? _daftarKecamatan;
  Future<List<Kelurahan>>? _daftarKelurahan;

  final TextEditingController _kecamatanController = TextEditingController();
  Kecamatan? _selectedKecamatan;

  final TextEditingController _kelurahanController = TextEditingController();
  Kelurahan? _selectedKelurahan;

  void loadKecamatan() {
    setState(() {
      _daftarKecamatan = Regions().getActiveKecamatan();
    });
  }

  void loadKelurahan() {
    setState(() {
      if (_selectedKecamatan != null) {
        _daftarKelurahan = Regions().getKelurahanByKecamatanId(_selectedKecamatan!.id);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadKecamatan());
    super.initState();
  }

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
                                Column(
                                  children: [
                                    FutureBuilder<List<Kecamatan>> (
                                      future: _daftarKecamatan,
                                      builder:(context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (_selectedKecamatan == null) {
                                            WidgetsBinding.instance
                                              .addPostFrameCallback((_) => setState(() {
                                              _selectedKecamatan = snapshot.data![0];
                                              loadKelurahan();
                                            }));
                                          }
                                          
                                          return DropdownMenu<Kecamatan>(
                                            initialSelection: snapshot.data![0],
                                            controller: _kecamatanController,
                                            requestFocusOnTap: true,
                                            enableSearch: true,
                                            label: const Text('Kecamatan'),
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedKecamatan = value;
                                              });
                                              loadKelurahan();
                                            },
                                            dropdownMenuEntries: snapshot.data!.map((Kecamatan e) => DropdownMenuEntry<Kecamatan>(value: e, label: e.name)).toList(),
                                          );
                                        } else if (snapshot.hasError) {
                                          debugPrint(snapshot.error.toString());
                                          return TextButton(onPressed: () => loadKecamatan(), child: const Text('Terjadi Kesalahan, tekan untuk coba lagi.'));
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    SizedBox(height: 16,),
                                    _daftarKelurahan == null ? const SizedBox(height: 0,) : FutureBuilder<List<Kelurahan>> (
                                      future: _daftarKelurahan,
                                      builder:(context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data!.length == 0) {
                                            WidgetsBinding.instance
                                              .addPostFrameCallback((_) => setState(() {
                                              _selectedKelurahan = null;
                                            }));
                                            return Text('Area Tidak Tersedia');
                                          }
                                          if (_selectedKelurahan == null) {
                                            WidgetsBinding.instance
                                              .addPostFrameCallback((_) => setState(() {
                                              _selectedKelurahan = snapshot.data![0];
                                            }));
                                          }
                                          return DropdownMenu<Kelurahan>(
                                            initialSelection: snapshot.data![0],
                                            controller: _kelurahanController,
                                            requestFocusOnTap: true,
                                            enableSearch: true,
                                            label: const Text('Kelurahan'),
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedKelurahan = value;
                                              });
                                            },
                                            dropdownMenuEntries: snapshot.data!.map((Kelurahan e) => DropdownMenuEntry<Kelurahan>(value: e, label: e.name)).toList(),
                                          );
                                        } else if (snapshot.hasError) {
                                          debugPrint(snapshot.error.toString());
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) => Future.delayed(Durations.extralong4, () => loadKelurahan(),));
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),

                                  ],
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
                                      if (!_formPrivacyPolicyState) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Setujui Privacy Policy untuk melanjutkan")));
                                        return;
                                      }
                                      if (_selectedKecamatan == null || _selectedKelurahan == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mohon untuk memilih lokasi yang tersedia")));
                                        return;
                                      }
                                        
                                      try {
                                        debugPrint("Submitted Register!");
                                        debugPrint("ids ${_selectedKecamatan!.id} ${_selectedKelurahan!.id}");
                                        await Authentication().register(
                                                _formEmailController.text,
                                                _formPasswordController.text,
                                                _formNameController.text,
                                                _formIdCardController.text,
                                                _formPhoneController.text,
                                                _formAddressController.text,
                                                _selectedKecamatan!.id,
                                                _selectedKelurahan!.id,
                                                );
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registrasi Berhasil. Silahkan login")));
                                        if (!context.mounted) return;
                                        context.go('/login');
                                      } catch (error) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
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

