import 'package:flutter/material.dart';

class AuxPage extends StatefulWidget {
  const AuxPage({super.key});

  @override
  State<AuxPage> createState() => _AuxPageState();
}

class _AuxPageState extends State<AuxPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Aux')
      ),
      body: const Center(
          child: Text('Hola mundo!')
      ),
    );
  }
}