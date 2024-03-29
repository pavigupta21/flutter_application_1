import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _messages = [];
  List<File> _images = [];
  bool _showTextInput = true;

  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Directionality(
      textDirection: TextDirection.ltr, // Change if needed
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Teacher's username"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/chat.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true, // Start from bottom
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index], index);
                  },
                ),
              ),
              _showTextInput ? _buildTextInput() : _buildImageSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white, // Background color for text input field
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_rounded),
              onPressed: () {
                _pickImageFromCamera();
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendMessage(_textEditingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _sendMessage('');
          },
          child: Text('Send Image'),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(String message, int index) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              _showDeleteDialog(context, index);
            },
            onTap: () {
              if (message.startsWith('Image: ')) {
                _showImageDialog(message.substring('Image: '.length));
              }
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.02),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: _buildMessageContent(message),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String message) {
    if (message.startsWith('Image: ')) {
      String imagePath = message.substring('Image: '.length);
      return Image.file(File(imagePath));
    } else {
      return Text(
        message,
        style: TextStyle(color: Colors.white),
      );
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty || _images.isNotEmpty) {
      setState(() {
        if (message.isNotEmpty) {
          _messages.insert(
              0, message); // Insert at the beginning for ListView reverse
        }
        if (_images.isNotEmpty) {
          for (var image in _images) {
            _messages.insert(0, 'Image: ${image.path}');
          }
          _images.clear();
          _showTextInput = true;
        } else {
          _showTextInput = message.isNotEmpty;
        }
      });
      _textEditingController.clear();
    }
  }

  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Message"),
          content: Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(index);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return; // Return if no image is selected

    setState(() {
      _images.add(File(returnImage.path));
      _showTextInput = false;
    });
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              imageProvider: FileImage(File(imagePath)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2.0,
              enableRotation: true,
            ),
          ),
        );
      },
    );
  }
}
