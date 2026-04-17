import 'package:flutter/material.dart';

class UrgencyFilter extends StatelessWidget {
  const UrgencyFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const Row(
            children: [
              Icon(Icons.filter_list),
              SizedBox(width: 8),
              Text(
                "URGENCY PRIORITY",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            children: [
              _buildTag("4 CRITICAL", Colors.red),
              const SizedBox(width: 8),
              _buildTag("12 STABLE", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}