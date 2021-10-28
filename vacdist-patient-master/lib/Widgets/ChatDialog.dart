import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vacdist/states/FlowtterState.dart';

import 'Chat.dart';

class ChatDialog extends StatefulWidget {
  ChatDialog(this.flowtterState);

  final FlowtterState flowtterState;

  @override
  _ChatDialogState createState() => _ChatDialogState(flowtterState);
}

class _ChatDialogState extends State<ChatDialog> {
  _ChatDialogState(this.flowtterState);

  final FlowtterState flowtterState;

  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Colors.blue,
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: flowtterState.sharedMessages.length,
                    itemBuilder: (context, index) {
                      var ret = Chat(
                          flowtterState.sharedMessages[index]['message'].toString(),
                          flowtterState.sharedMessages[index]['data']
                      );
                      print(ret);
                      return ret;
                    }
                  )
                ),

                Divider(
                  height: 5,
                  color: Colors.blue,
                ),
                Container(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 35,
                      ),
                      onPressed: (){},
                    ),
                    title: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromRGBO(220, 220, 220, 1)
                      ),
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter a message',
                          hintStyle: TextStyle(
                            color: Colors.black26
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),

                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        )
                      ),
                    ),

                    trailing: IconButton(
                      icon: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.blue,
                      ),
                      onPressed: () async {
                        if(messageController.text.isEmpty) {
                          print('empty message');
                        }
                        else {
                          flowtterState.insertMessage({
                            'data': 1,
                            'message': messageController.text
                          });
                          await flowtterState.insertResponse(messageController.text);
                          setState(() {
                            messageController.clear();
                            var currentFocus = FocusScope.of(context);
                            if(!currentFocus.hasPrimaryFocus){
                              currentFocus.unfocus();
                            }
                          });
                        }
                      },
                    ),
                  )
                )
              ]
            )
          )
      ])
    );
  }
}