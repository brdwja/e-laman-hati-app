// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

Future<void> deleteDialog({
  required BuildContext context,
  required Future<void> Function() onMisData,
  required Future<void> Function() onDead,
}) async {
  bool isLoading = false;
  bool isSecondConfirm = false;
  bool isSecondConfirmDead = false;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                isSecondConfirm
                    ? "Konfirmasi Penghapusan Data Salah"
                    : isSecondConfirmDead
                        ? "Konfirmasi Hewan Mati"
                        : "Konfirmasi Hapus",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            content: SizedBox(
              height: isLoading ? 40 : 10,
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
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
                                style: _cancelStyle(),
                                child: const Text('Batal'),
                                onPressed: () {
                                  setState(() => isSecondConfirm = false);
                                },
                              ),
                              TextButton(
                                style: _deleteStyle(),
                                child: const Text('Hapus'),
                                onPressed: () async {
                                  setState(() => isLoading = true);
                                  await onMisData();
                                  if (context.mounted)
                                    Navigator.of(context).pop();
                                },
                              ),
                            ]
                          : isSecondConfirmDead
                              ? [
                                  TextButton(
                                    style: _cancelStyle(),
                                    child: const Text('Batal'),
                                    onPressed: () {
                                      setState(
                                          () => isSecondConfirmDead = false);
                                    },
                                  ),
                                  TextButton(
                                    style: _deleteStyle(),
                                    child: const Text('Konfirmasi'),
                                    onPressed: () async {
                                      setState(() => isLoading = true);
                                      await onDead();
                                      if (context.mounted)
                                        Navigator.of(context).pop();
                                    },
                                  ),
                                ]
                              : [
                                  TextButton(
                                    style: _deleteStyle(),
                                    child: const Text('Mati'),
                                    onPressed: () {
                                      setState(
                                          () => isSecondConfirmDead = true);
                                    },
                                  ),
                                  TextButton(
                                    style: _deleteStyle(),
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

ButtonStyle _cancelStyle() => TextButton.styleFrom(
      backgroundColor: const Color(0xFFB0BEC5),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

ButtonStyle _deleteStyle() => TextButton.styleFrom(
      backgroundColor: const Color(0xffff6392),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
