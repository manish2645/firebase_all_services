import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_document/open_document.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CloudStorage extends StatefulWidget {
  const CloudStorage({Key? key}) : super(key: key);

  @override
  _CloudStorageState createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  int _currentIndex = 0;
  bool _uploading = false;
  double _uploadProgress = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF800B),
        title: Text('Cloud Storage'),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Upload File',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'List Folders & Files',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    if (_currentIndex == 0) {
      return Center(
        child: _uploading ? _buildUploadProgressIndicator() : _buildUploadButton(),
      );
    } else {
      return FutureBuilder<List<StorageItem>>(
        future: listItemsInStorage('uploads/'), // Update the path to your desired location
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildStorageTree(snapshot.data!);
          }
        },
      );
    }
  }


  Future<List<StorageItem>> listItemsInStorage(String storagePath) async {
    final storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref(storagePath).list();

    final List<StorageItem> items = [];

    for (var item in result.items) {
      final isFolder = item.name.endsWith('/');
      final itemName = isFolder ? item.name.split('/').first : item.name;
      items.add(StorageItem(name: itemName, reference: item, isFolder: isFolder));
    }
    return items;
  }

  Widget _buildStorageTree(List<StorageItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 20,
          child: ListTile(
            leading: item.isFolder ? Icon(Icons.folder,size: 40,) : Icon(Icons.insert_drive_file_sharp,size: 40,),
            title: Text(item.name),
            onTap: () {
              //_openImage(item.reference);
              if (item.isFolder) {
                _navigateToFolder(item.reference.fullPath);
              } else {
                _openFile(item.reference);
              }
            },
            // trailing: IconButton(
            //   onPressed: () {
            //
            //   },
            //   icon: Icon(Icons.download_for_offline_rounded, size: 30,),
            // )
          ),
        );
      },
    );
  }

  void _openImage(Reference fileReference) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/${fileReference.name}';

    if (File(filePath).existsSync()) {
      try {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(),
              body: PhotoView(
                imageProvider: FileImage(File(filePath)),
              ),
            );
          },
        ));
      } catch (e) {
        print('Error opening image: $e');
      }
    }
  }

  var _openResult = 'Unknown';
  Future<void> openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  void _openFile(Reference fileReference) async {
    final storage = FirebaseStorage.instance;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDir.path}/${fileReference.name}';

    try {
      EasyLoading.show(status: 'Downloading...');

      final File file = File(filePath);
      final DownloadTask task = fileReference.writeToFile(file);

      await task.whenComplete(() async {
        EasyLoading.dismiss();

        // Get the file extension
        String fileExtension = filePath.split('.').last.toLowerCase();

        if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
          _openImage(fileReference);
        } else if (fileExtension == 'pdf') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(),
                body: SfPdfViewer.file(file),
              );
            },
          ));
        } else if (
            fileExtension == 'doc' ||
            fileExtension == 'docx' ||
            fileExtension == 'xls' ||
            fileExtension == 'xlsx' ||
            fileExtension == 'ppt' ||
            fileExtension == 'pptx' ||
            fileExtension == 'csv') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Plugin example app'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('open result: $_openResult\n'),
                      TextButton(
                        child: Text('Tap to open file'),
                        onPressed: (){
                          openFile(filePath);
                          debugPrint(_openResult);
                        },
                      ),
                    ],
                  )
                ),
              );
            },
          ));
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      print('Error downloading or opening the file: $e');
    }
  }




  void _navigateToFolder(String folderPath) {
    listItemsInStorage(folderPath).then((items) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text(folderPath)),
            body: _buildStorageTree(items),
          );
        }),
      );
    });
  }

  Widget _buildUploadButton() {
    return ElevatedButton(
      onPressed: () {
        _uploadFile();
      },
      child: Text('Upload File'),
    );
  }

  Widget _buildUploadProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitCircle(
          color: Colors.blue,
          size: 50.0,
        ),
        SizedBox(height: 16.0),
        Text('Uploading... ${(100 * _uploadProgress).toStringAsFixed(2)}%'),
      ],
    );
  }

  Future<void> _uploadFile() async {
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.single;
      String fileName = file.name;
      Reference storageReference =
      FirebaseStorage.instance.ref().child("uploads/$fileName");

      UploadTask uploadTask = storageReference.putFile(File(file.path!));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress;
        });
      });

      await uploadTask.whenComplete(() {
        setState(() {
          _uploading = false;
        });

        // Show a success message
        _showSuccessMessage();
      });
    } else {
      setState(() {
        _uploading = false;
      });
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('File uploaded successfully'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

}

class StorageItem {
  final String name;
  final Reference reference;
  final bool isFolder;

  StorageItem({
    required this.name,
    required this.reference,
    this.isFolder = false,
  });
}


