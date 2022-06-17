import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/model/client_model.dart';
import 'package:insurances/screens/agency_layouts/charge_client.dart';
import 'package:insurances/screens/agency_layouts/documents_layout.dart';
import 'package:insurances/screens/client_documents.dart';
import 'package:insurances/shared/cubit/employee_cubit/states.dart';

import '../../shared/componenets/components.dart';
import '../../shared/cubit/employee_cubit/cubit.dart';
import '../../shared/cubit/screeens_cubits/home_cubit.dart';
import '../../shared/cubit/screeens_cubits/home_states.dart';
import 'create_client.dart';

class ResponsibleHomeScreen extends StatefulWidget {
  const ResponsibleHomeScreen({Key? key}) : super(key: key);

  @override
  _ResponsibleHomeScreenState createState() => _ResponsibleHomeScreenState();
}

class _ResponsibleHomeScreenState extends State<ResponsibleHomeScreen> {
  String? agencyId;
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();
  TextEditingController searchController = new TextEditingController();
  ClientModel clientModel = new ClientModel();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit()..getClients(),
      child: BlocConsumer
        <HomeCubit,HomeStates>(
          builder: (BuildContext context, state) => RefreshIndicator(
            onRefresh: () async { HomeCubit.get(context).getClients(); },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: ConditionalBuilder(
                  fallback: (BuildContext context) => Center(child: LinearProgressIndicator(),),
                  condition: state is! GetEmployeeLoadingState,
                  builder: (BuildContext context) => ConditionalBuilder(
                    fallback: (BuildContext context) => LinearProgressIndicator(),
                    condition: state is! GetClientsLoadingState,
                    builder: (BuildContext context) =>ConditionalBuilder(
                      fallback: (BuildContext context) =>Column(
                        children: [
                          Text('Error getting clients'),
                        ],
                      ),
                      condition: state is! GetClientsSuccessState,
                      builder: (BuildContext context) => Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  bottom: 10,
                                ),
                                child: Text('${HomeCubit.get(context).clients.length} FOUND',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.left,),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      agencyId = HomeCubit.get(context).empModel.agencyId;
                                    });
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => CreateNewClientScreen(agencyId: agencyId,update: false,)));
                                  },
                                  icon: Icon(Icons.add, size: 18),
                                  label: Text("Create new client",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          HomeCubit.get(context).clients.length == 0 ?
                              //NO CLIENTS TSARREF !!
                          Text(
                            'No clients found',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )
                              :
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 15,
                                  right: 15
                                ),
                                child: Form(
                                  child: defaultFormField(
                                      suffix: Icons.start,
                                      suffixIconColor: Colors.blueAccent,
                                      prefix: Icons.search,
                                      controller: searchController,
                                      validate: (value){

                                      },
                                      keyboardType: TextInputType.text,
                                      labelText: 'Search with CIN...',
                                    pressOnIcon: (){

                                    }
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 30,
                                  top: 10
                                ),
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context,position) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: ExpansionTileCard(
                                      baseColor: Colors.white38,
                                      elevation: 20,
                                      leading: CircleAvatar(child: Icon(Icons.person_pin_rounded)),
                                      title: Text('${HomeCubit.get(context).clients[position].fullName} (${HomeCubit.get(context).clients[position].cin})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      subtitle: Text('${HomeCubit.get(context).clients[position].phone}'),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 8.0,
                                            ),
                                            child: Text(
                                              "${HomeCubit.get(context).clients[position].email}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: TextButton(
                                            style: flatButtonStyle,
                                            onPressed: () {
                                              final clientCIN = HomeCubit.get(context).clients[position].cin;
                                              Navigator.push(context, MaterialPageRoute(builder: (builder)=> ClientDocuments(clientCIN: clientCIN)));
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Icon(Icons.file_open_sharp, size: 40,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                ),
                                                Text('View this client\'s documents'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.spaceAround,
                                          buttonHeight: 52.0,
                                          buttonMinWidth: 90.0,
                                          children: <Widget>[
                                            TextButton(
                                              style: flatButtonStyle,
                                              onPressed: () {
                                                final clientCIN = HomeCubit.get(context).clients[position].cin;
                                                final employeeId = HomeCubit.get(context).empModel.uid;
                                                final agencyId = HomeCubit.get(context).clients[position].agencyId;
                                                Navigator.push(context, MaterialPageRoute(builder: (builder)=> DocumentsLayout(clientCIN: clientCIN,uid : employeeId,agencyId : agencyId)));
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.document_scanner,size: 30,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                  ),
                                                  Text('Add document',style: TextStyle(fontSize: 12),),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              style: flatButtonStyle,
                                              onPressed: () {
                                                final clientCIN = HomeCubit.get(context).clients[position].cin;
                                                final employeeId = HomeCubit.get(context).empModel.uid;
                                                final agencyId = HomeCubit.get(context).clients[position].agencyId;
                                                Navigator.push(context, MaterialPageRoute(builder: (builder)=> ChargeClientScreen(clientCIN: clientCIN,employeeId : employeeId,agencyId : agencyId)));
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.alarm_add_rounded),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                  ),
                                                  Text('Charge'),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              style: flatButtonStyle,
                                              onPressed: () {
                                                setState(() {
                                                  clientModel = HomeCubit.get(context).clients[position];
                                                  agencyId = HomeCubit.get(context).empModel.agencyId;
                                                });
                                                Navigator.push(context,MaterialPageRoute(builder: (builder)=> CreateNewClientScreen(agencyId: agencyId,update: true,client: clientModel,)));
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.edit,color: Colors.amber,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                  ),
                                                  Text('Modify',style: TextStyle(color: Colors.amber),),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              style: flatButtonStyle,
                                              onPressed: () {
                                                HomeCubit.get(context).deleteClient(cin: HomeCubit.get(context).clients[position].cin);
                                                setState(() {});
                                                showToast(
                                                    message: 'Deleted successfully',
                                                  bgColor: Colors.greenAccent,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.delete_forever,color: Colors.redAccent,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                  ),
                                                  Text('Delete',style: TextStyle(color: Colors.redAccent),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: HomeCubit.get(context).clients.length,

//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: ExpansionTileCard(
//                               key: cardB,
//                               expandedTextColor: Colors.red,
//                               leading: CircleAvatar(child: Text('B')),
//                               title: Text('Tap me!'),
//                               subtitle: Text('I expand, too!'),
//                               children: <Widget>[
//                                 Divider(
//                                   thickness: 1.0,
//                                   height: 1.0,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16.0,
//                                       vertical: 8.0,
//                                     ),
//                                     child: Text(
//                                       """Hi there, I'm a drop-in replacement for Flutter's ExpansionTile.
//
// Use me any time you think your app could benefit from being just a bit more Material.
//
// These buttons control the card above!""",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText2!
//                                           .copyWith(fontSize: 16),
//                                     ),
//                                   ),
//                                 ),
//                                 ButtonBar(
//                                   alignment: MainAxisAlignment.spaceAround,
//                                   buttonHeight: 52.0,
//                                   buttonMinWidth: 90.0,
//                                   children: <Widget>[
//                                     TextButton(
//                                       style: flatButtonStyle,
//                                       onPressed: () {
//                                         cardA.currentState?.expand();
//                                       },
//                                       child: Column(
//                                         children: <Widget>[
//                                           Icon(Icons.arrow_downward),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 2.0),
//                                           ),
//                                           Text('Open'),
//                                         ],
//                                       ),
//                                     ),
//                                     TextButton(
//                                       style: flatButtonStyle,
//                                       onPressed: () {
//                                         cardA.currentState?.collapse();
//                                       },
//                                       child: Column(
//                                         children: <Widget>[
//                                           Icon(Icons.arrow_upward),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 2.0),
//                                           ),
//                                           Text('Close'),
//                                         ],
//                                       ),
//                                     ),
//                                     TextButton(
//                                       style: flatButtonStyle,
//                                       onPressed: () {
//                                         cardA.currentState?.toggleExpansion();
//                                       },
//                                       child: Column(
//                                         children: <Widget>[
//                                           Icon(Icons.swap_vert),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 2.0),
//                                           ),
//                                           Text('Toggle'),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
                                   separatorBuilder: (BuildContext context, int index) => Padding(
                                     padding: const EdgeInsets.symmetric(
                                       vertical: 10,
                                     ),
                                     child: Column(children: [divider()],),
                                   ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),

                  ),

                ),
              ),
            ),
          ),
          listener: (BuildContext context, Object? state) {  },
),
    );
  }
}
