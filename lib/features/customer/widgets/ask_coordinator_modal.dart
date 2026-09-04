import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/data/repository.dart';
import '../../../shared/models/cooperative_model.dart';

class AskCoordinatorModal extends ConsumerStatefulWidget {
  final Cooperative cooperative;
  final String serviceCategory;

  const AskCoordinatorModal({
    super.key,
    required this.cooperative,
    this.serviceCategory = 'General Repair',
  });

  static void show(BuildContext context, Cooperative cooperative,
      {String serviceCategory = 'General Repair'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AskCoordinatorModal(
        cooperative: cooperative,
        serviceCategory: serviceCategory,
      ),
    );
  }

  @override
  ConsumerState<AskCoordinatorModal> createState() =>
      _AskCoordinatorModalState();
}

class _AskCoordinatorModalState extends ConsumerState<AskCoordinatorModal> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(platformRepositoryProvider);
    final pastInquiries = repo.currentCustomerProfile.inquiries
        .where((i) => i.cooperativeId == widget.cooperative.id)
        .toList();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.cooperative.logoUrl),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ask Coordinator Before Booking',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.evergreen,
                          ),
                        ),
                        Text(
                          widget.cooperative.name,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.celadon),
            const SizedBox(height: 10),

            // Past Inquiry Thread if available
            if (pastInquiries.isNotEmpty) ...[
              const Text(
                'Recent Inquiry with this Guild:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkEmerald,
                ),
              ),
              const SizedBox(height: 8),
              ...pastInquiries.take(2).map((inq) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.frostedMint.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.celadon),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q: ${inq.question}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.evergreen,
                        ),
                      ),
                      if (inq.coordinatorReply != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'A (Coordinator): ${inq.coordinatorReply}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.darkEmerald,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        const Text(
                          'Awaiting coordinator response...',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.amberWarning,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            const Text(
              'Clarify Scope, Materials or Timeline:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.darkEmerald,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _questionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Do you bring scaffolding for high ceiling fan repair? What is the estimate?',
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_questionController.text.isNotEmpty) {
                    repo.sendPreBookingInquiry(
                      cooperativeId: widget.cooperative.id,
                      cooperativeName: widget.cooperative.name,
                      serviceCategory: widget.serviceCategory,
                      question: _questionController.text.trim(),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Question sent to guild coordinator! You will receive response within 15 mins.'),
                        backgroundColor: AppColors.seaGreen,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seaGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Send Question to Coordinator',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
