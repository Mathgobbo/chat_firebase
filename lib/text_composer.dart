import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  final Function({String text, File imgFile}) sendMessage;

  TextComposer(this.sendMessage);

   @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  TextEditingController _controller = new TextEditingController();
  bool _isComposing = false;
  ImagePicker imagePicker = new ImagePicker();
  void reset(){
    setState(() {
      _controller.clear();
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: ()async {
              final PickedFile picked = await imagePicker.getImage(source: ImageSource.gallery);
              File imgFile = File(picked.path);
              if(imgFile == null) return;

              widget.sendMessage(imgFile: imgFile);

            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem",),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                this.widget.sendMessage(text: text);
                reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              widget.sendMessage(text: _controller.text);
              reset();
            } : null,
          ),
        ],
      ),
    );
  }
}
