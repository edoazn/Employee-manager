import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/employee_repository.dart';
import '../../domain/entities/employee.dart';
import 'employee_list_provider.dart';


final employeeFormProvider = StateNotifierProvider.autoDispose<EmployeeFormNotifier, AsyncValue<void>>(
      (ref) => EmployeeFormNotifier(ref.read(employeeRepoProvider)),
);


class EmployeeFormNotifier extends StateNotifier<AsyncValue<void>> {
  final IEmployeeRepository _repo;
  EmployeeFormNotifier(this._repo) : super(const AsyncData(null));


  Future<void> submit({Employee? initial, required Employee payload}) async {
    state = const AsyncLoading();
    try {
      if (initial == null || initial.id == null) {
        await _repo.addEmployee(payload);
      } else {
        await _repo.updateEmployee(payload.copyWith(id: initial.id));
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}