class InsuranceServiceModel {
  final String id;
  final String insuranceService;
  final String insuranceNumber;
  final String insuranceEmail;
  final String website;
  final String package;
  final String action;
  bool isExpanded;
  InsuranceServiceModel({
    this.id,
    this.insuranceService,
    this.insuranceNumber,
    this.insuranceEmail,
    this.website,
    this.package,
    this.action,
    this.isExpanded,
  });
}

class ProfileModel {
  final String id;
  final String name;
  final String mobileNo;
  final String email;
  final String ssn;
  final String taxNo;
  final String city;
  final String country;
  final String dob;
  ProfileModel({
    this.id,
    this.name,
    this.mobileNo,
    this.email,
    this.ssn,
    this.taxNo,
    this.city,
    this.country,
    this.dob,
  });
}

class ReceiveDocumentModel {
  final String id;
  final String sentOn;
  final String title;
  final String description;
  final String url;
  final String fileName;
  bool isExpanded;
  ReceiveDocumentModel({
    this.id,
    this.sentOn,
    this.title,
    this.description,
    this.url,
    this.fileName,
    this.isExpanded,
  });
}
