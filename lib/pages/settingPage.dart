import "package:flutter/material.dart";
import "package:flutter_dropdown_alert/model/data_alert.dart";
import "package:lite_rolling_switch/lite_rolling_switch.dart";
import "package:provider/provider.dart";
import "package:sustraplay_abp/data/getUsers.dart";
import 'package:flutter_dropdown_alert/alert_controller.dart';
import "package:restart_app/restart_app.dart";
import "package:sustraplay_abp/providerTheme.dart";

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  LiteRollingSwitch(
                    value: true,
                    onTap: (){}, 
                    onDoubleTap: (){}, 
                    onSwipe: (){}, 
                    onChanged: (value){
                      if(value == true){
                        Provider.of<ProviderTheme>(context, listen: false).light();
                      }else{
                        Provider.of<ProviderTheme>(context, listen: false).dark();
                      }
                    },
                    textOn: "Ligth Mode",
                    textOff: "Dark Mode",
                    colorOn: Color(0xFFD89A77),
                    colorOff: Color(0xFF13151E),
                    iconOn: Icons.sunny,
                    iconOff: Icons.brightness_2,
                    textSize: 18,
                    width: 160,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: GridView.count(
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      childAspectRatio: 1,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            await logout().then((value){
                              AlertController.show("Success", "Logout done", TypeAlert.success);
                            });
                            Restart.restartApp(webOrigin: '/mainPage');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                width: 6,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  size: 80,
                                ),
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    height: 1
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'More accessibilities coming soon...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}