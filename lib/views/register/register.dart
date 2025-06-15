import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../api/authentication.dart';
import '../../api/regions.dart';
import '../../models/addressarea.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();

  final InputDecoration formInputDecoration = const InputDecoration(
      filled: true,
      prefixIcon: Icon(Icons.egg),
      label: Text("Input"),
      isDense: true);

  String? inputFormValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon diisi';
    }
    return null;
  }

  final TextEditingController _formNameController = TextEditingController();
  final TextEditingController _formPhoneController = TextEditingController();
  final TextEditingController _formIdCardController = TextEditingController();
  final TextEditingController _formAddressController = TextEditingController();
  final TextEditingController _formEmailController = TextEditingController();
  final TextEditingController _formPasswordController = TextEditingController();

  bool _formPrivacyPolicyState = false;

  Future<List<Kecamatan>>? _daftarKecamatan;
  final SingleValueDropDownController _kecamatanFormController =
      SingleValueDropDownController();
  Kecamatan? _selectedKecamatan;
  void _loadKecamatan() {
    setState(() {
      _daftarKecamatan = Regions().getActiveKecamatan();
    });
  }

  Future<List<Kelurahan>>? _daftarKelurahan;
  final SingleValueDropDownController _kelurahanFormController =
      SingleValueDropDownController();
  Kelurahan? _selectedKelurahan;
  void _loadKelurahan() {
    setState(() {
      if (_selectedKecamatan != null) {
        _daftarKelurahan =
            Regions().getKelurahanByKecamatanId(_selectedKecamatan!.id);
      }
    });
  }

  void loadKecamatan() {
    setState(() {
      _daftarKecamatan = Regions().getActiveKecamatan();
    });
  }

  void loadKelurahan() {
    setState(() {
      if (_selectedKecamatan != null) {
        _daftarKelurahan =
            Regions().getKelurahanByKecamatanId(_selectedKecamatan!.id);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadKecamatan());
    super.initState();
  }

  String? _selectedRole;
  final List<DropDownValueModel> _roleList = [
    DropDownValueModel(value: 'peternak', name: 'Peternak'),
    DropDownValueModel(value: 'umum', name: 'Umum'),
  ];
  final SingleValueDropDownController _roleFormController =
      SingleValueDropDownController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.go('/intro'),
      child: Scaffold(
        backgroundColor: const Color(0xfff063c8),
        body: SafeArea(
          child: (Stack(children: [
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
              bottom: 16,
              right: 16,
              child: Image.asset(
                'assets/images/dkpp-putih.png',
                height: 40,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Image.asset(
                      'assets/images/lamanhati-putih.png',
                      width: 200,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'DAFTAR AKUN BARU',
                                style: TextStyle(
                                    color: Color(0xff8898aa),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _formNameController,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.person),
                                        label: const Text('Nama'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _formEmailController,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.email),
                                        label: const Text('Email'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _formPasswordController,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.lock),
                                        label: const Text('Password'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _formPhoneController,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.phone),
                                        label: const Text('Nomor Telepon'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _formIdCardController,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.badge),
                                        label: const Text('No KTP'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      controller: _formAddressController,
                                      decoration: formInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.home),
                                        label: const Text(
                                            'Alamat (Jalan, No, RT/RW)'),
                                      ),
                                      validator: inputFormValidator,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    FutureBuilder<List<Kecamatan>>(
                                      future: _daftarKecamatan,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return DropDownTextField(
                                            controller:
                                                _kecamatanFormController,
                                            textFieldDecoration:
                                                formInputDecoration.copyWith(
                                              prefixIcon: const Icon(
                                                  Icons.location_city),
                                              label: const Text('Kecamatan'),
                                            ),
                                            searchAutofocus: true,
                                            clearOption: true,
                                            enableSearch: true,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value
                                                    is! DropDownValueModel) {
                                                  _selectedKecamatan = null;
                                                } else {
                                                  _selectedKecamatan =
                                                      value.value;
                                                  _loadKelurahan();
                                                }
                                              });
                                            },
                                            validator: inputFormValidator,
                                            dropDownItemCount:
                                                snapshot.data!.length,
                                            dropDownList: snapshot.data!
                                                .map((Kecamatan e) =>
                                                    DropDownValueModel(
                                                        value: e, name: e.name))
                                                .toList(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return TextButton(
                                              onPressed: () => _loadKecamatan(),
                                              child: const Text(
                                                  'Terjadi Kesalahan, tekan untuk coba lagi.'));
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    _daftarKelurahan == null
                                        ? const SizedBox(
                                            height: 0,
                                          )
                                        : FutureBuilder<List<Kelurahan>>(
                                            future: _daftarKelurahan,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.isEmpty) {
                                                  if (_selectedKelurahan !=
                                                      null) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) => setState(() {
                                                                  _selectedKelurahan =
                                                                      null;
                                                                }));
                                                  }
                                                  return const Text(
                                                      'Area Tidak Tersedia');
                                                }
                                                return DropDownTextField(
                                                  controller:
                                                      _kelurahanFormController,
                                                  textFieldDecoration:
                                                      formInputDecoration
                                                          .copyWith(
                                                    prefixIcon: const Icon(
                                                        Icons.holiday_village),
                                                    label:
                                                        const Text('Kelurahan'),
                                                  ),
                                                  searchAutofocus: true,
                                                  clearOption: true,
                                                  enableSearch: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value
                                                          is! DropDownValueModel) {
                                                        _selectedKelurahan =
                                                            null;
                                                      } else {
                                                        _selectedKelurahan =
                                                            value.value;
                                                      }
                                                    });
                                                  },
                                                  validator: inputFormValidator,
                                                  dropDownItemCount:
                                                      snapshot.data!.length,
                                                  dropDownList: snapshot.data!
                                                      .map((Kelurahan e) =>
                                                          DropDownValueModel(
                                                              value: e,
                                                              name: e.name))
                                                      .toList(),
                                                );
                                              } else if (snapshot.hasError) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) =>
                                                        Future.delayed(
                                                          Durations.extralong4,
                                                          () =>
                                                              _loadKelurahan(),
                                                        ));
                                              }
                                              return const CircularProgressIndicator();
                                            },
                                          ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    DropDownTextField(
                                      controller: _roleFormController,
                                      textFieldDecoration:
                                          formInputDecoration.copyWith(
                                        prefixIcon:
                                            const Icon(Icons.person_outline),
                                        label: const Text('Role'),
                                      ),
                                      clearOption: true,
                                      enableSearch: false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value is! DropDownValueModel) {
                                            _selectedRole = null;
                                          } else {
                                            _selectedRole = value.value;
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (_selectedRole == null) {
                                          return 'Pilih role';
                                        }
                                        return null;
                                      },
                                      dropDownItemCount: _roleList.length,
                                      dropDownList: _roleList,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CheckboxListTile(
                                      value: _formPrivacyPolicyState,
                                      onChanged: (value) {
                                        setState(() {
                                          _formPrivacyPolicyState =
                                              value ?? false;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: const Text(
                                        'Saya setuju dengan Privacy Policy',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (!_formPrivacyPolicyState) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Setujui Privacy Policy untuk melanjutkan")));
                                            return;
                                          }
                                          if (_selectedKecamatan == null ||
                                              _selectedKelurahan == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Mohon untuk memilih lokasi yang tersedia")));
                                            return;
                                          }
                                          if (_selectedRole == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Pilih role terlebih dahulu")));
                                            return;
                                          }

                                          try {
                                            await Authentication().register(
                                              _formEmailController.text,
                                              _formPasswordController.text,
                                              _formNameController.text,
                                              _formIdCardController.text,
                                              _formPhoneController.text,
                                              _formAddressController.text,
                                              _selectedKecamatan!.id,
                                              _selectedKelurahan!.id,
                                              _selectedRole!,
                                            );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Registrasi Berhasil. Silahkan login")));
                                            context.go('/login');
                                          } catch (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        error.toString())));
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    const Color(0xffff6392)),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'Buat Akun',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ])),
        ),
      ),
    );
  }
}
