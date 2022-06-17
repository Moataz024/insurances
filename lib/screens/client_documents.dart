import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/cubit/docubit/cubit.dart';
import 'package:insurances/shared/cubit/docubit/states.dart';

class ClientDocuments extends StatefulWidget {
  final clientCIN;
  const ClientDocuments({Key? key, this.clientCIN}) : super(key: key);

  @override
  _ClientDocumentsState createState() => _ClientDocumentsState();
}

class _ClientDocumentsState extends State<ClientDocuments> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          DocCubit()..getClientDocuments(clientCIN: widget.clientCIN),
      child: BlocConsumer<DocCubit,DocStates>(
        listener: (BuildContext context, state) {
        },
        builder: (BuildContext context, Object? state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ConditionalBuilder(
                  condition: state is DocumentsSuccessState,
                  fallback: (BuildContext context) => LinearProgressIndicator(),
                  builder: (BuildContext context) {
                    return DocCubit.get(context).clientDocs.length != 0 ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) => Stack(
                            children: [
                              Ink.image(
                                height: 600,
                                image: NetworkImage(DocCubit.get(context)
                                    .clientDocs[index]
                                    .fileUrl!),
                                fit: BoxFit.fitWidth,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${DocCubit.get(context)
                                    .clientDocs[index]
                                    .creationDate}'),
                              ),
                            ],
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: divider(),
                              ),
                          itemCount: DocCubit.get(context).clientDocs.length),
                    )
                        :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 300,horizontal: 50),
                      child: Text('No documents found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.grey),textAlign: TextAlign.center,),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
