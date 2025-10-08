import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/employee_repository.dart';
import '../../domain/entities/employee.dart';

final employeeRepoProvider =
    Provider<IEmployeeRepository>((ref) => EmployeeRepository());

final employeeListProvider =
    StateNotifierProvider<EmployeeListNotifier, AsyncValue<List<Employee>>>(
  (ref) => EmployeeListNotifier(ref.read(employeeRepoProvider)),
);

final employeeSearchQueryProvider = StateProvider<String>((ref) => '');

class EmployeeListNotifier extends StateNotifier<AsyncValue<List<Employee>>> {
  final IEmployeeRepository _repo;
  Timer? _debounce;

  EmployeeListNotifier(this._repo) : super(const AsyncLoading()) {
    fetchAll();
  }

  Future<void> fetchAll({String? search}) async {
    state = const AsyncLoading();
    try {
      final data = await _repo.fetchEmployees(search: search);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void onSearchChanged(WidgetRef ref, String q) {
    ref.read(employeeSearchQueryProvider.notifier).state = q;
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 500), () => fetchAll(search: q));
  }

  Future<void> deleteById(int id) async {
    await _repo.deleteEmployee(id);
    await fetchAll(search: null);
  }
}
