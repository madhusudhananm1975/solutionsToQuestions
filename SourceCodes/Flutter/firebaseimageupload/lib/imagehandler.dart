
import 'dart:async';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import './fibanocci.dart';
import './balancedsubstring.dart';
import 'package:string_validator/string_validator.dart';



class ImageHandler extends StatefulWidget {
  const ImageHandler({super.key});

  @override
  State<ImageHandler> createState() => ImageManager();
}

class ImageManager extends State<ImageHandler> {
  static final _formkey = GlobalKey<FormState>();

bool submitClicked = false;
bool filePicked = false;
bool videoUploadCompleted = false;
String submitLabel = "Upload File";
String firebasePath = "imagestore";
String message = "";
double webProgress = 0;

late Uint8List imagedata;
late firebase_storage.UploadTask uploadTask;
late firebase_storage.TaskSnapshot snapshot;
static late Uint8List? filePickerFileBytes;
late VideoPlayerController _controller;
late String fileName;
String fileType = "";
late String urlDownload;
List<String> imageTypes = ["jpg", "jpeg", "heic", "png", "bmp"];
List<String> videoTypes = ["mp4", "mov", "avi", "m4v", "3gp"];
String emptyVideo = "assets/videos/emptyvideo.mp4";

  final fibonacciInput = TextEditingController();
  final balStringInput = TextEditingController();

    @override
  void initState() {
    super.initState();
   
    _controller = VideoPlayerController.asset(emptyVideo)..initialize().then((_) {
                                  setState(() {});
                                  _controller.setLooping(false);  
                              });
    _controller.pause();
  }

Future<void> pickFile() async {

   _controller.pause();
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions:['jpg', 'mp4'], withData: true);

  if (result != null) {
    filePickerFileBytes = result.files.first.bytes;
    imagedata = filePickerFileBytes!;
    fileName = result.files.first.name;
    fileType = result.files.first.extension!;
    filePicked = true;
    if (imageTypes.contains(result.files.first.extension!)) {
      fileType = "image";
    } else if (videoTypes.contains(result.files.first.extension!)){
      fileType = "video";
    }

    setState(() {});         
  }
  return;

}

void playVideo()
{
    setState(() {
                _controller.pause();
                log('videoUploadCompleted ', name: videoUploadCompleted.toString());
                log('Download URL ', name: urlDownload.toString());
                _controller.play(); 
                setState(() {});
                _controller.addListener(() 
                  {
                      if (_controller.value.isCompleted) {
                        log('Video Completed', name: urlDownload.toString());
                      }
                  },);

                  submitClicked = false;

            },); 

}

