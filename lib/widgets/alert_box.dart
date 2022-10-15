import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AlertBox({super.key, required this.controller, required this.onSave, required this.onCancel, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.grey,
          child: const Text(
            "Salvar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.grey,
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
