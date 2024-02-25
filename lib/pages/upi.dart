import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';

class UpiPage extends StatefulWidget {
  final String receiverUpiId;
  final String receiverName;
  final double amount;

  const UpiPage({
    Key? key,
    required this.receiverUpiId,
    required this.receiverName,
    required this.amount,
  }) : super(key: key);

  @override
  State<UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends State<UpiPage> {
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInitiatePayment(context);
  }

  void _requestPermissionsAndInitiatePayment(BuildContext context) async {
    // Request necessary permissions
    await _requestPermissions();

    // Check if permissions are granted
    final PermissionStatus storageStatus = await Permission.storage.status;
    final PermissionStatus packageStatus = await Permission.manageExternalStorage.status;

    print(packageStatus);
    print(storageStatus);

    if (storageStatus.isGranted && packageStatus.isGranted) {
      // Permissions granted, initiate payment
      _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
        setState(() {
          apps = value;
          print(apps);
        });
      }).catchError((e) {
        apps = [];
        print("here in catch:${e}");
      });
    } else {
      // Permissions denied, show alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permissions Required'),
            content: Text('Please grant necessary permissions to use this feature.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _requestPermissions() async {
    // Request storage permission
    await Permission.storage.request();
    // Request permission to read all packages
    await Permission.manageExternalStorage.request();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: widget.receiverUpiId,
      receiverName: widget.receiverName,
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: widget.amount,
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          //style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ",
            //style: header
          ),
          Flexible(
              child: Text(
                body,
                //style: value,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        //style: header,
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  _checkTxnStatus(status);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else
                  return Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}