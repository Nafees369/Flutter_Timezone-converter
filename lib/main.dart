

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimeZoneConverter(),
    );
  }
}

class TimeZoneConverter extends StatefulWidget {
  const TimeZoneConverter({super.key});

  @override
  _TimeZoneConverterState createState() => _TimeZoneConverterState();
}

class _TimeZoneConverterState extends State<TimeZoneConverter> {
  DateTime? _selectedTime;
  String _selectedTimeZone = 'UTC';
  String _convertedTime = '';

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime.now().copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
        _selectedTime = _selectedTime!.copyWith(minute: pickedTime.minute);
      });
    }
  }

  void _convertTime() {
    final DateTime convertedTime = _selectedTime!.toUtc().add(Duration(hours: _getTimeZoneOffset(_selectedTimeZone)));
    final DateFormat formatter = DateFormat('hh:mm:ss a');
    setState(() {
      _convertedTime = formatter.format(convertedTime);
    });
  }


int _getTimeZoneOffset(String timeZone) {
  try {
    final location = Intl.getLocation(timeZone);


    // Handle locations without time zone data (optional)
    if (location.timeZone == null) {
      print('Time zone data not available for $timeZone');
      return 0; // Or handle it differently
    }

    final now = DateTime.now();
    final offset = location.offsetFromUtc(now).inHours;
    return offset;
  } catch (e) {
    // Handle other errors
    print('Invalid time zone: $timeZone');
    return 0;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Zone Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    child: const Text('Select Time'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimeZone,
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeZone = value!;
                      });
                    },
                    items: [
                      'UTC',
                      'EST',
                      'PST',
                      // Add more time zones as needed
                    ].map((tz) => DropdownMenuItem<String>(
                          value: tz,
                          child: Text(tz),
                        )).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Selected Time: ${_selectedTime?.toLocal().hour}:${_selectedTime?.toLocal().minute}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Converted Time: $_convertedTime',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _convertTime,
              child: const Text('Convert Time'),
            ),
          ],
        ),
      ),
    );
  }
}