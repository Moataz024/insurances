import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/agency_home.dart';
import 'package:insurances/screens/agency_layouts/create_employee.dart';
import 'package:insurances/shared/cubit/screeens_cubits/profile_states.dart';
import '../../model/employee_model.dart';
import '../../shared/componenets/components.dart';
import '../../shared/cubit/screeens_cubits/profile_cubit.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {

  late final EmployeeModel model;
  bool hasPermission = false;
  bool canDelete = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => ProfileCubit()..getCoWorkers(),
        child: BlocConsumer
          <ProfileCubit,ProfileStates>(
          builder: (BuildContext context, state) => ConditionalBuilder(
            fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
            condition: state is! GetEmployeeLoadingState ,
            builder: (BuildContext context) => SingleChildScrollView(
              child: Column(
                children: [
                  ConditionalBuilder(
                      condition: state is! CoWorkersLoadingState,
                      builder: (context) =>  ConditionalBuilder(
                          condition: state is! CoWorkersSuccessState,
                          builder:(context)=> Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      bottom: 10,
                                    ),
                                    child: Text('${ProfileCubit.get(context).coWorkers.length} FOUND',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.left,),
                                  ),
                                  Spacer(),
                                  ProfileCubit.get(context).model.responsible != null ? ProfileCubit.get(context).model.responsible! == true ?
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20,
                                    ),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => CreateEmployeeScreen()));
                                      },
                                      icon: Icon(Icons.add, size: 18),
                                      label: Text("Create new member",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                      :
                                      Container()
                                      :
                                      Container()

                                ],
                              ),
                              ProfileCubit.get(context).coWorkers.length == 0 ?
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 100
                                  ),
                                  child: Text(
                                    'You are the only one on the team',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  ),
                                ),
                              )
                                  :

                              ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (BuildContext context, int index) => divider(),
                                itemBuilder: (BuildContext context, int index)=> Slidable(
                                  // Specify a key if the Slidable is dismissible.
                                  key: ValueKey(0),

                                  // The start action pane is the one at the left or the top side.
                                  startActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: ScrollMotion(),

                                    // A pane can dismiss the Slidable.

                                    // All actions are defined in the children parameter.
                                    children: [
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                        onPressed: (context){
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=> AgencyHomeScreen(index: 1,)), (route) => false);

                                          ProfileCubit.get(context).deleteRecord(ProfileCubit.get(context).coWorkers[index]);
                                        },
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),

                                  // The end action pane is the one at the right or the bottom side.
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        // An action can be bigger than the others.
                                        flex: 2,
                                        onPressed: (BuildContext context){},
                                        backgroundColor: Color(0xFF7BC043),
                                        foregroundColor: Colors.white,
                                        icon: Icons.archive,
                                        label: 'Archive',
                                      ),
                                    ],
                                  ),

                                  // The child of the Slidable is what the user sees when the
                                  // component is not dragged.
                                  child: ListTile(

                                    title: Center(child: Text('${ProfileCubit.get(context).coWorkers[index].fullName} (${ProfileCubit.get(context).coWorkers[index].phone})')),


                                  ),
                                ),
                                itemCount: ProfileCubit.get(context).coWorkers.length,

                              )
                            ],
                          ),
                          fallback: (context)=> Container(
                            child: Text('The list is empty'),
                          )),
                      fallback: (BuildContext context) => LinearProgressIndicator()),
                ],
              ),
            ),
          ),
          listener: (BuildContext context, Object? state) {
            if(state is CoWorkersSuccessState) {
             if(state is LoadingDeleteState){
               showToast(message: 'Deleting...');
             }
             if(state is SuccessDeleteState){
               setState(() {});
               showToast(
                   gravity: ToastGravity.BOTTOM,
                   message: 'Deleted');
             }
            }

          },
        ),
      );
  }
}