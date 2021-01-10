import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:Hogwarts/utils//StorageUtil.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';

const accessid= 'LTAI4G7PGQy2LBnAzDsMLx8W';
const accesskey= 'VmwPJ9AAWF7b3y236Dzo1FTzSmWNtZ';
const host = 'http://freelancer-images.oss-cn-beijing.aliyuncs.com';

String policyText = '{"expiration": "2021-12-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

class Uploader {
  static Future<String> uploadImage(File _image) async {
    int userId = await StorageUtil.getIntItem("uid");
    String name = userId.toString() + "_user" + DateTime.now().millisecondsSinceEpoch.toString() + _image.path.substring(_image.path.lastIndexOf("."));

    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policy_base64);
    //进行utf8 编码
    List<int> key = utf8.encode(accesskey);
    //通过hmac,使用sha1进行加密
    List<int> signature_pre = new Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signature_pre);
    //dio的请求配置，这一步非常重要！
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;  //这个后台返回值dio 默认json 要设置为普通文本

    //创建dio对象
    Dio dio = new Dio(options);

    FormData data = new FormData.fromMap({
      'key': name,
      'policy': policy_base64,
      'OSSAccessKeyId': accessid,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file': await MultipartFile.fromFile(_image.path, filename: "image1", contentType: MediaType('image', 'jpeg')) //修改文件请求头
    });

    dio.post(host, data: data);
//    try {
//      Response response = await dio.post(host, data: data);
//      print(response.headers);
//      print(response.data);
//
//    } on DioError catch(e) {
//      print(e.message);
//      print(e.response.data);
//      print(e.response.headers);
//      print(e.response.request);
//    }
    return name;
  }
}
