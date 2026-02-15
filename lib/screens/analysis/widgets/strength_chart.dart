import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

/// Widget to display a line chart for strength tracking
/// 
/// Supports tracking maxWeight or totalVolume over time with dynamic scaling
/// and customizable appearance.
class StrengthChart extends StatelessWidget { // e.g. All-time adjusted PB

  const StrengthChart({
    super.key,
    required this.data,
    required this.metric,
    required this.title,
    this.benchmarkValue,
  });
  final List<Map<String, dynamic>> data; // {date: DateTime, maxWeight: double, totalVolume: int}
  final String metric; // 'maxWeight' or 'totalVolume'
  final String title;
  final double? benchmarkValue;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available for $title',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = const Color(0xFFD5FF5F);

    // Calculate Min/Max for Y-Axis
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    for (var item in data) {
      final val = (item[metric] as num).toDouble();
      if (val < minY) minY = val;
      if (val > maxY) maxY = val;
    }

    // Adjust range
    if (minY == double.infinity) {
      minY = 0;
      maxY = 10;
    }

    // Dynamic Scaling Logic
    if (minY == maxY) {
       minY = minY * 0.9; 
       maxY = maxY * 1.1;
       if (minY < 0) minY = 0;
       if (maxY == 0) maxY = 10; // Handle 0 case
    } else {
       final range = maxY - minY;
       
       // Ensure minimum visual range (buffer of at least 10% of value)
       // If range is tiny (e.g. 100 vs 101), force a bigger buffer
       final minRange = maxY * 0.1; 
       final effectiveRange = range < minRange ? minRange : range;

       minY -= effectiveRange * 0.2; // Add 20% padding bottom
       maxY += effectiveRange * 0.2; // Add 20% padding top
       
       if (minY < 0) minY = 0;
    }
    
    // Ensure benchmark is visible if provided
    if (benchmarkValue != null) {
      if (benchmarkValue! > maxY) maxY = benchmarkValue! * 1.05;
      if (benchmarkValue! < minY) minY = benchmarkValue! * 0.9; 
    }

    // X-Axis Logic: Data is now pre-aggregated by day, so we don't need to check for same-day duplicates
    // We can assume each entry is a unique day.
    bool _ = false; // Placeholder if we need same-day logic later, but for now completely removed per requirements

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title and benchmark value (if available)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            if (benchmarkValue != null && metric == 'maxWeight')
               Text(
                'PB: ${benchmarkValue!.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
               ),
          ],
        ),
        const SizedBox(height: 16),
        // Line chart widget
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1, // Force interval to 1 to handle index mapping correctly
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        // Intelligent Label Churning
                        // If lots of data, skip some labels
                        if (data.length > 6 && index % (data.length ~/ 4) != 0 && index != data.length - 1 && index != 0) {
                           return const SizedBox.shrink();
                        }
                        
                        final date = data[index]['date'] as DateTime;
                        final text = DateFormat('dd/MM').format(date); // Changed to dd/MM format

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 9, 
                                color: isDark ? Colors.white70 : Colors.black54
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                 leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == minY || value == maxY) return const SizedBox.shrink(); // Hide extremes if ugly
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      );
                    }
                  ),
                 ),
              ),
              borderData: FlBorderData(show: false),
              // Adjust minX/maxX to center single points nicely
              minX: -0.5, 
              maxX: (data.length - 1).toDouble() + 0.5,
              minY: minY,
              maxY: maxY,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                   getTooltipItems: (touchedSpots) {
                     return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index < 0 || index >= data.length) return null;
                        
                        final item = data[index];
                        final date = item['date'] as DateTime;
                        final val = item[metric];
                        
                        return LineTooltipItem(
                          '${DateFormat('MMM d').format(date)}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                             TextSpan(
                               text: '$val ${metric == 'totalVolume' ? 'kg' : 'kg (1RM)'}',
                               style: const TextStyle(color: Color(0xFFD5FF5F), fontWeight: FontWeight.w500),
                             ),
                          ],
                        );
                     }).toList();
                   },
                   fitInsideHorizontally: true,
                   fitInsideVertically: true,
                ),
              ),
              extraLinesData: ExtraLinesData(
                 horizontalLines: [
                    if (benchmarkValue != null && metric == 'maxWeight')
                      HorizontalLine(
                        y: benchmarkValue!,
                        color: const Color(0xFFD5FF5F).withValues(alpha: 0.5),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          style: TextStyle(
                            color: const Color(0xFFD5FF5F).withValues(alpha: 0.8), 
                            fontSize: 10, 
                            fontWeight: FontWeight.bold
                          ),
                          labelResolver: (line) => 'PB',
                        ),
                      ),
                 ]
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((e) {
                     return FlSpot(e.key.toDouble(), (e.value[metric] as num).toDouble());
                  }).toList(),
                  isCurved: data.length > 2, // Only curve if enough points
                  color: color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.1),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.2),
                        color.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
