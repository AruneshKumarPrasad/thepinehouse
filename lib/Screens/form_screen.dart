import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepinehouse/Helpers/firebase.dart';

import '../Global/global.dart';
import '../Helpers/models.dart';
import '../Widgets/FormScreen/drop_down_field.dart';
import '../Widgets/FormScreen/neu_button.dart';
import '../Widgets/FormScreen/neu_text_field.dart';
import '../Widgets/FormScreen/photo_upload.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({
    Key? key,
    required bool darkModeEnabled,
  })  : _darkModeEnabled = darkModeEnabled,
        super(key: key);

  final bool _darkModeEnabled;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _dropDownValue = "HR";
  bool _isLoading = false;
  File? _profileImage;

  final Model _profile = Model(
    profileID: '',
    nameInProfile: '',
    phoneNumber: '',
    age: 1,
    department: '',
    imageLink: '',
  );

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();

  void _changeDropDownValue(String value) {
    _dropDownValue = value;
  }

  void _changeProfilePhoto(File? image) {
    setState(() {
      _profileImage = image;
    });
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Name!';
    } else if (value.contains(RegExp(r'[0-9]'))) {
      return 'Your Name has a number please check!';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Phone Number!';
    } else if (value.length != 10) {
      return 'Phone number is incorrect!';
    }
    return null;
  }

  String? _ageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Age!';
    } else if (double.parse(value).toInt() <= 0 ||
        double.parse(value).toInt() >= 130) {
      return 'Enter correct Age!';
    }
    return null;
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate() && _profileImage != null) {
      _formKey.currentState!.save();

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      _profile.profileID = uniqueFileName;
      _profile.nameInProfile = _controllerName.text;
      _profile.phoneNumber = _controllerPhone.text;
      _profile.age = double.parse(_controllerAge.text).toInt();
      _profile.department = _dropDownValue;
      _dropDownValue = "HR";
      _controllerName.clear();
      _controllerPhone.clear();
      _controllerAge.clear();

      final String? tempLink =
          await FireHelp().fireStorageUpload(uniqueFileName, _profileImage!);
      _changeProfilePhoto(null);
      if (tempLink != null) {
        _profile.imageLink = tempLink;
        await FireHelp().fireAddData(_profile).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text("Form Submitted!"),
                  ),
                  behavior: SnackBarBehavior.floating,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  duration: const Duration(milliseconds: 750),
                ),
              ),
            );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  late FocusNode _nameFocusNode;
  late FocusNode _phoneFocusNode;
  late FocusNode _ageFocusNode;

  void _changeFocus(String text) {
    if (text == "Name: ") {
      _nameFocusNode.unfocus();
      _phoneFocusNode.requestFocus();
    } else if (text == "Phone: ") {
      _phoneFocusNode.unfocus();
      _ageFocusNode.requestFocus();
    } else if (text == "Age: ") {
      _ageFocusNode.unfocus();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _ageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerAge.dispose();

    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 18),
                  child: const Text(
                    "Let's resume making Profiles",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                NeuTextField(
                  darkModeEnabled: widget._darkModeEnabled,
                  textLabel: "Name: ",
                  textController: _controllerName,
                  textValidator: _nameValidator,
                  keyboardType: TextInputType.text,
                  capitalization: TextCapitalization.words,
                  focusNode: _nameFocusNode,
                  changeFocus: _changeFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                NeuTextField(
                  darkModeEnabled: widget._darkModeEnabled,
                  textLabel: "Phone: ",
                  textController: _controllerPhone,
                  textValidator: _phoneValidator,
                  keyboardType: TextInputType.phone,
                  capitalization: TextCapitalization.none,
                  focusNode: _phoneFocusNode,
                  changeFocus: _changeFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                NeuTextField(
                  darkModeEnabled: widget._darkModeEnabled,
                  textLabel: "Age: ",
                  textController: _controllerAge,
                  textValidator: _ageValidator,
                  keyboardType: TextInputType.number,
                  capitalization: TextCapitalization.none,
                  focusNode: _ageFocusNode,
                  changeFocus: _changeFocus,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UploadPhoto(
                      darkModeEnabled: widget._darkModeEnabled,
                      image: _profileImage,
                      changePhoto: _changeProfilePhoto,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 50,
                        margin: const EdgeInsets.only(right: 35),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: widget._darkModeEnabled
                              ? GlobalTraits.neuShadowsDark
                              : GlobalTraits.neuShadows,
                          color: widget._darkModeEnabled
                              ? GlobalTraits.bgGlobalColorDark
                              : GlobalTraits.bgGlobalColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: NeuDropdownButton(
                          initialDropDownValue: _dropDownValue,
                          setDropDownValue: _changeDropDownValue,
                          darkModeEnabled: widget._darkModeEnabled,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : NeuButton(
                        buttonLabel: "Submit",
                        darkModeEnabled: widget._darkModeEnabled,
                        performFunction: _submitForm,
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
