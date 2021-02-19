import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:my_neighbourhood_online/Networking/all_urls.dart';
import 'package:my_neighbourhood_online/api_response_model/set_count_api_call.dart';

class SetClickCountApiCall {
  int type;
  int propertyID;
  int userID;

  var logger = Logger();

  SetClickCountApiCall(this.type, this.propertyID, this.userID) {
    setCountAPICall();
  }

  void setCountAPICall() async {
    String typeText = '';

    if (this.type == 1) typeText = '360degree';
    if (this.type == 2) typeText = "Gallery";
    if (this.type == 3) typeText = "Whatsapp";
    if (this.type == 4) typeText = "Calling";

    Map<String, dynamic> body = {
      "type": typeText,
      "userId": this.userID,
      "propertyId": this.propertyID,
      "createDate": DateFormat('yyyy-MM-dd').format(DateTime.now())
    };

    logger.d("Set Count  body: $body");
    try {
      // final SharedPreferences preferences =
      //     await SharedPreferences.getInstance();

      FormData formData = new FormData.fromMap(body);
      Response response =
          await Dio().post(AllUrls().setCountURl, data: formData);
      logger.d("Set count API Status code - ${response.statusCode}");
      logger.d("Set count API RESPO: ${response.data.toString()}");
      if (response.statusCode != 200) {
        logger.wtf(response.data);
      } else {
        //TODO:------------------SUCCESS RESPONSE--------------------------
        SetCountApiResponse setCountApiResponse =
            setCountApiResponseFromJson(response.data);

        logger.i(setCountApiResponse.msg);
      }
    } on DioError catch (e) {
      if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          logger.e("INternet error");
        }
      } else {
        logger.e(e);
      }
    }
  }
}
