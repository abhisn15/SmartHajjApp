import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class UndangAgentScreen extends StatefulWidget {
  const UndangAgentScreen({Key? key}) : super(key: key);

  @override
  _UndangAgentScreenState createState() => _UndangAgentScreenState();
}

class _UndangAgentScreenState extends State<UndangAgentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(43, 69, 112, 1),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Undang Teman Agentmu",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Undang Teman Agentmu dan Jadilah Bagian dari Misi Mulia Kami.Bantu lebih banyak jamaah mewujudkan impian Umroh/Haji mereka.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share('Yuk jadi agent di aplikasi kami');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(43, 69, 112, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: Size(350, 50),
                    ),
                    child: Text(
                      'Undang Agent',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                    child: Image.asset(
                  'assets/profile/undangAgent.png',
                )),
              ],
            )));
  }
}
