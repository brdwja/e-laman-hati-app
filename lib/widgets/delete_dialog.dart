// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

Future<void> deleteDialog({
  required BuildContext context,
  required Future<void> Function() onMisData,
  required VoidCallback onDead,
}) async {
  bool isLoading = false;
  bool isSecondConfirm = false;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                isSecondConfirm ? "Konfirmasi Penghapusan" : "Konfirmasi Hapus",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            content: SizedBox(
              height: isLoading ? 40 : 10,
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox.shrink(),
              ),
            ),
            actions: isLoading
                ? []
                : <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: isSecondConfirm
                          ? [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFB0BEC5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Batal'),
                                onPressed: () {
                                  setState(() => isSecondConfirm = false);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xffff6392),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Hapus'),
                                onPressed: () async {
                                  setState(() => isLoading = true);
                                  await onMisData();
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              ),
                            ]
                          : [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFB0BEC5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Mati'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onDead();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xffff6392),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kesalahan data'),
                                onPressed: () {
                                  setState(() => isSecondConfirm = true);
                                },
                              ),
                            ],
                    ),
                  ],
          );
        },
      );
    },
  );
}
