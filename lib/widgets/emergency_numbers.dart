import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumbers extends StatelessWidget {
  final BuildContext context;
  const EmergencyNumbers({super.key, required this.context});

  Future<void> _makeCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneUri';
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Coming Soon'),
              content: const Text('This feature is coming soon'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Emergency Numbers',
              style: TextStyle(
                color: Color.fromARGB(255, 30, 68, 85),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                wordSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                EmergencyCard(
                  title: 'Ambulance',
                  number: '123',
                  description: 'For medical emergencies',
                  onTap: () => _makeCall('123'),
                  icon: Icons.emergency,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Police',
                  number: '122',
                  description: 'For police assistance',
                  onTap: () => _makeCall('122'),
                  icon: Icons.local_police,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Fire Department',
                  number: '180',
                  description: 'For fire emergencies',
                  onTap: () => _makeCall('180'),
                  icon: Icons.fire_truck,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Tourist Police',
                  number: '126',
                  description: 'Tourist emergency assistance',
                  onTap: () => _makeCall('126'),
                  icon: Icons.travel_explore,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Traffic Police',
                  number: '128',
                  description: 'Traffic emergencies and accidents',
                  onTap: () => _makeCall('128'),
                  icon: Icons.traffic,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Gas Emergency',
                  number: '129',
                  description: 'Gas leaks and emergencies',
                  onTap: () => _makeCall('129'),
                  icon: Icons.gas_meter,
                  color: Colors.purple,
                ),
                const SizedBox(height: 16),
                EmergencyCard(
                  title: 'Electricity Emergency',
                  number: '121',
                  description: 'Electricity emergencies',
                  onTap: () => _makeCall('121'),
                  icon: Icons.electric_bolt,
                  color: Colors.yellow.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final String title;
  final String number;
  final String description;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const EmergencyCard({
    super.key,
    required this.title,
    required this.number,
    required this.description,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 16,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.phone, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
