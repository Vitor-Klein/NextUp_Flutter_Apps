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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: .2,
    );

    // Estilos locais só para esta tela (não alteram a lógica)
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
    );

    final filled = theme.inputDecorationTheme.filled ?? true;

    return Scaffold(
      // AppBar minimalista combinando com o gradiente
      appBar: AppBar(
        title: const Text('Question Form'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(.06),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  shadowColor: theme.colorScheme.primary.withOpacity(.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          // Cabeçalho
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.forum_rounded,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tell us a bit about you',
                                      style: headline,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'We’ll use this info to reach out and help you faster.',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(.75),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Divider(height: 24),

                          // NAME
                          TextFormField(
                            controller: _nameCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: const Icon(Icons.person_rounded),
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: _req,
                          ),
                          const SizedBox(height: 12),

                          // EMAIL
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.alternate_email_rounded,
                              ),
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 12),

                          // PHONE
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              hintText: '(XX) XXXXX-XXXX',
                              prefixIcon: const Icon(Icons.phone_rounded),
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: _req,
                          ),
                          const SizedBox(height: 12),

                          // COMPANY
                          TextFormField(
                            controller: _companyCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Company name',
                              prefixIcon: const Icon(Icons.business_rounded),
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: _req,
                          ),
                          const SizedBox(height: 12),

                          // JOB SITE
                          TextFormField(
                            controller: _jobSiteCtrl,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Job site address',
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: _req,
                          ),
                          const SizedBox(height: 12),

                          // HELP TYPE
                          DropdownButtonFormField<String>(
                            value: _selectedHelpType,
                            items: _helpTypes
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.help_center_rounded,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(t),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _submitting
                                ? null
                                : (v) => setState(() => _selectedHelpType = v),
                            decoration: InputDecoration(
                              labelText: 'What can we help you with?',
                              filled: filled,
                              border: fieldBorder,
                              enabledBorder: fieldBorder,
                              focusedBorder: fieldBorder.copyWith(
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                v == null ? 'Please choose an option' : null,
                          ),
                          const SizedBox(height: 20),

                          // SUBMIT
                          SizedBox(
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: _submitting ? null : _submit,
                              icon: _submitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded),
                              label: Text(_submitting ? 'Sending...' : 'Send'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Disclaimer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                size: 18,
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(.7),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'By submitting, you agree to be contacted regarding your request.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
