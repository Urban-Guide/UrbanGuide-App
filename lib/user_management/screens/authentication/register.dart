import 'package:flutter/material.dart';
import 'package:urbun_guide/user_management/cocnstants/colors.dart';
import 'package:urbun_guide/user_management/cocnstants/discription.dart';
import 'package:urbun_guide/user_management/cocnstants/styles.dart';
import 'package:urbun_guide/user_management/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggle;
  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();

  //form key
  final _formKey = GlobalKey<FormState>();
  //email, password, phone, and address state
  String name = "";
  String email = "";
  String nic = "";
  String password = "";
  String phone = "";

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XffD0F2FD),
      appBar: AppBar(
        title: const Text("REGISTER"),
        elevation: 0,
        backgroundColor: const Color(0XffD0F2FD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 10),
          child: Column(
            children: [
              const Text(
                description,
                style: descriptionStyle,
              ),
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //name field
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Name",
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Please Enter your name" : null,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      //email field
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Email",
                        ),
                        validator: (val) => val!.isEmpty
                            ? "Enter a valid username or email"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "NIC",
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter a valid NIC";
                          } else if (!RegExp(r'^[0-9]{9}[VXvx]$')
                                  .hasMatch(val) &&
                              !RegExp(r'^[0-9]{12}$').hasMatch(val)) {
                            return "Enter a valid NIC (e.g., 123456789V or 199023456789)";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            nic = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      //password field
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                        validator: (val) => val!.length < 6
                            ? "Enter a password 6+ chars long"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      //phone number field
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Phone Number",
                        ),
                        keyboardType: TextInputType
                            .phone, // To bring up the phone number keyboard
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter a valid phone number";
                          } else if (val.length != 10) {
                            return "Phone number must be 10 digits";
                          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(val)) {
                            return "Enter only digits";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      //error text
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),

                      //switch to login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: descriptionStyle,
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                color: mainBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //button
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    name, email, nic, password, phone);
                            if (result == null) {
                              setState(() {
                                error = "Please enter a valid email";
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0Xff1E2A5E),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: mainYellow),
                          ),
                          child: const Center(
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
