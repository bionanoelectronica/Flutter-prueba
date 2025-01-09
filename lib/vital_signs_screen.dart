import 'dart:async';
    import 'dart:math';
    import 'package:flutter/material.dart';
    import 'package:fl_chart/fl_chart.dart';

    class VitalSignsScreen extends StatefulWidget {
      const VitalSignsScreen({super.key});

      @override
      _VitalSignsScreenState createState() => _VitalSignsScreenState();
    }

    class _VitalSignsScreenState extends State<VitalSignsScreen> {
      double _heartRate = 75.0;
      double _bloodPressureSystolic = 120.0;
      double _bloodPressureDiastolic = 80.0;
      double _oxygenSaturation = 98.0;
      List<FlSpot> _heartRateData = [];
      List<FlSpot> _bloodPressureData = [];
      List<FlSpot> _oxygenSaturationData = [];
      Timer? _timer;
      int _time = 0;

      @override
      void initState() {
        super.initState();
        _startMockDataStream();
      }

      @override
      void dispose() {
        _timer?.cancel();
        super.dispose();
      }

      void _startMockDataStream() {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _time++;
            _heartRate = 70 + Random().nextDouble() * 20;
            _bloodPressureSystolic = 110 + Random().nextDouble() * 30;
            _bloodPressureDiastolic = 70 + Random().nextDouble() * 20;
            _oxygenSaturation = 95 + Random().nextDouble() * 5;

            _heartRateData.add(FlSpot(_time.toDouble(), _heartRate));
            _bloodPressureData.add(FlSpot(_time.toDouble(), _bloodPressureSystolic));
            _oxygenSaturationData.add(FlSpot(_time.toDouble(), _oxygenSaturation));

            if (_heartRateData.length > 30) {
              _heartRateData.removeAt(0);
              _bloodPressureData.removeAt(0);
              _oxygenSaturationData.removeAt(0);
            }
          });
        });
      }

      LineChartData _createLineChartData(List<FlSpot> data, Color color) {
        return LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: data.isNotEmpty ? data.first.x : 0,
          maxX: data.isNotEmpty ? data.last.x : 30,
          minY: data.isNotEmpty ? data.map((e) => e.y).reduce(min) - 5 : 0,
          maxY: data.isNotEmpty ? data.map((e) => e.y).reduce(max) + 5 : 100,
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Vital Signs Monitor'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVitalSignCard(
                  'Heart Rate',
                  '${_heartRate.toStringAsFixed(0)} BPM',
                  Colors.red,
                  _heartRateData,
                ),
                _buildVitalSignCard(
                  'Blood Pressure',
                  '${_bloodPressureSystolic.toStringAsFixed(0)}/${_bloodPressureDiastolic.toStringAsFixed(0)} mmHg',
                  Colors.blue,
                  _bloodPressureData,
                ),
                _buildVitalSignCard(
                  'Oxygen Saturation',
                  '${_oxygenSaturation.toStringAsFixed(0)}%',
                  Colors.green,
                  _oxygenSaturationData,
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildVitalSignCard(String title, String value, Color color, List<FlSpot> data) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: LineChart(
                    _createLineChartData(data, color),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
