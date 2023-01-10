class Job {
  late String id;
  late String jobName;
  late String imageUrl;
  late int createdAt;
  late int updatedAt;

  Job({
    required this.id,
    required this.jobName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobName = json['name'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': jobName,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
