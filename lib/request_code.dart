import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'request/authorization_request.dart';
import 'model/config.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:io' show Platform;

class RequestCode {
  final StreamController<String> _onCodeListener = new StreamController();
  final FlutterWebviewPlugin _webView = new FlutterWebviewPlugin();
  final Config _config;
  AuthorizationRequest _authorizationRequest;

  var _onCodeStream;
  
  RequestCode(Config config) : _config = config {
    _authorizationRequest = new AuthorizationRequest(config);
  }

  String getUserAgent() {  
    if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Mobile/15E148 Safari/604.1";
    }
    return "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.117 Mobile Safari/537.36";
  }

  Future<String> requestCode() async {
    var code;
    final String urlParams = _constructUrlParams();
    
    await _webView.launch(
        Uri.encodeFull("${_authorizationRequest.url}?$urlParams"),
        clearCookies: _authorizationRequest.clearCookies, 
        hidden: false,  
        userAgent: "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.117 Mobile Safari/537.36",
        rect: _config.screenSize
    );

    _webView.onUrlChanged.listen((String url) {
      Uri uri = Uri.parse(url);

      if(uri.queryParameters["error"] != null) {
        _webView.close();
        throw new Exception("Access denied or authentation canceled."); 
      }
      
      if (uri.queryParameters["code"] != null) {
        _webView.close();
        _onCodeListener.add(uri.queryParameters["code"]);
      }       
    });

    code = await _onCode.first;
    return code;
  }

  Future<void> clearCookies() async {
    await _webView.launch("", hidden: true, clearCookies: true);
    await _webView.close();
  }

  Stream<String> get _onCode =>
      _onCodeStream ??= _onCodeListener.stream.asBroadcastStream();

  String _constructUrlParams() => _mapToQueryParams(_authorizationRequest.parameters);

  String _mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }
}