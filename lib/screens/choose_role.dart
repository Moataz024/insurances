import 'package:flutter/material.dart';
import 'package:insurances/screens/agency_register.dart';
import 'package:insurances/screens/choose_agency.dart';
import 'package:insurances/screens/client_register.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({Key? key}) : super(key: key);

  @override
  _ChooseRoleScreenState createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          height: 300,
          child: Column(
            children: [
              Text(
                  'Register as',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder:(context) => ChooseAgencyScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.groups,
                                  size: 90,
                                ),
                              ),
                              Text(
                                'AGENCY',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Text(
                                  'An agency shares their services with the clients',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: GestureDetector(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder:(context) => ClientRegisterScreen()),
                            );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                ),
                              ),
                              Text(
                                'CLIENT',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Text(
                                  'A client explores the services available shared by the agencies',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
