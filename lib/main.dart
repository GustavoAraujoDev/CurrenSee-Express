import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(CurrencyConverter());
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  double amount = 1.0;
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double convertedAmount = 0.0;

  Future<double> convertCurrency() async {
    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      double rate = data['rates'][toCurrency];
      return amount * rate;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CurrenSee Express | Conversor de Moedas',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('CurrenSee Express'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = double.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: fromCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        fromCurrency = newValue!;
                      });
                    },
                    items: ['USD', 'BRL', 'EUR', 'JPY', 'GBP']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text('to'),
                  DropdownButton<String>(
                    value: toCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        toCurrency = newValue!;
                      });
                    },
                    items: ['USD', 'BRL', 'EUR', 'JPY', 'GBP']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  double result = await convertCurrency();
                  setState(() {
                    convertedAmount = result;
                  });
                },
                child: Text('Convert'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.deepPurpleAccent),
                ),
              ),
              SizedBox(height: 20),
              Text('Converted Amount: $convertedAmount $toCurrency'),
              SizedBox(height: 20),
              Text(
                'CurrenSee Express - Your Passport to Currency Conversion Bliss',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
