// Dashboard.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keycloakdemo/pages/Dashboard.dart';

import '../util/constant.dart';
import 'login_screen.dart';

class WebviewPage extends StatefulWidget {
  // final String authorizationCode;
  // final Function(String)? exchangeAuthorizationCode;
  // String? token;

  WebviewPage({
    Key? key,
    //   required this.authorizationCode,
    // this.exchangeAuthorizationCode,
    // this.token,
  }

      ) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String? accessToken;
  String? refreshToken;


  @override
  void initState() {
    super.initState();
    // accessToken = prefs!.getString("access_token");
    // refreshToken = prefs!.getString("refresh_token");

    // Call the token exchange method when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Page'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // You can perform any logout logic here
              // For example, navigate back to the login screen
              await logout(accessToken!,refreshToken!);
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Customize the button color
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Authorization Code:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "{prefs!.getString}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Access Token:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              // "${prefs!.getString("refresh_token")}",
              "",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> logout(String accessToken, String refreshToken) async {
    // Keycloak logout endpoint
    final String logoutUrl = '${AppConstant.KEYCLOAK_BASE_URL}/realms/flutter_dotNet/protocol/openid-connect/logout';

    print("the acces token: $accessToken");
    print("the refresh token: $refreshToken");
    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': AppConstant.CLIENT_ID,
          'client_secret': AppConstant.CLIENT_SECRET,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 204) {
        // Logout successful
        print('Logout successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
        );
      } else {
        // Handle other status codes or error responses
        print('Logout failed. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during logout: $e');
    }
  }
}

