import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitcoinAverageURL = 'https://api-realtime.exrates.coinapi.io/v1/exchangerate';

const coinAPIURL = 'https://api-realtime.exrates.coinapi.io/v1/exchangerate';
const apiKey = '3d5ab5ed-d087-407f-8817-d0ea116c4b63';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    // Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
    // Return a Map of the results instead of a single value.

    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      //Update the URL to use the crypto symbol from the cryptoList
      String requestURL =
          '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}

// class CoinData {
//   //3-2: Update getCoinData to take the selectedCurrency as an input.
//   //3. Create the Asynchronous method getCoinData() that returns a Future (the price data).
//   Future<double>getCoinData(String selectedCurrency) async {
//     //4. Create a url combining the coinAPIURL with the currencies we're interested, BTC to USD.
//    // String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';
//     //4: Update the URL to use the selectedCurrency input.
//     String requestURL = '$bitcoinAverageURL/BTC/GBP?apikey=$apiKey';
//     //5. Make a GET request to the URL and wait for the response.
//     http.Response response = await http.get(Uri.parse(requestURL));
//
//     //6. Check that the request was successful.
//     if (response.statusCode == 200) {
//       //7. Use the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
//       var decodedData = jsonDecode(response.body);
//       //8. Get the last price of bitcoin with the key 'last'.
//       var lastPrice = decodedData['rate'];
//       //9. Output the lastPrice from the method.
//       return lastPrice;
//     } else {
//       //10. Handle any errors that occur during the request.
//       print(response.statusCode);
//       //Optional: throw an error if our request fails.
//       throw 'Problem with the get request';
//     }
//   }
// }