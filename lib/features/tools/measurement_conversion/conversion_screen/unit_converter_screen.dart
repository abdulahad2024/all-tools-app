import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../conversion_provider/conversion_tools_provider.dart';
import '../conversion_utils/conversion_models.dart';

class UnitConverterScreen extends ConsumerStatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  ConsumerState<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends ConsumerState<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController(text: '1');
  double _outputValue = 0.001;

  final Map<String, List<String>> _units = {
    'Length': ['Meter', 'Kilometer', 'Centimeter', 'Mile', 'Foot', 'Inch'],
    'Weight': ['Kilogram', 'Gram', 'Pound', 'Ounce'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Data Storage': ['MB', 'GB', 'TB', 'KB', 'Bytes'],
  };

  void _convert() {
    final category = ref.read(unitCategoryProvider);
    final fromUnit = ref.read(unitFromProvider);
    final toUnit = ref.read(unitToProvider);

    double input = double.tryParse(_inputController.text) ?? 0;
    double result = 0;

    if (category == 'Length') {
      double meters = input;
      if (fromUnit == 'Kilometer') meters = input * 1000;
      if (fromUnit == 'Centimeter') meters = input / 100;
      if (fromUnit == 'Mile') meters = input * 1609.34;
      if (fromUnit == 'Foot') meters = input * 0.3048;
      if (fromUnit == 'Inch') meters = input * 0.0254;

      result = meters;
      if (toUnit == 'Kilometer') result = meters / 1000;
      if (toUnit == 'Centimeter') result = meters * 100;
      if (toUnit == 'Mile') result = meters / 1609.34;
      if (toUnit == 'Foot') result = meters / 0.3048;
      if (toUnit == 'Inch') result = meters / 0.0254;
    } else if (category == 'Weight') {
      double kg = input;
      if (fromUnit == 'Gram') kg = input / 1000;
      if (fromUnit == 'Pound') kg = input * 0.453592;

      result = kg;
      if (toUnit == 'Gram') result = kg * 1000;
      if (toUnit == 'Pound') result = kg / 0.453592;
    } else {
      result = input;
    }

    setState(() => _outputValue = result);
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(unitCategoryProvider);
    final fromUnit = ref.watch(unitFromProvider);
    final toUnit = ref.watch(unitToProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          convHero('Unit Converter', 'Convert Length, Weight, Temperature and Data Storage units', Colors.deepOrange, Icons.straighten),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: category,
            isExpanded: true,
            items: _units.keys.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
            onChanged: (val) {
              if (val != null) {
                ref.read(unitCategoryProvider.notifier).state = val;
                ref.read(unitFromProvider.notifier).state = _units[val]![0];
                ref.read(unitToProvider.notifier).state = _units[val]![1];
                _convert();
              }
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
                          value: fromUnit,
                          items: _units[category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(unitFromProvider.notifier).state = val;
                              _convert();
                            }
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
                      '${_outputValue.toStringAsFixed(4)} $toUnit',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: toUnit,
                        items: _units[category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(unitToProvider.notifier).state = val;
                            _convert();
                          }
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
