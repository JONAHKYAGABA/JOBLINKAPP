import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/posted.dart';
import 'package:flutter_application_2/page/detail_page.dart';
import 'package:flutter_application_2/theme.dart';

class PostedCard extends StatefulWidget {
  final String jobName;

  final String company;
  final String about;

  final String location;

  final String qualifications;

  final String responsibilities;

  PostedCard(this.jobName, this.company, this.about, this.location,
      this.qualifications, this.responsibilities);

  @override
  State<PostedCard> createState() => _PostedCardState();
}

class _PostedCardState extends State<PostedCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
                widget.jobName,
                widget.about,
                widget.location,
                widget.company,
                widget.qualifications,
                widget.responsibilities),
          ),
        );
      },
      child: Row(
        children: [
          // Image.network(
          //   postedModel.companyLogo,
          //   height: 45,
          //   width: 45,
          // ),
          SizedBox(
            width: 27,
          ),
          Container(
            width: 230,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: mainColor, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jobName,
                  style: blackTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  widget.company,
                  style: lightTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 18.5,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
