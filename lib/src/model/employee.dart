class Employee {
  final int id;
  final String name;
  final String lastReportDate;

  const Employee(
      {required this.id, required this.name, this.lastReportDate = ''});

  Employee.fromJSON(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: '${json['firstname']} ${json['lastname']}',
          lastReportDate: json['lastreport'] ?? '',
        );
}
