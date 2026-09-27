import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Nâng cao 1 (NC1): Chuyển đổi giao diện Sáng/Tối (ThemeMode)
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 211a290018',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
      ),
      themeMode: mode,
      home: ProfilePage(onThemeToggle: toggleTheme),
    );
  }
}

// Màn hình chính (StatefulWidget để quản lý Lượt thích & Kỹ năng)
class ProfilePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const ProfilePage({super.key, required this.onThemeToggle});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _likes = 0;

  // Nâng cao 2 (NC2): Danh sách kỹ năng bằng Chip
  final Set<String> _selectedSkills = {};
  final List<String> _skills = ['Java', 'Dart', 'SQL', 'Git', 'UI/UX'];

  void _increase() => setState(() => _likes++);
  void _decrease() => setState(() {
        if (_likes > 0) _likes--;
      });
  void _reset() => setState(() => _likes = 0);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final likeColor = _likes >= 10 ? Colors.red : scheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab F1 - Hồ sơ của tôi'),
        backgroundColor: scheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onThemeToggle, // Nút đổi nền NC1
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ProfileCard(
                  name: 'Nguyễn Tuấn Thành',
                  studentId: '211a290018',
                  className: 'Lớp CNTT',
                ),
                const SizedBox(height: 24),

                // Hiển thị phần Nâng cao NC2
                Wrap(
                  spacing: 8.0,
                  children: _skills.map((skill) {
                    return FilterChip(
                      label: Text(skill),
                      selected: _selectedSkills.contains(skill),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSkills.add(skill);
                          } else {
                            _selectedSkills.remove(skill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text('Đã chọn: ${_selectedSkills.length} kỹ năng', style: const TextStyle(fontStyle: FontStyle.italic)),

                const SizedBox(height: 32),
                Text(
                  'Lượt thích: $_likes',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: likeColor),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(onPressed: _decrease, icon: const Icon(Icons.remove)),
                    const SizedBox(width: 12),
                    FilledButton.icon(onPressed: _increase, icon: const Icon(Icons.favorite), label: const Text('Thích')),
                    const SizedBox(width: 12),
                    IconButton.outlined(onPressed: _reset, icon: const Icon(Icons.refresh)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Thẻ hồ sơ (StatelessWidget vì nó chỉ hiển thị tĩnh)
class ProfileCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String className;

  const ProfileCard({
    super.key,
    required this.name,
    required this.studentId,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().split(' ').last.substring(0, 1);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(initial, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 12),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Text('MSSV: $studentId'),
            Text(className),
          ],
        ),
      ),
    );
  }
}