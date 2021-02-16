import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/service_locator.dart';

String token;
String baseUrl = config.baseUrl
    .replaceFirst('/ar/', '/${config.userLnag.countryCode ?? 'ar'}/');

BaseOptions options = BaseOptions(
  baseUrl: config.baseUrl,
  connectTimeout: 100000,
  receiveTimeout: 3000000,
  headers: <String, String>{
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': 'application/json',
    'authorization': ''
  },
  followRedirects: false,
  validateStatus: (int status) => status < 500,
);

Response<dynamic> response;

Dio dio = Dio(options);

void dioDefaults() {
  // dio.options.headers['authorization'] = 'Bearer ${config.token}';
  dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    // Do something before request is sent
    options.queryParameters.addAll(<String, String>{
      'latitude': config.lat.toString(),
      'longitude': config.long.toString()
    });
    return options;
    // If you want to resolve the request with some custom data，
    // you can return a `Response` object or return `dio.resolve(data)`.
    // If you want to reject the request with a error message,
    // you can return a `DioError` object or return `dio.reject(errMsg)`
  }, onResponse: (Response<dynamic> response) async {
    print("config.userLnag.countryCode ${config.userLnag.countryCode}");

    print(
        "status code: ${response.statusCode}  endpoint : ${response.request.path}");
    // print("error : ${response.realUri.toString()}");
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Login please");

      getIt<NavigationService>().navigateTo('/login', null);
    }
    return response; // continue
  }, onError: (DioError e) async {
    //Navigator.pushNamed(navigatorState.currentContext, "/login");
// print("status code: ${response.statusCode}  endpoint : ${response.request.path}");
    // Fluttertoast.showToast(msg: "Retry later");
    print(e.message);
    // Do something with response error
    return e; //continue
  }));
}
