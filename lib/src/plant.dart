import 'package:flutter/material.dart';

class Plant extends StatelessWidget {
  const Plant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Növény neve',
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
                children: [
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