import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FunnelStage {
  final String label;
  final int count;
  final double percentage;
  final Color color;

  const FunnelStage({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class BookingFunnelChart extends StatelessWidget {
  final List<FunnelStage> stages;

  const BookingFunnelChart({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Booking Funnel",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.frostedMint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Real-time',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.seaGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final stage in stages) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.evergreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${stage.count} (${(stage.percentage * 100).toInt()}%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: stage.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          width: double.infinity,
                          color: AppColors.celadon.withOpacity(0.4),
                        ),
                        FractionallySizedBox(
                          widthFactor: stage.percentage.clamp(0.05, 1.0),
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: stage.color,
                              borderRadius: BorderRadius.circular(6),
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
        ],
      ),
    );
  }
}

class SkillBarItem {
  final String skill;
  final int workerCount;
  final double ratio;

  const SkillBarItem({
    required this.skill,
    required this.workerCount,
    required this.ratio,
  });
}

class SkillDistributionCard extends StatelessWidget {
  final List<SkillBarItem> items;

  const SkillDistributionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.celadon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Worker Distribution by Skill',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkEmerald,
            ),
          ),
          const SizedBox(height: 14),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      item.skill,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.evergreen,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            color: AppColors.celadon.withOpacity(0.3),
                          ),
                          FractionallySizedBox(
                            widthFactor: item.ratio.clamp(0.05, 1.0),
                            child: Container(
                              height: 8,
                              color: AppColors.seaGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${item.workerCount}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.seaGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const SimpleBarChart({super.key, required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxVal = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(values.length, (index) {
        final ratio = maxVal > 0 ? (values[index] / maxVal) : 0.0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 22,
              height: (ratio * 110).clamp(10.0, 110.0),
              decoration: BoxDecoration(
                color: AppColors.seaGreen,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[index],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.evergreen,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class DonutSection {
  final double value;
  final Color color;
  final String label;

  const DonutSection({
    required this.value,
    required this.color,
    required this.label,
  });
}

class SimpleDonutChart extends StatelessWidget {
  final List<DonutSection> sections;

  const SimpleDonutChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: sections.map((sec) {
              return Expanded(
                flex: sec.value.toInt(),
                child: Container(
                  height: 18,
                  color: sec.color,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: sections.map((sec) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: sec.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  sec.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.evergreen,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
