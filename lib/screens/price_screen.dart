import 'dart:io' show Platform;

import 'package:bitcoin_ticker/services/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utilities/constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String bitcoinPrice = '?';
  String ethereumPrice = '?';
  String litecoinPrice = '?';
  bool showSpinner;

  void toggleSpinner() {
    setState(() {
      showSpinner = !showSpinner;
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }

    return DropdownButton(
      dropdownColor: kContainerColor,
      isExpanded: true,
      underline: SizedBox(),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 42,
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        toggleSpinner();
        setState(() {
          selectedCurrency = value;
          updatePrices(value);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency.toString()));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  void updatePrices(String currency) async {
    CoinData networkService = CoinData();
    var coinPrices = await networkService.getData(selectedCurrency);
    setState(() {
      bitcoinPrice = coinPrices['BTC'];
      ethereumPrice = coinPrices['ETH'];
      litecoinPrice = coinPrices['LTC'];
    });

    toggleSpinner();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      showSpinner = true;
    });
    updatePrices(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return showSpinner
        ? Container(
            color: kScaffoldBackgroundColor,
            child: SpinKitCubeGrid(
              size: 100,
              color: Colors.amber,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('\$ Coin Ticker'),
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                      child: Column(
                        children: [
                          IconContainer(
                            cryptocurrency: 'BTC',
                            iconPath: 'images/bitcoin.png',
                            cryptoPrice: bitcoinPrice,
                            selectedCurrency: selectedCurrency,
                          ),
                          IconContainer(
                            cryptocurrency: 'ETH',
                            iconPath: 'images/ethereum.jpg',
                            cryptoPrice: ethereumPrice,
                            selectedCurrency: selectedCurrency,
                          ),
                          IconContainer(
                            cryptocurrency: 'LTC',
                            iconPath: 'images/litecoin.png',
                            cryptoPrice: litecoinPrice,
                            selectedCurrency: selectedCurrency,
                          ),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          height: 80,
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: kContainerColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Platform.isIOS
                              ? iosPicker()
                              : androidDropdown())),
                ],
              ),
            ),
          );
  }
}

class IconContainer extends StatelessWidget {
  final String iconPath;
  final String cryptocurrency;
  final String cryptoPrice;
  final String selectedCurrency;
  IconContainer(
      {@required this.iconPath,
      @required this.cryptocurrency,
      @required this.cryptoPrice,
      @required this.selectedCurrency});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 575,
            height: 50,
            decoration: BoxDecoration(
                color: kContainerColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                '1 $cryptocurrency = $cryptoPrice $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -25,
            child: Container(
              width: 80,
              height: 100,
              child: Image.asset(
                iconPath,
              ),
            ),
          )
        ],
      ),
    );
  }
}
