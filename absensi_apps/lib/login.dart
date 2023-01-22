import 'dart:convert';

import 'package:absensi_apps/model/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

enum loginStatus {notSignIn, sigIn}

class _loginState extends State<login>{
  loginStatus _loginStatus = loginStatus.notSignIn;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;
  bool _apiCall = false;

  //fungsi untuk melihat password
  showHide(){
    setState((){
      _secureText = !_secureText;
    });
  }

  //fungsi cek validasi form
  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _apiCall = true;
      });
      login();
      //disini script untuk memanggil API
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
      body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['user'];
    String namaAPI = data['nama'];
    String id = data['user_id'];
    String semester = data["semester"];
    String npm = data["npm"];
    String foto = data["foto"];

    if (value == 1){
      // if(this.mounted){
      setState(() {
        _loginStatus = loginStatus.sigIn;
        savePref(value, usernameAPI, namaAPI, id, semester, foto, npm);
        getFCMToken(npm);
      });
      // }
      _snackbar(pesan);
    }else
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus){
      case loginStatus.notSignIn:
        String username;
        String password;
        return Scaffold(
          body: Form(
            key: _key,
            child: new Container(
              padding: EdgeInsets.only(top: 50.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.cyanAccent[900],
                  Colors.cyanAccent[700],
                  Colors.cyanAccent[500],
                ]),
              ),
              child: Center(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white, fontSize: 40
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Aplikasi Absensi",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: new Image.asset(
                                        "gambar/logoabsensi",
                                      width: 100,
                                      height: 100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, 3),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        validator: (e){
                                          if (e.isEmpty){
                                            return "Silahkan Masukan Username";
                                          }
                                        },
                                        onSaved: (e) => username = e,
                                        decoration: InputDecoration(
                                          hintText: "Username",
                                          hintStyle: TextStyle(
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        obscureText: _secureText,
                                        validator: (e){
                                          if (e.isEmpty){
                                            return "Silahkan Masukan Password";
                                          }
                                        },
                                        onSaved: (e) => password = e,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: showHide,
                                            icon: Icon(_secureText? Icons.visibility_off: Icons.visibility,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  check(); //pengecekan validasi API Login
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.cyanAccent[900],
                                  ),
                                  child: Center(
                                    child: _apiCall? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white
                                      ),
                                    )
                                    : Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        break;
      case loginStatus.sigIn:
      // link ke HOME jika statusnya udah login
        break;
    }
  }
}
