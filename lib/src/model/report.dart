class Report {
  static const createdAtColumn = "createdat";
  static const dayColumn = "dayreport";
  int id;
  String day, content, createdat;

  Report({
    this.id = 0,
    this.content = '',
    this.createdat = '',
    this.day = '',
  });

  Report.fromJSON(Map<String, dynamic> json)
      : this(
          content: json['content'],
          createdat: json['createdat'],
          day: json[dayColumn],
          id: json['id'],
        );

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "content": content,
      dayColumn: day,
      createdAtColumn: createdat,
    };
  }

  Map<String, dynamic> toJSONAPI() {
    return {
      "id": id,
      "content": content,
      "dayreport": day,
    };
  }
}
