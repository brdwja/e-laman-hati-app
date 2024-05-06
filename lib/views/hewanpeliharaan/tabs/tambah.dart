import 'dart:io';

import 'package:elaman_hati/api/petownership.dart';
import 'package:elaman_hati/models/idvalue.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:intl/intl.dart';

class TambahHewanPeliharaan extends StatefulWidget {
  const TambahHewanPeliharaan({super.key});
  @override
  State<TambahHewanPeliharaan> createState() => _TambahHewanPeliharaanState();
}

class _TambahHewanPeliharaanState extends State<TambahHewanPeliharaan> {
  final _formKey = GlobalKey<FormState>();

  var submitDisabled = false;

  final InputDecoration formInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: InputBorder.none,
    prefixIcon: const Icon(Icons.egg),
    label: const Text("Input"),
    isDense: true,
    
  );

  String? inputFormValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mohon diisi';
    }
    return null;
  }

  final TextEditingController _formNameController = TextEditingController();

  final TextEditingController _formDOBController = TextEditingController();
  DateTime? dateOfBirth;

  bool _vaccineStatus = false;
  final TextEditingController _formVaccineController = TextEditingController();
  DateTime? dateOfLastVaccine;

  bool _sterileStatus = false;
  final TextEditingController _formSterileController = TextEditingController();
  DateTime? dateOfLastSterile;


  Future<List<IDValue>>? _genderList;
  final SingleValueDropDownController _genderFormController = SingleValueDropDownController();
  IDValue? _selectedGender;
  void _loadGender() {
    setState(() {
      _genderList = PetOwnership().getGenders();
    });
  }

  Future<List<IDValue>>? _petTypeList;
  final SingleValueDropDownController _petTypeFormController = SingleValueDropDownController();
  IDValue? _selectedPetType;
  void _loadPetType() {
    setState(() {
      _petTypeList = PetOwnership().getPetTypes();
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadGender();
    _loadPetType();
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
                    controller: _formNameController,
                    decoration: formInputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.star),
                      label: const Text('Nama Hewan'),
                    ),
                    validator: inputFormValidator,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: _petTypeList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Material(
                        elevation: 2,
                        child: DropDownTextField(
                          controller: _petTypeFormController,
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
                                _selectedPetType = null;
                              } else {
                                _selectedPetType = value.value;
                              }
                            });
                          },
                          validator: inputFormValidator,
                          dropDownItemCount: snapshot.data!.length,
                          dropDownList: snapshot.data!
                              .map((IDValue e) => DropDownValueModel(value: e, name: e.name)).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadPetType(),
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
                FutureBuilder(
                  future: _genderList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Material(
                        elevation: 2,
                        child: DropDownTextField(
                          controller: _genderFormController,
                          textFieldDecoration: formInputDecoration.copyWith(
                            prefixIcon: const Icon(Icons.wc),
                            label: const Text('Sex'),
                          ),
                          searchAutofocus: true,
                          clearOption: true,
                          enableSearch: true,
                          onChanged: (value) {
                            setState(() {
                              if (value is! DropDownValueModel) {
                                _selectedGender = null;
                              } else {
                                _selectedGender = value.value;
                              }
                            });
                          },
                          validator: inputFormValidator,
                          dropDownItemCount: snapshot.data!.length,
                          dropDownList: snapshot.data!
                              .map((IDValue e) => DropDownValueModel(value: e, name: e.name)).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return TextButton(
                          onPressed: () => _loadGender(),
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
                Material(
                  elevation: 2,
                  child: TextFormField(
                    controller: _formDOBController,
                    decoration: formInputDecoration.copyWith(
                      prefixIcon: const Icon(Icons.cake),
                      label: const Text('Tanggal Lahir (Perkiraan)'),
                    ),
                    validator: inputFormValidator,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? chosenDate = await showDatePicker(context: context, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: DateTime.now());
                      if (chosenDate != null) {
                        dateOfBirth = chosenDate;
                        _formDOBController.text = DateFormat('dd-MM-yyyy').format(chosenDate);
                      }
                    },
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _sterileStatus ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                          key: const Key("sterilFormFieldVisible"),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Material(
                                elevation: 2,
                                child: TextFormField(
                                  controller: _formSterileController,
                                  decoration: formInputDecoration.copyWith(
                                    prefixIcon: const Icon(Icons.health_and_safety),
                                    label: const Text('Tanggal Steril'),
                                  ),
                                  validator: inputFormValidator,
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    DateTime? chosenDate = await showDatePicker(context: context, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: DateTime.now());
                                    if (chosenDate != null) {
                                      dateOfLastSterile = chosenDate;
                                      _formSterileController.text = DateFormat('dd-MM-yyyy').format(chosenDate);
                                    }
                                  },
                                ),
                              ),
                            ),
                            Checkbox(value: _sterileStatus, onChanged: (state) => setState(() {_sterileStatus = state ?? false;})),
                          ],
                        ),
                  )
                      : Row(
                      key: const Key("sterilFormFieldNotVisible"),
                      children: [
                        Checkbox(value: _sterileStatus, onChanged: (state) => setState(() {
                        _sterileStatus = state ?? false;
                      })),  
                      const Text("Peliharaan Sudah Steril")
                      ],
                    ),
                ),
                SizedBox(height: _vaccineStatus ? 16 : 0,),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _vaccineStatus ? Row(
                        key: const Key("vaksinFormFieldVisible"),
                        children: [
                          Flexible(
                            child: Material(
                              elevation: 2,
                              child: TextFormField(
                                controller: _formVaccineController,
                                decoration: formInputDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.vaccines),
                                  label: const Text('Tanggal Vaksin'),
                                ),
                                validator: inputFormValidator,
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  DateTime? chosenDate = await showDatePicker(context: context, firstDate: DateTime.fromMillisecondsSinceEpoch(0), lastDate: DateTime.now());
                                  if (chosenDate != null) {
                                    dateOfLastVaccine = chosenDate;
                                    _formVaccineController.text = DateFormat('dd-MM-yyyy').format(chosenDate);
                                  }
                                },
                              ),
                            ),
                          ),
                          Checkbox(value: _vaccineStatus, onChanged: (state) => setState(() {_vaccineStatus = state ?? false;})),
                        ],
                      )
                      : Row(
                      key: const Key("vaksinFormFieldNotVisible"),
                      children: [
                        Checkbox(value: _vaccineStatus, onChanged: (state) => setState(() {
                        _vaccineStatus = state ?? false;
                      })),  
                      const Text("Peliharaan Sudah Divaksin")
                      ],
                    ),
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
                      try {
                        setState(() {
                          submitDisabled = true;
                        });
                        debugPrint("requesting");
                        await PetOwnership().create(
                          _imageFile!,
                          _selectedGender!.id,
                          _selectedPetType!.id,
                          dateOfLastSterile,
                          dateOfLastVaccine,
                          dateOfBirth!,
                          _formNameController.text,
                        );
                        debugPrint("requesting done");
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil mengajukan bantuan!")));
                        _imageFile = null;
                        _formNameController.text = '';
                        _genderFormController.clearDropDown();
                        _petTypeFormController.clearDropDown();
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    
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
