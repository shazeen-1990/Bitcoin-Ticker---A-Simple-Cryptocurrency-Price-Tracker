import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
 // String? selectedCurrency = 'USD';
  // Update the default currency to AUD, the first item in the currencyList.
  String? selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown(){

    List<DropdownMenuItem<String>> dropdownItems = [];

    for(int i = 0; i < currenciesList.length; i++){
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
          child: Text(currency),
          value: currency);
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems, //rectify my code
        onChanged: (value){
        setState(() {
        selectedCurrency = value!;
        // Call getData() when the picker/dropdown changes.
        getData();
        });

        });
  }

  CupertinoPicker iOSPicker(){

    List<Text> pickerItems = [];

    for(String currency in currenciesList){
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
        setState(() {
          // Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          // Call getData() when the picker/dropdown changes.
          getData();
        });
      }, children: pickerItems,
    );

  }

  Widget? getPicker(){
    if (Platform.isIOS){
      return iOSPicker();
    }else if (Platform.isAndroid){
      return androidDropdown();
    }
  }

  // Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data comes back from the async methods.
  //String bitcoinValueInUSD = '?';
  String bitcoinValue = '?';

  //value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String, String> coinValues = {};
  // Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. First we have to create a variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;


  // Create an async method here await the coin data from coin_data.dart
  void getData() async {
    //7: Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      //We're now passing the selectedCurrency when we call getCoinData().
     // double data = await CoinData().getCoinData();
      var data = await CoinData().getCoinData(selectedCurrency!);
      // We can't await in a setState(). So you have to separate it out into two steps.
      // Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
       // bitcoinValueInUSD = data.toStringAsFixed(0);
       // bitcoinValue = data.toStringAsFixed(0);//need to fix
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                cryptoCurrency: 'BTC',
                // Finally, we use a ternary operator to check if we are waiting
                // and if so, we'll display a '?' otherwise we'll show the actual
                // price data.
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}


// Refactor this Padding Widget into a separate Stateless Widget called CryptoCard, so we can create 3 of them, one for each cryptocurrency.
class CryptoCard extends StatelessWidget {
  final String? value;
  final String? selectedCurrency;
  final String cryptoCurrency;
  // You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget.
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}