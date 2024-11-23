import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/utils/my_border.dart';

class UpdateUsersInformation extends StatefulWidget {
  final UserModel userModel;
  const UpdateUsersInformation({super.key, required this.userModel});

  @override
  State<UpdateUsersInformation> createState() => _UpdateUsersInformationState();
}

class _UpdateUsersInformationState extends State<UpdateUsersInformation> {
  late FocusNode _nameNode;
  late FocusNode _phoneNumberNode;
  late FocusNode _addressNode;
  final _formKey = GlobalKey<FormState>();
  String initialImagePath = '';
  late bool _isLoading;

  var fullNameEditingController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var addressEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _nameNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _addressNode = FocusNode();

    fullNameEditingController.text = widget.userModel.fullName;
    phoneNumberController.text = widget.userModel.phoneNumber;
    addressEditingController.text = widget.userModel.address;
    initialImagePath = widget.userModel.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _nameNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      setState(() => _isLoading = true);
      if (initialImagePath != widget.userModel.imageUrl) {
        //Checking if the user is logged In using google account then writing logic for changing that image also.
        if (initialImagePath.contains('firebasestorage')) {
          //user have images that if not from google account
          final FirebaseStorage _storage = FirebaseStorage.instance;
          final reference = _storage.refFromURL(initialImagePath);
          await reference.delete();
          // Upload picture to Firebase Storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('userimages')
              .child(widget.userModel.id + '.jpg');
          await ref
              .putFile(File(widget.userModel.imageUrl))
              .then((_) async => ref.getDownloadURL())
              .then((imageUrl) => widget.userModel.imageUrl = imageUrl)
              .catchError((e) {
            throw e.toString();
          });
        } else {
           // Upload picture to Firebase Storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('userimages')
              .child(widget.userModel.id + '.jpg');
          await ref
              .putFile(File(widget.userModel.imageUrl))
              .then((_) async => ref.getDownloadURL())
              .then((imageUrl) => widget.userModel.imageUrl = imageUrl)
              .catchError((e) {
            throw e.toString();
          });
        }
      } else {
        widget.userModel.imageUrl = initialImagePath;
      }
      userDataProvider.updateUserData(widget.userModel).then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }).catchError((error) {
        if (error.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(context);
        } else {
          MyAlertDialog.error(context, error.message.toString());
        }
      }).whenComplete(() {
        setState(() => _isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.06, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Center(
                    child: Stack(
                      children: [
                        ImageViewer(
                          imagePath: widget.userModel.imageUrl,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 26,
                            width: 26,
                            child: RawMaterialButton(
                              elevation: 5,
                              fillColor: Theme.of(context).primaryColor,
                              shape: const CircleBorder(),
                              onPressed: () async {
                                MyAlertDialog.imagePicker(context).then(
                                  (pickedImagePath) {
                                    if (pickedImagePath != null &&
                                        pickedImagePath.toString().isNotEmpty) {
                                      setState(() => widget.userModel.imageUrl =
                                          pickedImagePath);
                                    }
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name TextFormField
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            key: const ValueKey('Full Name'),
                            controller: fullNameEditingController,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your full name'
                                : null,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              contentPadding: EdgeInsets.all(12),
                              border: const OutlineInputBorder(),
                              enabledBorder:
                                  MyBorder.outlineInputBorder(context),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            onEditingComplete: () =>
                                FocusScope.of(context).requestFocus(_nameNode),
                            onSaved: (value) =>
                                widget.userModel.fullName = value!,
                          ),
                        ),

                        // Phone Number TextFormField
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: phoneNumberController,
                            key: const ValueKey('Phone Number'),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a valid phone number'
                                : null,
                            focusNode: _phoneNumberNode,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              contentPadding: EdgeInsets.all(12),
                              border: const OutlineInputBorder(),
                              enabledBorder:
                                  MyBorder.outlineInputBorder(context),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_addressNode),
                            onSaved: (value) =>
                                widget.userModel.phoneNumber = value!,
                          ),
                        ),
                        // Address
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: addressEditingController,
                            key: const ValueKey('Address'),
                            validator: (value) => value!.isEmpty
                                ? 'Please Enter full address'
                                : null,
                            focusNode: _addressNode,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'Country/State/City/Street/ZIP',
                              contentPadding: const EdgeInsets.all(12),
                              border: const OutlineInputBorder(),
                              enabledBorder:
                                  MyBorder.outlineInputBorder(context),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            onEditingComplete: () =>
                                FocusScope.of(context).requestFocus(),
                            onSaved: (value) =>
                                widget.userModel.address = value!,
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: Material(
                                color: Theme.of(context).primaryColor,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Text(
                                      'Cancel !'.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Update button

                            const Spacer(),
                            // cancel Update button

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: Material(
                                color: Theme.of(context).primaryColor,
                                child: InkWell(
                                  onTap: _isLoading
                                      ? () {}
                                      : () {
                                          _submitForm();
                                          FocusScope.of(context).unfocus();
                                        },
                                  child: Center(
                                    child: !_isLoading
                                        ? Text(
                                            'Update !'.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          )
                                        : const CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatefulWidget {
  final String? imagePath;
  const ImageViewer({super.key, required this.imagePath});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool _isNetworkImage(String? path) {
    return path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Fixed height
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
        color: Colors.grey[200],
        image: DecorationImage(
          image: _isNetworkImage(widget.imagePath)
              ? CachedNetworkImageProvider(widget.imagePath!)
              : FileImage(File(widget.imagePath!)),
          fit: BoxFit.cover,
        ),
      ),

      // Show local file image
    );
  }
}
