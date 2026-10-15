import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController(text: '1');
  String _category = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  double _outputValue = 0.001;

  final Map<String, List<String>> _units = {
    'Length': ['Meter', 'Kilometer', 'Centimeter', 'Mile', 'Foot', 'Inch'],
    'Weight': ['Kilogram', 'Gram', 'Pound', 'Ounce'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Data Storage': ['MB', 'GB', 'TB', 'KB', 'Bytes'],
  };

  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0;
    double result = 0;

    if (_category == 'Length') {
      double meters = input;
      if (_fromUnit == 'Kilometer') meters = input * 1000;
      if (_fromUnit == 'Centimeter') meters = input / 100;
      if (_fromUnit == 'Mile') meters = input * 1609.34;
      if (_fromUnit == 'Foot') meters = input * 0.3048;
      if (_fromUnit == 'Inch') meters = input * 0.0254;

      result = meters;
      if (_toUnit == 'Kilometer') result = meters / 1000;
      if (_toUnit == 'Centimeter') result = meters * 100;
      if (_toUnit == 'Mile') result = meters / 1609.34;
      if (_toUnit == 'Foot') result = meters / 0.3048;
      if (_toUnit == 'Inch') result = meters / 0.3048;
    } else if (_category == 'Weight') {
      double kg = input;
      if (_fromUnit == 'Gram') kg = input / 1000;
      if (_fromUnit == 'Pound') kg = input * 0.453592;

      result = kg;
      if (_toUnit == 'Gram') result = kg * 1000;
      if (_toUnit == 'Pound') result = kg / 0.453592;
    } else {
      result = input;
    }

    setState(() => _outputValue = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButton<String>(
            value: _category,
            isExpanded: true,
            items: _units.keys.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
            onChanged: (val) {
              setState(() {
                _category = val!;
                _fromUnit = _units[_category]![0];
                _toUnit = _units[_category]![1];
                _convert();
              });
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Value to Convert',
                      suffixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _fromUnit,
                          items: _units[_category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                          onChanged: (val) {
                            setState(() => _fromUnit = val!);
                            _convert();
                          },
                        ),
                      ),
                    ),
                    onChanged: (_) => _convert(),
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.swap_vert, size: 36, color: Colors.blue),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('Converted Result'),
                    subtitle: Text(
                      '${_outputValue.toStringAsFixed(4)} $_toUnit',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _toUnit,
                        items: _units[_category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (val) {
                          setState(() => _toUnit = val!);
                          _convert();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
