import 'package:flutter/material.dart';

class SleekDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<Icon>? iconsEach;

  const SleekDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.iconsEach,
  }) : super(key: key);

  @override
  _SleekDropdownState createState() => _SleekDropdownState();
}

class _SleekDropdownState extends State<SleekDropdown> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedValue);
    _focusNode = FocusNode();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 60), // Adjust based on your TextField height
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  // Check if iconsEach is provided and within bounds
                Icon icon = (widget.iconsEach != null && index < widget.iconsEach!.length)
                    ? widget.iconsEach![index]
                    : Icon(Icons.explore, color: Colors.black54); // Default icon if not provided

                  return ListTile(
                    leading: icon,
                    title: Text(_filteredItems[index]),
                    onTap: () {
                      _controller.text = _filteredItems[index];
                      widget.onChanged(_filteredItems[index]);
                      _focusNode.unfocus();
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

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    _overlayEntry?.markNeedsBuild(); // Rebuild overlay to reflect changes
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) => _filterItems(value),
        ),
      ),
    );
  }
}
