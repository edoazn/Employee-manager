import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/employee_model.dart';
import '../../domain/entities/employee.dart';

abstract class IEmployeeRepository {
  Future<List<Employee>> fetchEmployees({String? search});

  Future<Employee> getEmployee(int id);

  Future<Employee> addEmployee(Employee employee);

  Future<Employee> updateEmployee(Employee employee);

  Future<void> deleteEmployee(String id);
}

class EmployeeRepository implements IEmployeeRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<Employee>> fetchEmployees({String? search}) async {
    try {
      final res = await _dio.get('/employees', queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'sortBy': 'createdAt',
        'order': 'desc',
      });
      final list = (res.data as List)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      list.sort(
          (a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
      return list;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  @override
  Future<Employee> getEmployee(int id) async {
    try {
      final res = await _dio.get('/employees/$id');
      return EmployeeModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  @override
  Future<Employee> addEmployee(Employee employee) async {
    try {
      final model = EmployeeModel(
        name: employee.name,
        position: employee.position,
        salary: employee.salary,
        address: employee.address,
        phone: employee.phone,
        createdAt: employee.createdAt,
      );
      final res =
          await _dio.post('/employees', data: model.toJson(forPost: true));
      return EmployeeModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    if (employee.id == null) {
      throw Exception('ID employee wajib diisi untuk update');
    }
    try {
      final model = EmployeeModel(
        id: employee.id,
        name: employee.name,
        position: employee.position,
        salary: employee.salary,
        address: employee.address,
        phone: employee.phone,
      );
      final res =
          await _dio.put('/employees/${employee.id}', data: model.toJson());
      return EmployeeModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await _dio.delete('/employees/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }
}