void showMessage()
{

    showDialog(
          context: context,
          builder: (context) => AlertDialog(
                    title: const Text("Status"),
                    content: Text(message),
                    actions: [ TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')) ]
                  )
        );// showDialog
}

Future uploadFileToFireStore() async {

    try {
          uploadTask = firebase_storage.FirebaseStorage.instance
                                        .ref()
                                        .child('$firebasePath/$fileName').putData(imagedata);
          uploadTask.snapshotEvents.listen((event){
                                    setState(() {
                                      webProgress = ((event.bytesTransferred.toDouble()/event.totalBytes.toDouble()) *  98 ).roundToDouble();
                                    });
                                  });

          snapshot = await uploadTask.whenComplete((){});

          urlDownload = await snapshot.ref.getDownloadURL();
          filePicked = false;
          submitClicked = false;

          if ((urlDownload.length > 1) && (fileType == "video"))
          {
              videoUploadCompleted = true;
              _controller.pause();
              _controller = VideoPlayerController.networkUrl(Uri.parse(urlDownload) )
                                                 ..initialize().then((_) { setState(() { }); }  ) ;
          }
          
          setState((){  });
          message = "File has been successfully uploaded to Firebase";
          showMessage();

      } catch (e) {
                  log('error occured',  name: e.toString());
                  }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    fibonacciInput.dispose();
    balStringInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    Form(
      key: _formkey,
    child: Scaffold(
          resizeToAvoidBottomInset: true, 
          extendBody: false,
          appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text('Solutions For Questions'),                
                  ),

          body: SizedBox(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
            child: Column(children: [
            const SizedBox(height: 6),
            Card(
                 borderOnForeground: false,
                 color: const Color.fromARGB(255, 255, 255, 255),
                 child: Column(
                   children: [
                      if(fileType != "video")
                        if (filePicked) // display the selected image
                            FittedBox( fit: BoxFit.cover, 
                                      child: SizedBox(width: 420, height: 380,
                                      child: Image.memory(filePickerFileBytes!, fit: BoxFit.fill),
                                                      ),
                                    )
                        else // display the placeholder
                          FittedBox( fit: BoxFit.cover, 
                                   child: SizedBox(width: 420, height: 380,
                                   //child: Placeholder(color:Colors.grey, strokeWidth: 0.0,),
                                   child: Image.asset('assets/images/emptyjpg.jpg', fit: BoxFit.fill)
                                                  ),
                                 )   
                      else if ((fileType == "video") && (filePicked)) //for video files - web usage of file path is yet provisioned so displaying the filename
                            FittedBox( fit: BoxFit.cover, 
                                      alignment: Alignment.center,
                                      child: SizedBox(width: 420, height: 380,
                                      child: Text("Selected Video File: \n $fileName", textAlign: TextAlign.center, style: const TextStyle(fontSize:24)),
                                                      ),
                                    ),

                               
                    if(videoUploadCompleted)
                            FittedBox( fit: BoxFit.cover, // Set BoxFit to cover the entire container
                                       child: SizedBox(width: 420, height: 380,
                                              child: VideoPlayer(_controller),
                                                              ),
                    ),
                
                const SizedBox(height: 9),
                if(submitClicked)
                  SizedBox(
                  height:12, 
                  width:200,
                  child: LinearProgressIndicator(
                                                value: webProgress/98,
                                                valueColor: const AlwaysStoppedAnimation(Color.fromARGB(255, 65, 130, 24)),
                                                backgroundColor: const Color.fromARGB(255, 193, 192, 200),
                                                color: Colors.green,
                                                ),
                          )
                else
                const SizedBox(),

                const SizedBox(height: 6),      
                if(submitClicked)
                  Text("$webProgress%", style: const TextStyle(color: Color.fromARGB(255, 169, 4, 4)), )
                else
                  const SizedBox(),

                const SizedBox(height: 9),
                Row(
                children: <Widget>[
                      Expanded(child: 
                          ElevatedButton(
                            onPressed: () {
                                                if (submitClicked)
                                                {
                                                    message = " Please wait.\nPrevious upload is in progress ";
                                                    showMessage();
                                                }
                                                else
                                                {
                                                    _controller.pause();
                                                    videoUploadCompleted = false;
                                                    filePicked = false;
                                                    urlDownload = "";
                                                    pickFile();
                                                }
                                            }, //OnPressed
                            style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        padding: const EdgeInsets.symmetric(vertical: 9),
                                        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                        ),
                            child: const Text("Pick File",
                                        style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 20),
                                            ),
                          ),
                    ),
                    const SizedBox(width: 6),
                    if(filePicked)
                      Expanded(child: 
                          ElevatedButton(
                                onPressed: () {
                                                if (submitClicked)
                                                {
                                                    message = " Please wait.\nPrevious upload is in progress ";
                                                    showMessage();
                                                }
                                                else
                                                {
                                                  submitClicked = true;
                                                  uploadFileToFireStore();
                                                }
                                              }, //OnPressed
                            style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        padding: const EdgeInsets.symmetric(vertical: 9),
                                        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                        ),
                            child: Text(submitLabel,
                                        style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 20),
                                      ),
                        ),
                      ),
                    ]
                ),
                              
                const SizedBox(height: 9),
                if (videoUploadCompleted)
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[ 
                      Expanded(child: 
                        ElevatedButton(
                              onPressed: () {
                                              playVideo();
                                            }, //OnPressed
                              style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                          ),
                              child: const Text("Play Video",
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 20),
                                        ),
                              ),
                        ),
                      const SizedBox(width: 6),
                       Expanded(child: 
                        ElevatedButton(
                              onPressed: () {
                                              _controller.pause();                                       
                                            }, //OnPressed
                              style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                          ),
                              child: const Text("Stop Video",
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 20),
                                        ),
                              ),
                        ),
                      ],
                   ),
 
                  const SizedBox(height: 15),
                  ],
                ),
              ),
            const SizedBox(width: 9),
            Card(
                 borderOnForeground: false,
                 color: const Color.fromARGB(255, 255, 255, 255),
                 child: Column(
                   children: [

                                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      //maxLength:100,
                      //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: balStringInput,
                      decoration: InputDecoration(
                          hintText: "Input-Balnced Substring ",
                          //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3)),  ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          //prefixIcon: const Icon(Icons.text_fields_outlined)
                          ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                   const SizedBox(width: 6),
                       Expanded(child: 
                        ElevatedButton(
                              onPressed: () {
                                                if (balStringInput.value.text.isNotEmpty)
                                                {
                                                        _controller.pause();
                                                        List balSubStr = [];
                                                        balSubStr = [];
                                                        balSubStr = balancedSubString(balStringInput.value.text);
                                                        message = "Longest Balanced SubString(s) : \n";
                                                        if (balSubStr.isEmpty){
                                                          message = "${message}No Balanced SubString exists";
                                                        }
                                                        else{
                                                                for (var item in balSubStr) { 
                                                                    message = "$message\n$item";
                                                                    }
                                                        }
                                                        showMessage();   
                                                }
                                                else{
                                                  message = "Please enter a string to find balanced substring";
                                                  showMessage();
                                                }
                                          
                                            }, //OnPressed
                              style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                          ),
                              child: const Text("Balanced Substring",
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 14),
                                        ),
                              ),
                        ),

                ]),
              ]
                 )
            ),

            const SizedBox(width: 9),
            Card(
                 borderOnForeground: false,
                 color: const Color.fromARGB(255, 255, 255, 255),
                 child: Column(
                   children: [

                                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                       onFieldSubmitted: (value) {}, 
                              validator: (value) { 
                                if (value!.isEmpty) { 
                                  return 'Enter a valid number!'; 
                                } 
                                return null; 
                              },
                      controller: fibonacciInput,
                      decoration: InputDecoration(
                          hintText: "Fibonacci N input ",
                          //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3)),  ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          //prefixIcon: const Icon(Icons.text_fields_outlined)
                          ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                   const SizedBox(width: 6),
                       Expanded(child: 
                        ElevatedButton(
                              onPressed: () {
                                                if ((fibonacciInput.value.text.isNotEmpty) && (isNumeric(fibonacciInput.value.text) ))
                                                {
                                                    double fibonaciiValue = 0;
                                                    fibonaciiValue = fibfunc(double.parse(fibonacciInput.value.text));
                                                    log('fibonaciiValue = ', name: fibonaciiValue.toString());
                                                    message = "Fibonacci at ${fibonacciInput.value.text} position is \n$fibonaciiValue";
                                                    message = "$message\n\n please note: 0 is considered as the First value.";
                                                    showMessage(); 
                                                }
                                                else{
                                                    message = "Please enter value for N to find Nth Term in Fibonacci series";
                                                    showMessage();
                                                }
                                    
                                            }, //OnPressed
                              style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                                          ),
                              child: const Text("Find Fibanocci",
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 14),
                                        ),
                              ),
                        ),

                ]),
                   ]
                 )
            ),



            ],
          )
        ),
      ),
    ),
    );
  } //widget build
}
