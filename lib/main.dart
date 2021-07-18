import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.dark,
    ),
    title: 'Simple Interest',
    home: SIForm(),
    showSemanticsDebugger: false,
  ));
}

class SIForm extends StatefulWidget {
  @override
  _SIFormState createState() => _SIFormState();
}

extension extString on String {
  bool get isValidNumber {
    final numberRegExp = RegExp("[0-9]");
    return numberRegExp.hasMatch(this);
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rupees', 'Cedis', 'Dollars'];

  var _formKey = GlobalKey<FormState>();
  var _currentItemSelected = '';

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String result = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset('img/getcertified.jpg',
                      height: 150.0, width: 150.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextFormField(
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: principalController,
                    validator: (String value) {
                      return _validateFormFields(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Principal',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter Principal',
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextFormField(
                    controller: roiController,
                    keyboardType: TextInputType.number,
                    validator: (String value) {
                      return _validateFormFields(value);
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Rate of Interest',
                        hintText: 'Percentage',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: termController,
                        validator: (String value) {
                          return _validateFormFields(value);
                        },
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Rate of Interest',
                            hintText: 'Percentage',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(
                      width: 10.0,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      value: _currentItemSelected,
                      onChanged: (String newValueSelected) {
                        _onDropDownItemSelected(newValueSelected);
                      },
                    ))
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Calculate',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  this.result = _calculateTotalReturns();
                                }
                              });
                            },
                            color: Colors.green,
                          ),
                        ),
                        Container(width: 20.0),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Reset',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            onPressed: () {
                              setState(() {
                                Reset();
                              });
                            },
                            color: Colors.red,
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Container(
                    child: Text(this.result),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    int term = int.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';

    return result;
  }

  void Reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    result = '';
    _currentItemSelected = _currencies[0];
  }

  String _validateFormFields(String value) {
    if (value.isEmpty) {
      return 'Enter a value';
    }
    if (value.isValidNumber) {
      return null;
    } else {
      return 'Enter a number';
    }
  }
}
