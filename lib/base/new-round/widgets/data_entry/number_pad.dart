import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/base/new-round/logic/add_update_button/addupdatebutton_cubit.dart';
import 'package:shot_locker/base/new-round/widgets/data_entry/calculator_button.dart';

class NumberPad extends StatelessWidget {
  final void Function(String number) onSelectNumber;
  const NumberPad({Key? key, required this.onSelectNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _getButton({
      required String text,
      required void Function(String selectedValue) onNumberSelected,
      Color textColor = Colors.white,
    }) {
      return Expanded(
        child: CalculatorButton(
          label: text,
          onTap: (selectedLabel) async {
            await HapticFeedback.lightImpact();
            onNumberSelected.call(selectedLabel);
          },
          labelColor: textColor,
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getButton(
              text: '1',
              onNumberSelected: (selectedNumber) =>
                  onSelectNumber.call(selectedNumber),
            ),
            _getButton(
              text: '2',
              onNumberSelected: (selectedNumber) =>
                  onSelectNumber.call(selectedNumber),
            ),
            _getButton(
              text: '3',
              onNumberSelected: (selectedNumber) =>
                  onSelectNumber.call(selectedNumber),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getButton(
                text: '4',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            _getButton(
                text: '5',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            _getButton(
                text: '6',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getButton(
                text: '7',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            _getButton(
                text: '8',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            _getButton(
                text: '9',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ❌
            _getButton(
                text: 'C',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            _getButton(
                text: '0',
                onNumberSelected: (selectedNumber) =>
                    onSelectNumber.call(selectedNumber)),
            // _getButton(
            //     text: '⏎',
            //     onNumberSelected: (selectedNumber) =>
            //         onSelectNumber.call(selectedNumber)),
            BlocBuilder<AddupdatebuttonCubit, AddupdatebuttonState>(
              builder: (context, state) {
                return _getButton(
                    text: '${state.buttonName} Shot',
                    onNumberSelected: (selectedNumber) =>
                        onSelectNumber.call(selectedNumber));
              },
            ),
          ],
        ),
      ],
    );
  }
}
