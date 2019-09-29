import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'util.dart' as util;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  String _cityentered;

  void showstuff() async {
    Map data = await getweather(util.api, util.defaultcity);
    print(data.toString());
  }

  Future _nextScreen(BuildContext context) async{
    Map result= await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new Changecity();
      })
    );

    if(result != null && result.containsKey('enter')){
        _cityentered= result['enter'];

    }


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimate"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed:() {
            _nextScreen(context);
          })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              height: 1200.0,
              width: 480.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 0.0),
            child: new Text(
              "${_cityentered == null ? util.defaultcity : _cityentered}",
              style: citystyle(),
            ),
          ),

          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 350.0, 0.0, 0.0),
            child: updatetemp(_cityentered),
          ),
        ],
      ),
    );
  }




  Future<Map> getweather(String api, String city) async {
    String appurl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.api}&units=metric";
    http.Response response = await http.get(appurl);
    return json.decode(response.body);
  }

  Widget updatetemp(String city){
    return new FutureBuilder(
        future: getweather(util.api, city == null ? util.defaultcity : city ),
        builder:(BuildContext context, AsyncSnapshot<Map> snapshot) {
          if(snapshot.hasData){
            Map content= snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(" Temp: ${content['main']['temp'].toString()}",
                    style: temp(),),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()} C\n"
                          "Min: ${content['main']['temp_min'].toString()} C\n"
                          "Max: ${content['main']['temp_max'].toString()} C\n"
                          "Wind: ${content['wind']['speed'].toString()} Km/h \n"
                      ,

                      style: extra(),
                    ),
                  ),
                  )
                ],
              ),
            );
          }

          else{
            return new Container();
          }
        }
    );
  }
}


class Changecity extends StatelessWidget {
  var _cityfield= new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter city',
                  ),
                  controller: _cityfield,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: (){
                    Navigator.pop(context,{
                      'enter': _cityfield.text
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.red,
                  child: new Text('Get Weather'),
                ),
                ),

            ],
          )
        ],
      ),
    );
  }
}









TextStyle citystyle() {
  return new TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 28.0,
  );
}

TextStyle extra(){
  return new TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 24.0
  );
}



TextStyle temp() {
  return new TextStyle(
      color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.w500);
}
