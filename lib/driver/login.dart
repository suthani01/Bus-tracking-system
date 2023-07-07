import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/driver/driver.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double screenHeight;
  late double screenWidth;
  String phoneNumber = "";
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black54,
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 5,
        centerTitle: true,
        toolbarHeight: screenHeight / 5,
        title: Text('Driver Login',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                color: Colors.black)),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            focusNode: myFocusNode,
            autocorrect: false,
            autofocus: false,
            controller: TextEditingController()
              ..text = phoneNumber
              ..selection = TextSelection.collapsed(offset: phoneNumber.length),
            keyboardType: TextInputType.number,
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp("[0-9]+")),
              LengthLimitingTextInputFormatter(10)
            ],
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(myFocusNode);
              });
            },
            onChanged: (text) {
              phoneNumber = text;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.yellow[800]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.yellow[800]!),
              ),
              filled: true,
              hintStyle: TextStyle(
                color: Colors.grey[350],
              ),
              labelText: "Driver ID",
              hintText: "",
              // prefixIcon: Icon(
              //   Icons.phone,
              // ),
              fillColor: Colors.transparent,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            focusNode: myFocusNode2,
            autocorrect: false,
            obscureText: true,
            autofocus: false,
            controller: TextEditingController()
              ..text = phoneNumber
              ..selection = TextSelection.collapsed(offset: phoneNumber.length),
            keyboardType: TextInputType.number,
            inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp("[0-9]+")),
              LengthLimitingTextInputFormatter(10)
            ],
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(myFocusNode2);
              });
            },
            onChanged: (text) {
              phoneNumber = text;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.yellow[800]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.yellow[800]!),
              ),
              filled: true,
              hintStyle: TextStyle(
                color: Colors.grey[350],
              ),
              labelText: "Password",
              hintText: "",
              // prefixIcon: Icon(
              //   Icons.phone,
              // ),
              fillColor: Colors.transparent,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Driver()));
            },
            child: Text("Login"))
      ]),
    );
  }
}
