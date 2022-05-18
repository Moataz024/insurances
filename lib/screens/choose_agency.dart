import 'package:flutter/material.dart';
import 'package:insurances/screens/pick_agency.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'agency_register.dart';

class ChooseAgencyScreen extends StatefulWidget {
  const ChooseAgencyScreen({Key? key}) : super(key: key);

  @override
  _EmployeeRegisterScreenState createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends State<ChooseAgencyScreen> {

  bool exists = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightTheme ? Colors.blueAccent : Colors.blueGrey,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 200,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        exists = true;
                      });
                    },
                    child: Container(
                      height: 300,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: exists ? Colors.grey[300] : Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.groups,
                              size: 60,
                            ),
                            SizedBox(height: 20,),
                            Text(
                                'EXISTING AGENCY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30,),
                            Text(
                                'My agency already registered on this platform',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        exists = false;
                      });
                    },
                    child: Container(
                      height: 300,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: exists ? Colors.grey : Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.group_add,
                              size: 70,
                            ),
                            SizedBox(height: 20,),
                            Text(
                                'NEW AGENCY',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 70,),
                            Text(
                                'My agency doesn\'t exist on this platform and i am the responsible',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 300,
              bottom: 20,
            ),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => exists ? FormValidationWithDropdown() : AgencyRegisterScreen() ));
              },
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.navigate_next,
                size: 40,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
