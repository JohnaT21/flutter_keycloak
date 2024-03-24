import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keycloakdemo/util/constant.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../ServiceLocator.dart';
import 'Dashboard.dart';
import 'package:http/http.dart' as http;

SharedPreferences? prefs;

class LoginScreen extends StatefulWidget {
  static const String LoginScreenPageRouting = 'Login page route name';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  WebViewController? _controller;
  late String authorizationUrl;
  String state = "";
  bool isRedirecting = false;
  bool authorizationInProgress = false;
  bool handledAuthorization = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    state = Random.secure().nextInt(999999).toString();
    authorizationUrl =
    '${AppConstant.KEYCLOAK_BASE_URL}/realms/flutter_dotNet/protocol/openid-connect/auth?redirect_uri=${AppConstant.KEYCLOAK_BASE_URL}/auth&client_id=codex&response_type=code&scope=openid&state=$state';
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    // Set the WebView controller to null after disposing
    _controller = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication WebView'),
      ),
      body: WebView(
        initialUrl: authorizationUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) async {
          print("on Page finished: $url");
          if (isRedirecting) {
            Uri uri = Uri.parse(url);
            String? authorizationCode = uri.queryParameters['code'];
            bool token = await _exchangeAuthorizationCode(authorizationCode!);
            print(token);
            if(token){
              print(token);
              Navigator.pushNamedAndRemoveUntil(
                  context, DashboardPage.DashboardRoutingName, (route) => false);

              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DashboardPage(),
              //   ),
              // );
            }
          }
          print("out onPage: $isRedirecting");
        },
        onWebResourceError: (WebResourceError error) {
          print("Received error: ${error.errorCode}, ${error.description}");
        },
        navigationDelegate: (NavigationRequest request) {
          print("on the navigation request: $request");
          isRedirecting = true;
          return NavigationDecision.navigate;
        },
        // Disable text input to allow normal typing
        gestureNavigationEnabled: true,
      ),
    );
  }

  Future<bool> _exchangeAuthorizationCode(String authorizationCode) async {
    final String tokenEndpoint =
        '${AppConstant.KEYCLOAK_BASE_URL}/realms/flutter_dotNet/protocol/openid-connect/token';
    final String clientId = AppConstant.CLIENT_ID;
    final String clientSecret = AppConstant.CLIENT_SECRET;
    final String redirectUri = '${AppConstant.KEYCLOAK_BASE_URL}/auth';

    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse(tokenEndpoint),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'authorization_code',
            'code': authorizationCode,
            'client_id': clientId,
            'client_secret': clientSecret,
            'redirect_uri': redirectUri,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);




          // Save token to SharedPreferences
          await saveDataToPrefs(data);

          return true;
        } else if (response.statusCode == 400) {
          // ... existing code ...
        } else {
          print('Received non-200 status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during token exchange: $e');
      }

      // Retry after a delay
      await Future.delayed(Duration(seconds: 2));
      retryCount++;
    }

    return false;
  }

  Future<void> saveDataToPrefs(Map<String, dynamic> data) async {
    // Save the token to SharedPreferences
    print("Before saving the token");
    print(prefs!.getString("access_token"));
    await prefs!.setString("access_token", data["access_token"]);
    await prefs!.setString("refresh_token", data["refresh_token"]);

    print("Token saved");
  }
}
