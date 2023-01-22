import 'package:absensi_apps/constant/constant.dart';
import 'package:absensi_apps/launcher.dart';
import 'package:absensi_apps/login.dart';
import 'package:flutter/material.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Aplikasi Absensi",
    home: launcher(),
    theme:  ThemeData(primaryColor: Colors.cyanAccent[500]),
    routes: <String, WidgetBuilder>{
      SPLASH_SCREEN: (BuildContext context) => launcher(),
      HOME_SCREEN: (BuildContext context) => login(),
    },
  ));
}

class _loginState extends State<login>{
  loginStatus _loginStatus = loginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();
  String msg = "";
  bool _secureText = true;
  bool _apiCall = false;


  showHide(){
    setState((){
      _secureText = !_secureText;
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _apiCall = true;
      });
      login();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  void _snackbar(String str){
  if (str.isEmpty) return;
  _scaffoldState.currentState.showSnackBar(new SnackBar(
    backgroundColor: Colors.green,
    content: new Text(str,
    style: new TextStyle(fontSize: 15.0, color: Colors.white),),
  ));
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
      });
      // }
      _snackbar(pesan);
    } else {
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
    }
  }

  savePref(int value, String username, String nama, String id, String semester, String foto, String nmp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("semester", semester);
      preferences.setString("npm", npm);
      preferences.setString("foto", foto);
    });
  }

    var velue;
    getPref() async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        value = preferences.getInt("value");
        _loginStatus = value == 1 ? _loginStatus.signIn : _loginStatus.notSignIn;
      });
    }

    signOut() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        _apiCall = false;
        preferences.setInt("value", null);
        preferences.comit();
        _loginStatus = loginStatus.sigIn;
      });
    }

  @override
  void initState(){
      // TOPO: implement initState
    if (this.mounted){
      super.initState();
      getPref();
    }
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
        return MainMenu(signOut);
        break;
    }
  }
}

  class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MeinMenu(this.signOut);
    @override
    _MainMenuState createState() => _MainMenuState();
  }

  String notifikasi;

  class _MainMenuState extends State<MainMenu> {
    signOut(){
      signOut(){
        if(this.mounted){
          setState(() {
            widget.signOut();
          });
        }
      }

      String username = "", nama = "", userid = "";
      TabController tabController;

      getPref() async {
        SharedPreferences preferences = await SharedPreferences.getInsstance();
        setState(() {
          username = preferences.getString("user");
          nama = preferences.getString("nama");
          userid = preferences.getString("id");
        });
      }
    }

    @override
    initState(){
      if (this.mounted){
        super.initState();
        getPref();
      }
    }

    @override
    void dispose(){
      // sub.dispose();
      if (mounted){
        super.dispose();
      }
    }

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                new Image.asset(
                  "gambar/logoabsensi.png",
                  width: 30,
                  height: 30,
                ),
                SizedBox(
                  width: 20.0,
                ),
                new Text(
                  "Aplikasi Absensi",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: _buildIconBadge(
                  Icons.notifications, notifikasi ?? '', Colors.green,
                ), onPressed: null,
              ),
              IconButton(
                onPressed: (){
                  signOut();
                },
                color: Colors.white,
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              home(),
              // Chat(),
              About(),
            ],
          ),
          bottomNavigationBar: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.amber[900],
            indicatorColor: Colors.greenAccent,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                child:  new Text(
                  "home",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.person),
                child: new Text(
                  "About",
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  widget _buildIconBadge(
    IconData icon,
    String badgeText,
    Color badgeColor,
  ){
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          size: 30.0,
        ),
        Positioned(
         top: 2.0,
         right: 4.0,
         child: Container(
           padding: EdgeInsets.all(1.0),
           decoration: BoxDecoration(
             color: badgeColor,
             shape: BoxShape.circle,
           ),
           constraints: BoxConstraints(
             minWidth: 18.0,
             minHeight: 18.0,
           ),
           child: Center(
             child: Text(
               badgeText,
               textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 10.0,
                 fontWeight: FontWeight.bold,
               ),
             ),
           ),
         ),
        )
      ],
    )
  }
