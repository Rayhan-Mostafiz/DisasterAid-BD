import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/sos_button.dart';
import '../widgets/custom_card.dart';
import 'map_screen.dart';
import 'first_aid_guide.dart';
import 'emergency_contacts.dart';
import 'help_request_feed.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: AppColors.warning),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'বর্তমানে কোনো active disaster alert নেই',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SOS Button - center e
            const Center(
              child: Text('Emergency? Press SOS',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ),
            const SizedBox(height: 12),
            Center(
              child: SOSButton(onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('🆘 SOS পাঠাবেন?'),
                    content: const Text(
                        'আপনার location সহ emergency alert সব responder-দের কাছে পাঠানো হবে।'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✅ SOS Alert পাঠানো হয়েছে!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('পাঠান',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            Text('Quick Actions', style: AppTextStyles.heading),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                CustomCard(
                  icon: Icons.map_outlined,
                  title: 'Disaster Map',
                  color: Colors.blue,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MapScreen())),
                ),
                CustomCard(
                  icon: Icons.medical_services_outlined,
                  title: 'First Aid Guide',
                  color: Colors.green,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FirstAidGuide())),
                ),
                CustomCard(
                  icon: Icons.contacts_outlined,
                  title: 'Emergency Contacts',
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmergencyContacts())),
                ),
                CustomCard(
                  icon: Icons.people_outline,
                  title: 'Help Requests',
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HelpRequestFeed())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
