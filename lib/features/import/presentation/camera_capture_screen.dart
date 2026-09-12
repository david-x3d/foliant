import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  Future<void> _pending = Future.value();
  bool _foreground = true;
  bool _leaving = false;
  bool loading = true;
  bool capturing = false;
  bool changingFlash = false;
  bool flash = false;
  String? error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enqueue(_initialize);
  }

  // Serialize native calls so pausing, capturing and disposal cannot race.
  void _enqueue(Future<void> Function() operation) {
    _pending = _pending.then((_) => operation()).catchError((Object e) async {
      await _release();
      if (!mounted) return;
      setState(() {
        loading = false;
        capturing = false;
        error = e is CameraException && e.code.startsWith('CameraAccessDenied')
            ? 'Bitte den Kamerazugriff in den App-Einstellungen erlauben.'
            : 'Die Kamera konnte nicht verwendet werden. Bitte erneut versuchen.';
      });
    });
  }

  Future<void> _release() async {
    final old = controller;
    controller = null;
    flash = false;
    try {
      await old?.dispose();
    } catch (_) {
      // A camera disconnected by Android may already be closed.
    }
  }

  Future<void> _initialize() async {
    if (!mounted || !_foreground || _leaving) return;
    await _release();
    final cameras = await availableCameras();
    if (!mounted || !_foreground || _leaving) return;
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
    controller = c;
    await c.initialize();
    try {
      await c.setFlashMode(FlashMode.off);
    } on CameraException {
      // Flashless devices can still take photos.
    }
    if (!mounted || !_foreground || _leaving) {
      await _release();
      return;
    }
    setState(() {
      loading = false;
      error = null;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_leaving) return;
    if (mounted) setState(() => loading = true);
    _enqueue(_foreground ? _initialize : _release);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _leaving = true;
    _enqueue(_release);
    super.dispose();
  }

  void _toggleFlash() {
    if (changingFlash || capturing || loading) return;
    setState(() => changingFlash = true);
    _enqueue(() async {
      try {
        final c = controller;
        if (c == null || !_foreground || _leaving) return;
        final next = !flash;
        await c.setFlashMode(next ? FlashMode.torch : FlashMode.off);
        if (mounted) setState(() => flash = next);
      } on CameraException {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Der Blitz ist nicht verfügbar.')),
          );
        }
      } finally {
        if (mounted) setState(() => changingFlash = false);
      }
    });
  }

  void _capture() {
    if (capturing || changingFlash || loading) return;
    setState(() => capturing = true);
    _enqueue(() async {
      try {
        final c = controller;
        if (c == null || !_foreground || _leaving) return;
        final shot = await c.takePicture();
        // Finish disposal BEFORE returning to the importer and opening uCrop.
        await _release();
        if (!mounted || _leaving || !_foreground) return;
        _leaving = true;
        Navigator.pop(context, shot.path);
      } finally {
        if (mounted) setState(() => capturing = false);
      }
    });
  }

  void _retry() {
    setState(() {
      loading = true;
      error = null;
    });
    _enqueue(_initialize);
  }

  @override
  Widget build(BuildContext context) {
    final ready = controller?.value.isInitialized == true;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          tooltip: 'Abbrechen',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Seite aufnehmen'),
        actions: [
          IconButton(
            tooltip: 'Blitz',
            onPressed: !ready || loading || capturing || changingFlash
                ? null
                : _toggleFlash,
            icon: Icon(
              flash ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            ),
          ),
        ],
      ),
      body: loading || capturing
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _retry,
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            )
          : !ready
          ? const SizedBox.shrink()
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio:
                          MediaQuery.orientationOf(context) ==
                              Orientation.portrait
                          ? 1 / controller!.value.aspectRatio
                          : controller!.value.aspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(controller!),
                          const IgnorePointer(
                            child: CustomPaint(painter: _GridPainter()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      const Text(
                        'Seite im Rahmen halten',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 78,
                        height: 78,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: const CircleBorder(
                              side: BorderSide(color: Colors.white54, width: 4),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: changingFlash ? null : _capture,
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            semanticLabel: 'Foto aufnehmen',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .25)
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
