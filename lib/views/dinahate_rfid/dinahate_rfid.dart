// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:elaman_hati/api/dinahate_rfidanimal.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:elaman_hati/models/rfidanimal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

class DinaHateRFID extends StatefulWidget {
  const DinaHateRFID({super.key});

  @override
  State<DinaHateRFID> createState() => _DinaHateRFIDState();
}

class _DinaHateRFIDState extends State<DinaHateRFID> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xffff6392)
        ),
        backgroundColor: Colors.white,
        title: const Text('Cek Data DinaHate'),
        titleTextStyle: const TextStyle(
          color: Color(0xff525f7f),
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
              RFIDCard(),
            ],
      ),
      endDrawer: const NavDrawer(),
    );
  }
}


class RFIDCard extends StatefulWidget {
  RFIDCard({
    super.key,
  });

  @override
  State<RFIDCard> createState() => _RFIDCardState();
}

class _RFIDCardState extends State<RFIDCard> {
  final _formKey = GlobalKey<FormState>();

  final _rfidTextController = TextEditingController();

  var _buttonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children: [
          Card.filled(
            clipBehavior: Clip.hardEdge,
            color: Colors.white,
            elevation: 1,
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff50c8d0)
                      ),
                      child: SizedBox(
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned(
                              top: -280,
                              right: -150,
                              child: Container(
                                width: 400,
                                height: 400,
                                decoration: const BoxDecoration(
                                  color: Color(0xff61cdd5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Image.asset('assets/images/dinahate-putih.png', height: 80,),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Data\nHewan!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, height: 1, color: Colors.white),),
                                  SizedBox(height: 8,),
                                  Text("Ternak dan Liar", style: TextStyle(fontSize: 32, height: 1, color: Colors.white),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                        child: Material(
                          elevation: 2,
                          child: TextFormField(
                            controller: _rfidTextController,
                            validator: (value) => value != null && value.isNotEmpty ? null : "Isi ID Chip",
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              
                              prefixIcon: Icon(Icons.nfc),
                              label: Text("ID Chip"),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          ),
          Positioned(
            bottom: -20,
            left: 20,
            child: ElevatedButton(
              onPressed: _buttonDisabled ? null : () async {
                if (!_formKey.currentState!.validate()) return;
                try {
                  setState(() {
                    _buttonDisabled = true;
                  });
                  final animalData = await DinaHateRFIDAnimalAPI().get(_rfidTextController.text);
                  debugPrint(animalData.toString());
                  if (!context.mounted) return;
                  showModalBottomSheet<void>(
                    isScrollControlled: false,
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return RFIDAnimalContents(animal: animalData,);
                    },
                  );
                } catch (err) {
                  ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                      SnackBar(
                        content: Text(err.toString()),
                      ),
                    );
                } finally {
                  setState(() {
                    _buttonDisabled = false;
                  });
                }
                
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 35),
                backgroundColor: const Color(0xff50c8d0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Lihat Data'),
            ),
          ),
        ],
      );
  }
}


class RFIDAnimalContents extends StatelessWidget {
  const RFIDAnimalContents({required this.animal, super.key});
  final RFIDAnimal animal;

  Widget buildItem(IconData icon, String name, String content) {
    return DefaultTextStyle.merge(
      style: const TextStyle(color: Color(0xff172b4d)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: const Color(0xff172b4d),),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(content, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.clip,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      "${dotenv.env['LAMANHATI_STORAGE']}/${animal.photo}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 200, child: Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                buildItem(Icons.nfc, 'ID Chip', animal.rfidToken),
                const SizedBox(height: 8,),
                buildItem(Icons.person, 'Pemilik', animal.owner),
                const SizedBox(height: 8,),
                buildItem(Icons.pets, 'Jenis', animal.animalType),
                const SizedBox(height: 8,),
                buildItem(Icons.wc, 'Gender', animal.gender),
                const SizedBox(height: 8,),
                buildItem(Icons.scale, 'Weight', "${animal.weight} Kg"),
                const SizedBox(height: 8,),
                buildItem(Icons.cake, 'Usia', animal.getAge()),
                const SizedBox(height: 8,),
                buildItem(Icons.calendar_month, 'Waktu Aduan', DateFormat('HH:mm dd-MM-yyyy').format(animal.timestamp)),
                const SizedBox(height: 32,),
              ],
            ),
          ),
        ),
    );
  }
}