import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/employee_model.dart';
import '../../domain/entities/employee.dart';

abstract class IEmployeeRepository {
  Future<List<Employee>> fetchEmployees({String? search});

  Future<Employee> getEmployee(int id);

  Future<Employee> addEmployee(Employee employee);

  Future<Employee> updateEmployee(Employee employee);

  Future<void> deleteEmployee(int id);
}

class EmployeeRepository implements IEmployeeRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<Employee>> fetchEmployees({String? search}) async {
    try {
      final res = await _dio.get('/employees', queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search,
      });
      final data =
          (res.data as List).map((e) => EmployeeModel.fromJson(e)).toList();
      return data;
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
      );
      final res =
          await _dio.post('/employees', data: model.toJson(forPost: true));
      return EmployeeModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? e.message);
    }
  }

  @override
  Future<void> deleteEmployee(int id) {
    // TODO: implement deleteEmployee
    throw UnimplementedError();
  }

  @override
  Future<Employee> updateEmployee(Employee employee) {
    // TODO: implement updateEmployee
    throw UnimplementedError();
  }
}
