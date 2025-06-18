// ignore_for_file: unused_field, sort_child_properties_last, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:io';

import 'package:elaman_hati/api/petownership.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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

  final TextEditingController _formNameController = TextEditingController();
  final TextEditingController _formDOBController = TextEditingController();
  final TextEditingController _formVaccineController = TextEditingController();
  final TextEditingController _formSterileController = TextEditingController();
  final TextEditingController _formWeightController = TextEditingController();

  final SingleValueDropDownController _genderFormController =
      SingleValueDropDownController();
  final SingleValueDropDownController _petTypeFormController =
      SingleValueDropDownController();

  DateTime? dateOfBirth;
  DateTime? dateOfLastVaccine;
  DateTime? dateOfLastSterile;
  bool _vaccineStatus = false;
  bool _sterileStatus = false;
  Future<Map<int, String>>? _animalTypeMap;
  int? _selectedAnimalTypeId;
  String? _selectedGender;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    final role = GetStorage().read('USER_ROLE');
    _loadAnimalType(role);
  }

  void _loadAnimalType(String role) async {
    try {
      final future = PetOwnership().getAnimalsType(role);
      final result = await future;

      if (!mounted) return;

      setState(() {
        _animalTypeMap = Future.value(result);
      });
    } catch (e) {
      //
    }
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
                _buildTextField(_formNameController, 'Nama Hewan', Icons.star),
                const SizedBox(height: 16),
                FutureBuilder<Map<int, String>>(
                  future: _animalTypeMap,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return TextButton(
                        onPressed: () {
                          final role = GetStorage().read('role') ?? 'peternak';
                          _loadAnimalType(role);
                        },
                        child: const Text(
                            "Gagal memuat jenis hewan. Tekan untuk coba lagi."),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Tidak ada data jenis hewan.");
                    }

                    final Map<int, String> typeMap = snapshot.data!;
                    final List<DropDownValueModel> dropdownList = typeMap
                        .entries
                        .map((e) =>
                            DropDownValueModel(value: e.key, name: e.value))
                        .toList();

                    return Material(
                      elevation: 2,
                      child: DropDownTextField(
                        controller: _petTypeFormController,
                        textFieldFocusNode: FocusNode(),
                        textFieldDecoration: formInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.pets),
                          label: const Text('Jenis Hewan'),
                        ),
                        clearOption: true,
                        enableSearch: true,
                        dropDownItemCount: dropdownList.length,
                        dropDownList: dropdownList,
                        validator: (_) => _selectedAnimalTypeId == null
                            ? 'Mohon pilih jenis hewan'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            if (value is DropDownValueModel) {
                              _selectedAnimalTypeId = value.value;
                            } else {
                              _selectedAnimalTypeId = null;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 16),
                _buildDatePickerField(
                    _formDOBController,
                    'Tanggal Lahir (Perkiraan)',
                    Icons.cake,
                    (picked) => dateOfBirth = picked),
                const SizedBox(height: 16),
                _buildTextField(
                    _formWeightController, 'Berat (kg)', Icons.line_weight,
                    isNumber: true),
                const SizedBox(height: 16),
                _buildSterileSection(),
                const SizedBox(height: 16),
                _buildVaccineSection(),
                const Divider(height: 32),
                _buildImagePickerButton(),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(_imageFile!.path), height: 200),
                    ),
                  ),
                const SizedBox(height: 16),
                _submitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return Material(
      elevation: 2,
      child: TextFormField(
        controller: controller,
        decoration: formInputDecoration.copyWith(
          prefixIcon: Icon(icon),
          label: Text(label),
        ),
        keyboardType: isNumber ? TextInputType.number : null,
        validator: inputFormValidator,
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label,
      IconData icon, Function(DateTime) onDatePicked) {
    return Material(
      elevation: 2,
      child: TextFormField(
        controller: controller,
        decoration: formInputDecoration.copyWith(
          prefixIcon: Icon(icon),
          label: Text(label),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onDatePicked(picked);
            controller.text = DateFormat('dd-MM-yyyy').format(picked);
          }
        },
        validator: inputFormValidator,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Material(
      elevation: 2,
      child: DropDownTextField(
        controller: _genderFormController,
        textFieldDecoration: formInputDecoration.copyWith(
          prefixIcon: const Icon(Icons.wc),
          label: const Text('Sex'),
        ),
        dropDownList: const [
          DropDownValueModel(name: 'Jantan', value: 'Jantan'),
          DropDownValueModel(name: 'Betina', value: 'Betina'),
        ],
        dropDownItemCount: 2,
        onChanged: (value) {
          setState(() =>
              _selectedGender = value is DropDownValueModel ? value.name : '');
        },
        validator: inputFormValidator,
      ),
    );
  }

  Widget _buildSterileSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _sterileStatus
          ? Row(
              key: const Key("sterilFormFieldVisible"),
              children: [
                Flexible(
                    child: _buildDatePickerField(
                        _formSterileController,
                        'Tanggal Steril',
                        Icons.health_and_safety,
                        (picked) => dateOfLastSterile = picked)),
                Checkbox(
                    value: _sterileStatus,
                    onChanged: (state) =>
                        setState(() => _sterileStatus = state ?? false)),
              ],
            )
          : Row(
              key: const Key("sterilFormFieldNotVisible"),
              children: [
                Checkbox(
                    value: _sterileStatus,
                    onChanged: (state) =>
                        setState(() => _sterileStatus = state ?? false)),
                const Text("Peliharaan Sudah Steril")
              ],
            ),
    );
  }

  Widget _buildVaccineSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _vaccineStatus
          ? Row(
              key: const Key("vaksinFormFieldVisible"),
              children: [
                Flexible(
                    child: _buildDatePickerField(
                        _formVaccineController,
                        'Tanggal Vaksin',
                        Icons.vaccines,
                        (picked) => dateOfLastVaccine = picked)),
                Checkbox(
                    value: _vaccineStatus,
                    onChanged: (state) =>
                        setState(() => _vaccineStatus = state ?? false)),
              ],
            )
          : Row(
              key: const Key("vaksinFormFieldNotVisible"),
              children: [
                Checkbox(
                    value: _vaccineStatus,
                    onChanged: (state) =>
                        setState(() => _vaccineStatus = state ?? false)),
                const Text("Peliharaan Sudah Divaksin")
              ],
            ),
    );
  }

  Widget _buildImagePickerButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final source = await showDialog<ImageSource>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Pilih Sumber Gambar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.collections),
                  title: const Text('Galeri'),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
        if (source == null) return;
        final file =
            await _imagePicker.pickImage(source: source, imageQuality: 60);
        if (file != null) setState(() => _imageFile = file);
      },
      icon: const Icon(Icons.camera),
      label: Text(_imageFile == null ? 'Tambahkan Gambar' : 'Ubah Gambar'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: submitDisabled
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                if (_imageFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Mohon untuk menambahkan gambar")),
                  );
                  return;
                }
                setState(() => submitDisabled = true);
                try {
                  // debugPrint("requesting...");
                  // debugPrint(_formNameController.text);
                  // debugPrint(_selectedAnimalTypeId.toString());
                  // debugPrint(_selectedGender);
                  // debugPrint(_formDOBController.text);
                  // debugPrint(_formWeightController.text);
                  // debugPrint(_formSterileController.text);
                  // debugPrint(_formVaccineController.text);
                  // debugPrint('image: ${_imageFile?.name}');

                  final dateFormat = DateFormat('dd-MM-yyyy');

                  await PetOwnership().addAnimal(
                    _formNameController.text,
                    _selectedAnimalTypeId!,
                    _selectedGender!,
                    dateFormat.parse(_formDOBController.text),
                    _formSterileController.text.isNotEmpty
                        ? dateFormat.parse(_formSterileController.text)
                        : null,
                    _formVaccineController.text.isNotEmpty
                        ? dateFormat.parse(_formVaccineController.text)
                        : null,
                    _imageFile!,
                    double.parse(_formWeightController.text),
                  );

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Berhasil menambahkan data!")),
                  );
                  _formNameController.clear();
                  _formDOBController.clear();
                  _formSterileController.clear();
                  _formVaccineController.clear();
                  _formWeightController.clear();
                  _genderFormController.clearDropDown();
                  _petTypeFormController.clearDropDown();
                  setState(() {
                    _imageFile = null;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                } finally {
                  setState(() => submitDisabled = false);
                }
              }
            },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('AJUKAN'),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
