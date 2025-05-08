import 'package:flutter/material.dart';
import 'src/rust/frb_generated.dart'; // initializes the Rust bridge
import 'src/rust/api/simple.dart'; // imports the rust square() function in simple.rs

// starting the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // makes sure flutter/dart is ready
  await RustLib.init(); // initializes the rust code bridge
  runApp(const MyApp());
}

// root (main) widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'noise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black,
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SquarePage(),
    );
  }
}

// main screen with input and result
class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  // call the rust square() function
  void _calculateSquare() {
    final input = int.tryParse(_controller.text);
    if (input != null) {
      final squared = square(num: input);
      setState(() {
        _result = 'Result: $squared';
      });
    } else {
      setState(() {
        _result = 'Invalid number!!!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('noise')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // informative text for white noise devs
              const Text(
                'This app takes a number, sends it to native Rust code,\n'
                'calculates its square and shows the result.\n\n'
                'To update the Rust code, edit `rust/src/api/simple.rs`, then run\n'
                '`flutter_rust_bridge_codegen generate` to update Flutter bindings.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // receives the input
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Enter a number'),
              ),
              const SizedBox(height: 20),

              // the calculate button
              ElevatedButton(
                onPressed: _calculateSquare,
                child: const Text('CALCULATE'),
              ),
              const SizedBox(height: 24),

              // shows the result
              AnimatedOpacity(
                opacity: _result.isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
