class Tenant {
  String name,
      phonenumber,
      address,
      type,
      email,
      website,
      city,
      zipcode,
      state,
      region,
      country;
  String logo;
  int id;

  Tenant(
      {this.address = '',
      this.city = '',
      this.country = '',
      this.email = '',
      this.logo = '',
      this.name = '',
      this.phonenumber = '',
      this.region = '',
      this.state = '',
      this.type = '',
      this.website = '',
      this.zipcode = '',
      this.id = 0});
}
