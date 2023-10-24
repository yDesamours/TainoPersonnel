class Employee {
  final int id;
  final String name;

  const Employee({required this.id, required this.name});

  Employee.fromJSON(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: '${json['firstname']} ${json['lastname']}',
        );
}
