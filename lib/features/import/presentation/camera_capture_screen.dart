import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? controller;
  bool loading = true;
  bool flash = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('Keine Kamera verfügbar.');
      final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final c = CameraController(
        back,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      await c.initialize();
      await c.setFlashMode(FlashMode.off);
      if (!mounted) return;
      setState(() {
        controller = c;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    final c = controller;
    if (c == null) return;
    flash = !flash;
    await c.setFlashMode(flash ? FlashMode.torch : FlashMode.off);
    if (mounted) setState(() {});
  }

  Future<void> _capture() async {
    final c = controller;
    if (c == null || c.value.isTakingPicture) return;
    final shot = await c.takePicture();
    await c.setFlashMode(FlashMode.off);
    if (!mounted) return;
    Navigator.pop(context, shot.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Buchseite fotografieren'),
        actions: [
          IconButton(
            tooltip: 'Blitz',
            onPressed: controller == null ? null : _toggleFlash,
            icon: Icon(
              flash ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Text(error!, style: const TextStyle(color: Colors.white)),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller!),
                const IgnorePointer(child: _GridOverlay()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    minimum: const EdgeInsets.all(24),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        minimumSize: const Size(78, 78),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _capture,
                      child: const Icon(Icons.camera_rounded, size: 34),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GridPainter());
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .35)
      ..strokeWidth = 1;
    for (var i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(size.width * i / 3, 0),
        Offset(size.width * i / 3, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height * i / 3),
        Offset(size.width, size.height * i / 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
