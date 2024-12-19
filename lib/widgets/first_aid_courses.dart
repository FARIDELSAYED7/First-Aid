import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Course {
  final String title;
  final String description;
  final String duration;
  final String level;
  final String icon;
  final Color color;
  final double progress;
  final String url;

  const Course({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.icon,
    required this.color,
    required this.progress,
    required this.url,
  });
}

class FirstAidCourses extends StatefulWidget {
  const FirstAidCourses({super.key});

  @override
  State<FirstAidCourses> createState() => _FirstAidCoursesState();
}

class _FirstAidCoursesState extends State<FirstAidCourses> {
  String _selectedCategory = 'All Courses';

  final List<Course> _courses = const [
    Course(
      title: 'Basic First Aid',
      description: 'Essential skills for emergency response',
      duration: '4 hours',
      level: 'Beginner',
      icon: 'assets/icons/bandage.svg',
      color: Color(0xFFFFE0E0),
      progress: 0.0,
      url: 'https://www.redcross.org/take-a-class/first-aid',
    ),
    Course(
      title: 'CPR & AED',
      description: 'Life-saving cardiac emergency skills',
      duration: '6 hours',
      level: 'Intermediate',
      icon: 'assets/icons/heart.svg',
      color: Color(0xFFE0F4FF),
      progress: 0.3,
      url: 'https://www.redcross.org/take-a-class/cpr',
    ),
    Course(
      title: 'Emergency Response',
      description: 'Advanced emergency management',
      duration: '8 hours',
      level: 'Advanced',
      icon: 'assets/icons/ambulance.svg',
      color: Color(0xFFE0FFE3),
      progress: 0.7,
      url: 'https://www.redcross.org/take-a-class/emergency-response',
    ),
    Course(
      title: 'Wound Care',
      description: 'Proper treatment of injuries',
      duration: '3 hours',
      level: 'Beginner',
      icon: 'assets/icons/medical-kit.svg',
      color: Color(0xFFFFF4E0),
      progress: 0.5,
      url: 'https://www.redcross.org/take-a-class/first-aid/wound-care',
    ),
    Course(
      title: 'Child Safety',
      description: 'Pediatric first aid essentials',
      duration: '5 hours',
      level: 'Intermediate',
      icon: 'assets/icons/child.svg',
      color: Color(0xFFE8E0FF),
      progress: 0.2,
      url: 'https://www.redcross.org/take-a-class/first-aid/child-baby-first-aid',
    ),
    Course(
      title: 'Disaster Prep',
      description: 'Natural disaster readiness',
      duration: '6 hours',
      level: 'Advanced',
      icon: 'assets/icons/warning.svg',
      color: Color(0xFFFFE0F0),
      progress: 0.0,
      url: 'https://www.redcross.org/take-a-class/disaster-preparedness',
    ),
  ];

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'All Courses') {
      return _courses;
    }
    return _courses.where((course) => course.level == _selectedCategory).toList();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Aid Training',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Master life-saving skills with our comprehensive courses',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'All Courses',
                    isSelected: _selectedCategory == 'All Courses',
                    onTap: () => setState(() => _selectedCategory = 'All Courses'),
                  ),
                  _CategoryChip(
                    label: 'Beginner',
                    isSelected: _selectedCategory == 'Beginner',
                    onTap: () => setState(() => _selectedCategory = 'Beginner'),
                  ),
                  _CategoryChip(
                    label: 'Intermediate',
                    isSelected: _selectedCategory == 'Intermediate',
                    onTap: () => setState(() => _selectedCategory = 'Intermediate'),
                  ),
                  _CategoryChip(
                    label: 'Advanced',
                    isSelected: _selectedCategory == 'Advanced',
                    onTap: () => setState(() => _selectedCategory = 'Advanced'),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final course = _filteredCourses[index];
                  return _CourseCard(
                    title: course.title,
                    description: course.description,
                    duration: course.duration,
                    level: course.level,
                    icon: course.icon,
                    color: course.color,
                    progress: course.progress,
                    onTap: () => _launchURL(course.url),
                  );
                },
                childCount: _filteredCourses.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String level;
  final String icon;
  final Color color;
  final double progress;
  final VoidCallback onTap;

  const _CourseCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.icon,
    required this.color,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  icon,
                  height: 32,
                  width: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (progress > 0)
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
