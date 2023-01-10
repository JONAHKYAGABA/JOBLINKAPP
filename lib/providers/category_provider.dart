import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/job.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider with ChangeNotifier {
  // Future<List<Job>> getCategories() async {
  //   try {
  //     var response = await http
  //         .get(Uri.parse('https://bwa-jobs.herokuapp.com/categories'));

  //     print('status code : ${response.statusCode}');
  //     print('body : ${response.body}');

  //     if (response.statusCode == 200) {
  //       List<Job> job = [];
  //       List data = jsonDecode(response.body);

  //       data.forEach((category) {
  //         job.add(Job.fromJson(category));
  //       });

  //       return job;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

}
