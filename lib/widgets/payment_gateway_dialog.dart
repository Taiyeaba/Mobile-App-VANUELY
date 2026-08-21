import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../utils/app_colors.dart';

class PaymentGatewaySheet extends StatefulWidget {
  final Venue venue;
  final String eventType;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final int guestCount;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final double payableDeposit;
  final String selectedPaymentMethod;

  const PaymentGatewaySheet({
    super.key,
    required this.venue,
    required this.eventType,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.guestCount,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.payableDeposit,
    required this.selectedPaymentMethod,
  });

  @override
  State<PaymentGatewaySheet> createState() => _PaymentGatewaySheetState();
}

class _PaymentGatewaySheetState extends State<PaymentGatewaySheet> {
  late String _activeMethod;
  late TextEditingController _accountController;
  final TextEditingController _otpController = TextEditingController(text: '8492');
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _activeMethod = widget.selectedPaymentMethod;
    _accountController = TextEditingController(text: widget.clientPhone);
  }

  @override
  void dispose() {
    _accountController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (_accountController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid payment account / phone number!')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    Navigator.pop(context, true); // Success signal
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: AppColors.gold, size: 22),
                    SizedBox(width: 8),
                    Text(
                      '256-Bit SSL Payment Gateway',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Deposit Amount Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Venue:', style: TextStyle(fontSize: 12, color: textSecondary)),
                      Text(widget.venue.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payable Advance Deposit:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold)),
                      Text(
                        '৳${widget.payableDeposit.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Text('Select Payment Channel:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
            const SizedBox(height: 10),

            // Payment Options Selector
            Row(
              children: [
                _buildPaymentChip('bKash', Icons.account_balance_wallet, Colors.pink),
                const SizedBox(width: 8),
                _buildPaymentChip('Nagad', Icons.phone_android, Colors.orange),
                const SizedBox(width: 8),
                _buildPaymentChip('Rocket', Icons.credit_card, Colors.purple),
                const SizedBox(width: 8),
                _buildPaymentChip('Card', Icons.payment, Colors.blue),
              ],
            ),

            const SizedBox(height: 16),

            // Wallet/Card Input
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: '$_activeMethod Account / Card Number',
                prefixIcon: const Icon(Icons.payment_outlined, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),

            const SizedBox(height: 12),

            // OTP Code Input
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Security PIN / OTP Code',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New security OTP sent via SMS!')),
                    );
                  },
                  child: const Text('Resend', style: TextStyle(fontSize: 11, color: AppColors.gold)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),

            const SizedBox(height: 18),

            // Submit Payment Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isProcessing ? null : _processPayment,
                icon: _isProcessing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Icon(Icons.check_circle_rounded, color: Colors.black, size: 20),
                label: Text(
                  _isProcessing ? 'PROCESSING SSL PAYMENT...' : 'PAY ৳${widget.payableDeposit.toStringAsFixed(0)} & CONFIRM BOOKING',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChip(String name, IconData icon, Color color) {
    final isSelected = _activeMethod == name;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeMethod = name),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.gold.withValues(alpha: 0.18)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.gold : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.gold : color, size: 20),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.gold : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
