import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  color: Colors.deepPurple.shade100,
                  width: screenWidth,
                  height: isClicked == false ? screenHeight : 0,
                  child: const Center(
                      child: Text("Click the button below for animation")),
                ),
                Positioned(
                  bottom: 200,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        isClicked = true;
                      });
                    },
                    height: 45,
                    color: Colors.deepPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    minWidth: screenWidth * 0.7,
                    child: const Text(
                      "Enter",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const Center(child: Text("Dashboard"))
          ],
        ),
      ),
    );
  }
}
