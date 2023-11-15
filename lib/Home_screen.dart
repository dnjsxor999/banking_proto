import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'dart:async';
import '../models/transaction.dart';

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

class ConnectButton extends StatefulWidget {
  const ConnectButton({super.key});

  @override
  _ConnectButtonState createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  StreamSubscription<LinkSuccess>? _streamSuccess;
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  }

  @override
  void dispose() {
    _streamSuccess?.cancel();
    super.dispose();
  }

  void _onSuccess(LinkSuccess event) {
    final publicToken = event.publicToken;
    print("Received public token: $publicToken");
    // Exchange public token for access token
    PlaidService.setAccessToken(http.Client(), publicToken).then((accessToken) {
      print('Access Token: $accessToken');
      // Handle the access token as needed
      PlaidService.getTransactions(http.Client()).then((fetchedTransactions) {
        setState(() {
          transactions = fetchedTransactions;
        });
        print(transactions);
      });
    }).catchError((e) {
      print('Error exchanging public token: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final linkToken = await PlaidService.getLinkToken(http.Client());
          print('linkToken generated');
          print(linkToken);
          LinkConfiguration configuration =
              LinkTokenConfiguration(token: linkToken);

          PlaidLink.open(configuration: configuration);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to connect to bank account')),
          );
        }
      },
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
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: transactions.length,
            //     itemBuilder: (context, index) {
            //       final transaction = transactions[index];
            //       return ListTile(
            //         title: Text(transaction.name),
            //         subtitle: Text(
            //             '${transaction.date} - \$${transaction.amount.toString()}'),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
