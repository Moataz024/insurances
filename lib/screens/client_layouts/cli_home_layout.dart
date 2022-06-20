import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fbutton_nullsafety/fbutton_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/client_documents.dart';
import 'package:insurances/screens/client_layouts/appointment_form.dart';
import 'package:insurances/screens/client_layouts/calendar_view.dart';
import 'package:insurances/shared/cubit/cli_agency_cubit/cli_agency_cubit.dart';
import 'package:insurances/shared/cubit/cli_agency_cubit/cli_agency_states.dart';

class CliHomeLayout extends StatefulWidget {
  const CliHomeLayout({Key? key}) : super(key: key);

  @override
  _CliHomeLayoutState createState() => _CliHomeLayoutState();
}

class _CliHomeLayoutState extends State<CliHomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => CliAgencyCubit()..getAgency(),
        child: BlocConsumer<CliAgencyCubit,CliAgencyStates>(
          listener: (BuildContext context, Object? state) {  },
            builder: (BuildContext context, state) => ConditionalBuilder(
              fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
              builder: (BuildContext context) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[150],
                  boxShadow: [
                    BoxShadow(color: Colors.white24, spreadRadius: 2)
                  ]
                ),
                child: Column(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue[100],
                            boxShadow:[
                              BoxShadow(color: Colors.grey, spreadRadius: 2),
                            ],
                          ),
                          height: 70,
                          child: Center(
                            child: Text('${CliAgencyCubit.get(context).agencyModel.name}',overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: Colors.black38,
                              shadows: [
                                Shadow(
                                  color: Colors.blueGrey.shade900.withOpacity(0.5),
                                  offset: Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                      )
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Location : ',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),),
                        )),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('${CliAgencyCubit.get(context).agencyModel.Location}',overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Contact phone : ',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                        )),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('${CliAgencyCubit.get(context).agencyModel.contactPhone}',overflow: TextOverflow.ellipsis,),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Contact email: ',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                        )),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('${CliAgencyCubit.get(context).agencyModel.email}',overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Responsible : ',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                        )),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('${CliAgencyCubit.get(context).employeeModel.fullName}',overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20
                      ),
                      child: ElevatedButton.icon(

                        onPressed: () {
                          var clientId = CliAgencyCubit.get(context).cliModel.uid;
                          var agencyId = CliAgencyCubit.get(context).cliModel.agencyId;
                          var name = CliAgencyCubit.get(context).cliModel.fullName;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AppointmentFormScreen(client : clientId,agency : agencyId,name : name)));
                        },
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.handshake, size: 30),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("REQUEST AN APPOINTMENT",style: TextStyle(fontSize: 20),),
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 50,
                        top: 10,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=> CalendarScreen()));
                        },
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.calendar_today, size: 30),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("VIEW APPOINTMENTS",style: TextStyle(fontSize: 20),),
                        ),
                      )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            var clientCIN = CliAgencyCubit.get(context).cliModel.cin;
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=> ClientDocuments(clientCIN: clientCIN,)));
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.file_open, size: 30),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("VIEW DOCUMENTS",style: TextStyle(fontSize: 20),),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              condition: state is! LoadingAgencyState,

            ),

    ),
    );
  }
}
