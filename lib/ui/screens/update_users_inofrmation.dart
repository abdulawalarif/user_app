import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/utils/my_border.dart';
import 'package:user_app/ui/widgets/image_preview.dart';

class UpdateUsersInformation extends StatefulWidget {
  const UpdateUsersInformation({super.key});

  @override
  State<UpdateUsersInformation> createState() => _UpdateUsersInformationState();
}

class _UpdateUsersInformationState extends State<UpdateUsersInformation> {
  late FocusNode _nameNode;
  late FocusNode _phoneNumberNode;
  late FocusNode _addressNode;
  final _formKey = GlobalKey<FormState>();
  late UserModel _userModel;
  late bool _isLoading;
  String _pickedImagePath = '';
  var fullNameEditingController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var addressEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userModel = UserModel();
    _isLoading = false;
    _nameNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _addressNode = FocusNode();

    final _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _userDataProvider.fetchUserData();

    _userModel = _userDataProvider.userData;
    fullNameEditingController.text= _userModel.fullName;
    phoneNumberController.text = _userModel.phoneNumber;
    addressEditingController.text = _userModel.address;
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
         final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
        setState(() => _isLoading = true);
        userDataProvider
            .updateUserData(
            _userModel)
            .then((_) {
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
    final _userDataProvider = Provider.of<UserDataProvider>(context);
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _userDataProvider.fetchUserData();
    });
    _userModel = _userDataProvider.userData;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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

                // Upload Profile Picture
                Center(
                  child: Stack(children: [
                    ///if image already exists then will have to write different code for it!
                    ImagePreview(imagePath: _pickedImagePath),
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
                            MyAlertDialog.imagePicker(context)
                                .then((pickedImagePath) => setState(
                                    () => _pickedImagePath = pickedImagePath))
                                .then((_) =>
                                    _userModel.imageUrl = _pickedImagePath);
                          },
                          child: const Icon(Icons.add_a_photo,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ]),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          key: ValueKey('Full Name'),
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
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_nameNode),
                          onSaved: (value) => _userModel.fullName = value!,
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
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_addressNode),
                          onSaved: (value) => _userModel.phoneNumber = value!,
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
                            enabledBorder: MyBorder.outlineInputBorder(context),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(),
                          onSaved: (value) => _userModel.address = value!,
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),

                      Row(
                        children: [
                          // Update button
                          SizedBox(
                            width: 30.w,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? () {}
                                  : () {
                                      _submitForm();
                                      FocusScope.of(context).unfocus();
                                    },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Update'),
                                  ]),
                            ),
                          ),
                              const Spacer(),
                          // cancel Update button
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 30.w,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: const Center(child:  Text('Cancel', style: TextStyle(
                                color: Colors.black, fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
