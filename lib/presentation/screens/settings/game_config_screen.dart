import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameConfigScreen extends StatefulWidget {
  const GameConfigScreen({super.key});

  @override
  State<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends State<GameConfigScreen> {
  bool _soundEnabled = true;
  bool _autoSaveEnabled = true;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _autoSaveEnabled = prefs.getBool('autosave_enabled') ?? true;
      _volume = prefs.getDouble('volume') ?? 0.5;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('autosave_enabled', _autoSaveEnabled);
    await prefs.setDouble('volume', _volume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo trang trí ở trên cùng
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Header: Back - Title - Save (Check)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black),
                  const Text(
                    'Cấu hình game đố vui',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.check, color: Colors.black),
                ],
              ),
              const SizedBox(height: 40),
              
              // Âm thanh
              _buildSettingItem(
                label: 'Âm thanh',
                child: Row(
                  children: [
                    Checkbox(
                      value: _soundEnabled,
                      activeColor: Colors.black,
                      onChanged: (val) {
                        setState(() => _soundEnabled = val ?? false);
                        _saveSettings();
                      },
                    ),
                    const Text('Bật', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Điểm cao nhất
              _buildSettingItem(
                label: 'Điểm cao nhất',
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '3500',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tự động lưu game
              _buildSettingItem(
                label: 'Tự động lưu game',
                child: Row(
                  children: [
                    Checkbox(
                      value: _autoSaveEnabled,
                      activeColor: Colors.black,
                      onChanged: (val) {
                        setState(() => _autoSaveEnabled = val ?? false);
                        _saveSettings();
                      },
                    ),
                    const Text('Bật', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Volume Label
              const Text(
                'Volume',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 10),

              // Volume Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.black,
                  thumbColor: Colors.black,
                  overlayColor: Colors.black.withOpacity(0.1),
                  trackHeight: 1.5,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                ),
                child: Slider(
                  value: _volume,
                  onChanged: (val) {
                    setState(() => _volume = val);
                    _saveSettings();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper để căn lề nhãn và phần tương tác theo cột
  Widget _buildSettingItem({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(
          width: 120, // Giảm xuống 120 để checkbox gần label hơn
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        child,
      ],
    );
  }
}
