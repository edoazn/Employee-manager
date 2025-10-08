import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    super.id,
    required super.name,
    required super.position,
    required super.salary,
    required super.address,
    required super.phone,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: (json['employeeID'] ?? json['id']) is String
            ? int.tryParse(json['employeeID'] ?? json['id'])
            : (json['employeeID'] ?? json['id']) as int?,
        name: json['name'] as String,
        position: json['position'] as String,
        salary: (json['salary'] as num).toDouble(),
        address: json['address'] as String? ?? '-',
        phone: json['phone'] as String? ?? '-',
      );

  Map<String, dynamic> toJson({bool forPost = false}) {
    final map = <String, dynamic>{
      'name': name,
      'position': position,
      'salary': salary,
      'address': address,
      'phone': phone,
    };
    if (!forPost && id != null) map['employeeID'] = id;
    return map;
  }
}
