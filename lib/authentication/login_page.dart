import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../conformation/confirmation_screen.dart';
import '../homescreen/service_list.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final List<Services> selectedServices;
  final double totalAmount;
  final String stylistName;

  const LoginPage({
    Key? key,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.selectedServices,
    required this.totalAmount,
    required this.stylistName,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isButtonPressed = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void sendMessagesToEnteredNumber() async {
    String phoneNumber = '+91' + _phoneController.text.trim();
    String messageBody =
        'Your scissors salon appointment is scheduled for ${widget.selectedDate.toString()} at ${widget.selectedTimeSlots.join(", ")}. Name: ${_nameController.text}, Phone: ${_phoneController.text}  Wait for Scissor conformation';
    sendSMS(messageBody, phoneNumber);
  }

  void sendSMS(String messageBody, String phoneNumber) async {
    final accountSid = 'AC8032394725a51f80a26427f0ecd06af6';
    final authToken = 'c77948c1e2e06069b9b09d4abce4005b';
    final twilioNumber = '+16508648721';

    final Uri uri = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization':
        'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'From': twilioNumber,
        'To': phoneNumber,
        'Body': messageBody,
      },
    );

    if (response.statusCode == 201) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${response.statusCode}');
      print(response.body);
    }
  }

  void _saveData() {
    print("Attempting to save data...");
    String text1 = _nameController.text;
    String text2 = _phoneController.text;

    print("Name: $text1");
    print("Phone: $text2");
    print("Selected Date: ${widget.selectedDate}");
    print("Selected Time Slots: ${widget.selectedTimeSlots}");
    print("Selected Services: ${widget.selectedServices}");
    print("Total Amount: ${widget.totalAmount}");
    print("stylistName: ${widget.stylistName}");

    Timestamp timestamp = Timestamp.fromDate(widget.selectedDate);
    List<Map<String, dynamic>> servicesList =
    widget.selectedServices.map((service) => service.toMap()).toList();

    FirebaseFirestore.instance.collection('Users').add({
      'name': text1,
      'phoneNumber': text2,
      'selectedDate': timestamp,
      'selectedTimeSlots': widget.selectedTimeSlots,
      'selectedServices': servicesList,
      'totalAmount': widget.totalAmount,
      'stylistName': widget.stylistName,
      'status': 'pending'

    }).then((value) {
      print("Data saved successfully!");
    }).catchError((error) {
      print("Failed to save data: $error");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                      Image.asset(
                        'assets/Scissors-image-remove.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 9)),
                          Text(
                            "Scissor's",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.brown[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Enter your Details",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.brown[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          constraints:
                          BoxConstraints(maxWidth: 430, maxHeight: 279),
                          // Adjust the maximum width as needed
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    cursorColor: Colors.brown,
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Enter your name",
                                      labelStyle: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.brown[900],
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown, width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown, width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your name";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(

                                    cursorColor: Colors.brown,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                                    ],
                                    decoration: InputDecoration(
                                      prefixText: "+91 ",
                                      labelText: "Enter your mobile number",
                                      labelStyle: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.brown[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),

                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown, width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.brown, width: 1.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your number";
                                      } else if (!RegExp(r'^[0-9]*$')
                                          .hasMatch(value)) {
                                        return "Please enter a valid mobile number";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isButtonPressed = !_isButtonPressed;
                                        });

                                        if (_formKey.currentState!.validate()) {
                                          AuthService.sentOtp(
                                            phone: _phoneController.text,
                                            errorStep: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Error in sending OTP",
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                        color:
                                                        Colors.brown[900],
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                            nextStep: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title:
                                                      Text("OTP Verification"),
                                                      content: Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text("Enter 6 digit OTP"),
                                                          SizedBox(height: 12),
                                                          Form(
                                                            key: _formKey1,
                                                            child: TextFormField(
                                                              cursorColor:
                                                              Colors.brown,
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                              controller:
                                                              _otpController,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.brown),
                                                              decoration:
                                                              InputDecoration(
                                                                labelText:
                                                                "Enter OTP",
                                                                labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .brown),
                                                                border:
                                                                OutlineInputBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      8),
                                                                ),
                                                                enabledBorder:
                                                                OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .brown,
                                                                      width: 1.0),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      8),
                                                                ),
                                                                focusedBorder:
                                                                OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .brown,
                                                                      width: 1.0),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      8),
                                                                ),
                                                              ),
                                                              validator: (value) {
                                                                if (value!.length !=
                                                                    6) {
                                                                  return "Invalid OTP";
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  sendMessagesToEnteredNumber();
                                                                  _saveData();
                                                                  if (_formKey1
                                                                      .currentState!
                                                                      .validate()) {
                                                                    AuthService
                                                                        .loginWithOtp(
                                                                      otp:
                                                                      _otpController
                                                                          .text,
                                                                    ).then((value) {
                                                                      if (value ==
                                                                          "Success") {
                                                                        Navigator.pop(
                                                                            context); // Close the OTP verification dialog
                                                                        Navigator
                                                                            .pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (context) =>
                                                                                ConfirmationScreen(
                                                                                  name:
                                                                                  _nameController.text,
                                                                                  phoneNumber:
                                                                                  _phoneController.text,
                                                                                  selectedDate:
                                                                                  widget.selectedDate,
                                                                                  selectedTimeSlots:
                                                                                  widget.selectedTimeSlots,
                                                                                  stylistName:
                                                                                  widget.stylistName,
                                                                                ), // Navigate to the next page on success
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        ScaffoldMessenger.of(
                                                                            context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                            Text(
                                                                              value,
                                                                              style:
                                                                              TextStyle(color: Colors.white),
                                                                            ),
                                                                            backgroundColor:
                                                                            Colors.red,
                                                                          ),
                                                                        );
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "Submit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                    TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                                  fixedSize:
                                                                  Size(150, 50),
                                                                  primary: Colors
                                                                      .brown[900],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Send OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: _isButtonPressed
                                            ? Colors.brown[400]
                                            : Colors.brown[900],
                                        onPrimary: Colors.black,
                                        minimumSize: Size(0, 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
