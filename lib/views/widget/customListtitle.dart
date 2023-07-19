import "package:flutter/material.dart";

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
