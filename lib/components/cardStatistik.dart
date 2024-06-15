import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:flutter_dropdown_alert/alert_controller.dart";
import "package:flutter_dropdown_alert/model/data_alert.dart";
import "package:sustraplay_abp/data/getStatistikData.dart";

class CardStatistik extends StatelessWidget {
  CardStatistik(this.dataStat);

  final Map<String, List<String>> dataStat;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(dataStat.keys.toString().substring(1, dataStat.keys.toString().length - 1));
    return GestureDetector(
      onLongPress: (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Delete Data",
                style: TextStyle(
                  color: Colors.black,
                  height: 1,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Are you sure to delete this data?",
                style: TextStyle(
                  color: Colors.black,
                  height: 1,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                Container(
                  height: 40,
                  width: 100,
                  child: FloatingActionButton(
                    heroTag: "btnCancleCardStat",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  child: FloatingActionButton(
                    heroTag: "btnSureCardStat",
                    onPressed: () async {
                      delStatGame(dataStat['id']![0]);
                      AlertController.show("Success", "Data has been added", TypeAlert.success);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDoubleTap: (){
        DateTime newDate = DateFormat('yyyy-MM-dd').parse(dataStat.keys.toString().substring(1, dataStat.keys.toString().length - 1));
        String newPeak = dataStat.values.elementAt(0)[0];
        final controller = TextEditingController();
        controller.text = newPeak;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            StateSetter _setState;
              return AlertDialog(
                title: Text(
                  "Update Data Peak",
                  style: TextStyle(
                    color: Colors.black,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    _setState = setState;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: controller,
                          onChanged: (value){
                            setState(() {
                              newPeak = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                            hintText: "Peak"
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Date Picked:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat("MMMM - yyyy").format(newDate),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 160,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: FloatingActionButton(
                            heroTag: "btnSetCardYearMonth",
                            onPressed: () async{
                              final DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: newDate,
                                firstDate: DateTime(1958),
                                lastDate: DateTime(3000)
                              );
                              if(dateTime != null){
                                _setState(() {
                                  newDate = date;
                                });
                              }
                            },
                            child: Text(
                              "Pick a Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        child: FloatingActionButton(
                          heroTag: "btnCancleCardStat",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancle",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        child: FloatingActionButton(
                          heroTag: "btnUpdateCardStat",
                          onPressed: () async {
                            if(newPeak != ""){
                              updetStatGame(dataStat['id']![0], newPeak, newDate);
                              AlertController.show("Success", "Data has been updated", TypeAlert.success);
                              Navigator.pop(context);
                            }else{
                              AlertController.show("Warning!", "Please fill in peak first", TypeAlert.warning);
                            }
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onDoubleTap: (){
              },
              child: Text(
                DateFormat.MMMM().format(date),
                style: TextStyle(
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dataStat.values.elementAt(0)[0].toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                GestureDetector(
                  onDoubleTap: (){
                  },
                  child: Text(
                    'Peak',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dataStat.values.elementAt(0)[1].toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                Text(
                  'Gain',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}