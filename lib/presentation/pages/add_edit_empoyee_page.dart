import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/employee.dart';
import '../provider/employee_form_provider.dart';
import '../provider/employee_list_providers.dart';

class AddEditEmployeePage extends ConsumerStatefulWidget {
  final Object? employeeArg; // GoRouter extra
  const AddEditEmployeePage({super.key, this.employeeArg});

  @override
  ConsumerState<AddEditEmployeePage> createState() =>
      _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends ConsumerState<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _position;
  late final TextEditingController _salary;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  Employee? initial;

  @override
  void initState() {
    super.initState();
    if (widget.employeeArg is Employee) {
      initial = widget.employeeArg as Employee;
    }
    _name = TextEditingController(text: initial?.name);
    _position = TextEditingController(text: initial?.position);
    _salary = TextEditingController(text: initial?.salary.toString());
    _address = TextEditingController(text: initial?.address);
    _phone = TextEditingController(text: initial?.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _position.dispose();
    _salary.dispose();
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = initial != null;
    final formState = ref.watch(employeeFormProvider);

    ref.listen(employeeFormProvider, (prev, next) {
      if (prev is AsyncLoading && next is AsyncData) {
// Setelah submit berhasil, refresh list & kembali
        ref.read(employeeListProvider.notifier).fetchAll();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(isEdit ? 'Berhasil diperbarui' : 'Berhasil disimpan')),
        );
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _position,
                  decoration: const InputDecoration(labelText: 'Posisi'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Posisi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _salary,
                  decoration: const InputDecoration(labelText: 'Gaji'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final d = double.tryParse(v ?? '');
                    if (d == null || d <= 0) {
                      return 'Masukkan gaji yang valid (> 0)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  decoration: const InputDecoration(labelText: 'No. Telp'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: formState is AsyncLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(isEdit ? 'Update' : 'Simpan'),
                    onPressed: formState is AsyncLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final payload = Employee(
                                id: initial?.id,
                                name: _name.text.trim(),
                                position: _position.text.trim(),
                                salary: double.parse(_salary.text.trim()),
                                address: _address.text.trim(),
                                phone: _phone.text.trim(),
                              );
                              await ref
                                  .read(employeeFormProvider.notifier)
                                  .submit(
                                    initial: initial,
                                    payload: payload,
                                  );
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
