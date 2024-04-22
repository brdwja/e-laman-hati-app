import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../../api/animals.dart';
import '../../../models/animaltype.dart';

import '../../../api/regions.dart';
import '../../../models/addressarea.dart';

import '../../../api/report.dart';

class TambahBantuan extends StatefulWidget {
  const TambahBantuan({super.key});
  @override
  State<TambahBantuan> createState() => _TambahBantuanState();
}

class _TambahBantuanState extends State<TambahBantuan> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _formGejalaController = TextEditingController();
  final TextEditingController _formAlamatController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

  Future<List<AnimalType>>? _daftarHewan;
  final TextEditingController _hewanController = TextEditingController();
  AnimalType? _selectedHewan;
  void _loadHewan() {
    setState(() {
      _daftarHewan = Animals().getActiveAnimal();
    });
  }

  Future<List<Kecamatan>>? _daftarKecamatan;
  final TextEditingController _kecamatanController = TextEditingController();
  Kecamatan? _selectedKecamatan;
  void _loadKecamatan() {
    setState(() {
      _daftarKecamatan = Regions().getActiveKecamatan();
    });
  }

  Future<List<Kelurahan>>? _daftarKelurahan;
  final TextEditingController _kelurahanController = TextEditingController();
  Kelurahan? _selectedKelurahan;
  void _loadKelurahan() {
    setState(() {
      if (_selectedKecamatan != null) {
        _daftarKelurahan =
            Regions().getKelurahanByKecamatanId(_selectedKecamatan!.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHewan();
    _loadKecamatan();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: _formGejalaController,
                  decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      prefixIcon: const Icon(Icons.sick),
                      label: const Text("Gejala"),
                      isDense: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon diisi';
                    }
                    return null;
                  },
                  maxLines: null, // Allow multiline input
                  keyboardType:
                      TextInputType.multiline, // Enable multiline keyboard
                  textInputAction:
                      TextInputAction.newline, // Enable new line on enter press
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: _daftarHewan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // if (_selectedHewan == null) {
                      //   WidgetsBinding.instance
                      //       .addPostFrameCallback((_) => setState(() {
                      //             _selectedHewan = snapshot.data![0];
                      //           }));
                      // }
                      return DropdownMenu<AnimalType>(
                        width: 250,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          isDense: true,
                        ),
                        // initialSelection: snapshot.data![0],
                        controller: _hewanController,
                        requestFocusOnTap: true,
                        enableSearch: true,
                        label: const Text('Jenis Hewan'),
                        onSelected: (value) {
                          setState(() {
                            _selectedHewan = value;
                          });
                        },
                        dropdownMenuEntries: snapshot.data!
                            .map((AnimalType e) =>
                                DropdownMenuEntry<AnimalType>(
                                    value: e, label: e.name))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadHewan(),
                          child: const Text(
                              'Terjadi Kesalahan, tekan untuk coba lagi.'));
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const Divider(
                  height: 32,
                ),
                TextFormField(
                  controller: _formAlamatController,
                  decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      prefixIcon: const Icon(Icons.home),
                      label: const Text("Alamat"),
                      isDense: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder<List<Kecamatan>>(
                  future: _daftarKecamatan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // if (_selectedKecamatan == null) {
                      //   WidgetsBinding.instance
                      //       .addPostFrameCallback((_) => setState(() {
                      //             _selectedKecamatan = snapshot.data![0];
                      //             _loadKelurahan();
                      //           }));
                      // }

                      return DropdownMenu<Kecamatan>(
                        width: 250,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          isDense: true,
                        ),
                        // initialSelection: snapshot.data![0],
                        controller: _kecamatanController,
                        requestFocusOnTap: true,
                        enableSearch: true,
                        label: const Text('Kecamatan'),
                        onSelected: (value) {
                          setState(() {
                            _selectedKecamatan = value;
                          });
                          _loadKelurahan();
                        },
                        dropdownMenuEntries: snapshot.data!
                            .map((Kecamatan e) => DropdownMenuEntry<Kecamatan>(
                                value: e, label: e.name))
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
                              if (_selectedKelurahan != null) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => setState(() {
                                          _selectedKelurahan = null;
                                        }));
                              }
                              return const Text('Area Tidak Tersedia');
                            }
                            // if (_selectedKelurahan == null) {
                            //   WidgetsBinding.instance
                            //       .addPostFrameCallback((_) => setState(() {
                            //             _selectedKelurahan = snapshot.data![0];
                            //           }));
                            // }
                            return DropdownMenu<Kelurahan>(
                              width: 250,
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                isDense: true,
                              ),
                              // initialSelection: snapshot.data![0],
                              controller: _kelurahanController,
                              requestFocusOnTap: true,
                              enableSearch: true,
                              label: const Text('Kelurahan'),
                              onSelected: (value) {
                                setState(() {
                                  _selectedKelurahan = value;
                                });
                              },
                              dropdownMenuEntries: snapshot.data!
                                  .map((Kelurahan e) =>
                                      DropdownMenuEntry<Kelurahan>(
                                          value: e, label: e.name))
                                  .toList(),
                            );
                          } else if (snapshot.hasError) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => Future.delayed(
                                      Durations.extralong4,
                                      () => _loadKelurahan(),
                                    ));
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                const Divider(
                  height: 32,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    ImageSource? sourceOption = await showDialog<ImageSource>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pilih Sumber Gambar'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Kamera'),
                                  onTap: () => Navigator.of(context)
                                      .pop(ImageSource.camera),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.collections),
                                  title: const Text('Galeri'),
                                  onTap: () => Navigator.of(context)
                                      .pop(ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    if (sourceOption == null) return;
                    final XFile? imageFile = await _imagePicker.pickImage(
                        source: sourceOption,
                        imageQuality: 60,
                        maxHeight: 3000,
                        maxWidth: 3000);
                    if (imageFile == null) return;
                    setState(() {
                      _imageFile = imageFile;
                    });
                  },
                  icon: const Icon(Icons.camera),
                  label: _imageFile == null
                      ? const Text('Tambahkan Gambar')
                      : const Text("Ubah Gambar"),
                ),
                _imageFile == null
                    ? const SizedBox(
                        height: 0,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_imageFile!.path),
                          height: 200,
                        ),
                      ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedHewan == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Mohon untuk memilih jenis hewan",
                            ),
                          ),
                        );
                      }

                      if (_selectedKecamatan == null || _selectedKelurahan == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Mohon untuk memilih lokasi yang tersedia",
                            ),
                          ),
                        );
                        return;
                      }
                      if (_imageFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Mohon untuk menambahkan gambar",
                            ),
                          ),
                        );
                        return;
                      }
                      debugPrint(
                          "${_formGejalaController.text} ${_selectedHewan?.name} ${_formAlamatController.text} ${_selectedKecamatan?.name} ${_selectedKelurahan?.name} ${_imageFile?.path}");
                      try {
                        await ReportAnimal().create(
                            _formAlamatController.text,
                            _selectedKecamatan!.id,
                            _selectedKelurahan!.id,
                            _formGejalaController.text,
                            _imageFile!,
                            _selectedHewan!.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil mengajukan bantuan!")));
                        _formAlamatController.text = '';
                        _formGejalaController.text = '';
                        DefaultTabController.of(context).animateTo(1);
                        setState(() {
                          _imageFile = null;
                        });
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }
                  },
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(4),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('AJUKAN'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
