import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Analytics',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: colorScheme.onBackground),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildOverviewCard(
              context,
              title: 'Tasks Completed',
              value: '120',
              change: '+10%',
              isPositive: true,
            ),
            const SizedBox(height: 12),
            _buildOverviewCard(
              context,
              title: 'Messages Sent',
              value: '350',
              change: '+5%',
              isPositive: true,
            ),
            const SizedBox(height: 12),
            _buildOverviewCard(
              context,
              title: 'Team Activity',
              value: '20',
              change: '-2%',
              isPositive: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Performance',
              style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tasks Completed Over Time',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                '120',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(51),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '+10%',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'Last 7 Days',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: CustomPaint(
                      painter: _PerformanceChartPainter(),
                      size: const Size(double.infinity, 200),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mon',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Tue',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Wed',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Thu',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Fri',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Sat',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                      Text('Sun',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green[400] : Colors.red[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      0.3,
      0.8,
      0.5,
      0.7,
      0.9,
      0.4,
      0.6
    ]; // Example data for last 7 days

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final areaGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.withAlpha(51),
        Colors.blue.withAlpha(0),
      ],
    );

    final areaPaint = Paint()
      ..shader = areaGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF2D3548)
      ..strokeWidth = 1;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    if (points.isEmpty) return;

    // Create line path
    final path = Path();
    final areaPath = Path();

    final spacing = size.width / (points.length - 1);
    var currentPoint = Offset(0, size.height * (1 - points[0]));

    path.moveTo(currentPoint.dx, currentPoint.dy);
    areaPath.moveTo(currentPoint.dx, size.height);
    areaPath.lineTo(currentPoint.dx, currentPoint.dy);

    for (var i = 1; i < points.length; i++) {
      final x = spacing * i;
      final y = size.height * (1 - points[i]);
      final previousY = currentPoint.dy;
      final control1 = Offset(x - spacing / 2, previousY);
      final control2 = Offset(x - spacing / 2, y);

      path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, x, y);
      areaPath.cubicTo(
          control1.dx, control1.dy, control2.dx, control2.dy, x, y);

      currentPoint = Offset(x, y);
    }

    // Complete the area path
    areaPath.lineTo(size.width, size.height);
    areaPath.close();

    // Draw area and line
    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final x = spacing * i;
      final y = size.height * (1 - points[i]);

      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = const Color(0xFF0A1021),
      );
      canvas.drawCircle(
        Offset(x, y),
        3,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
