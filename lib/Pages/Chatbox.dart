import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Chat extends StatefulWidget {

  String doubtId;


  Chat(this.doubtId);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textEditingController = TextEditingController();
  
  bool _showTextInput = true;

  bool isTeacher=false;

  Map<String, dynamic>? current;
  Map<String, dynamic>? opposite;

  List<Map<String, dynamic>> chatList=[];
  
  File? imgFile;

  getDoubtDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('doubt').doc(widget.doubtId).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Access the data from the document
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      // Now you can use data as needed
      print('Doubt data: $data');

      if(isTeacher){
        opposite=await getUserFromId(data['student']);
      }else{
        opposite=await getUserFromId(data['teacher']);
      }


      setState(() {});

    } else {
      print('No doubt found with the ID');
    }
  }

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    current=await getUserFromId(user!.uid);

    if(current!['role']=="teacher"){
      isTeacher=true;
    }else{
      isTeacher=false;
    }
    getDoubtDetails();
  }

  getOppositeUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> current=await getUserFromId(user!.uid);

    if(current['role']=="teacher"){
      isTeacher=true;
    }else{
      isTeacher=false;
    }
    getDoubtDetails();
  }

  Future<Map<String, dynamic>> getUserFromId(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists
    if (userDoc.exists) {
      // Access the data from the document
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Now you can use userData as needed
     return userData;

    } else {
      print('No user found with the ID');
      Map<String, dynamic>? userData;
      return userData!;
    }
  }

  getChat() async {
    try {

      Stream<QuerySnapshot> chatStream= await FirebaseFirestore.instance.collection('doubt').doc(widget.doubtId).collection("chat") .orderBy('timestamp', descending: true).snapshots();

      chatStream.listen((QuerySnapshot querySnapshot) {
        List<QueryDocumentSnapshot> userDocs = querySnapshot.docs;
        chatList = userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        if(mounted)
        setState(() {});

        print("chatlist   3333333333333333333    ${chatList.length}");
      }, onError: (error) {
        print('Error fetching chat data: $error');
      });

    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getChat();
    super.initState();
  }

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
          title: Text(opposite!=null?opposite!['username']:""),
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
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(chatList[index], index);
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
        Container(
          height:MediaQuery.of(context).size.width-100 ,
          child: Image.file(imgFile!),
        ),
        ElevatedButton(
          onPressed: () {
            _sendMessage('');
          },
          child: Text('Send Image'),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> d, int index) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      child: current!=null?
      Row(
        mainAxisAlignment: d['from']==current!['uid']?MainAxisAlignment.end:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              _showDeleteDialog(context, d['id']);
            },
            onTap: () {
              if (d['image'].toString().isNotEmpty) {
                _showImageDialog(d['image']);
              }
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: d['from']==current!['uid']?Radius.circular(20.0):Radius.circular(0.0),
                  bottomRight: d['from']==current!['uid']?Radius.circular(0.0):Radius.circular(20.0),
                ),
              ),
              child: _buildMessageContent(d['message'],d['image']),
            ),
          ),
        ],
      ):Container(),
    );
  }

  Widget _buildMessageContent(String message,String image) {
    if (message.isEmpty) {

      return Image.network(image);
    } else {
      return Text(
        message,
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty || imgFile!=null) {
        if (message.isNotEmpty) {
         // Insert at the beginning for ListView reverse
          storeMsg(message,"");
        }
        if (imgFile!=null) {


          List<int> bytes = await imgFile!.readAsBytes();
          // Convert the bytes to Uint8List
          Uint8List uint8list = Uint8List.fromList(bytes);

          final storageRef = FirebaseStorage.instance.ref();

          final vRef = storageRef.child("image/${DateTime.now().millisecondsSinceEpoch.toString()}.png");


            await vRef.putData(uint8list).then((p0)  {});

            await vRef.getDownloadURL().then((value) async {
              storeMsg(message,value);
            });




        } else {
          _showTextInput = message.isNotEmpty;
        }

      _textEditingController.clear();
    }
  }

  storeMsg(String msg,String img){

    DocumentReference documentReference = FirebaseFirestore.instance.collection('doubt').doc(widget.doubtId).collection("chat").doc();

    documentReference.set({
      'id':documentReference.id.toString(),
      'from': current!['uid'],
      'message': msg,
      'image':img,
      'timestamp':DateTime.now().millisecondsSinceEpoch.toString()
    });

    if(img.isNotEmpty){
      _showTextInput = true;
      imgFile=null;
    }

    _textEditingController.clear();

  }

  void _deleteMessage(String id) {

    try {
      FirebaseFirestore.instance
          .collection('doubt')
          .doc(widget.doubtId)
          .collection("chat")
          .doc(id) // Specify the document ID of the document to delete
          .delete();
      print('Chat deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }

  }

  void _showDeleteDialog(BuildContext context, String id) {
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
                _deleteMessage(id);
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
    imgFile=null;
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return; // Return if no image is selected

    setState(() {
      imgFile=File(returnImage.path);
      _showTextInput = false;
    });
  }

  void _showImageDialog(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              imageProvider: NetworkImage(url),
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
