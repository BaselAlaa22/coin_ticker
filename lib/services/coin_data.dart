import 'dart:convert';

import 'package:http/http.dart' as http;

const List currenciesList = [
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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apikey = '77ED0641-7290-435D-B194-BB3549834779';

class CoinData {
  Future getData(String selectedCurrency) async {
    Map<String, String> coinPrices = {};
    String requestURL;
    for (String cryptoCoin in cryptoList) {
      requestURL = coinAPIURL +
          '/' +
          cryptoCoin +
          '/' +
          selectedCurrency +
          '?apikey=' +
          apikey;
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double cryptoPrice = decodedData['rate'];
        coinPrices[cryptoCoin] = cryptoPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with get request';
      }
    }

    return coinPrices;
  }
}
