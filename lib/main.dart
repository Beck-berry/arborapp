import 'package:flutter/material.dart';

void main() {
  runApp(const Arborapp());
}

class Arborapp extends StatelessWidget {
  const Arborapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arborapp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(cim: 'Arborapp Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.cim}) : super(key: key);

  final String cim;

  @override
  State<MyHomePage> createState() => _ArborappState();
}

class _ArborappState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cim),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Növény neve',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.green
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/tree.jpg')
                  ),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla elementum tempor dolor id varius. Nulla dictum ipsum sit amet elit tincidunt, at iaculis ex condimentum. In hac habitasse platea dictumst. Cras vitae metus aliquet eros ornare egestas id non ipsum. Maecenas lobortis pretium libero, vel scelerisque erat eleifend nec. Nullam rhoncus nisi id justo vehicula efficitur. Quisque erat sapien, maximus a metus non, ullamcorper tincidunt nibh.',
                      textAlign: TextAlign.justify,
                    )
                  )
                ],
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/tree.jpg',
                    height: 50
                  )
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/tree.jpg',
                    height: 50
                  )
                ),
              ]
            ),
            Row(
              children: [
                Expanded(
                    child: Image.asset(
                        'assets/images/tree.jpg',
                        height: 50
                    )
                ),
                Expanded(
                    child: Image.asset(
                        'assets/images/tree.jpg',
                        height: 50
                    )
                ),
              ]
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Image.asset(
                    'assets/images/tree.jpg',
                    height: 110
                  ),
                  Image.asset(
                      'assets/images/tree.jpg',
                      height: 110
                  ),
                  Image.asset(
                      'assets/images/tree.jpg',
                      height: 110
                  ),
                  Image.asset(
                      'assets/images/tree.jpg',
                      height: 110
                  ),
                  Image.asset(
                      'assets/images/tree.jpg',
                      height: 110
                  ),
                ],
              )
            ),
          ]
        )
      )
    );
  }
}
