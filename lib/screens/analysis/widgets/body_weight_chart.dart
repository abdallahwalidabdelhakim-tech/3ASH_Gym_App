// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget to display a body weight tracking chart
/// 
/// Shows a line chart of weight measurements over time with interactive features.
// ignore: camel_case_types
class Body_Weight_Chart extends StatelessWidget {
  
  const Body_Weight_Chart({
    super.key, 
    required this.data, 
    required this.metric, 
    required this.title,
  });
  
  final List<Map<String, dynamic>> data;
  final String metric;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Prepare chart data points
    final spots = data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return FlSpot(index.toDouble(), item[metric]);
    }).toList();

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chart title
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        // Line chart
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                horizontalInterval: 5,
                verticalInterval: 7,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: _calculateXAxisInterval(data.length),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        final date = data[index]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()} kg',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: data.length - 1.toDouble(),
              minY: _calculateMinY(spots),
              maxY: _calculateMaxY(spots),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: const Color(0xFFD5FF5F),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFFD5FF5F),
                        strokeWidth: 2,
                        strokeColor: Colors.black,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFD5FF5F).withValues(alpha: 0.3),
                        const Color(0xFFD5FF5F).withValues(alpha: 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      final item = data[index];
                      final date = item['date'] as DateTime;
                      
                      return LineTooltipItem(
                        '${item[metric]} kg\n${date.day}/${date.month}/${date.year}',
                        TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  // Handle touch events if needed
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Calculates appropriate X-axis interval based on data points count
  double _calculateXAxisInterval(int dataCount) {
    if (dataCount <= 7) return 1;
    if (dataCount <= 14) return 2;
    if (dataCount <= 30) return 5;
    return 10;
  }

  /// Calculates minimum Y value with padding
  double _calculateMinY(List<FlSpot> spots) {
    final minValue = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    return minValue - 2; // Add 2kg padding below minimum
  }

  /// Calculates maximum Y value with padding
  double _calculateMaxY(List<FlSpot> spots) {
    final maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return maxValue + 2; // Add 2kg padding above maximum
  }
}
