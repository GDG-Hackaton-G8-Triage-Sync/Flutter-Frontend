import 'package:flutter/material.dart';
import 'urgency_filter.dart';
class QueueHeader extends StatelessWidget {
  const QueueHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side (Logo + Title)
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.monitor_heart,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                "TriageSync",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Right Side
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "LIVE QUEUE",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "24 Patients",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              Icon(
                Icons.notifications,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 16),
      const UrgencyFilter(),
        ],
      ),
    );
  }
}