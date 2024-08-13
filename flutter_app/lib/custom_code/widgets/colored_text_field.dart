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

class ColoredTextField extends StatefulWidget {
  final String initialText;
  final double? height;
  final double? width;
  final Color textColor;
  final Color highlightedTextColor;
  final Future Function(String newText) callback;

  const ColoredTextField({
    super.key,
    this.initialText = '',
    this.height,
    this.width,
    required this.textColor,
    required this.highlightedTextColor,
    required this.callback,
  });

  @override
  ColoredTextFieldState createState() => ColoredTextFieldState();
}

class ColoredTextFieldState extends State<ColoredTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final GlobalKey _textFieldKey = GlobalKey();
  double _textFieldHeight = 0;
  String _initialText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _handleFocusChange() {
    setState(() {
      if (_focusNode.hasFocus) {
        _initialText = _controller.text;
      } else if (_initialText != _controller.text) {
        widget.callback(_controller.text);
      }
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextFieldHeight();
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = _calculateTopPadding();

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.height ?? 0,
      ),
      width: widget.width,
      child: Stack(
        children: [
          if (!_isFocused)
            Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: topPadding),
              child: RichText(
                text: buildTextSpan(
                    _controller.text,
                    TextStyle(
                      fontSize: 14,
                      color: widget.textColor,
                      letterSpacing: 1.0,
                      fontFamily:
                          Theme.of(context).textTheme.bodyMedium?.fontFamily,
                      fontWeight:
                          Theme.of(context).textTheme.bodyMedium?.fontWeight,
                      height: 1.5,
                    )),
              ),
            ),
          TextField(
            key: _textFieldKey,
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.0,
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              fontWeight: Theme.of(context).textTheme.bodyMedium?.fontWeight,
              color: _isFocused ? widget.textColor : Colors.transparent,
              height: 1.5,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              hintText: '',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            onChanged: (text) {
              setState(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updateTextFieldHeight();
                });
              });
            },
          ),
        ],
      ),
    );
  }

  void _updateTextFieldHeight() {
    final context = _textFieldKey.currentContext;
    if (context != null) {
      final height = context.size?.height ?? 0;
      setState(() {
        _textFieldHeight = height;
      });
    }
  }

  double _calculateTopPadding() {
    final int lines = ((_textFieldHeight - 27) / 21)
        .ceil(); // Assuming each line is approximately 21 pixels tall

    return lines > 1 ? 8 : 13.5;
  }

  TextSpan buildTextSpan(String text, TextStyle style) {
    final redStyle = style.copyWith(color: widget.highlightedTextColor);
    final List<TextSpan> children = [];

    final List<String> lines = text.split('\n');

    for (String line in lines) {
      final List<String> words = line.split(' ');

      for (String word in words) {
        if (word.startsWith('~')) {
          final String cleanWord = word.substring(1);
          children.add(TextSpan(text: cleanWord, style: redStyle));
        } else {
          children.add(TextSpan(text: word, style: style));
        }
        children.add(const TextSpan(text: ' '));
      }
      children.add(const TextSpan(text: '\n'));
    }

    if (children.isNotEmpty && children.last.text == '\n') {
      children.removeLast();
    }

    return TextSpan(style: style, children: children);
  }
}
