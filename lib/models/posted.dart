class Posted {
  // late String id;
  late String jobName;
  late String company;
  late String category;
  late String email;
  late String contacts;
  late String location;
  late List about;
  late List qualifications;
  late List responsibilities;
  late int createdAt;
  late int updatedAt;

  Posted({
    // required this.id,
    required this.jobName,
    required this.company,
    required this.category,
    required this.location,
    required this.about,
    required this.qualifications,
    required this.responsibilities,
    required this.createdAt,
    required this.updatedAt,
    required email,
    required contacts,
  });

  // Posted.fromJson(Map<String, dynamic> json) {
  //  // id = json['id'];
  //   jobName = json['name'];
  //   category = json['category'];
  //   company = json['companyName'];

  //   location = json['location'];
  //   about = json['about'];
  //   qualifications = json['qualifications'];
  //   responsibilities = json['responsibilities'];
  //   createdAt = json['createdAt'];
  //   updatedAt = json['updatedAt'];
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': jobName,
  //     'category': category,
  //     'companyName': company,
  //     'location': location,
  //     'about': about,
  //     'qualifications': qualifications,
  //     'responsibilities': responsibilities,
  //     'createdAt': createdAt,
  //     'updatedAt': updatedAt,
  //   };
  // }
  factory Posted.fromMap(map) {
    //print(map);
    return Posted(
      jobName: map['jobName'],
      company: map['company'],
      responsibilities: map['Reponsibilities'] as List,
      qualifications: map['Qualifications'] as List,
      location: 'location',
      email: map['email'],
      contacts: map['contacts'],
      about: map['about'] as List,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      category: map['category'],
    );
  }

  //get photoUrl => null;
//sending to server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'jobName': jobName,
      'company': company,
      'Reponsibilities': responsibilities,
      'Qualifications': qualifications,
      'location': location,
      'email': email,
      'contacts': contacts,
      'about': about,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category,
    };
  }
}
