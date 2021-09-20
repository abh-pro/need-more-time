import 'App.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main(){
  //#ff2DA67A
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  return runApp(MaterialApp(
    title: "need more time",
    home: App(),
    debugShowCheckedModeBanner: false,
  ));
}