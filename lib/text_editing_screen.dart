import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class TextEditorScreen extends StatefulWidget {
  @override
  _TextEditorScreenState createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  String _displayText = 'New Text';
  double _fontSize = 16.0;
  Color _textColor = Colors.black;
  String _fontFamily = 'Roboto';
  FontWeight _fontWeight = FontWeight.normal;

  List<Map<String, dynamic>> _states = [];
  int _currentStateIndex = -1;

  @override
  void initState() {
    super.initState();
    _saveState(); // Save the initial state
  }

  void _saveState() {
    if (_currentStateIndex < _states.length - 1) {
      // Remove any redo states if we are in the middle of the stack
      _states = _states.sublist(0, _currentStateIndex + 1);
    }

    _states.add({
      'displayText': _displayText,
      'fontSize': _fontSize,
      'textColor': _textColor,
      'fontFamily': _fontFamily,
      'fontWeight': _fontWeight,
    });

    _currentStateIndex++;
  }

  void _undo() {
    if (_currentStateIndex > 0) {
      _currentStateIndex--;
      _applyState(_states[_currentStateIndex]);
    }
  }

  void _redo() {
    if (_currentStateIndex < _states.length - 1) {
      _currentStateIndex++;
      _applyState(_states[_currentStateIndex]);
    }
  }

  void _applyState(Map<String, dynamic> state) {
    setState(() {
      _displayText = state['displayText'];
      _fontSize = state['fontSize'];
      _textColor = state['textColor'];
      _fontFamily = state['fontFamily'];
      _fontWeight = state['fontWeight'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Editor'),
        backgroundColor: const Color.fromARGB(255, 4, 136, 118),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _displayText,
                  style: GoogleFonts.getFont(
                    _fontFamily,
                    fontSize: _fontSize,
                    color: _textColor,
                    fontWeight: _fontWeight,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Font Family Dropdown
                    DropdownButton<String>(
                      value: _fontFamily,
                      items: [
                        'Roboto',
                        'Merriweather',
                        'Lato',
                        'Open Sans',
                        'Montserrat',
                        'Oswald',
                        'Raleway',
                        'Quicksand',
                        'Poppins',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            _fontFamily = newValue!;
                            _saveState();
                          },
                        );
                      },
                    ),
                    // Font Size Dropdown
                    DropdownButton<double>(
                      value: _fontSize,
                      items: [
                        16.0,
                        18.0,
                        22.0,
                        24.0,
                        32.0,
                      ].map((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (double? newValue) {
                        setState(
                          () {
                            _fontSize = newValue!;
                            _saveState();
                          },
                        );
                      },
                    ),
                    // Font Weight Dropdown
                    DropdownButton<FontWeight>(
                      value: _fontWeight,
                      items: [
                        FontWeight.w100,
                        FontWeight.w200,
                        FontWeight.w300,
                        FontWeight.w400,
                        FontWeight.w500,
                        FontWeight.w600,
                        FontWeight.w700,
                        FontWeight.w800,
                        FontWeight.w900,
                      ].map((FontWeight value) {
                        return DropdownMenuItem<FontWeight>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (FontWeight? newValue) {
                        setState(
                          () {
                            _fontWeight = newValue!;
                            _saveState();
                          },
                        );
                      },
                    ),
                    // Color Picker Icon
                    IconButton(
                      icon: Icon(Icons.color_lens, color: _textColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: _textColor,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      _textColor = color;
                                      _saveState();
                                    });
                                  },
                                  labelTypes: const [], // Disable labels
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _undo,
                      child: const Icon(
                        Icons.undo,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _redo,
                      child: const Icon(
                        Icons.redo,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    _displayText = text;
                    _saveState();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter text here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
