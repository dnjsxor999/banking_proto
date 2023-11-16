import 'package:draft_ui/PlaidLink.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../service.dart';
// import 'package:plaid_flutter/plaid_flutter.dart';
// import 'dart:async';
// import '../models/transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConnectButton(),
      ),
    );
  }
}

class ConnectButton extends StatelessWidget {
  const ConnectButton({super.key});

  Future<void> _handleOnTap(BuildContext context) async {
    try {
      final linkToken = await PlaidService.getLinkToken(http.Client());
      print('linkToken generated');
      print(linkToken);
      _navigateToPlaid(context, linkToken);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to bank account')),
      );
    }
  }

  void _navigateToPlaid(BuildContext context, String linkToken) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LinkToPlaid(
          linkToken: linkToken,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleOnTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(),
              ),
              child: const Text('Connect bank accounts',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }
// }
