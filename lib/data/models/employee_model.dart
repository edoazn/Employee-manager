import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    super.id,
    required super.name,
    required super.position,
    required super.salary,
    required super.address,
    required super.phone,
    super.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: (json['id'] ?? json['employeeID']).toString(),
        name: json['name'] as String,
        position: json['position'] as String,
        salary: double.tryParse(json['salary']?.toString() ?? '') ?? 0.0,
        address: json['address'] as String? ?? '-',
        phone: json['phone'] as String? ?? '-',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson({bool forPost = false}) {
    final map = <String, dynamic>{
      'name': name,
      'position': position,
      'salary': salary,
      'address': address,
      'phone': phone,
      if (forPost) 'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    };
    if (!forPost && id != null) map['employeeID'] = id;
    return map;
  }
}
