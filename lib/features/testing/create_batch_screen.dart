import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/testing_workflow_provider.dart';

class CreateBatchScreen extends ConsumerStatefulWidget {
  const CreateBatchScreen({super.key});

  @override
  ConsumerState<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends ConsumerState<CreateBatchScreen> {
  late final TextEditingController _batchIdController;
  late final TextEditingController _sourceController;
  late final TextEditingController _storageLocationController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _batchIdController = TextEditingController(text: "FS-2026-00128");
    _sourceController = TextEditingController(text: "Farm Produced");
    _storageLocationController = TextEditingController(text: "Silage Pit 01");
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _batchIdController.dispose();
    _sourceController.dispose();
    _storageLocationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final workflow = ref.read(testingWorkflowProvider);
    ref.read(testingWorkflowProvider.notifier).createBatch(
      feedType: workflow.selectedFeedType,
      batchNumber: _batchIdController.text.trim(),
      source: _sourceController.text.trim(),
      storageLocation: _storageLocationController.text.trim(),
      notes: _notesController.text.trim(),
    );
    context.push('/test/sample');
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Feed Batch"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feed Type Selector Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.grass_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Selected Feed Type", style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
                          Text(
                            workflow.selectedFeedType,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.primaryGreen),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text("Batch ID", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _batchIdController,
                decoration: const InputDecoration(
                  hintText: "e.g. FS-2026-00128",
                  prefixIcon: Icon(Icons.qr_code_2_outlined, color: AppColors.textLight),
                ),
              ),

              const SizedBox(height: 18),

              const Text("Source", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: "Farm Produced",
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textLight),
                ),
                items: const [
                  DropdownMenuItem(value: "Farm Produced", child: Text("Farm Produced")),
                  DropdownMenuItem(value: "Purchased (Local Mandi)", child: Text("Purchased (Local Mandi)")),
                  DropdownMenuItem(value: "Co-operative Supply", child: Text("Co-operative Supply")),
                  DropdownMenuItem(value: "Commercial Feed Supplier", child: Text("Commercial Feed Supplier")),
                ],
                onChanged: (val) {
                  if (val != null) _sourceController.text = val;
                },
              ),

              const SizedBox(height: 18),

              const Text("Storage Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: "Silage Pit 01",
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.warehouse_outlined, color: AppColors.textLight),
                ),
                items: const [
                  DropdownMenuItem(value: "Silage Pit 01", child: Text("Silage Pit 01")),
                  DropdownMenuItem(value: "Silage Pit 02", child: Text("Silage Pit 02")),
                  DropdownMenuItem(value: "Shed Bay 2", child: Text("Shed Bay 2")),
                  DropdownMenuItem(value: "Feed Store Room", child: Text("Feed Store Room")),
                ],
                onChanged: (val) {
                  if (val != null) _storageLocationController.text = val;
                },
              ),

              const SizedBox(height: 18),

              const Text("Notes (optional)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: "Add any notes on harvest date, moisture or treatment...",
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _handleContinue,
                child: const Text("Continue"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
