import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('images/Nasa_logo.jpg');
    var image = new Image(image: assetsImage, width:100.0, height: 100.0);

    return new Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(25.0),
            decoration: new ShapeDecoration(
              color: Colors.white,
              shadows: [BoxShadow(color: Colors.black, blurRadius: 15.0)],
              shape: new Border.all(
                color: Colors.red,
                width: 8.0,
              ),
            ),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min , children: [
                Container(child: image),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  'NASA QR Scanner',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Made under NASA 2019 President Idris Shareif"),
                Text("Developed by bipindr123@gmail.com"),
              ]),
            )));
  }
}
