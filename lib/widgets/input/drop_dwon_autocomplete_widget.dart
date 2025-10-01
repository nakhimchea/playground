import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/widgets/input/inputfield_widget.dart';

class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  const AutocompleteTextField(
      {super.key, required this.items, required this.onItemSelect, this.decoration, this.validator});

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<String> _filteredItems;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputFieldWidget(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onFieldChange,
        // decoration: widget.decoration,
        validator: widget.validator,
        trailing: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  void _onFieldChange(String val) {
    setState(() {
      if (val == '') {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((element) => element.toLowerCase().contains(val.toLowerCase())).toList();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              color: AppColors.surface,
              child: ListView.builder(
                itemCount: _filteredItems.length,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                itemBuilder: (BuildContext context, int index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      _controller.text = item;
                      _focusNode.unfocus();
                      widget.onItemSelect(item);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
