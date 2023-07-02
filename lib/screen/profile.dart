import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uploader_app/model/profile_model.dart';
import 'package:uploader_app/repo/profile_repo.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  File? _selectedImage;

  String imageName = '';
  bool imageError = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process form data or submit it to an API
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String address = _addressController.text;
      String phoneNumber = _phoneNumberController.text;
      String nationality = _nationalityController.text;
      File? image = _selectedImage;

      if (image == null) {
        setImageError();
        return;
      }

      ProfileModel profileModel = ProfileModel(
          firstname: firstName,
          lastname: lastName,
          address: address,
          phone: phoneNumber,
          nationality: nationality,
          image: image);

      ProfileRepo profileRepo = ProfileRepo();

      profileRepo.updateProfile(profileModel);

      return;

      // Perform further actions with the form data

      // Reset the form
      _formKey.currentState!.reset();
      setState(() {
        imageName = '';
      });
      _selectedImage = null;
    }
  }

  selectImage(ImageSource imageSource) async {
    final imageTemp = await ImagePicker().pickImage(
      source: imageSource,
    );

    if (imageTemp == null) {
      setImageError();
      return;
    }

    setState(() {
      imageName = imageTemp.name;
      imageError = false;
      _selectedImage = File(imageTemp.path);
    });
  }

  setImageError() {
    setState(() {
      imageName = 'Please select image';
      imageError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _nationalityController,
                decoration: const InputDecoration(labelText: 'Nationality'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your nationality';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              ElevatedButton(
                onPressed: () {
                  selectImage(ImageSource.gallery);
                },
                child: const Text('Select Image'),
              ),
              if (imageName.isNotEmpty) const SizedBox(height: 16.0),
              if (imageName.isNotEmpty)
                Text(
                  imageName,
                  style:
                      TextStyle(color: imageError ? Colors.red : Colors.black),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
