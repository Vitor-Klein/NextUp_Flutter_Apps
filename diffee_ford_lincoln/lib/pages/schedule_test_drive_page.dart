import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleTestDrivePage extends StatefulWidget {
  const ScheduleTestDrivePage({super.key});

  @override
  State<ScheduleTestDrivePage> createState() => _ScheduleTestDrivePageState();
}

class _ScheduleTestDrivePageState extends State<ScheduleTestDrivePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVehicle;

  final _vehicles = const ['F-150', 'Mustang', 'Ranger', 'Bronco', 'Maverick'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _vehicleCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateCtrl.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
        final materialLocalizations = MaterialLocalizations.of(context);
        _timeCtrl.text = materialLocalizations.formatTimeOfDay(
          time,
          alwaysUse24HourFormat: true,
        );
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final snackText = StringBuffer()
      ..writeln('Reservation: Test Drive')
      ..writeln('Name: ${_nameCtrl.text}')
      ..writeln('Phone: ${_phoneCtrl.text}')
      ..writeln('Email: ${_emailCtrl.text}')
      ..writeln('Vehicle: $_selectedVehicle')
      ..writeln('Date: ${_dateCtrl.text}')
      ..writeln('Time: ${_timeCtrl.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackText.toString()),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Aqui você poderia enviar para seu backend/Firestore.
  }

  String? _required(String? v, {String field = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule a Reservation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Test Drive',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Full Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _required(v, field: 'Full Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '(xx) xxxxx-xxxx',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => _required(v, field: 'Phone Number'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final req = _required(v, field: 'Email');
                  if (req != null) return req;
                  final emailRegex = RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                  ); // simples
                  if (!emailRegex.hasMatch(v!.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Vehicle
              DropdownButtonFormField<String>(
                value: _selectedVehicle,
                decoration: const InputDecoration(
                  labelText: 'Vehicle',
                  border: OutlineInputBorder(),
                ),
                items: _vehicles
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedVehicle = v),
                validator: (v) => v == null ? 'Please select a vehicle' : null,
              ),
              const SizedBox(height: 16),

              // Date
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                onTap: _pickDate,
                validator: (v) => _required(v, field: 'Date'),
              ),
              const SizedBox(height: 16),

              // Time
              TextFormField(
                controller: _timeCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                  ),
                ),
                onTap: _pickTime,
                validator: (v) => _required(v, field: 'Time'),
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Schedule'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
