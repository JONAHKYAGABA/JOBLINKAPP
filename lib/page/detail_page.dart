import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/posted.dart';
import 'package:flutter_application_2/page/apply.dart';
import 'package:flutter_application_2/theme.dart';

class DetailPage extends StatefulWidget {
  final String jobName;

  final String about;

  final String location;

  final String company;

  final String qualifications;

  final String responsibilities;

  DetailPage(this.jobName, this.about, this.location, this.company,
      this.qualifications, this.responsibilities);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isClicked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: isClicked ? 80 : 30,
          ),
          isClicked ? Container() : successApplyMessage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.network(
              //   widget.postItem.companyLogo,
              //   width: 60,
              //   height: 60,
              // ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.jobName,
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${widget.company}, Inc • ${widget.location}',
                style: lightTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: edge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //NOTE:ABOUT THE JOB
                Text(
                  'About the job',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icon_dot.png',
                          height: 12,
                          width: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            widget.about,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),

                SizedBox(
                  height: 30,
                ),
                //NOTE:QUALIFICATIONS
                Text(
                  'Qualifications',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/icon_dot.png',
                          height: 12,
                          width: 12,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 300,
                        child: Flexible(
                          child: Text(
                            widget.qualifications,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ]),

                SizedBox(
                  height: 30,
                ),
                //NOTE:Responsibilities

                Text(
                  'Responsibilities',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.asset(
                            'assets/images/icon_dot.png',
                            height: 12,
                            width: 12,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            widget.responsibilities,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 80),
            child: ElevatedButton(
              style: isClicked ? signInButtonStyle : signInButtonRedStyle,
              onPressed: () {
                setState(() {
                  String company = widget.company;
                  isClicked = !isClicked;
                  print(isClicked);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Apply(
                        company: company,
                      ),
                    ),
                  );
                });
              },
              child: Text(
                'Apply for Job',
                style: whiteTextStyle,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Message Recruiter',
              style: lightTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}

Widget successApplyMessage() {
  return Center(
    child: Container(
      margin: EdgeInsets.only(
        bottom: 30,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            49,
          ),
        ),
      ),
      child: Text(
        'You have applied this job and the \nrecruiter will contact you',
        textAlign: TextAlign.center,
        style: lightTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
