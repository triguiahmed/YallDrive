import 'package:car_rental_app_clean_arch/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class ScaffoldPage extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String? title;
  final List<Widget>? actions;
  final Color? color;
  final List<BottomNavigationBarItem> bottomNavItems;
  final List<String> routes;

  const ScaffoldPage({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.bottomNavItems,
    required this.routes,
    this.title,
    this.actions, 
    this.color,
  }); 

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  void _onItemTapped(int index) {
    if (index != widget.currentIndex && index < widget.routes.length) {
      Navigator.pushReplacementNamed(context, widget.routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.whiteColor,
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!),
              actions: widget.actions,
              backgroundColor: widget.color,
              centerTitle: true,
            )
          : null,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: widget.bottomNavItems,
      ),
    );
  }
}
