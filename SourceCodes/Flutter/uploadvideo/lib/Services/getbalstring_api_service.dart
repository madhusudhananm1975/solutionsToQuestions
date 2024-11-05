import 'dart:developer';

import 'package:http/http.dart' as http;
import 'constants.dart';
import 'dart:convert'; 

class GetBalStringAPIService {

  Future<String> getBalString(String userrequest) async {
    try {
      log('user request to send ', name: userrequest);
      var url = Uri.parse(ApiConstants.checkBalStringEndPoint);
      var response = await http.post(url, headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8', }, 
      body: userrequest );

      if (response.statusCode == 200) 
      {
        final responseData = jsonDecode(response.body);
        String dataList = responseData['body'];

        final statusReceived = responseData["Status"];
        if (statusReceived == "Success") 
        {
            log('Status', name: statusReceived);
            return dataList;
        }
        else
        {
          dataList = "Unable to Process";
          return dataList;
        }   
      }
    }
    catch (e) {
      log(e.toString());
    }
    return "";
  }
}