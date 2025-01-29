import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/models/vbt_set.dart';
import 'package:vbt_app/screens/shared/floating_action_button.dart';
import 'package:vbt_app/screens/home/workout/set/ongoing_set_screen.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class NewSetScreen extends ConsumerStatefulWidget {
  const NewSetScreen(this.set, {super.key});

  final VBTSet set;

  @override
  ConsumerState<NewSetScreen> createState() => NewSetScreenState();
}

class NewSetScreenState extends ConsumerState<NewSetScreen> {
  final _bodyWeightController = TextEditingController();
  final _loadWeightController = TextEditingController();

  final RegExp _decimalNumberRegExp = RegExp(r'^\d*\.?\d*');

  @override
  void initState() {
    _bodyWeightController.text = "50.0";
    _loadWeightController.text = "50.0";
    super.initState();
  }

  @override
  void dispose() {
    _bodyWeightController.dispose();
    _loadWeightController.dispose();
    super.dispose();
  }

  void _startSet() {
    widget.set.bodyWeight = double.parse(_bodyWeightController.text);
    widget.set.loadWeight = double.parse(_loadWeightController.text);
    Navigator.push(context, MaterialPageRoute(builder: (context) => OngoingSetScreen(widget.set)));
  }

  Widget _createField(
      {required String label,
      required TextEditingController controller,
      required double min,
      required double max,
      required int divisions}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(labelText: "$label (kg)"),
          style: const TextStyle(color: AppColors.textColor),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(_decimalNumberRegExp)
          ],
          onChanged: (value) {
            if (value.isNotEmpty && double.tryParse(value) != null) {
              setState(() {});
            }
          },
        ),
        Slider(
          value: double.parse(controller.text),
          min: min,
          max: max,
          divisions: divisions,
          label: controller.text,
          onChanged: (value) {
            setState(() {
              controller.text = value.toStringAsFixed(1);
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: MediumTitle(widget.set.name)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                _createField(
                    label: "Body weight",
                    controller: _bodyWeightController,
                    min: 0,
                    max: 200,
                    divisions: 2000),
                const SizedBox(height: 16),
                _createField(
                    label: "Load weight",
                    controller: _loadWeightController,
                    min: 0,
                    max: 200,
                    divisions: 400),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: PrimaryFloatingActionButton(
            label: "Start set",
            icon: const Icon(Icons.not_started_outlined),
            onPressed: _startSet,
            heroTag: "start_new_set"));
  }
}
