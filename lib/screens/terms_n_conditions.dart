import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsNConditions extends StatelessWidget {
  TextStyle normalTextStyle = TextStyle(color: Colors.white, fontSize: 15);
  TextStyle boldTextStyle =
      TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
  TextStyle extraboldTextStyle =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

  //TODO: BULLET POINTS GE HERE:
  final lba = [
    "By accepting this User Agreement, either through clicking ‘proceed’ or clicking a box indicating acceptance on our website or mobile application.",
    "You represent and warrant that You have read, understood, and agree to be bound by this User Agreement executed between You and us.",
    "BIL may amend/modify these terms and conditions at any time, and such modifications shall be effective immediately upon posting of the modified terms and conditions on the website or mobile application. You may review the modified terms and conditions periodically to be aware of such modifications and your continued access or use of the Firm’s Services, shall be deemed conclusive proof of your acceptance of these terms and conditions, as amended/modified from time to time. BIL may also suspend the operation of their Services for support or technical upgradation, maintenance work, in order to update the content or for any other reason.",
    "If You utilize the Services in a manner inconsistent with this User Agreement, BIL may terminate your access, block your future access and/or seek such additional relief as the circumstances of your misuse may be deemed to be fit and proper."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BaseCanvas(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: buildTnCListView(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchWhatsApp(phone: "+91-9920165555", message: "");
        },
        elevation: 10,
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/whatsapp_green_logo.png',
                fit: BoxFit.fill,
              ),
            )),
      ),
    );
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      Fluttertoast.showToast(
          msg: "Could not send message to $phone",
          backgroundColor: Color(0xffBF3B38),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      throw 'Could not launch ${url()}';
    }
  }

  Widget buildTnCListView() {
    final _markDownData = lba.map((x) => "- $x\n").reduce((x, y) => "$x$y");
    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "M/s. My Neighbourhood Property Solutions is a partnership firm registered under the law of India, (hereinafter referred to as “We” or “Us” or “Firm” or “BIL”).",
          style: normalTextStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "We offer individuals, businesses, and organizations a platform that enables them to list for the purpose of sale/ rental of property, find a property, and related property services, etc. through the services provided on our website (www.myneighbourhoodonline.com) and mobile application (if applicable) [Hereinafter referred to as “Services”].",
          style: normalTextStyle,
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            style: normalTextStyle,
            children: <TextSpan>[
              TextSpan(text: "User", style: boldTextStyle),
              TextSpan(text: ' or'),
              TextSpan(text: "You ", style: boldTextStyle),
              TextSpan(
                  text:
                      "is defined as an individual or corporate subscriber for the Services and the signatory, whose particulars are contained in the application form and includes his successors and permitted assignees."),
              TextSpan(text: "User", style: boldTextStyle),
              TextSpan(text: ' or'),
              TextSpan(text: "You ", style: boldTextStyle),
              TextSpan(
                  text:
                      ' also includes any person who access or avail the Services of the Firm for the purpose of hosting, publishing, sharing, transacting, displaying or uploading information or views and includes other persons jointly participating in using the Services of the Firm.')
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text:
                    "Your use of our Services is governed by these terms of use (hereinafter referred to as ",
                style: normalTextStyle),
            TextSpan(text: "User Agreement", style: boldTextStyle),
            TextSpan(
                text:
                    "). If You do not agree to the terms of this User Agreement do not avail our Services or use our website or mobile application.",
                style: normalTextStyle)
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "LEGALLY BINDING AGREEMENT",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "By accepting this User Agreement, either through clicking ‘proceed’ or clicking a box indicating acceptance on our website or mobile application.",
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "BIL may amend/modify these terms and conditions at any time, and such modifications shall be effective immediately upon posting of the modified terms and conditions on the website or mobile application. You may review the modified terms and conditions periodically to be aware of such modifications and your continued access or use of the Firm’s Services, shall be deemed conclusive proof of your acceptance of these terms and conditions, as amended/modified from time to time. BIL may also suspend the operation of their Services for support or technical upgradation, maintenance work, in order to update the content or for any other reason.",
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "If You utilize the Services in a manner inconsistent with this User Agreement, BIL may terminate your access, block your future access and/or seek such additional relief as the circumstances of your misuse may be deemed to be fit and proper.",
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "ELIGIBILITY",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Use of the Firm’s Services is only available to persons who can form legally binding contracts under the Indian Contract Act, 1872 and are not barred from entering into a contract under any other relevant provision. Persons who are ‘incompetent to contract’ within the meaning of the Indian Contract Act, 1872 including minors are not eligible to use the Services, website or mobile application. If You are a minor i.e. under the age of eighteen (18) years, You should not use our Services or access or transact on our website or mobile application in any manner whatsoever.",
          style: normalTextStyle,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "OWNERSHIP OF WEBSITE, CONTENT AND TRADEMARKS",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  ''' Unless otherwise agreed in writing, all materials on our website and mobile application, including text, graphics, information, content, images, illustrations, designs, icons, photographs, video clips, audio clips, sounds, music, artwork, computer code, software and other materials, and the copyrights, trademarks, trade names, service marks, logos, trade dress and/or other intellectual property rights in such materials [collectively, the “Content”], are owned, controlled and/or licensed by us, our associated entities or our licensors.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The Content are intended solely for personal, non-commercial use. No right, title or interest in any downloaded or copied Content is transferred to You as a result of any downloading or copying of the Content.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You shall not, either Yourself or assist any person to, reproduce, publish, upload, transmit, encode, distribute, mirror, display, perform, alter, modify, create derivative works from, sell or exploit or otherwise use any of the Content or the website or mobile application in connection with any public, business or commercial purpose. Any such use shall be deemed to be a violation of our intellectual property and proprietary rights. Any use for which You receive any remuneration, whether in money or otherwise, shall be considered commercial use for the purposes of this clause.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''All logos, brands, trade marks and service marks appearing on our Services are the properties either owned or used under license by BIL and/or its associates. All rights accruing from the same, statutory or otherwise, wholly vest with BIL and/or its associates, other trademarks, trade names and service marks used or displayed on our website and mobile application are the registered and unregistered trademarks, trade names and service marks of third parties. Nothing contained on our website and mobile application grants or should be construed as granting, by implication, estoppel, or otherwise, any license or right to You to use any such trademarks, trade names, service marks or logos displayed on such website and mobile application. Any use of such materials without our express written permission is strictly prohibited.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "USE OF OUR SERVICES, WEBSITE AND MOBILE APPLICATION",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You accept, agree and confirm that You shall use our Services only as permitted under this User Agreement and only in a manner consistent with all applicable laws, rules and regulations, and generally accepted practices or guidelines in relevant jurisdictions, including any laws governing the export of data to or from Your country of residence.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not use any “deep-link”, “robot”, “page-scrape”, “spider”, or other automatic or manual device or process, software, program, code, algorithm or methodology, to access, acquire, copy or monitor any portion of our website, mobile application or Content, or in any way reproduce or circumvent the navigational structure or presentation of our website, mobile application or Content, or obtain or attempt to obtain any materials, documents or information through any means not purposely made available by us through the website or mobile application. We reserve the right to take measures to prevent any such activity. You agree that You shall not resell use of, or access to, the website or mobile application to any third party.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You accept, agree and confirm that You shall use our Services only as permitted under this User Agreement and only in a manner consistent with all applicable laws, rules and regulations, and generally accepted practices or guidelines in relevant jurisdictions, including any laws governing the export of data to or from Your country of residence.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not gain or attempt to gain unauthorized access to any portion or feature of our website or mobile application, or any other systems or networks connected to the website or mobile application or to any of our business partners’ servers, systems or networks, or to any of the services offered on or through our website or mobile application, by hacking, “password-mining” or using any other illegitimate method of accessing data.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not probe, scan or test the vulnerability of our website or mobile application or any network connected to the website or mobile application, nor breach the security or authentication measures on our website or mobile application or any network connected to our website or mobile application. You agree not to reverse look-up, trace or seek to trace any information on any other visitor to our website or mobile application, or any other customer of ours in any way where the purpose is to discover materials or information, including but not limited to personal information, personally identifiable information or other information that reasonably could be used to connect non-personally identifiable information to personally identifiable information.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not take any action that would cause an unreasonably or disproportionately large load on the infrastructure of the website or mobile application or our systems or networks, or any systems or networks connected to the website or mobile application or to us in an attempt to overwhelm our systems to create a “denial of service” or similar attack. vi. You agree that You shall not use or exploit the data that is available on our website or mobile application for commercial purposes, including any web scraping activities to obtain information.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not use any device, technology, software, routine or method to interfere or attempt to interfere with the proper functioning or features of our website or mobile application or any transaction occurring on our website or mobile application, or with any other person’s use of our website or mobile application.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not forge headers or otherwise manipulate identifiers in order to disguise the origin of any message or transmittal You send to us on or through our website or mobile application. You must not impersonate or pretend that You are any other person or falsely claim You represent another person or entity.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall not use our website or mobile application or any Content for any purpose that is unlawful or prohibited under this User Agreement and the laws of all relevant jurisdictions.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You agree that You shall at all times ensure full compliance with the applicable provisions of the Indian Information Technology Act, 2000 and Rules thereunder as applicable and as amended from time to time and also all other applicable laws, rules and regulations in all relevant jurisdictions.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''By using our website or mobile application to send emails, messages, videos, text or any other data, information or communication to us or any other user of the website or mobile application, You agree and understand that You are communicating with us or such other user through electronic records and that You consent to receive communications via electronic records from us or such other user periodically and as and when required. We may communicate with You by email or by any other mode of communication, electronic or otherwise. You further agree that the transmission of emails, data, information, documents or other communication via internet or electronic communication devices are not entirely secure and You accept the risks associated with the abuse or misuse of electronic communication channels, hacking, fraud etc., irrespective of the strict procedures and security features which we will implement to try to prevent unauthorized access.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You must not do any of the following when using our website or mobile application: ''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Create accounts using fake, fraudulent or otherwise false means;",
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Transfer or otherwise assign login details of Your account without our express prior written consent; and ''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Infringe a third party's intellectual property rights.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "USER-GENERATED CONTENT",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Apart from personal information collected on or from our website or mobile application, which is subject to our Privacy Policy, any material, information, suggestions, ideas, concepts, know-how, techniques, questions, comments, messages or other communication You transmit or post to our website or mobile application [“User-Generated Content”] is and will be considered non-confidential and non-proprietary.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Such User-Generated Content will become our property and You agree to grant us worldwide, perpetual and transferable rights in such User-Generated Content. We shall be entitled to, in accordance with our Privacy Policy, use the User-Generated Content or any of its elements for any type of use forever, including but not limited to promotional and advertising purposes and in any media whether now known or hereafter devised, including the creation of derivative works that may include the User-Generated Content You provide. You agree to perform all further acts necessary to perfect any of the above-mentioned rights granted by You to us, including the execution of any documents, if required by us.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''We may use any User-Generated Content in our sole discretion, including for the purposes of reproduction, transmission, disclosure, publication, broadcast, development and we may use any User-Generated Content to develop and/or improve our services/products to consumers and send You targeted marketing messages. We shall be under no obligation: [1] to maintain any User-Generated Content in confidence; [2] to pay compensation for any User-Generated Content and/or its use; or [3] to monitor, use, return, review or respond to any User-Generated Content. We will have no liability related to the content of any User- Generated Content, whether or not arising under the laws of copyright, libel, privacy, obscenity, or otherwise. We retain the right to remove any User-Generated Content that includes any material we deem inappropriate or unacceptable at our sole discretion.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Such User-Generated Content will become our property and You agree to grant us worldwide, perpetual and transferable rights in such User-Generated Content. We shall be entitled to, in accordance with our Privacy Policy, use the User-Generated Content or any of its elements for any type of use forever, including but not limited to promotional and advertising purposes and in any media whether now known or hereafter devised, including the creation of derivative works that may include the User-Generated Content You provide. You agree to perform all further acts necessary to perfect any of the above-mentioned rights granted by You to us, including the execution of any documents, if required by us.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You represent and warrant that any Content You submit as User-Generated Content is original to You, that You own all applicable legal rights in the Content, and that the Content does not and will not infringe upon the rights of any other person, entity or third party or contain any libelous, tortious, or otherwise unlawful information.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You represent and warrant that any individuals depicted in audio or visual files submitted as part of User-Generated Content, including Yourself, are of the age of majority i.e. 18 years or more. If any of the individuals depicted in any User-Generated Content are minors, You represent and warrant that You are the parent or legal guardian of each such individual and You grant the use of the media containing his/her depiction in accordance with this User Agreement.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "USER–GENERATED CONTENT RULES",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You must comply with the rules governing User-Generated Content ["User-Generated Content Rules"] set forth in this section.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''If You post any content on our website or mobile application, You are solely responsible for each User-Generated Content that You post or transmit to other users and You agree to indemnify us fully. You further agree that You will not hold us responsible or liable for any User-Generated Content from another user that You access on our website or mobile application.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Categories of prohibited User-Generated Content are set forth below and reflect examples but are not intended to be exhaustive of what constitutes prohibited User-Generated Content. Without limitation, You agree that You shall not host, display, modify, upload, post, publish, transmit, update or share any content on our website or mobile application or to other users that You know or reasonably believe:''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''If You post any content on our website or mobile application, You are solely responsible for each User-Generated Content that You post or transmit to other users and You agree to indemnify us fully. You further agree that You will not hold us responsible or liable for any User-Generated Content from another user that You access on our website or mobile application.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Categories of prohibited User-Generated Content are set forth below and reflect examples but are not intended to be exhaustive of what constitutes prohibited User-Generated Content. Without limitation, You agree that You shall not host, display, modify, upload, post, publish, transmit, update or share any content on our website or mobile application or to other users that You know or reasonably believe:''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''is defamatory, libelous, abusive, obscene, pornographic, pedophilic, profane, offensive, invasive of other’s privacy or unethical; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''is unlawfully threatening or unlawfully harassing including but not limited to "indecent representation of women" within the meaning of the Indecent Representation of Women [Prohibition] Act, 1986 or other applicable laws; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''infringes or violates another party’s intellectual property rights [such as music, videos, photos or other materials for which You do not have written authority from the owner of such materials to post on, or transmit to others], including any party’s right of publicity or right of privacy [including but not limited to unauthorized disclosure of a party’s name, phone number, email address or any other details]; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''is unlawfully threatening or unlawfully harassing including but not limited to "indecent representation of women" within the meaning of the Indecent Representation of Women [Prohibition] Act, 1986 or other applicable laws; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''violates or encourages the violation of any law, statute, ordinance or regulation [including, but not limited to, criminal laws, those governing export control, consumer protection, unfair competition, money laundering or gambling, anti- discrimination or false advertising] or could give rise to civil liability; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''is harmful, threatening, harassing, unethical, ethnically objectionable or that promotes racism, bigotry or hatred of any kind against any group or individual; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''promotes or encourages violence, harassment, hatred, racism, bigotry against an individual or a group of individuals; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''promotes damage or destruction of property; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''IS INAccurate, fraudulent, false or misleading in any way; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''impersonates another person; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''is illegal or promotes any illegal activities; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''promotes illegal or unauthorized copying of another person’s copyrighted work or links to them or providing information to circumvent security measures; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications equipment or limit access to our website or mobile application; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''contains any Trojan horses, worms, time bombs, cancelbots, easter eggs or other computer programming routines that may damage, detrimentally interfere with, diminish value of, surreptitiously intercept or expropriate any system, data or personal information; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''contains or provides instructional information about illegal activities such as making or buying illegal weapons, violating someone's privacy, or providing or creating computer viruses; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''harm minors in any way; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''contains any advertising, promotional materials, “junk mail,” “spam,” “chain letters,” “pyramid schemes,” or any other form of solicitation; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''contains material that exploits people in a sexual, violent or otherwise inappropriate manner or solicits personal information from anyone; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''solicits gambling or engages in any gambling activity which we, in our sole discretion, believe is or could be construed as being illegal; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''provides unauthorized access or exceeds the scope of authorized access to our website or mobile application or to profiles, account information or other areas of our website or mobile application or solicits passwords or personal identifying information for commercial or unlawful purposes from other users; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''interferes with another user's use and enjoyment of our website or mobile application; or''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPointHole(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''refers to any website or URL that, in our sole discretion, contains material that is inappropriate and contains content that would be prohibited or violates the letter or spirit of this User Agreement.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''When using our website or mobile application, You may be exposed to User-Generated Content from a variety of sources. We are not responsible for the content, accuracy, usefulness, safety, or intellectual property rights of or relating to such User-Generated Content.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''It is possible that other users [including unauthorized users or ‘hackers’] may post or transmit incorrect, offensive or obscene materials and that You may be involuntarily exposed to such incorrect, offensive and obscene materials. It is also possible for others to obtain personal information about You due to Your use of the website and mobile application, and that the recipient may use such information to harass or injure You. We do not approve of such unauthorized uses, but by using our Services, website and mobile application You acknowledge and agree that we are not responsible for the use of any personal information that You may rely on or publicly disclose or share with others on our website or mobile application.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "COPYRIGHT AND TRADEMARK RULES",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''We are committed to complying with copyright and related laws, and we require all users of our website and mobile application to comply with these laws. Accordingly, You must not post or store any material or content on, or disseminate any material or content in any manner that constitutes an infringement of third party intellectual property rights, including but not limited to, rights granted by copyright law. You must not post, modify, distribute, or reproduce in any way any copyrighted material, trademarks, or other proprietary information belonging to others without obtaining the prior written consent of the owner of such proprietary rights. It is our policy to terminate privileges of any user who infringes the intellectual property rights of others upon receipt of proper notification to us by the intellectual property rights owner or their legal agent.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''f you believe that your work has been copied and posted on our website or mobile application in a way that constitutes copyright or trademark infringement, please contact us at: contactus@myneighbourhoodonline.com''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "ACCOUNTS, PASSWORDS AND SECURITY",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''In order to avail our Services, You are required to create an account on our website and/ or mobile application.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Apart from the representations made in our Privacy Policy regarding our protection of Your information, You are solely and entirely responsible for maintaining the confidentiality of Your account information, including Your Account ID and password, and for any and all activity that occurs on or under Your account. If any of the information provided to us as part of the account opening or registration process changes, You must promptly change Your account details online.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You must notify us immediately of any actual or potential unauthorized use of Your account or password, or any other actual or potential breach of security. However, You are solely liable for the actions of, and any losses incurred by us or any third party due to, someone else using Your Account ID, password or account.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''You must not use anyone else’s Account ID, password or account at any time without the express permission and consent of the holder of that Account ID, password or account. We cannot and will not be liable for any loss or damage arising from Your failure to comply with these obligations.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "FEES, CHARGES AND TAXES",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''All charges listed on our website or mobile application are in Indian Rupees [INR], or their corresponding value in the currencies which You opt to view.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The charges listed on our website and mobile application are, where applicable, exclusive of VAT/CST, service tax, Goods and Services Tax [GST], duties and cesses [as applicable] unless stated otherwise. If any additional charges or fees apply these will be clearly disclosed at the beginning of the payment process.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "PAYMENT",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''We accept payment [through our third-party merchants] through any of the payment methods specified on our website/ mobile application. We do not directly collect Your payment. A third party payment gateway collects Your payment on our behalf. We will thus not be liable or responsible for Your use of such third-party payment services.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''While availing any of the payment methods available on our mobile application or website, we will not be responsible or assume any liability, whatsoever in respect of any loss or damage arising directly or indirectly to You due to lack of authorization for any transactions, or exceeding the preset limit mutually agreed by You and Your bank, or any payment issues arising out of the transaction, or decline of transaction for any other reasons.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "REFUND",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "There will be no refund of any kind for any payment for the Services provided herein.",
          style: normalTextStyle,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "TERMINATION AND LIABILITIES UPON TERMINATION",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''We may suspend or terminate Your account and/or use of our Services at any time in accordance with this User Agreement and without any prior notice to You. No refunds in any manner whatsoever shall be provided in such a case.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The amounts due and payable to the Firm by the User upon termination shall be payable within 30 days of the relevant date of termination.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "INDEMNITY",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '''User hereby indemnifies and continues to keep indemnified the Firm its partners, employees, agents, representatives from any third party lawsuit or proceeding brought against the Firm based upon or otherwise any claim arising from the fact that (i) the User Generated Content, Site and/or User features infringe any copyright, trade secret or trademark of such third party and (ii) the Firm's use of any User Generated Content, provided that such use complies with the requirements of the Agreement and (iii) the User's use of the Services in any manner inconsistent with or in breach of the Agreement; and/or (iv) any claim alleging facts that would constitute a breach of User's representations and warranties made in this Agreement. The User shall give the Firm full control and sole authority over the defence and settlement of such claim.''',
          style: normalTextStyle,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "LIMITATION OF LIABILITY",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''User agrees that neither Firm nor its partners, or employee shall be liable for any direct or/and indirect or/and incidental or/and special or/and consequential or/and exemplary damages, resulting from the use or/and the inability to use the Service. User further agrees that Firm shall not be liable for any damages arising from interruption, suspension or termination of service, including but not limited to direct and/or indirect and/or incidental or/and special consequential or/and exemplary damages, whether such interruption or/and suspension or/and termination was justified or not, negligent or intentional, inadvertent or advertent. In sum, in no event shall Firm's total liability to the User for all damages or/and losses or/and causes of action exceed the amount paid by the User to Firm, if any, that is related to the cause of action.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The Firm takes no responsibility/liability whatsoever for shortage or non-fulfilment of the Service/s on Firm or any other related site due to or arising out of technical failure or/and malfunctioning or/and otherwise and the User hereby undertakes that in such situation/s, the User shall not claim any right/damages/ relief, etc. against the Firm for "Deficiency of service" under The Consumer Protection Act or any other Act/Rules, etc.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Firm shall not be liable for any and all costs, charges, expenses, etc. incurred in relation to the downloading fees by third party, airtime, ISP connection costs, etc., of which are to be borne by the user personally.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "LINKS TO OUR WEBSITES; THIRD PARTY LINKS ON OUR WEBSITES",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Creating or maintaining any link from another website to any page on our website or mobile application without our prior written permission is prohibited. Running or displaying our website or mobile application or any information or material displayed on any website in frames or through similar means on another website without our prior written permission is prohibited. Any permitted links to our website or mobile application must comply with all applicable laws, statutes, rules and regulations.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''From time to time, our website or mobile application may contain links to other websites that are not owned, operated or controlled by us. All such links are provided solely as a convenience to You. If You use these links, You will leave our website or mobile application and we cannot be responsible for any content, materials, information or events that are present on or that occur on websites or mobile applications that are not owned, operated or controlled by us.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "CHANGE IN WEBSITE, MOBILE APPLICATION OR CONTENT",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '''We reserve the right, in our sole discretion, to: modify, suspend or discontinue any of our Services, Content, feature or product offered through our website or mobile application, with or without notice; modify and/or waive any fees charged in connection with our Services; and/or offer opportunities to some or all users of our Services. You agree that we shall not be liable to You or to any third party should any of the foregoing occur with respect to our Services.''',
          style: normalTextStyle,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "MISCELLANEOUS",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Confidentiality: The receiving party shall keep confidential and secret and not disclose to any third party the confidential information nor any part of it, except to any of the receiving party's associates, if required and upon prior permission in writing from the disclosing party. The receiving party agrees to take all possible precautions with regard to protecting confidential information from any third party.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''It is Your responsibility to ascertain and obey all applicable local, state, and international laws, statutes, rules and regulations [including minimum age requirements] related to the use of our Services and use of our website and mobile application. Any dispute arising out of, or relating to, the use of our Services, our website or mobile application will be governed by and construed in accordance with the laws of India.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Jurisdiction and Governing Law: This User Agreement and any dispute or claim arising out of or in connection with it or its subject matter or formation shall be governed by and construed in accordance with the laws of India and courts in Mumbai with respect to all matters and disputes arising under this Agreement.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Severability: If any part of this User Agreement shall be held or declared to be invalid or unenforceable for any reason by any court of competent jurisdiction, such provision shall be ineffective but shall not affect any other part of the User Agreement.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Promotions: There may be available, from time to time, events listed on the website and mobile application which are hosted and organized by third parties. You hereby understand and agree that the third-party hosting and organizing the event will be solely responsible for all matters related to that event and BIL is in no way directly or indirectly responsible to You for such events.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Waiver: Any failure by us to partially or fully exercise any rights or the waiver of any breach of the User Agreement by You, shall not prevent a subsequent exercise of such right by us or be deemed a waiver by us of any subsequent breach by You of the same or any other term of the User Agreement. Our rights and remedies under the User Agreement shall be cumulative, and the exercise of any such right or remedy shall not limit our right to exercise any other right or remedy.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Force Majeure: A party shall not breach this User Agreement and is not liable to the other party for a delay or failure to perform an obligation resulting from events or circumstances beyond a party’s reasonable control, including acts of God, war, pandemic, epidemic, flood, fire, storm, explosion, civil disobedience, tempest, theft, vandalism, riots, terrorist actions, wars, interruption to telecommunications systems, network failure or the act or omission of any third party [other than contractors or subcontractors] over which the party has no control, but does not include an obligation to pay monies.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Assignment: You may not assign or delegate or otherwise deal with all or any of Your rights or obligations under this User Agreement. We have the right to assign or otherwise delegate all or any of our rights or obligations under this User Agreement to any person.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Contact Us: If You have any questions or concerns about the User Agreement, please contact us at contactus@myneighbourhoodonline.com.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "DISCLAIMER",
          style: extraboldTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The User hereby agrees that use of the Service is at the User's sole risk. The Service is provided on an "as is" or/and on an "as available" basis. Firm expressly disclaims all warranties of any kind, whether express or implied, including, but not limited to the implied warranties of merchantability, fitness for a particular purpose and non-infringement.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The Firm makes no warranty that the Services shall meet User's requirements, that the Services shall be uninterrupted or/and timely or/and secure or/and error free.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''This Site is vulnerable to data corruption, interception, tampering, viruses as well as delivery errors and we do not accept liability for any consequence that may arise therefrom. We may need to make the Site unavailable with or without notice to carry out maintenance or upgrade work. We accept no liability for any interruption or loss of Service.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Property descriptions and other information provided on our Site are intended for information and marketing purposes and, whilst displayed in good faith, we will not in any circumstances accept responsibility for their accuracy. It is the responsibility of prospective buyers/tenants to satisfy themselves as to the accuracy of any property descriptions displayed and the responsibility of agents/sellers/brokers to ensure the accuracy and integrity of property descriptions provided on Our Site and in any property particulars.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''Any value estimates provided on our Site are intended for general interest and information purposes only and should not be relied upon for any commercial transaction or similar use. None of the information available on Our Site is intended to be a substitute for independent professional advice and users are recommended to seek advice from suitably qualified professionals such as surveyors and solicitors if relevant to their particular circumstances. We shall not be liable for any losses suffered as a result of relying on our value estimates.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bulletPOint(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '''The User shall ensure that while using the Service, all prevailing and applicable laws, rules and regulations, directly or indirectly for the use of systems, service or equipment shall at all times, be strictly complied with by the User and the Firm shall not be liable in any manner whatsoever for default of any nature regarding the same, by the User.''',
                  style: normalTextStyle,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Container bulletPointHole() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.white)),
    );
  }

  Container bulletPOint() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset('assets/images/back_arrow.png'),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          "Terms & Conditions",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      ),
    );
  }
}
