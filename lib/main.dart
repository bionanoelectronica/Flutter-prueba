import 'package:flutter/material.dart';
    import 'package:vital_signs_monitor/vital_signs_screen.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Vital Signs Monitor',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const VitalSignsScreen(),
        );
      }
    }
