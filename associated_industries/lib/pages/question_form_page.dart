import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class QuestionFormPage extends StatefulWidget {
  const QuestionFormPage({super.key});

  @override
  State<QuestionFormPage> createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _jobSiteCtrl = TextEditingController();

  final List<String> _helpTypes = const ['Call', 'Quote', 'General Questions'];
  String? _selectedHelpType;

  bool _submitting = false;

  // Use a MESMA região configurada na sua Function (southamerica-east1)
  late final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'southamerica-east1',
  );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _companyCtrl.dispose();
    _jobSiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHelpType == null) {
      _showSnack('Please select how we can help.');
      return;
    }

    setState(() => _submitting = true);

    try {
      final callable = _functions.httpsCallable('sendQuestionForm');
      final resp = await callable.call<Map<String, dynamic>>({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'company_name': _companyCtrl.text.trim(),
        'job_site_address': _jobSiteCtrl.text.trim(),
        'help_type': _selectedHelpType!,
        // opcional: 'to': 'destinatario@seuemail.com'
      });

      final data = resp.data;
      final ok = data['ok'] == true;

      if (ok) {
        if (mounted) {
          _showSnack('Sent successfully! We will contact you soon.');
          _formKey.currentState!.reset();
          setState(() => _selectedHelpType = null);
        }
      } else {
        final err = (data['error'] ?? 'Unknown error').toString();
        _showSnack('Error: $err');
      }
    } on FirebaseFunctionsException catch (e) {
      // Erros vindos da Function
      _showSnack('Error: ${e.message ?? e.code}');
    } catch (e) {
      _showSnack('Network/client error. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final e = v.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);
    if (!ok) return 'Invalid e-mail';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Question Form')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      'Tell us a bit about you',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    // Name
                    TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 12),

                    // Phone
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '(XX) XXXXX-XXXX',
                        border: OutlineInputBorder(),
                      ),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),

                    // Company name
                    TextFormField(
                      controller: _companyCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Company name',
                        border: OutlineInputBorder(),
                      ),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),

                    // Job site address
                    TextFormField(
                      controller: _jobSiteCtrl,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Job site address',
                        border: OutlineInputBorder(),
                      ),
                      validator: _req,
                    ),
                    const SizedBox(height: 12),

                    // Help type
                    DropdownButtonFormField<String>(
                      value: _selectedHelpType,
                      items: _helpTypes
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: _submitting
                          ? null
                          : (v) => setState(() => _selectedHelpType = v),
                      decoration: const InputDecoration(
                        labelText: 'What can we help you with?',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null ? 'Please choose an option' : null,
                    ),
                    const SizedBox(height: 20),

                    // Submit
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Send'),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'By submitting, you agree to be contacted regarding your request.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
