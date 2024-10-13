import 'package:flutter/material.dart';

class MyPublicTransButton extends StatefulWidget {
  final void Function()? onTap;

  const MyPublicTransButton({super.key, required this.onTap});

  @override
  _MyPublicTransButtonState createState() => _MyPublicTransButtonState();
}

class _MyPublicTransButtonState extends State<MyPublicTransButton> {
  String _selectedTransport = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTransportButton(context, 'assets/images/png/bus.png', 'bus'),
            _buildTransportButton(context, 'assets/images/png/car.png', 'car'),
            _buildTransportButton(
                context, 'assets/images/png/walk.png', 'walk'),
            _buildTransportButton(
                context, 'assets/images/png/bicycle.png', 'bicycle'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportButton(
      BuildContext context, String assetPath, String transportType) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransport = transportType;
        });
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        width: screenWidth * 0.2,
        height: screenHeight * 0.04,
        decoration: BoxDecoration(
          color: _selectedTransport == transportType
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: Image.asset(
            assetPath,
            color: _selectedTransport == transportType
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
