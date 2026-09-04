import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/booking_model.dart';

class RatingReviewScreen extends ConsumerStatefulWidget {
  final Booking booking;

  const RatingReviewScreen({super.key, required this.booking});

  @override
  ConsumerState<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends ConsumerState<RatingReviewScreen> {
  double _overallRating = 5.0;
  double _professionalism = 5.0;
  double _serviceQuality = 5.0;
  double _coordination = 5.0;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _selectedTags = [];

  final List<String> _availableTags = [
    'Punctual',
    'Transparent Rate',
    'Clean Finish',
    'Co-op Certified',
    'Honest Quote',
    'Fair & Polite',
    'Thorough Diagnostic',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7FFF3),
      appBar: AppBar(
        backgroundColor: AppColors.darkEmerald,
        title: const Text(
          'Rate Service & Cooperative',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Technician & Booking Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.celadon),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      widget.booking.workerPhotoUrl.isNotEmpty
                          ? widget.booking.workerPhotoUrl
                          : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.booking.workerName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          '${widget.booking.serviceCategory} • ${widget.booking.cooperativeName}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Overall Star Rating
            Center(
              child: Column(
                children: [
                  const Text(
                    'Overall Experience',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1.0;
                      return IconButton(
                        iconSize: 36,
                        icon: Icon(
                          starVal <= _overallRating
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.amberWarning,
                        ),
                        onPressed: () {
                          setState(() => _overallRating = starVal);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Multi-dimensional Sub-ratings
            Container(
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
                    'Cooperative Quality Dimensions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkEmerald,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubRatingRow(
                    label: 'Technician Professionalism & Courtesy',
                    rating: _professionalism,
                    onChanged: (val) => setState(() => _professionalism = val),
                  ),
                  const Divider(color: AppColors.celadon),
                  _buildSubRatingRow(
                    label: 'Service Quality & Clean Finish',
                    rating: _serviceQuality,
                    onChanged: (val) => setState(() => _serviceQuality = val),
                  ),
                  const Divider(color: AppColors.celadon),
                  _buildSubRatingRow(
                    label: 'Cooperative Coordination & Fair Pricing',
                    rating: _coordination,
                    onChanged: (val) => setState(() => _coordination = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cooperative Tags
            const Text(
              'Select Cooperative Feedback Badges',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: AppColors.frostedMint,
                  checkmarkColor: AppColors.darkEmerald,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.darkEmerald
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Review Comment Box
            const Text(
              'Detailed Feedback (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    'Tell the community about your experience, punctuality, and fair pricing...',
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit Cooperative Review',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubRatingRow({
    required String label,
    required double rating,
    required Function(double) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.evergreen),
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            final starVal = index + 1.0;
            return InkWell(
              onTap: () => onChanged(starVal),
              child: Icon(
                starVal <= rating ? Icons.star : Icons.star_border,
                size: 20,
                color: AppColors.amberWarning,
              ),
            );
          }),
        ),
      ],
    );
  }

  void _submitReview() {
    final repo = ref.read(platformRepositoryProvider);
    repo.submitReview(
      bookingId: widget.booking.id,
      workerId: widget.booking.workerId,
      cooperativeId: widget.booking.cooperativeId,
      rating: _overallRating,
      professionalism: _professionalism,
      serviceQuality: _serviceQuality,
      coordination: _coordination,
      comment: _commentController.text.isEmpty
          ? 'Exceptional cooperative service!'
          : _commentController.text,
      tags: _selectedTags,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review submitted! Thank you for supporting the guild.'),
        backgroundColor: AppColors.seaGreen,
      ),
    );

    context.pop();
  }
}
