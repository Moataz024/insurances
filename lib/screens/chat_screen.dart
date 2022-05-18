import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/message_cubit/cubit.dart';
import 'package:insurances/shared/cubit/message_cubit/states.dart';

import '../model/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MessageCubit()
        ..getMessages(),
      child: BlocConsumer<MessageCubit, MessageStates>(
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightTheme ? Colors.blueAccent : Colors.blueGrey,
            title: Text('Chat'),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {

                    });
        },
                  icon: Icon(Icons.refresh_outlined)),
            ],
          ),
          body: ConditionalBuilder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: ()=> MessageCubit.get(context).getMessages(),
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (MessageCubit.get(context).messages.length == 0) {
                            return Container(
                              child: Text('No messages found'),
                            );
                          }
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              MessageCubit.get(context).messages[index].senderId)
                            return buildMyMessage(
                                MessageCubit.get(context).messages[index]);
                          return buildMessage(
                              MessageCubit.get(context).messages[index]);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: MessageCubit.get(context).messages.length,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: TextFormField(
                                controller: messageController,
                                onFieldSubmitted: (value) {
                                  messageController.text = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message...',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: MaterialButton(
                              height: 40,
                              minWidth: 1,
                              onPressed: () {
                                MessageCubit.get(context).sendMessage(
                                  message: messageController.text.toString(),
                                  dateTime: DateTime.now().toString(),
                                );
                                setState(() {
                                  messageController.text = '';
                                });
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fallback: (BuildContext context) => LinearProgressIndicator(),
            condition: state is! GetEmployeeLoadingState,

          ),
        ),
        listener: (BuildContext context, Object? state) {
            MessageCubit.get(context).messages.map((e) {
              if(e.agencyId != MessageCubit.get(context).empModel.agencyId){
                MessageCubit.get(context).messages.remove(e);
              }
            });

        },
      ),
    );
  }

  Widget buildMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${model.sender}',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Text('${model.message}'),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildMyMessage(MessageModel model) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${model.sender}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Text('${model.message}'),
                ],
              )),
        ],
      ),
    );
  }
}
