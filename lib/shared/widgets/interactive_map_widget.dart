import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/cooperative_model.dart';
import '../models/worker_model.dart';

class InteractiveMapWidget extends StatefulWidget {
  final double height;
  final bool showLiveRoute;
  final bool isInteractive;
  final String? customerAddress;
  final WorkerProfile? focusedWorker;
  final List<WorkerProfile> nearbyWorkers;
  final List<Cooperative> nearbyCooperatives;
  final bool showCooperativesMode;
  final Function(WorkerProfile)? onWorkerTap;
  final Function(Cooperative)? onCooperativeTap;

  const InteractiveMapWidget({
    super.key,
    this.height = 220,
    this.showLiveRoute = false,
    this.isInteractive = true,
    this.customerAddress = 'Plot 42, 2nd Avenue, Anna Nagar East',
    this.focusedWorker,
    this.nearbyWorkers = const [],
    this.nearbyCooperatives = const [],
    this.showCooperativesMode = false,
    this.onWorkerTap,
    this.onCooperativeTap,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late bool _showCoops;

  @override
  void initState() {
    super.initState();
    _showCoops = widget.showCooperativesMode;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant InteractiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showCooperativesMode != widget.showCooperativesMode) {
      setState(() {
        _showCoops = widget.showCooperativesMode;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE5F5EC),
        border: Border.all(color: AppColors.celadon, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.evergreen.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Vector Map Canvas
          Positioned.fill(
            child: CustomPaint(
              painter: _CityVectorMapPainter(
                showLiveRoute: widget.showLiveRoute,
                pulseScale: _pulseAnimation.value,
              ),
            ),
          ),

          // Customer Pin (Home)
          const Positioned(
            left: 70,
            bottom: 65,
            child: _LocationMarker(
              label: 'Your Location',
              icon: Icons.home,
              color: AppColors.darkEmerald,
              isCustomer: true,
            ),
          ),

          // Render Worker Pins or Cooperative Pins
          if (!_showCoops) ...[
            if (widget.nearbyWorkers.isNotEmpty) ...[
              Positioned(
                right: 90,
                top: 45,
                child: GestureDetector(
                  onTap: () => widget.onWorkerTap?.call(widget.nearbyWorkers.first),
                  child: _WorkerMapPin(
                    worker: widget.nearbyWorkers.first,
                    isFocused: widget.focusedWorker?.uid == widget.nearbyWorkers.first.uid,
                  ),
                ),
              ),
              if (widget.nearbyWorkers.length > 1)
                Positioned(
                  right: 50,
                  bottom: 50,
                  child: GestureDetector(
                    onTap: () => widget.onWorkerTap?.call(widget.nearbyWorkers[1]),
                    child: _WorkerMapPin(
                      worker: widget.nearbyWorkers[1],
                      isFocused: widget.focusedWorker?.uid == widget.nearbyWorkers[1].uid,
                    ),
                  ),
                ),
              if (widget.nearbyWorkers.length > 2)
                Positioned(
                  left: 140,
                  top: 55,
                  child: GestureDetector(
                    onTap: () => widget.onWorkerTap?.call(widget.nearbyWorkers[2]),
                    child: _WorkerMapPin(
                      worker: widget.nearbyWorkers[2],
                      isFocused: widget.focusedWorker?.uid == widget.nearbyWorkers[2].uid,
                    ),
                  ),
                ),
            ],
          ] else ...[
            // Cooperative Hub Pins
            Positioned(
              right: 80,
              top: 40,
              child: GestureDetector(
                onTap: () {
                  if (widget.nearbyCooperatives.isNotEmpty) {
                    widget.onCooperativeTap?.call(widget.nearbyCooperatives.first);
                  }
                },
                child: _CooperativeHubPin(
                  coop: widget.nearbyCooperatives.isNotEmpty
                      ? widget.nearbyCooperatives.first
                      : null,
                ),
              ),
            ),
            if (widget.nearbyCooperatives.length > 1)
              Positioned(
                left: 150,
                bottom: 40,
                child: GestureDetector(
                  onTap: () {
                    widget.onCooperativeTap?.call(widget.nearbyCooperatives[1]);
                  },
                  child: _CooperativeHubPin(
                    coop: widget.nearbyCooperatives[1],
                  ),
                ),
              ),
          ],

          // Map Overlay Header / Controls
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.celadon),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.evergreen.withOpacity(0.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.seaGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showCoops ? 'Cooperative Guilds' : 'Live Verified Workers',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkEmerald,
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle Switch between Workers & Cooperatives
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _showCoops = false),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: !_showCoops ? AppColors.seaGreen : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
                          ),
                          child: Text(
                            'Workers',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: !_showCoops ? AppColors.white : AppColors.evergreen,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _showCoops = true),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _showCoops ? AppColors.seaGreen : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
                          ),
                          child: Text(
                            'Co-ops',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _showCoops ? AppColors.white : AppColors.evergreen,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _WorkerMapPin extends StatelessWidget {
  final WorkerProfile worker;
  final bool isFocused;

  const _WorkerMapPin({
    required this.worker,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.pineTeal,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.evergreen.withOpacity(0.2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            '${worker.name.split(' ').first} • ₹${worker.hourlyRate.toInt()}/h',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(
              color: isFocused ? AppColors.seaGreen : AppColors.mintLeaf,
              width: isFocused ? 2.5 : 2,
            ),
            image: DecorationImage(
              image: NetworkImage(worker.photoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Icon(Icons.arrow_drop_down, color: AppColors.seaGreen, size: 16),
      ],
    );
  }
}

class _CooperativeHubPin extends StatelessWidget {
  final Cooperative? coop;

  const _CooperativeHubPin({this.coop});

  @override
  Widget build(BuildContext context) {
    final name = coop?.name ?? 'Anna Nagar Co-op';
    final available = coop?.availableTodayCount ?? 14;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.darkEmerald,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.evergreen.withOpacity(0.25),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.diversity_3, color: AppColors.mintLeaf, size: 12),
              const SizedBox(width: 4),
              Text(
                '$name ($available Avail)',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.seaGreen, width: 2.5),
          ),
          child: const Icon(
            Icons.domain,
            color: AppColors.seaGreen,
            size: 20,
          ),
        ),
        const Icon(Icons.arrow_drop_down, color: AppColors.darkEmerald, size: 16),
      ],
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isCustomer;

  const _LocationMarker({
    required this.label,
    required this.icon,
    required this.color,
    this.isCustomer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.celadon),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: Icon(icon, color: AppColors.white, size: 16),
        ),
      ],
    );
  }
}

class _CityVectorMapPainter extends CustomPainter {
  final bool showLiveRoute;
  final double pulseScale;

  _CityVectorMapPainter({
    required this.showLiveRoute,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F6EF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFF3FBF7)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final parkPaint = Paint()
      ..color = const Color(0xFFD6F0E0)
      ..style = PaintingStyle.fill;

    // Parks
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.45, 20, 80, 50),
        const Radius.circular(12),
      ),
      parkPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, size.height * 0.55, 60, 60),
        const Radius.circular(10),
      ),
      parkPaint,
    );

    // Minor Roads
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.4),
      minorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.45, size.height),
      minorRoadPaint,
    );

    // Main Avenue
    final mainRoad = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.75,
        size.height * 0.25,
      )
      ..lineTo(size.width, size.height * 0.2);
    canvas.drawPath(mainRoad, roadPaint);

    // Live Route Polyline
    if (showLiveRoute) {
      final routePaint = Paint()
        ..color = AppColors.seaGreen
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final routePath = Path()
        ..moveTo(70, size.height - 65)
        ..lineTo(size.width * 0.4, size.height * 0.55)
        ..lineTo(size.width - 90, 60);

      canvas.drawPath(routePath, routePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CityVectorMapPainter oldDelegate) => true;
}
