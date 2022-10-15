import 'package:flutter/material.dart';

class FABAdd extends StatelessWidget {

  final Function()? onPressed;

  const FABAdd({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //backgroundColor: Colors.grey,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.white,),
    
    );
  }
}
