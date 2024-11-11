import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const channel = MethodChannel('flutter_kotlin_calculator/channel');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter And Kotlin Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController firstNumber = TextEditingController();
  final TextEditingController secondNumber = TextEditingController();
  String operation = '+';
  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 5,
                    controller: firstNumber,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: DropdownButton<String>(
                      value: operation,
                      items: const [
                        DropdownMenuItem<String>(
                          value: '+',
                          child: Text('+'),
                        ),
                        DropdownMenuItem<String>(
                          value: '-',
                          child: Text('-'),
                        ),
                        DropdownMenuItem<String>(
                          value: '*',
                          child: Text('*'),
                        ),
                        DropdownMenuItem<String>(
                          value: '/',
                          child: Text('/'),
                        ),
                        DropdownMenuItem<String>(
                          value: '%',
                          child: Text('%'),
                        ),
                      ],
                      onChanged: (item) {
                        setState(() {
                          operation = item ?? operation;
                        });
                      }),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    maxLength: 5,
                    controller: secondNumber,
                    textAlign: TextAlign.center,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(result ?? ''),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await channel.invokeMethod<String>('calculate', {
            'firstNumer': int.parse(firstNumber.text),
            'secondNumer': int.parse(secondNumber.text),
            'operation': operation
          });
          setState(() {
            result = response;
          });
        },
        child: const Text('Calcular'),
      ),
    );
  }
}
