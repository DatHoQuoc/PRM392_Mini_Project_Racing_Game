import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // <-- 1. THÊM DÒNG IMPORT THƯ VIỆN NÀY
import 'widgets/checkerboard_row.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  bool isAudioOn = true;
  final int currentPoints = 100;

  // <-- 2. THÊM ĐỐI TƯỢNG QUẢN LÝ PHÁT NHẠC
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startBackgroundMusic(); // <-- 3. GỌI PHÁT NHẠC NGAY KHI KHỞI TẠO MÀNH HÌNH
  }

  // <-- 4. THÊM HÀM XỬ LÝ PHÁT NHẠC NỀN AN TOÀN
  Future<void> _startBackgroundMusic() async {
    try {
      // Thiết lập nguồn nhạc từ thư mục assets/audio/
      await _audioPlayer.setSource(AssetSource('audio/background_music.mp3'));
      // Thiết lập phát lặp đi lặp lại liên tục (vòng lặp)
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Bắt đầu phát
      await _audioPlayer.resume();
      debugPrint("🎵 Nhạc nền đã khởi chạy thành công!");
    } catch (e) {
      debugPrint("❌ Lỗi khởi tạo hoặc phát nhạc: $e");
    }
  }

  // <-- 5. THÊM HÀM ĐIỀU KHIỂN BẬT / TẮM NHẠC KHI NHẤN NÚT
  void _toggleAudio() {
    setState(() {
      isAudioOn = !isAudioOn;
      if (isAudioOn) {
        _audioPlayer.resume(); // Phát tiếp tục khi bật lại
      } else {
        _audioPlayer.pause();  // Tạm dừng nhạc khi tắt
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // <-- 6. GIẢI PHÓNG BỘ NHỚ KHI THOÁT MÀN HÌNH
    super.dispose();
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF1A1A1A),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🏁 HOW TO PLAY 🏁',
                  style: TextStyle(
                    color: Color(0xFFFFC107),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '• 3 racers compete simultaneously with random speeds.\n'
                  '• Place your bets on your favorite racer before the race starts.\n'
                  '• Correct bets reward points; incorrect bets deduct funds from your balance.',
                  style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF990000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('GOT IT!', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF660000),
      body: Center(
        child: AspectRatio(
          aspectRatio: 812 / 375,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF660000),
            ),
            child: Stack(
              children: [
                // Viền Caro Trên/Dưới - Đã sửa right: 0 để phủ dài toàn bộ viền màn hình sang hết bên phải
                const Positioned(top: 0, left: 0, right: 0, child: CheckerboardRow()),
                const Positioned(bottom: 0, left: 0, right: 0, child: CheckerboardRow()),

                const Positioned(top: 15, left: 15, child: Icon(Icons.outlined_flag, color: Color(0xFFFFC107), size: 28)),
                const Positioned(top: 15, right: 90, child: Icon(Icons.outlined_flag, color: Color(0xFFFFC107), size: 28)),

                // MAIN CONTENT AREA - Đã dịch chuyển sang phải thêm một chút bằng cách thêm left padding
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 40,   // Thêm đệm trái để đẩy cụm nội dung qua phải một chút theo ý bạn
                      right: 65,  // Giữ đệm phải để tránh đè lên hàng menu điều khiển dọc
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'RACING',
                          style: TextStyle(
                            fontSize: 62,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFFFC107), Color(0xFFE64A19), Color(0xFFFFC107)],
                                stops: [0.1, 0.6, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 320.0, 75.0)),
                            shadows: [
                              const Shadow(
                                offset: Offset(3.0, 3.0),
                                color: Color(0xFF660000),
                              ),
                              const Shadow(
                                offset: Offset(6.0, 6.0),
                                color: Colors.black,
                              ),
                              Shadow(
                                blurRadius: 15.0,
                                color: const Color(0xFFE64A19).withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildMainButton(
                              title: 'TRACK',
                              subtitle: '',
                              titleColor: Colors.black,
                              backgroundColor: const Color(0xFFFFC107),
                              hasCheckerboardBg: false,
                              onTap: () => debugPrint('Track Tapped - Handled by Team Member'),
                            ),
                            const SizedBox(width: 25),
                            _buildMainButton(
                              title: 'PLAY',
                              subtitle: '',
                              titleColor: Colors.black,
                              backgroundColor: const Color(0xFFFFC107),
                              hasCheckerboardBg: false,
                              onTap: () => debugPrint('Play Tapped - Handled by Team Member'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // RIGHT MENU CONTROLS (Giữ nguyên kích thước nhỏ gọn như lượt trước)
                Positioned(
                  right: 15,
                  top: 20,
                  bottom: 20,
                  width: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cụm hiển thị Points nhỏ gọn
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFFC107), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                        child: Column(
                          children: [
                            const Text('POINTS', style: TextStyle(color: Color(0xFFFFC107), fontSize: 8, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(
                              currentPoints.toString().padLeft(4, '0'),
                              style: const TextStyle(color: Color(0xFFFFC107), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                            ),
                          ],
                        ),
                      ),

                      // Các nút tròn chức năng Rules & Audio nhỏ nhắn
                      Column(
                        children: [
                          _buildSidebarIconButton(
                            icon: const Text('!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                            label: '',
                            backgroundColor: const Color(0xFFFFC107),
                            onTap: () => _showRulesDialog(context),
                          ),
                          const SizedBox(height: 25),
                          _buildSidebarIconButton(
                            icon: Icon(isAudioOn ? Icons.volume_up : Icons.volume_off, color: isAudioOn ? Colors.black : Colors.white70, size: 15),
                            label: '',
                            backgroundColor: isAudioOn ? const Color(0xFFFFC107) : Colors.grey,
                            onTap: _toggleAudio, // <-- 7. ĐỔI THÀNH GỌI HÀM _toggleAudio ĐỂ XỬ LÝ NHẠC
                          ),
                        ],
                      ),

                      // Nút Log Out nằm dưới cùng
                      InkWell(
                        onTap: () => debugPrint('Log Out Tapped'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Color(0xFF990000), size: 10),
                              SizedBox(width: 2),
                              Text('OUT', style: TextStyle(color: Color(0xFF990000), fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required String title,
    required String subtitle,
    required Color titleColor,
    Color? backgroundColor,
    required bool hasCheckerboardBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 65,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 4))],
        ),
        child: Stack(
          children: [
            if (hasCheckerboardBg)
              Opacity(
                opacity: 0.15,
                child: GridView.count(
                  crossAxisCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(24, (index) => Container(color: index % 2 == 0 ? Colors.black : Colors.white)),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(color: titleColor, fontSize: 24, fontWeight: FontWeight.w900)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: TextStyle(color: titleColor.withValues(alpha: 0.6), fontSize: 8, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarIconButton({
    required Widget icon,
    required String label,
    Color backgroundColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Center(child: icon),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}