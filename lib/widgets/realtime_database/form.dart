

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/userDataModel.dart';

class PersonalDetailsForm extends StatefulWidget {
  @override
  _PersonalDetailsFormState createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nameController.text = value!;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emailController.text = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _dob = value;
                      });
                    }
                  });
                },
                validator: (value) {
                  if (_dob == null) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
                readOnly: true,
                controller: TextEditingController(
                  text: _dob != null
                      ? "${_dob!.day}/${_dob!.month}/${_dob!.year}"
                      : '',
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  icon: Icon(Icons.people),
                ),
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _gender = value;
                  });
                },
                value: _gender,
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  icon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumberController.text = value!;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  icon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addressController.text = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data saved successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String string) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed'),
          content: Text(string),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Date of Birth: $_dob');
      print('Gender: $_gender');
      print('Phone Number: ${_phoneNumberController.text}');
      print('Address: ${_addressController.text}');
      User userData = User(
          dob: _dob!.toIso8601String(),
          email: _emailController.text,
          gender: _gender!,
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          address: _addressController.text
      );
      // Save data to Firebase
      try {
        savePersonalDetailsToFirebase(userData);
      } catch (error) {
        print('Error saving data: $error');
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _dob = null;
    _gender = null;
    _phoneNumberController.clear();
    _addressController.clear();
  }



  void savePersonalDetailsToFirebase(User userData) {
    final databaseReference = FirebaseDatabase.instance.reference();
    final personalDetailsRef = databaseReference.child('personal_details');

    personalDetailsRef.push().set(userData.toJson()).then((_) {
      // Data saved successfully
      _showSuccessDialog();
    }).catchError((error) {
      // Handle the error and provide feedback to the user
      _showErrorDialog(error.toString());
    });
  }



}
