import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEventScreen extends StatefulWidget {
  final String organization;

  const AddEventScreen({Key? key, required this.organization}) : super(key: key);

  @override
  State<AddEventScreen> createState() => AddEventScreenState();
}

class AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedType = 'Treinamento';

  final List<String> allowedOrganizations = ['Sacerdócio', 'Soc. Socorro', 'Geral'];
  final String presidenteUid = 'KIpUZzoiCdQvOom5BDJd5Xij4rA3';

  bool canCreateEvent(String organization, String? uid) {
    return allowedOrganizations.contains(organization) || uid == presidenteUid;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos e selecione uma data.')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (!canCreateEvent(widget.organization, currentUser?.uid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Organização "${widget.organization}" não tem permissão para criar eventos.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': Timestamp.fromDate(_selectedDate!),
        'type': _selectedType,
        'organization': widget.organization,
        'teacherId': currentUser?.uid,
      });

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Erro ao salvar evento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar evento.')),
      );
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate == null
                      ? 'Selecionar data'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
                onTap: _selectDate,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['Aula', 'Reunião', 'Treinamento']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveEvent,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
