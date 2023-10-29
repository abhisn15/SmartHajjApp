import 'package:flutter/material.dart';

class BottomSheetDompet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                controller:
                    scrollController, // Perbaiki penulisan 'scrollController'
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  // Perbaiki penulisan parameter
                  return ListTile(title: Text("Item $index"));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
