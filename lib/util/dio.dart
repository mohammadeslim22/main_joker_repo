import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/providers/map_provider.dart';

String token;
// String baseUrl = config.baseUrl
//     .replaceFirst('/ar/', '/${config.userLnag.countryCode ?? 'ar'}/');

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
  validateStatus: (int status) => status < 501,
);

Response<dynamic> response;

Dio dio = Dio(options);

void dioDefaults() {
  dio.interceptors.add(InterceptorsWrapper(onRequest:
      (RequestOptions options, RequestInterceptorHandler rHandlers) async {
  
    options.queryParameters.addAll(<String, String>{
      'latitude':
          getIt<HOMEMAProvider>().lat.toString() ?? config.lat.toString(),
      'longitude':
          getIt<HOMEMAProvider>().long.toString() ?? config.long.toString()
    });  print(
        "request going to ${options.path} request data ${options.queryParameters}");
    rHandlers.next(options);
  }, onResponse:
      (Response<dynamic> response, ResponseInterceptorHandler rHandlers) async {
    print(
        "status code on response: ${response.statusCode}  endpoint : ${response.realUri}");
    // print("error : ${response.realUri.toString()}");
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Login please");

      getIt<NavigationService>().navigateTo('/login', null);
    }
    rHandlers.next(response);
  }, onError: (DioError e, ErrorInterceptorHandler eHandler) async {
    getIt<NavigationService>().navigateTo('/login', null);
    // print(
    //     "status code: on error${response.statusCode}  endpoint : ${response.realUri}");
    Fluttertoast.showToast(msg: "Retry later");

    eHandler.next(e);
  }));
}
