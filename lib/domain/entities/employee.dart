class Employee {
  final int? id;
  final String name;
  final String position;
  final double salary;
  final String address;
  final String phone;

  const Employee({
    this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.address,
    required this.phone,
  });

  Employee copyWith({
    int? id,
    String? name,
    String? position,
    double? salary,
    String? address,
    String? phone,
  }) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
        salary: salary ?? this.salary,
        address: address ?? this.address,
        phone: phone ?? this.phone,
      );
}
