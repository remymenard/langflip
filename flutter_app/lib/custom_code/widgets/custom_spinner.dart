// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class CustomSpinner extends StatelessWidget {
  const CustomSpinner({Key? key, this.width, this.height, this.color})
      : super(key: key);

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double computedHeight = height ?? width ?? 50;
    return Container(
      height: computedHeight,
      width: computedHeight,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary, strokeWidth: 2),
      ),
    );
  }
}
