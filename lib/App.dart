import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color _green = Color(0xff38CD97);
final Color _darkGreen = Color(0xff2DA67A);
final Color _white = Color(0xffffffff);
final Color _grey = Color(0xffe5e5e5);


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _green,
        body: Column(
          children: [
            SizedBox(
              width: getPercentConvWidth(context, 100),
              height: _statusBarHeight,
              child: ColoredBox(
                color: _darkGreen,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: getPercentConvHeight(context, 5))),
            //here the stateful widget will be added which will control the most of the data.
            CountDown(),
          ],
        ));
  }

  double getPercentConvHeight(BuildContext context, int qwe) {
    return MediaQuery.of(context).size.height * (qwe / 100);
  }

  double getPercentConvWidth(BuildContext context, int qwe) {
    return MediaQuery.of(context).size.width * (qwe / 100);
  }
}

class CountDown extends StatefulWidget {
  const CountDown({Key? key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  String _seconds = "00";
  String _milliSeconds = "00";

  bool _running = false;
  bool _waiting = false;
  List<LapsDataStruct> laps = [];
  List<LapsSimpleDataStruct> sendLaps = [];
  int _initialTime = 0;
  int _remaining = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          drawCounter(context),
          Padding(padding: EdgeInsets.only(top: getPercentConvHeight(context, 1))),
          drawLaps(context),
          Padding(padding: EdgeInsets.only(top: getPercentConvHeight(context, 1))),
          drawButtons(context),
        ],
      ),
    );
  }

  Widget drawCounter(BuildContext context) {
    final TextStyle _secondsStyle = GoogleFonts.publicSans(
      color: _white,
      fontSize: 100,
      fontWeight: FontWeight.bold,
    );
    final TextStyle _milliSecondsStyle = GoogleFonts.publicSans(
        color: _grey,
        fontSize: 50,
        fontWeight: FontWeight.bold
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: SizedBox(
        height: getPercentConvHeight(context, 20),
        width: getPercentConvWidth(context, 85),
        child: ColoredBox(
          color: _darkGreen,
          child: Row( // the children will be two columns with one for SS and another for ms ms.
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: getPercentConvWidth(context, 10))),
              //the asynchronous function should be able to change the values in the private region and here the changes should be there on setstate.
              Container(
                height: getPercentConvHeight(context, 15),
                width: getPercentConvWidth(context, 40),
                alignment: AlignmentDirectional.bottomEnd,
                child: Text(
                  _seconds,
                  style: _secondsStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: getPercentConvWidth(context, 1)),
              ),
              Container(
                alignment: AlignmentDirectional.bottomStart,
                height: getPercentConvHeight(context, 13),
                width: getPercentConvWidth(context, 34),
                child: Text(
                  _milliSeconds,
                  style: _milliSecondsStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget drawLaps(BuildContext context){
    if(_running){
      final TextStyle lapTitleStyle = GoogleFonts.publicSans(
        fontSize: 20,
        color: _white,
        fontWeight: FontWeight.bold,
      );

      final Widget drawLapTitle = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: getPercentConvHeight(context, 5),
          color: _darkGreen,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: getPercentConvWidth(context, 5))),
              SizedBox(
                width: getPercentConvWidth(context, 30),
                child: Text(
                  "LAP",
                  style: lapTitleStyle,),
              ),
              SizedBox(
                width: getPercentConvWidth(context, 20),
                child: Text(
                  "TIME",
                  style: lapTitleStyle,),
              ),
              SizedBox(
                width: getPercentConvWidth(context, 30),
                child: Text(
                  "ELAPSED",
                  style: lapTitleStyle,
                ),
              )
            ],
          ),
        ),
      );

      Widget drawLapData = ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          width: getPercentConvWidth(context, 85),
          height: getPercentConvHeight(context, 39),
          color: _darkGreen,
          child: SingleChildScrollView(
            child: Column(
              children: parseLaps(),
            ),
          ),
        ),
      );
      return SizedBox(
        width: getPercentConvWidth(context, 85),
        height: getPercentConvHeight(context, 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            drawLapTitle,
            Padding(padding: EdgeInsets.only(top: getPercentConvHeight(context, 1))),
            drawLapData
          ],
        ),
      );
    }
    return SizedBox(
      width: getPercentConvWidth(context, 85),
      height: getPercentConvHeight(context, 45),
    );
  }

  double getPercentConvHeight(BuildContext context, double qwe) {
    return MediaQuery.of(context).size.height * (qwe / 100);
  }

  double getPercentConvWidth(BuildContext context, double qwe) {
    return MediaQuery.of(context).size.width * (qwe / 100);
  }
  List<Widget> parseLaps(){
    if(laps.length > 0){
      final TextStyle lapTileStyle = GoogleFonts.publicSans(
        fontSize: 17,
        color: _grey,
        fontWeight: FontWeight.bold,
      );
      List<Widget> retLaps = [];
      for(int i = 0; i<laps.length;i++){
        var temp = laps[i];
        retLaps.add(Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: _white)),
          ),
          height: getPercentConvHeight(context, 4),
          width: getPercentConvWidth(context, 85),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: getPercentConvWidth(context, 5))),
              SizedBox(
                width: getPercentConvWidth(context, 30),
                child: Text(
                  temp.lap,
                  style: lapTileStyle,),
              ),
              SizedBox(
                width: getPercentConvWidth(context, 20),
                child: Text(
                  temp.time,
                  style: lapTileStyle,),
              ),
              SizedBox(
                width: getPercentConvWidth(context, 30),
                child: Text(
                  temp.elapsed,
                  style: lapTileStyle,
                ),
              )
            ],
          ),

        ));
      }
      return retLaps;
    }
    return [];
  }


  Widget drawButtons(BuildContext context){
    if(_running){
      return Container(
        width: getPercentConvWidth(context, 85),
        height: getPercentConvHeight(context, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: _darkGreen,
                width: getPercentConvWidth(context, 40),
                height: getPercentConvHeight(context, 15),
                child: IconButton(
                  icon: Icon(Icons.stop),
                  color: _white,
                  iconSize: 70,
                  onPressed: (){
                    setState(() {
                      _running=false;
                      parseAndSend();
                      laps.clear();
                      sendLaps.clear();
                    });
                  },
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                color: _darkGreen,
                width: getPercentConvWidth(context, 40),
                height: getPercentConvHeight(context, 15),
                child: IconButton(
                  icon: Icon(Icons.fiber_manual_record_rounded),
                  color: _white,
                  iconSize: 70,
                  onPressed: (){
                    addLap();
                  },
                ),
              ),
            )
          ],
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: _darkGreen,
        width: getPercentConvWidth(context, 85),
        height: getPercentConvHeight(context, 15),
        child: IconButton(
          icon: Icon(getIcon()),
          color: _white,
          iconSize: 70,
          onPressed: () async {
            if(!_waiting){
              setState(() {
                _waiting = true;
              });
              String url = "https://cricinshots.com/sde/moretimeplease.php";
              Future<String> response = getHttps(url);
              String qw = await response;
              if(qw != "e"){
                int time = json.decode(qw)["time"];
                _remaining=_initialTime = time;
                setState(() {
                  updateCounter(0);
                  decreaseOnTime(Duration(milliseconds: 3));
                  _waiting=false;
                  _running = true;

                });
              }else{
                setState(() {
                  _waiting=false;
                });

              }

            }
          },
        ),
      ),
    );
  }
  void updateCounter(int toSubtract){
    _remaining = _remaining - toSubtract;
    if(_remaining <= 0){
      _seconds="00";
      _milliSeconds="00";
      _remaining=0;
      parseAndSend();
      sendLaps.clear();
      laps.clear();
      _running=false;

    }else {
      List temp = intToStringTimes(_remaining);
      _seconds = temp[0];
      _milliSeconds = temp[1];
    }
  }
  
  List<String> intToStringTimes(int time){
    double timeConv = time/1000;
    String stringConv = timeConv.toString();
    List<String> splitString = stringConv.split(".");
    String seconds = splitString[0];
    String milliseconds = splitString[1];
    if(seconds.length == 1){
      seconds = "0" + seconds;
    }
    if(milliseconds.length > 2){
      milliseconds = milliseconds[0] + milliseconds[1];
    }
    return [seconds,milliseconds];
  }
  
  IconData getIcon(){
    if(_waiting)
      {
        return Icons.animation;
      }
    else{
      return Icons.play_arrow;
    }
  }

  Future<String> getHttps(String url) async{
    try {
      String response="";
      await Dio().get(url).then((value) => response=value.toString());
      return response;
    } catch (e) {
      return "e";
    }
  }

  void decreaseOnTime(Duration duration){
    Timer.periodic(duration, (timer) {
      if(!_running){
        timer.cancel();
      }
      setState(() {
        updateCounter(duration.inMilliseconds);
      });

    });
  }

  void addLap(){
    int lap = sendLaps.length+1;
    int time;
    int elapsed = _initialTime - _remaining;
    if(sendLaps.length > 0){
      int temp = sendLaps.last.retElapsed();
      time = elapsed - temp;
    }else{
      time = _initialTime - _remaining;
    }
    sendLaps.add(LapsSimpleDataStruct(lap, time, elapsed));

    // adding onto the laps.
    List<String> tempTime = intToStringTimes(time);
    List<String> tempElapsed = intToStringTimes(elapsed);
    laps.add(LapsDataStruct(lap.toString(), tempTime[0]+":"+tempTime[1], tempElapsed[0]+":"+tempElapsed[1]));
  }
  void parseAndSend() async {
    var dio = Dio();
    String url = "https://cricinshots.com/sde/takeyourtime.php";
    print({"time":_initialTime,"laps":jsonEncode(sendLaps),"remaining":_remaining,"repo":"\"https://github.com\""});
    try{
      Response response = await dio.post(url,data: jsonEncode({"time":_initialTime,"laps":jsonEncode(sendLaps),"remaining":_remaining,"repo":"\"https://github.com\""}),
          options: Options(
            validateStatus: (status) => true,
            headers: {"Content-Type": "application/json"},
          ));
      print(response.data);
    }catch(e){
      print("Fail");
    }

  }
  Future<String> postHttps(String url) async{
    try {
      String response="";
      await Dio().get(url).then((value) => response=value.toString());
      return response;
    } catch (e) {
      return "e";
    }
  }
}
class LapsSimpleDataStruct{
  final int _id;
  final int _time;
  final int _elapsed;
  LapsSimpleDataStruct(this._id,this._time,this._elapsed);

  Map toJson() => {
    'id': _id,
    'time': _time,
    'elapsed': _elapsed
  };
  int retElapsed(){
    return this._elapsed;
  }

}
class LapsDataStruct{
  String lap="";
  String time="";
  String elapsed="";
  LapsDataStruct(this.lap,this.time,this.elapsed);
}
