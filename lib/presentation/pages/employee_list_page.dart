import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/employee.dart';
import '../provider/employee_list_providers.dart';
import '../widgets/employee_card.dart';

class EmployeeListPage extends ConsumerWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(employeeListProvider);
    final query = ref.watch(employeeSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Karyawan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama karyawan...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
              onChanged: (v) => ref
                  .read(employeeListProvider.notifier)
                  .onSearchChanged(ref, v),
            ),
          ),
        ),
      ),
      body: listState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async =>
              ref.read(employeeListProvider.notifier).fetchAll(search: query),
          child: items.isEmpty
              ? const Center(child: Text('Belum ada data'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => _EmployeeTile(emp: items[i]),
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Gagal memuat data\n$e', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => ref
                      .read(employeeListProvider.notifier)
                      .fetchAll(search: query),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _EmployeeTile extends ConsumerWidget {
  final Employee emp;

  const _EmployeeTile({required this.emp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmployeeCard(
      emp: emp,
      onTap: () => context.push('/edit', extra: emp),
      onEdit: () => context.push('/edit', extra: emp),
      onDelete: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hapus Data'),
            content: Text('Yakin ingin menghapus ${emp.name}?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Hapus')),
            ],
          ),
        );
        if (ok == true) {
          await ref.read(employeeListProvider.notifier).deleteById(emp.id!);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Data dihapus')));
        }
      },
    );
  }
}
