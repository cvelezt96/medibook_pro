import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_summary_widget.dart';
import './widgets/appointment_type_selector.dart';
import './widgets/calendar_widget.dart';
import './widgets/consultation_type_widget.dart';
import './widgets/doctor_header_widget.dart';
import './widgets/insurance_card_widget.dart';
import './widgets/notes_input_widget.dart';
import './widgets/time_slot_bottom_sheet.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({Key? key}) : super(key: key);

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  // Mock data for selected doctor
  final Map<String, dynamic> selectedDoctor = {
    "id": 1,
    "name": "Dr. Sarah Johnson",
    "specialization": "Cardiologist",
    "photo":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
    "rating": 4.8,
    "reviews": 127,
    "experience": "15 years",
    "location": "Heart Care Medical Center",
  };

  // Mock insurance information
  final Map<String, dynamic> insuranceInfo = {
    "provider": "Blue Cross Blue Shield",
    "planType": "PPO Premium",
    "memberId": "BC123456789",
    "groupNumber": "GRP001234",
    "copay": "\$25",
    "deductible": "\$500 remaining",
    "status": "Active",
  };

  // Available dates for appointments (next 30 days, excluding weekends)
  late List<DateTime> availableDates;

  // Time slots for selected date
  final List<Map<String, dynamic>> timeSlots = [
    {"id": 1, "time": "09:00 AM", "isAvailable": true},
    {"id": 2, "time": "09:30 AM", "isAvailable": false},
    {"id": 3, "time": "10:00 AM", "isAvailable": true},
    {"id": 4, "time": "10:30 AM", "isAvailable": true},
    {"id": 5, "time": "11:00 AM", "isAvailable": false},
    {"id": 6, "time": "11:30 AM", "isAvailable": true},
    {"id": 7, "time": "02:00 PM", "isAvailable": true},
    {"id": 8, "time": "02:30 PM", "isAvailable": true},
    {"id": 9, "time": "03:00 PM", "isAvailable": false},
    {"id": 10, "time": "03:30 PM", "isAvailable": true},
    {"id": 11, "time": "04:00 PM", "isAvailable": true},
    {"id": 12, "time": "04:30 PM", "isAvailable": true},
    {"id": 13, "time": "06:00 PM", "isAvailable": true},
    {"id": 14, "time": "06:30 PM", "isAvailable": false},
    {"id": 15, "time": "07:00 PM", "isAvailable": true},
    {"id": 16, "time": "07:30 PM", "isAvailable": true},
  ];

  // State variables
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  Map<String, dynamic>? selectedTimeSlot;
  String selectedAppointmentType = "routine";
  String selectedConsultationType = "in-person";
  String notes = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    availableDates = [];
    final now = DateTime.now();

    for (int i = 1; i <= 30; i++) {
      final date = now.add(Duration(days: i));
      // Exclude weekends (Saturday = 6, Sunday = 7)
      if (date.weekday != 6 && date.weekday != 7) {
        availableDates.add(date);
      }
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedTimeSlot = null;
    });
    _showTimeSlotBottomSheet();
  }

  void _showTimeSlotBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimeSlotBottomSheet(
        selectedDate: selectedDate,
        timeSlots: timeSlots,
        onTimeSlotSelected: (slot) {
          setState(() {
            selectedTimeSlot = slot;
          });
          HapticFeedback.selectionClick();
        },
      ),
    );
  }

  void _onAppointmentTypeSelected(String type) {
    setState(() {
      selectedAppointmentType = type;
    });
    HapticFeedback.selectionClick();
  }

  void _onConsultationTypeChanged(String type) {
    setState(() {
      selectedConsultationType = type;
    });
    HapticFeedback.selectionClick();
  }

  void _onNotesChanged(String newNotes) {
    setState(() {
      notes = newNotes;
    });
  }

  void _onVerifyBenefits() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Insurance benefits verified successfully"),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  double _calculateTotalCost() {
    double baseCost = 0;

    switch (selectedAppointmentType) {
      case "routine":
        baseCost = 150.0;
        break;
      case "followup":
        baseCost = 100.0;
        break;
      case "newpatient":
        baseCost = 200.0;
        break;
      case "urgent":
        baseCost = 250.0;
        break;
    }

    // Apply consultation type modifier
    if (selectedConsultationType == "telemedicine") {
      baseCost *= 0.8; // 20% discount for telemedicine
    }

    // Apply insurance copay
    return baseCost - 25.0; // \$25 copay covered
  }

  String _getAppointmentTypeTitle(String type) {
    switch (type) {
      case "routine":
        return "Routine Checkup";
      case "followup":
        return "Follow-up";
      case "newpatient":
        return "New Patient";
      case "urgent":
        return "Urgent Care";
      default:
        return "Routine Checkup";
    }
  }

  String _getDuration(String type) {
    switch (type) {
      case "routine":
        return "30 minutes";
      case "followup":
        return "20 minutes";
      case "newpatient":
        return "45 minutes";
      case "urgent":
        return "15 minutes";
      default:
        return "30 minutes";
    }
  }

  void _bookAppointment() {
    if (selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select a time slot"),
          backgroundColor: AppTheme.errorLight,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    HapticFeedback.heavyImpact();

    // Simulate booking process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

      // Navigate to payment processing
      Navigator.pushNamed(context, '/payment-processing');
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentDetails = {
      "date": selectedDate,
      "time": selectedTimeSlot?["time"] ?? "Not selected",
      "appointmentType": _getAppointmentTypeTitle(selectedAppointmentType),
      "consultationType": selectedConsultationType == "in-person"
          ? "In-Person Visit"
          : "Telemedicine",
      "duration": _getDuration(selectedAppointmentType),
      "notes": notes,
    };

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Book Appointment"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
                context, '/appointment-history-and-medical-records'),
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor header
            DoctorHeaderWidget(doctor: selectedDoctor),
            SizedBox(height: 3.h),

            // Calendar widget
            CalendarWidget(
              selectedDate: selectedDate,
              onDateSelected: _onDateSelected,
              availableDates: availableDates,
            ),
            SizedBox(height: 3.h),

            // Selected time slot display
            if (selectedTimeSlot != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Time",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            "${selectedTimeSlot!["time"]}",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _showTimeSlotBottomSheet,
                      child: const Text("Change"),
                    ),
                  ],
                ),
              ),

            if (selectedTimeSlot != null) SizedBox(height: 3.h),

            // Appointment type selector
            AppointmentTypeSelector(
              selectedType: selectedAppointmentType,
              onTypeSelected: _onAppointmentTypeSelected,
            ),
            SizedBox(height: 3.h),

            // Consultation type
            ConsultationTypeWidget(
              selectedType: selectedConsultationType,
              onTypeChanged: _onConsultationTypeChanged,
            ),
            SizedBox(height: 3.h),

            // Insurance information
            InsuranceCardWidget(
              insuranceInfo: insuranceInfo,
              onVerifyBenefits: _onVerifyBenefits,
            ),
            SizedBox(height: 3.h),

            // Notes input
            NotesInputWidget(
              notes: notes,
              onNotesChanged: _onNotesChanged,
            ),
            SizedBox(height: 3.h),

            // Appointment summary
            if (selectedTimeSlot != null)
              AppointmentSummaryWidget(
                appointmentDetails: appointmentDetails,
                totalCost: _calculateTotalCost(),
              ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 14.w,
            child: ElevatedButton(
              onPressed: selectedTimeSlot != null && !isLoading
                  ? _bookAppointment
                  : null,
              child: isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'event_available',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          selectedTimeSlot != null
                              ? "Book Appointment - \$${_calculateTotalCost().toStringAsFixed(2)}"
                              : "Select Time Slot",
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
