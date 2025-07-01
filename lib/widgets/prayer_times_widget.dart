import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/provider/prayer_time_provider.dart';
import 'package:azkar/service/prayer_location.dart';
import 'package:azkar/service/prayer_model.dart';
import 'package:azkar/widgets/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  late Timer _timer;
  String _nextPrayerCountdown = '';
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final provider = Provider.of<PrayerTimeProvider>(context, listen: false);
      final entry = provider.getNextPrayerWithTime();
      if (entry != null) {
        final remaining = entry.value.difference(DateTime.now());
        if (mounted) {
          setState(() {
            _nextPrayerCountdown = _formatDuration(remaining);
            _nextPrayerName = entry.key.name;
          });
        }
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double _calculateNextPrayerProgress() {
    final provider = Provider.of<PrayerTimeProvider>(context, listen: false);
    final entry = provider.getNextPrayerWithTime();
    if (entry == null) return 0.0;

    final now = DateTime.now();
    final target = entry.value;

    DateTime? previous;
    for (final p in provider.prayerTimes.reversed) {
      final parts = p.time.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final dt = DateTime(now.year, now.month, now.day, hour, minute);
      if (dt.isBefore(now)) {
        previous = dt;
        break;
      }
    }

    final start = previous ?? now.subtract(const Duration(hours: 1));
    final total = target.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds;

    return total == 0 ? 0.0 : (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerTimeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageProvider.localizedStrings['Prayer Times'] ??
                        'Prayer Times',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D3B2A),
                    ),
                  ),
                  TextButton(
                    child: Text("Change Location"),
                    onPressed: () async {
                      final newLocation = await Navigator.push<PrayerLocation>(
                        context,
                        MaterialPageRoute(builder: (_) => LocationSelector()),
                      );
                      if (newLocation != null) {
                        provider.updateLocation(newLocation);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Location Info
              if (provider.currentLocation != null)
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.currentLocation!.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: provider.resetToCurrentLocation,
                      child: Text(
                        languageProvider.localizedStrings['Reset to Current'] ??
                            'Reset',
                      ),
                    ),
                  ],
                ),

              /// Countdown + Progress
              if (_nextPrayerCountdown.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        'Next Prayer ($_nextPrayerName): $_nextPrayerCountdown',
                        key: ValueKey(_nextPrayerCountdown),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// 🔁 Use this for Linear Progress
                    LinearProgressIndicator(
                      value: _calculateNextPrayerProgress(),
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.deepOrange,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 4),

                    // 🔁 Or use this for Circular Progress (optional alternative)
                    // Center(
                    //   child: SizedBox(
                    //     width: 60,
                    //     height: 60,
                    //     child: CircularProgressIndicator(
                    //       value: _calculateNextPrayerProgress(),
                    //       strokeWidth: 6,
                    //       backgroundColor: Colors.grey.shade300,
                    //       color: Colors.deepOrange,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

              /// Prayer Time Rows
              if (provider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (provider.error != null)
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.red),
                )
              else
                ...provider.prayerTimes.map(_buildPrayerTimeRow).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(PrayerTime prayer) {
    final now = DateTime.now();
    final parts = prayer.time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final prayerTime = DateTime(now.year, now.month, now.day, hour, minute);
    final isPast = prayerTime.isBefore(now) && !prayer.isCurrent;

    final bgColor = prayer.isCurrent
        ? const Color(0xFF1D3B2A).withOpacity(0.1)
        : isPast
        ? Colors.grey.shade100
        : Colors.grey.shade50;

    final borderColor = prayer.isCurrent
        ? const Color(0xFF1D3B2A)
        : isPast
        ? Colors.grey.shade300
        : Colors.grey.shade300;

    final textColor = prayer.isCurrent
        ? const Color(0xFF1D3B2A)
        : isPast
        ? Colors.grey
        : Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (prayer.isCurrent)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1D3B2A),
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                prayer.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: prayer.isCurrent
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          Text(
            prayer.time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: prayer.isCurrent ? FontWeight.bold : FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
