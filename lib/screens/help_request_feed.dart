import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';
import '../models/alert_model.dart';

class HelpRequestFeed extends StatefulWidget {
  const HelpRequestFeed({super.key});

  @override
  State<HelpRequestFeed> createState() => _HelpRequestFeedState();
}

class _HelpRequestFeedState extends State<HelpRequestFeed> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color _severityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber[700]!;
      default:
        return Colors.green;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'flood':
        return Icons.water;
      case 'fire':
        return Icons.local_fire_department;
      case 'earthquake':
        return Icons.terrain;
      default:
        return Icons.warning;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day ago';
  }

  // ✅ Firestore এ নতুন Help Request add করা
  Future<void> _addHelpRequest() async {
    // Form dialog দেখানো
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _HelpRequestDialog(),
    );

    if (result == null) return;

    try {
      await _firestore.collection('alerts').add({
        'title': result['title'],
        'description': result['description'],
        'type': result['type'],
        'severity': result['severity'],
        'latitude': 23.8103,
        'longitude': 90.4125,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'current_user',
        'isResolved': false,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Help request সফলভাবে পাঠানো হয়েছে!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Respond button — Firestore এ update করা
  Future<void> _respondToAlert(String alertId) async {
    try {
      await _firestore.collection('alerts').doc(alertId).update({
        'isResolved': true,
        'respondedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Response পাঠানো হয়েছে!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Requests',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),

      // ✅ StreamBuilder — Firestore থেকে real-time data
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('alerts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          // Empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('কোনো help request নেই'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final alertId = docs[index].id;

              final title = data['title'] ?? 'No Title';
              final description = data['description'] ?? '';
              final type = data['type'] ?? 'other';
              final severity = data['severity'] ?? 'medium';
              final isResolved = data['isResolved'] ?? false;
              final createdAt = data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                color: isResolved ? Colors.grey[100] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isResolved
                                ? Colors.grey
                                : _severityColor(severity),
                            radius: 18,
                            child: Icon(_typeIcon(type),
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  '${severity.toUpperCase()} • ${_timeAgo(createdAt)}${isResolved ? ' • ✅ Resolved' : ''}',
                                  style: TextStyle(
                                      color: isResolved
                                          ? Colors.grey
                                          : _severityColor(severity),
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(description,
                          style: AppTextStyles.body),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.map_outlined, size: 16),
                            label: const Text('Map'),
                          ),
                          const SizedBox(width: 8),
                          if (!isResolved)
                            ElevatedButton.icon(
                              onPressed: () => _respondToAlert(alertId),
                              icon: const Icon(Icons.volunteer_activism,
                                  size: 16, color: Colors.white),
                              label: const Text('Respond',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addHelpRequest,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Request Help',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ✅ Help Request Form Dialog
class _HelpRequestDialog extends StatefulWidget {
  @override
  State<_HelpRequestDialog> createState() => _HelpRequestDialogState();
}

class _HelpRequestDialogState extends State<_HelpRequestDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _type = 'flood';
  String _severity = 'medium';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('নতুন Help Request'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'শিরোনাম'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'বিবরণ'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'ধরন'),
              items: const [
                DropdownMenuItem(value: 'flood', child: Text('বন্যা')),
                DropdownMenuItem(value: 'fire', child: Text('আগুন')),
                DropdownMenuItem(value: 'earthquake', child: Text('ভূমিকম্প')),
                DropdownMenuItem(value: 'other', child: Text('অন্যান্য')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            DropdownButtonFormField<String>(
              value: _severity,
              decoration: const InputDecoration(labelText: 'তীব্রতা'),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
              ],
              onChanged: (v) => setState(() => _severity = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('বাতিল'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isEmpty) return;
            Navigator.pop(context, {
              'title': _titleController.text,
              'description': _descController.text,
              'type': _type,
              'severity': _severity,
            });
          },
          child: const Text('পাঠান'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}