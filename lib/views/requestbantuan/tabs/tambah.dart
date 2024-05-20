import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';


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

  var submitDisabled = false;

  final TextEditingController _formGejalaController = TextEditingController();
  final TextEditingController _formAlamatController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

  final InputDecoration formInputDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: InputBorder.none,
    
    prefixIcon: Icon(Icons.egg),
    label: Text("Input"),
    isDense: true,
    
  );

  String? inputFormValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon diisi';
    }
    return null;
  }

  Future<List<AnimalType>>? _daftarHewan;
  final SingleValueDropDownController _hewanFormController = SingleValueDropDownController();
  AnimalType? _selectedHewan;
  void _loadHewan() {
    setState(() {
      _daftarHewan = Animals().getActiveAnimal();
    });
  }

  Future<List<Kecamatan>>? _daftarKecamatan;
  final SingleValueDropDownController _kecamatanFormController = SingleValueDropDownController();
  Kecamatan? _selectedKecamatan;
  void _loadKecamatan() {
    setState(() {
      _daftarKecamatan = Regions().getActiveKecamatan();
    });
  }

  Future<List<Kelurahan>>? _daftarKelurahan;
  final SingleValueDropDownController _kelurahanFormController = SingleValueDropDownController();
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
                Material(
                  elevation: 2,
                  child: TextFormField(
                    controller: _formGejalaController,
                    decoration: formInputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.sick),
                      label: const Text('Gejala'),
                    ),
                    validator: inputFormValidator,
                    maxLines: null, // Allow multiline input
                    keyboardType:
                        TextInputType.multiline, // Enable multiline keyboard
                    textInputAction:
                        TextInputAction.newline, // Enable new line on enter press
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: _daftarHewan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Material(
                        elevation: 2,
                        child: DropDownTextField(
                          controller: _hewanFormController,
                          textFieldDecoration: formInputDecoration.copyWith(
                            prefixIcon: const Icon(Icons.pets),
                            label: const Text('Jenis Hewan'),
                          ),
                          searchAutofocus: true,
                          clearOption: true,
                          enableSearch: true,
                          onChanged: (value) {
                            setState(() {
                              if (value is! DropDownValueModel) {
                                _selectedHewan = null;
                              } else {
                                _selectedHewan = value.value;
                              }
                            });
                          },
                          validator: inputFormValidator,
                          dropDownItemCount: snapshot.data!.length,
                          dropDownList: snapshot.data!
                              .map((AnimalType e) => DropDownValueModel(value: e, name: e.name)).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadHewan(),
                          child: const Text(
                              'Terjadi Kesalahan, tekan untuk coba lagi.',
                            ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16,),
                Material(
                  elevation: 2,
                  child: TextFormField(
                    controller: _formAlamatController,
                    decoration: formInputDecoration.copyWith(
                            prefixIcon: const Icon(Icons.home),
                            label: const Text('Alamat'),
                          ),
                    validator: inputFormValidator,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder<List<Kecamatan>>(
                  future: _daftarKecamatan,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Material(
                        elevation: 2,
                        child: DropDownTextField(
                          controller: _kecamatanFormController,
                          textFieldDecoration: formInputDecoration.copyWith(
                            prefixIcon: const Icon(Icons.location_city),
                            label: const Text('Kecamatan'),
                          ),
                          searchAutofocus: true,
                          clearOption: true,
                          enableSearch: true,
                          onChanged: (value) {
                            setState(() {
                              if (value is! DropDownValueModel) {
                                _selectedKecamatan = null;
                              } else {
                                _selectedKecamatan = value.value;
                                _loadKelurahan();
                              }
                            });
                          },
                          validator: inputFormValidator,
                          dropDownItemCount: snapshot.data!.length,
                          dropDownList: snapshot.data!.map((Kecamatan e) => DropDownValueModel(value: e, name: e.name)).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadKecamatan(),
                          child: const Text(
                              'Terjadi Kesalahan, tekan untuk coba lagi.',
                            ),
                          );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                _daftarKelurahan == null ? const SizedBox(height: 0,) : 
                FutureBuilder<List<Kelurahan>>(
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
                      return Material(
                        elevation: 2,
                        child: DropDownTextField(
                          controller: _kelurahanFormController,
                          textFieldDecoration: formInputDecoration.copyWith(
                            prefixIcon: const Icon(Icons.holiday_village),
                            label: const Text('Kelurahan'),
                          ),
                          searchAutofocus: true,
                          clearOption: true,
                          enableSearch: true,
                          onChanged: (value) {
                            setState(() {
                              if (value is! DropDownValueModel) {
                                _selectedKelurahan = null;
                              } else {
                                _selectedKelurahan = value.value;
                              }
                            });
                          },
                          validator: inputFormValidator,
                          dropDownItemCount: snapshot.data!.length,
                          dropDownList: snapshot.data!.map((Kelurahan e) => DropDownValueModel(value: e, name: e.name)).toList(),
                        ),
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
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
                  onPressed: submitDisabled ? null : () async {
                    // debugPrint(_selectedHewan.toString());
                    // debugPrint(_selectedHewan?.name);
                    // debugPrint(_selectedKecamatan.toString());
                    // debugPrint(_selectedKecamatan?.name);
                    // debugPrint(_selectedKelurahan.toString());
                    // debugPrint(_selectedKelurahan?.name);
                    // return;
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
                        setState(() {
                          submitDisabled = true;
                        });
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
                        _hewanFormController.clearDropDown();
                        _kecamatanFormController.clearDropDown();
                        _kelurahanFormController.clearDropDown();
                        setState(() {
                          _selectedHewan = null;
                          _selectedKecamatan = null;
                          _selectedKelurahan = null;
                          _daftarKelurahan = null;
                        });
                        DefaultTabController.of(context).animateTo(0);
                        setState(() {
                          _imageFile = null;
                        });
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      } finally {
                        setState(() {
                          submitDisabled = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
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
