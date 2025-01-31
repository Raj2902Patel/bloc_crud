import 'package:bloc_crud/models/userModel.dart';
import 'package:bloc_crud/widgets/toastWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user_bloc.dart';

class UpdateData extends StatefulWidget {
  final User userUpdate;

  const UpdateData({super.key, required this.userUpdate});

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userUpdate.name;
    numberController.text = widget.userUpdate.contactNumber.toString();
    emailController.text = widget.userUpdate.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update User',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 20,
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: "eg. John",
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null; // No error
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 10,
                    controller: numberController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Contact number is required';
                      } else if (int.tryParse(value) == null) {
                        return 'Enter a valid number';
                      } else if (value.length != 10) {
                        return 'Enter a valid Number';
                      }
                      return null; // No error
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 20,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email),
                      hintText: "eg. abc@gmail.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null; // No error
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final name = nameController.text;
                      final number = numberController.text;
                      final email = emailController.text;
                      final id = widget.userUpdate.id;

                      final updatedUser = User(
                        id: id,
                        name: name,
                        contactNumber: int.parse(number),
                        email: email,
                      );
                      if (name.isNotEmpty &&
                          email.isNotEmpty &&
                          number.isNotEmpty) {
                        context
                            .read<UserBloc>()
                            .add(UpdateUserEvent(updatedUser));
                        toastDialog(
                          context: context,
                          message: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Data has been updated successfully!",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          leadingIcon: const Icon(Icons.info),
                          animationDuration: const Duration(seconds: 1),
                          displayDuration: const Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text("All Fields Are Required Fields!"),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
