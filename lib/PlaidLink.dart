import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'dart:async';
import '../models/transaction.dart';

class LinkToPlaid extends StatefulWidget {
  final String linkToken;

  const LinkToPlaid({
    super.key,
    required this.linkToken,
  });

  @override
  State<LinkToPlaid> createState() => _ConnectPlaidState();
}

class _ConnectPlaidState extends State<LinkToPlaid> {
  StreamSubscription<LinkSuccess>? _streamSuccess;
  bool hasAccessToken = false;
  late Future<List<Transaction>> transactions;

  @override
  void initState() {
    super.initState();
    LinkConfiguration configuration =
        LinkTokenConfiguration(token: widget.linkToken);
    PlaidLink.open(configuration: configuration);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
    transactions = PlaidService.getTransactions(http.Client());
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
      hasAccessToken = true;
      print('Access Token: $accessToken');
      // print(_streamSuccess);
      // Handle the access token as needed

      transactions = PlaidService.getTransactions(http.Client());

      // PlaidService.getTransactions(http.Client()).then((fetchedTransactions) {
      //   setState(() {
      //     transactions = fetchedTransactions;
      //   });
      //   print(transactions);
      // });
    }).catchError((e) {
      print('Error exchanging public token: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Retreiving Transaction"),
            FutureBuilder(
              future: transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData && hasAccessToken) {
                  // success, we need to replace this widget to STATICS!
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final transaction = snapshot.data![index];
                        return ListTile(
                          title: Text(transaction.name),
                          subtitle: Text(
                              '${transaction.date} - \$${transaction.amount.toString()}'),
                        );
                      },
                    ),
                  );
                } else {
                  // if fail,
                  return Column(
                    children: [
                      const Text("Fail to retreive Transaction"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Try again"),
                      )
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // State<StatefulWidget> createState() {
  //   // TODO: implement createState
  //   throw UnimplementedError();
  // }
}
