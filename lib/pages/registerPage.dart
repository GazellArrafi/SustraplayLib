import "package:flutter/material.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          width: MediaQuery.of(context).size.width,
          height: 700,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(35))
          ),
          child: Column(
            children: [
              Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 55,
                ),
              ),
              //TextField Nama
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
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
                    hintText: "Nama"
                  ),
                ),
              ),
              //TextField Email
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
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
                    hintText: "Email"
                  ),
                ),
              ),
              //TextField Username
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
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
                    hintText: "Username"
                  ),
                ),
              ),
              //TextField Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  obscureText: true,
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
                    hintText: "Password"
                  ),
                ),
              ),
              //TextField re-Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  obscureText: true,
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
                    hintText: "Re-Password"
                  ),
                ),
              ),
              //Button Sign Up
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 200,
                  height: 65,
                  child: FloatingActionButton(
                    onPressed: null,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}