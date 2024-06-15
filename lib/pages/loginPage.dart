import "package:flutter/material.dart";
import "package:flutter_dropdown_alert/model/data_alert.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sustraplay_abp/data/getUsers.dart";
import 'package:flutter_dropdown_alert/alert_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  
  Future<void> signIn() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await login(username, password).then((user) {
      if(!user.isEmpty){
        pref.setString("id", user['id']!);
        pref.setString("name", user['name']!);
        pref.setString("email", user['email']!);
        pref.setString("username", user['username']!);
        pref.setString("password", user['password']!);
        pref.setString("role", user['role']!);

        AlertController.show("Success", "Redirect to home page", TypeAlert.success);
      }else{
        AlertController.show("Error", "Username or password is incorrect", TypeAlert.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 330,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  "img/Logo.png",
                  width: 240,
                ),
                Text(
                  "Sustraplay Library",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            margin: EdgeInsets.only(top: 40, left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            height: 450,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                //TextField Username
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        username = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 30
                      ),
                      enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer, 
                          width: 4
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          width: 2,
                          ),
                      ),
                      hintText: "Username"
                    ),
                  ),
                ),
                //TextField Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        password = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 30
                      ),
                      enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer, 
                          width: 4
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          width: 2,
                          ),
                      ),
                      hintText: "Password"
                    ),
                  ),
                ),
                //Button Login
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: 200,
                    height: 65,
                    child: FloatingActionButton(
                      onPressed: () async{
                        if(username != "" && password != ""){
                          await signIn().then((value) => context.push("/homePage"));
                        }else{
                          AlertController.show("Warning!", "Please fill in username or password first", TypeAlert.warning);
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                //Register Text
                Text(
                  "Don't have account yet?",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    context.push('/register');
                  },
                  child: Text(
                    "Register here",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}