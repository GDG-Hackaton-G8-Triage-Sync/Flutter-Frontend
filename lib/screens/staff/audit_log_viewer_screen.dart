import 'package:flutter/material.dart';

class AuditLogEntry {
  const AuditLogEntry({
    required this.time,
    required this.actor,
    required this.action,
    required this.target,
  });

  final String time;
  final String actor;
  final String action;
  final String target;
}

class AuditLogViewerScreen extends StatelessWidget {
  const AuditLogViewerScreen({super.key, required this.entries});

  final List<AuditLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Audit Log Viewer',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No audit records yet.',
                style: TextStyle(color: Color(0xFF44474E)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.time,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF73777F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${entry.actor} • ${entry.action}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target: ${entry.target}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF44474E),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
