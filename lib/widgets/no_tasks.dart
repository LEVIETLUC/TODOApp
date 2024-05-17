import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NoTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(20, 15, 20, 35),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/empty_ic.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                'No Todos Available',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const AutoSizeText(
                "Let's Add Some Tasks Todo!!!",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}
