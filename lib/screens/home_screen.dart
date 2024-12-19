import 'package:flutter/material.dart';
import '../widgets/emergency_numbers.dart';
import '../widgets/hospital_map.dart';
import '../widgets/ai_chat.dart';
import '../widgets/first_aid_courses.dart';
import '../screens/medical_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Emergency Numbers',
    'Nearby Hospitals',
    'First Aid Courses',
    'AI Assistant',
    'Medical Profile'
  ];

  final List<Color> _iconColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          EmergencyNumbers(context: context),
          const HospitalMap(),
          const FirstAidCourses(),
          const AiChat(),
          const MedicalInfoScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.emergency, 'Emergency'),
                _buildNavItem(1, Icons.local_hospital, 'Hospitals'),
                _buildNavItem(2, Icons.school, 'Courses'),
                _buildNavItem(3, Icons.chat_bubble, 'AI Chat'),
                _buildNavItem(4, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? _iconColors[index] // Unique color for selected icon
                  : Colors.grey, // Unselected icon color
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? _iconColors[index] // Unique color for selected text
                    : Colors.grey, // Unselected text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
