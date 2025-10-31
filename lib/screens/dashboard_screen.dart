import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Tasks',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '12',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Trust Score',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tier 2',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.75,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '750/1000',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Completion Rate',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '85%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Last 30 Days ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '+10%',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: CustomPaint(
                      painter: _LineChartPainter(),
                      size: const Size(double.infinity, 160),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Week 1',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 15)),
                      Text('Week 2',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 15)),
                      Text('Week 3',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 15)),
                      Text('Week 4',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Upcoming Deadlines',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const _DeadlineItem(
              title: 'Project Proposal',
              subtitle: 'Due in 2 days',
            ),
            const _DeadlineItem(
              title: 'Client Presentation',
              subtitle: 'Due in 5 days',
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const _DeadlineItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onBackground),
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 16)),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      0.7,
      0.5,
      0.8,
      0.6,
      0.9,
      0.4,
      0.8,
      0.7,
      0.6,
      0.9,
      0.5,
      0.8
    ]; // Example data

    final areaPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.withOpacity(0.2), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()..color = Colors.transparent;
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke;

    // background
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      bgPaint,
    );

    // grid baseline
    for (int i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (points.isEmpty) return;

    final spacing = size.width / (points.length - 1);
    final path = Path();
    final area = Path();

    Offset pointAt(int i) {
      final x = i * spacing;
      final y = size.height * (1 - points[i].clamp(0.0, 1.0));
      return Offset(x, y);
    }

    path.moveTo(0, pointAt(0).dy);
    area.moveTo(0, size.height);
    area.lineTo(0, pointAt(0).dy);

    for (int i = 1; i < points.length; i++) {
      final p1 = pointAt(i - 1);
      final p2 = pointAt(i);
      final controlX = (p1.dx + p2.dx) / 2;
      final control1 = Offset(controlX, p1.dy);
      final control2 = Offset(controlX, p2.dy);
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        p2.dx,
        p2.dy,
      );
      area.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        p2.dx,
        p2.dy,
      );
    }

    area.lineTo(size.width, size.height);
    area.close();

    canvas.drawPath(area, areaPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
