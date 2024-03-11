import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class UserData {
  String key;
  String address;
  String dob;
  String email;
  String gender;
  String name;
  String phoneNumber;

  UserData(this.key,this.address, this.dob, this.email, this.gender, this.name, this.phoneNumber);

  Map<String, dynamic> toMap() {
    return {
      'key':key,
      'address': address,
      'dob': dob,
      'email': email,
      'gender': gender,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

class _UserListScreenState extends State<UserListScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<UserData> userDataList = [];
  UserData? userToBeUpdated;

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
    databaseReference.child('personal_details').get().then((DataSnapshot dataSnapshot) {
      final Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        values.forEach((key, data) {
          final Map<dynamic, dynamic>? userValues = data as Map<dynamic, dynamic>?;
          if (userValues != null) {
            UserData user = UserData(
              key,
              userValues['address'] ?? 'Address Not Provided',
              userValues['dob'] ?? 'Date of Birth Not Provided',
              userValues['email'] ?? 'Email Not Provided',
              userValues['gender'] ?? 'Gender Not Provided',
              userValues['name'] ?? 'Name Not Provided',
              userValues['phoneNumber'] ?? 'Phone Number Not Provided',
            );
            setState(() {
              userDataList.add(user);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userDataList.isEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Data Found')
              ],
            )
          )
          : ListView.builder(
        itemCount: userDataList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                deleteUserDataByKey(userDataList[index].key);
              });
            },
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(Icons.person,size: 40,),
                title: Text(userDataList[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userDataList[index].email),
                    //Text(userDataList[index].dob),
                    Text(userDataList[index].gender),
                    Text(userDataList[index].phoneNumber),
                  ],
                ),
                trailing: Column(
                  children: [
                    IconButton(
                        onPressed: (){
                          userToBeUpdated = userDataList[index];
                          openUpdateDialog(context, userToBeUpdated!);
                          },
                        icon: Icon(Icons.cloud_upload_outlined, color: Colors.blue,)
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteUserDataByKey(String userKey) {
    final databaseReference = FirebaseDatabase.instance.ref();
    final userRef = databaseReference.child('personal_details').child(userKey);
    userRef.remove().then((_) {
      print("Data deleted successfully!");
    }).catchError((error) {
      print("Error deleting data: $error");
    });
  }

  void openUpdateDialog(BuildContext context, UserData user) {

    TextEditingController nameController = TextEditingController(text: user.name);
    TextEditingController addressController = TextEditingController(text: user.address);
    TextEditingController dobController = TextEditingController(text: user.dob);
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController genderController = TextEditingController(text: user.gender);
    TextEditingController phoneController = TextEditingController(text: user.phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update User Data'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    // Update the user's name.
                    nameController.text = value;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: addressController,
                  onChanged: (value) {
                    addressController.text = value;
                    // Update the user's address.
                  },
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: dobController,
                  onChanged: (value) {
                    dobController.text = value;
                    // Update the user's date of birth.
                  },
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    emailController.text = value;
                    // Update the user's email.
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: genderController,
                  onChanged: (value) {
                    genderController.text = value;
                    // Update the user's gender.
                  },
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: phoneController,
                  onChanged: (value) {
                    phoneController.text = value;
                    // Update the user's phone number.
                  },
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (user != null) {
                  user.name = nameController.text;
                  user.address = addressController.text;
                  user.dob = dobController.text;
                  user.email = emailController.text;
                  user.gender = genderController.text;
                  user.phoneNumber = phoneController.text;

                  databaseReference
                      .child('personal_details')
                      .child(user.key)
                      .update(user.toMap());
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
