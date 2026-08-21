import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/venue.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/time_slot_button.dart';
import '../../widgets/guest_counter.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/payment_gateway_dialog.dart';
import 'booking_confirmation_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final Venue venue;

  const BookingFlowScreen({
    super.key,
    required this.venue,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 1;
  final int _totalSteps = 6;

  late String _selectedEventType;
  late String _selectedTimeSlot;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  int _guestCount = 200;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _specialRequestController;

  final TextEditingController _promoController = TextEditingController();
  double _promoDiscountPercent = 0.0;
  String? _promoMessage;
  String _selectedPaymentMethod = 'bKash';

  @override
  void initState() {
    super.initState();
    _selectedEventType = widget.venue.category;
    _selectedTimeSlot = widget.venue.availableSlots.isNotEmpty
        ? widget.venue.availableSlots.first
        : '10:00 AM';

    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _specialRequestController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'VENUELY15' || code == 'GOLD2026') {
      setState(() {
        _promoDiscountPercent = 0.15;
        _promoMessage = '15% Promo Discount Applied!';
      });
    } else if (code.isEmpty) {
      setState(() {
        _promoDiscountPercent = 0.0;
        _promoMessage = null;
      });
    } else {
      setState(() {
        _promoDiscountPercent = 0.0;
        _promoMessage = 'Invalid Promo Code. Try "VENUELY15"';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.gold,
                    onPrimary: Colors.black,
                    surface: AppColors.darkCard,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.gold,
                    onPrimary: Colors.black,
                    surface: AppColors.lightCard,
                    onSurface: Colors.black,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 5) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _confirmBooking() async {
    final baseDeposit = widget.venue.pricePerDay * 0.15;
    final finalDeposit = baseDeposit * (1 - _promoDiscountPercent);

    // Open Payment Gateway Sheet
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PaymentGatewaySheet(
          venue: widget.venue,
          eventType: _selectedEventType,
          selectedDate: _selectedDate,
          selectedTimeSlot: _selectedTimeSlot,
          guestCount: _guestCount,
          clientName: _nameController.text,
          clientEmail: _emailController.text,
          clientPhone: _phoneController.text,
          payableDeposit: finalDeposit,
          selectedPaymentMethod: _selectedPaymentMethod,
        );
      },
    );

    if (success == true && mounted) {
      final booking = Booking(
        id: 'VN-2026-${(100 + (DateTime.now().millisecondsSinceEpoch % 899))}',
        venueId: widget.venue.id,
        venueName: widget.venue.name,
        venueImage: widget.venue.imageUrls.first,
        eventType: _selectedEventType,
        date: '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
        timeSlot: _selectedTimeSlot,
        guestCount: _guestCount,
        totalPrice: widget.venue.pricePerDay,
        depositPaid: finalDeposit,
        status: 'Confirmed',
        clientName: _nameController.text,
        clientEmail: _emailController.text,
        clientPhone: _phoneController.text,
        specialRequest: _specialRequestController.text,
        createdAt: DateTime.now(),
      );

      Provider.of<BookingProvider>(context, listen: false).addBooking(booking);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: booking)),
      );
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Venue - Step $_currentStep of $_totalSteps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator Bar
            LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              color: AppColors.gold,
              minHeight: 4,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: _buildStepContent(context),
                ),
              ),
            ),

            // Bottom Navigation Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    Expanded(
                      child: SecondaryButton(
                        label: 'Back',
                        onPressed: _previousStep,
                      ),
                    ),
                  if (_currentStep > 1) const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentStep == _totalSteps ? 'Pay & Confirm' : 'Continue',
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    switch (_currentStep) {
      case 1:
        // STEP 1: Event Type
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Event Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Choose the nature of your upcoming occasion', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.eventTypes.map((type) {
                final isSelected = _selectedEventType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: AppColors.gold,
                  backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedEventType = type;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 2:
        // STEP 2: Select Date
        final dateStr = '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Reservation Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Pick an available calendar date for your venue', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: AppColors.gold, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event Date', style: TextStyle(fontSize: 12, color: textSecondary)),
                          Text(dateStr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_calendar_rounded, color: AppColors.gold),
                  ],
                ),
              ),
            ),
          ],
        );

      case 3:
        // STEP 3: Time Slot
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Time Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Choose an available slot for your event session', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return TimeSlotButton(
                  slot: slot,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedTimeSlot = slot;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 4:
        // STEP 4: Guest Count
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimated Guest Count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Specify how many guests will attend (Max: ${widget.venue.guestCapacity})', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 30),
            Center(
              child: GuestCounter(
                count: _guestCount,
                maxCapacity: widget.venue.guestCapacity,
                onChanged: (newCount) {
                  setState(() {
                    _guestCount = newCount;
                  });
                },
              ),
            ),
          ],
        );

      case 5:
        // STEP 5: Contact Details
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Host Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Enter contact details for booking verification', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Full Name',
              controller: _nameController,
              prefixIcon: Icons.person_outline,
              validator: (val) => AppValidators.validateRequired(val, 'Full Name'),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Email Address',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.validateEmail,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Phone Number',
              controller: _phoneController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: AppValidators.validatePhone,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Special Requests (Optional)',
              controller: _specialRequestController,
              prefixIcon: Icons.edit_note_outlined,
              maxLines: 2,
            ),
          ],
        );

      case 6:
        // STEP 6: Booking Summary & Payment Method & Promo Code
        final dateStrSummary = '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}';
        final baseDeposit = widget.venue.pricePerDay * 0.15;
        final discountAmount = baseDeposit * _promoDiscountPercent;
        final finalDeposit = baseDeposit - discountAmount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Summary & Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 6),
            Text('Review your reservation details and select payment method.', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 16),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  _summaryRow('Venue', widget.venue.name, isBold: true),
                  const Divider(),
                  _summaryRow('Event Type', _selectedEventType),
                  _summaryRow('Date', dateStrSummary),
                  _summaryRow('Time Slot', _selectedTimeSlot),
                  _summaryRow('Guests', '$_guestCount Person(s)'),
                  _summaryRow('Host Name', _nameController.text),
                  _summaryRow('Phone', _phoneController.text),
                  const Divider(),
                  _summaryRow('Total Package Rate', '৳${widget.venue.pricePerDay.toStringAsFixed(0)}', isBold: true),
                  _summaryRow('Base Advance Deposit (15%)', '৳${baseDeposit.toStringAsFixed(0)}'),
                  if (_promoDiscountPercent > 0)
                    _summaryRow('Promo Discount (15%)', '-৳${discountAmount.toStringAsFixed(0)}', isGold: true),
                  _summaryRow('Payable Deposit', '৳${finalDeposit.toStringAsFixed(0)}', isBold: true, isGold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Promo Code Input Box
            Text('Promo / Coupon Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter "VENUELY15"',
                      hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _applyPromoCode,
                  child: const Text('Apply', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (_promoMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                _promoMessage!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _promoDiscountPercent > 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Payment Method Selector
            Text('Select Payment Channel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['bKash', 'Nagad', 'Rocket', 'Credit/Debit Card'].map((pm) {
                final isSelected = _selectedPaymentMethod == pm;
                return ChoiceChip(
                  label: Text(pm),
                  selected: isSelected,
                  selectedColor: AppColors.gold,
                  backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedPaymentMethod = pm;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, bool isGold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: isBold ? 13 : 12,
                fontWeight: isBold || isGold ? FontWeight.bold : FontWeight.w600,
                color: isGold ? AppColors.gold : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
