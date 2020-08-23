import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:joker/providers/mainprovider.dart';
import 'package:provider/provider.dart';

class CountryPickerCode extends StatelessWidget {
  const CountryPickerCode({Key key, this.onCountryChange, this.isRTL}) : super(key: key);
  final Function(CountryCode) onCountryChange;
  final bool isRTL;
  @override
  Widget build(BuildContext context) {
    final MainProvider bolc = Provider.of<MainProvider>(context);

    return CountryCodePicker(
      onChanged: onCountryChange,
      initialSelection: bolc.countryCode,
      favorite: const <String>['+966', 'SA'],
      showFlagDialog: true,
      showFlag: false,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      padding: isRTL == true
          ? const EdgeInsets.fromLTRB(0, 0, 32, 0)
          : const EdgeInsets.fromLTRB(32, 0, 0, 0),
    );
  }
}
