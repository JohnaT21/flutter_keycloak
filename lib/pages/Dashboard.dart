import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:keycloakdemo/data/Model/store_registration.dart';
import 'package:logger/logger.dart';

import '../ServiceLocator.dart';
import '../data/bloc/store_bloc.dart';
import '../util/constant.dart';
import 'login_screen.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);
  static const String DashboardRoutingName = 'Bottom page route name';
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? accessToken;
  String? refreshToken;
  var logger = Logger(printer: PrettyPrinter());
  late StoreBloc storeBloc;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController quantityEditingController = TextEditingController();

  @override
  void initState() {


    accessToken = prefs!.getString("access_token");
    refreshToken = prefs!.getString("refresh_token");
    sl<StoreBloc>().add(StoreEventCategory(accessToken!));
    super.initState();

    // httpReturn();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreBloc, StoreState>(
      listener: (context, state) {

        logger.d("Inside the listener: $state");
        if(state is LoadedStoreCreateState){
          sl<StoreBloc>().add(StoreEventCategory(accessToken!));
        }
        // Handle state changes if needed
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard Page'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  // Perform logout logic
                  // sl<StoreBloc>().add(StoreEventCategory());
                  print("the logout clicked");
                  await logout(accessToken!, refreshToken!);
                  // var response = await http.get(Uri.parse('${AppConstant.API_BASE_URL}')
                  // );
                  // print(response.body);
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
            ],
          ),
          body:(state is LoadingStoreState)? Center(

            child: CircularProgressIndicator(),
          ):
          (state is LoadedStoreState)?
           SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Store Data",
                        style: TextStyle(
                          fontSize:18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange
                        ),
                        ),

                        InkWell(
                          onTap: (){
                            showDialog(context: context,
                                builder: (_){
                              return AlertDialog(
                                title: Text('My Dialog Box'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameEditingController,
                                      decoration: InputDecoration(
                                        labelText: 'Package Name',
                                      ),
                                    ),
                                    TextField(
                                      controller: quantityEditingController,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog box
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(nameEditingController.text);
                                      print(quantityEditingController.text);

                                      var storeModel = StoreRegistrationModel(packageName: nameEditingController.text,
                                          quantity: int.parse(quantityEditingController.text));
                                      sl<StoreBloc>().add(CreateStoreEventCategory(accessToken!, storeModel));
                                      nameEditingController.clear();
                                      quantityEditingController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                                });
                          },
                          child: Text("Add Store",
                            style: TextStyle(
                                fontSize:18,
                                fontWeight: FontWeight.bold,
                              color: Colors.orange
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(thickness:2 ,),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('PackageName')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('CreatedBy')),
                      // DataColumn(label: Text('CreatedDate')),

                    ],
                    rows: state.storeReturn.data.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data.id.toString())),
                      DataCell(Text(data.packageName)),
                        DataCell(Text(data.quantity.toString())),
                          DataCell(Text(data.createdBy)),
                          // DataCell(Text(data.createdAt.toIso8601String()))
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),

          ): (state is ErrorGettingStoreState)?
           Center(child: Text("Error "),)
              : Center(child: Text("the data"),),

        );
      }
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
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.LoginScreenPageRouting, (route) => false);
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

Widget showDialogBox(BuildContext context){
  return AlertDialog(
    title: Text('My Dialog Box'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TextField(
        //   controller: _controller1,
        //   decoration: InputDecoration(
        //     labelText: 'Text Field 1',
        //   ),
        // ),
        // TextField(
        //   controller: _controller2,
        //   decoration: InputDecoration(
        //     labelText: 'Text Field 2',
        //   ),
        // ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the dialog box
        },
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // Handle OK button press
          // String text1 = _controller1.text;
          // String text2 = _controller2.text;
          // print('Text Field 1: $text1');
          // print('Text Field 2: $text2');
          // Navigator.of(context).pop(); // Close the dialog box
        },
        child: Text('OK'),
      ),
    ],
  );
}
