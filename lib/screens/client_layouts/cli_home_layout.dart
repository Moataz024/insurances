import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              builder: (BuildContext context) => Column(
                children: [
                  Center(child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[300],
                          boxShadow:[
                            BoxShadow(color: Colors.grey, spreadRadius: 2),
                          ],
                        ),
                        height: 70,
                        child: Center(
                          child: Text('${CliAgencyCubit.get(context).agencyModel.name}',
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    )
                  ),
                  Text('Responsisble : ${CliAgencyCubit.get(context).agencyModel.Location}'),
                  Text('Contact :'),
                  Text('Email : ${CliAgencyCubit.get(context).agencyModel.email}'),
                  Text('Phone : ${CliAgencyCubit.get(context).agencyModel.contactPhone}'),
                  Text('Responsible : ${CliAgencyCubit.get(context).employeeModel.fullName}'),
                  Text('Phone : ${CliAgencyCubit.get(context).agencyModel.contactPhone}')

                ],
              ),
              condition: state is! LoadingAgencyState,

            ),

    ),
    );
  }
}
