import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TandCPage extends StatefulWidget {
  const TandCPage({Key? key}) : super(key: key);

  @override
  State<TandCPage> createState() => TandCPageState();
}

class TandCPageState extends State<TandCPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool buttonEnabled = false;

  Future<String> loadAsset(String fname) async {
    return await rootBundle.loadString(fname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor("##121212"),
      appBar: AppBar(
        backgroundColor: hexStringToColor("##121212"),
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      initialData: "INUS가 준수하는 개인정보처리방침입니다.",
                      future: loadAsset("assets/terms&conditions.txt"),
                      builder: (context, AsyncSnapshot<String> snapshot) =>
                          Text(
                        snapshot.data!,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
