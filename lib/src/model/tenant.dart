class Tenant {
  String name;
  String? phonenumber,
      address,
      type,
      email,
      website,
      city,
      zipcode,
      state,
      region,
      country,
      logo;
  int id;

  Tenant(
      {this.address = '',
      this.city = '',
      this.country = '',
      this.email = '',
      this.logo,
      this.name = '',
      this.phonenumber = '',
      this.region = '',
      this.state = '',
      this.type = '',
      this.website = '',
      this.zipcode = '',
      this.id = 0});

  Tenant.fromJSON(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
        );

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'id': id,
      'logo': logo,
    };
  }
}
