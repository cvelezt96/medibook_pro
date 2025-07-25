import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_card_widget.dart';
import './widgets/appointment_details_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_filter_header_widget.dart';

class AppointmentHistoryAndMedicalRecords extends StatefulWidget {
  const AppointmentHistoryAndMedicalRecords({Key? key}) : super(key: key);

  @override
  State<AppointmentHistoryAndMedicalRecords> createState() =>
      _AppointmentHistoryAndMedicalRecordsState();
}

class _AppointmentHistoryAndMedicalRecordsState
    extends State<AppointmentHistoryAndMedicalRecords>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isRefreshing = false;

  // Mock data for appointments and medical records
  final List<Map<String, dynamic>> _appointmentHistory = [
    {
      "id": 1,
      "doctorName": "Dr. Sarah Johnson",
      "specialization": "Cardiology",
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "visitType": "Follow-up Consultation",
      "status": "completed",
      "diagnosis":
          "Patient shows significant improvement in cardiovascular health. Blood pressure readings are within normal range. Continue current medication regimen.",
      "medications": [
        {
          "name": "Lisinopril",
          "dosage": "10mg",
          "duration": "30 days",
          "instructions": "Take once daily in the morning with food"
        },
        {
          "name": "Metoprolol",
          "dosage": "25mg",
          "duration": "30 days",
          "instructions": "Take twice daily, morning and evening"
        }
      ],
      "followUpInstructions":
          "Schedule follow-up appointment in 3 months. Continue monitoring blood pressure daily. Maintain low-sodium diet and regular exercise routine.",
      "documents": [
        {
          "fileName": "ECG_Report_Jan2025.pdf",
          "fileType": "pdf",
          "fileSize": 2.5 * 1024 * 1024,
          "uploadDate": DateTime.now().subtract(const Duration(days: 7)),
          "isSecure": true
        },
        {
          "fileName": "Blood_Test_Results.pdf",
          "fileType": "pdf",
          "fileSize": 1.8 * 1024 * 1024,
          "uploadDate": DateTime.now().subtract(const Duration(days: 7)),
          "isSecure": true
        }
      ]
    },
    {
      "id": 2,
      "doctorName": "Dr. Michael Chen",
      "specialization": "Neurology",
      "date": DateTime.now().subtract(const Duration(days: 14)),
      "visitType": "Initial Consultation",
      "status": "completed",
      "diagnosis":
          "Mild tension headaches likely due to stress and poor sleep patterns. No signs of serious neurological conditions.",
      "medications": [
        {
          "name": "Ibuprofen",
          "dosage": "400mg",
          "duration": "As needed",
          "instructions":
              "Take as needed for headache relief, maximum 3 times daily"
        }
      ],
      "followUpInstructions":
          "Implement stress management techniques. Maintain regular sleep schedule of 7-8 hours. Return if headaches worsen or become more frequent.",
      "documents": [
        {
          "fileName": "MRI_Scan_Report.pdf",
          "fileType": "pdf",
          "fileSize": 5.2 * 1024 * 1024,
          "uploadDate": DateTime.now().subtract(const Duration(days: 14)),
          "isSecure": true
        }
      ]
    },
    {
      "id": 3,
      "doctorName": "Dr. Emily Rodriguez",
      "specialization": "Dermatology",
      "date": DateTime.now().add(const Duration(days: 3)),
      "visitType": "Routine Check-up",
      "status": "upcoming",
      "diagnosis": "",
      "medications": [],
      "followUpInstructions": "",
      "documents": []
    },
    {
      "id": 4,
      "doctorName": "Dr. James Wilson",
      "specialization": "Orthopedics",
      "date": DateTime.now().subtract(const Duration(days: 30)),
      "visitType": "Post-Surgery Follow-up",
      "status": "completed",
      "diagnosis":
          "Excellent recovery progress from knee arthroscopy. Range of motion improving as expected. No signs of infection or complications.",
      "medications": [
        {
          "name": "Celecoxib",
          "dosage": "200mg",
          "duration": "14 days",
          "instructions": "Take once daily with food for inflammation"
        }
      ],
      "followUpInstructions":
          "Continue physical therapy sessions 3 times per week. Gradually increase activity level. Avoid high-impact activities for another 4 weeks.",
      "documents": [
        {
          "fileName": "X-Ray_Post_Surgery.jpg",
          "fileType": "jpg",
          "fileSize": 3.1 * 1024 * 1024,
          "uploadDate": DateTime.now().subtract(const Duration(days: 30)),
          "isSecure": true
        },
        {
          "fileName": "Physical_Therapy_Plan.pdf",
          "fileType": "pdf",
          "fileSize": 1.2 * 1024 * 1024,
          "uploadDate": DateTime.now().subtract(const Duration(days: 30)),
          "isSecure": true
        }
      ]
    }
  ];

  List<Map<String, dynamic>> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredAppointments = List.from(_appointmentHistory);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterAppointments() {
    setState(() {
      _filteredAppointments = _appointmentHistory.where((appointment) {
        final matchesSearch = _searchQuery.isEmpty ||
            (appointment['doctorName'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (appointment['specialization'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (appointment['diagnosis'] as String? ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesFilter = _selectedFilter == 'All' ||
            (appointment['specialization'] as String) == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medical records updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentDetailsWidget(
        appointment: appointment,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showDateRangeFilter() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    ).then((dateRange) {
      if (dateRange != null) {
        // Filter appointments by date range
        setState(() {
          _filteredAppointments = _appointmentHistory.where((appointment) {
            final appointmentDate = appointment['date'] as DateTime;
            return appointmentDate.isAfter(
                    dateRange.start.subtract(const Duration(days: 1))) &&
                appointmentDate
                    .isBefore(dateRange.end.add(const Duration(days: 1)));
          }).toList();
        });
      }
    });
  }

  void _exportRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Medical Records'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select export format:'),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.errorLight,
                size: 6.w,
              ),
              title: Text('PDF Report'),
              subtitle: Text('Comprehensive medical history'),
              onTap: () {
                Navigator.pop(context);
                _generatePDFReport();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: Text('CSV Data'),
              subtitle: Text('Structured appointment data'),
              onTap: () {
                Navigator.pop(context);
                _generateCSVReport();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _generatePDFReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating PDF report...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        action: SnackBarAction(
          label: 'View',
          textColor: AppTheme.lightTheme.colorScheme.onPrimary,
          onPressed: () {
            // Open PDF viewer
          },
        ),
      ),
    );
  }

  void _generateCSVReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV report downloaded'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Medical Records',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/user-profile-and-settings'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text('History'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'folder',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text('Documents'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'family_restroom',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text('Family'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter header
          SearchFilterHeaderWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _filterAppointments();
            },
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              _filterAppointments();
            },
            onDateRangeFilter: _showDateRangeFilter,
            onExportRecords: _exportRecords,
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Appointment History Tab
                _buildAppointmentHistoryTab(),

                // Documents Tab
                _buildDocumentsTab(),

                // Family Tab
                _buildFamilyTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/appointment-booking'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 5.w,
        ),
        label: Text(
          'Book Appointment',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentHistoryTab() {
    if (_filteredAppointments.isEmpty && _appointmentHistory.isEmpty) {
      return EmptyStateWidget(
        onBookAppointment: () =>
            Navigator.pushNamed(context, '/appointment-booking'),
      );
    }

    if (_filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No appointments found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: _filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _filteredAppointments[index];
          return AppointmentCardWidget(
            appointment: appointment,
            onViewDetails: () => _showAppointmentDetails(appointment),
            onScheduleFollowup: () =>
                Navigator.pushNamed(context, '/appointment-booking'),
            onContactOffice: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Calling ${appointment['doctorName']}\'s office...'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final allDocuments = _appointmentHistory
        .expand((appointment) => appointment['documents'] as List)
        .cast<Map<String, dynamic>>()
        .toList();

    if (allDocuments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'folder_open',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No documents available',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Medical documents will appear here after appointments',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: allDocuments.length,
      itemBuilder: (context, index) {
        final document = allDocuments[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'insert_drive_file',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document['fileName'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${(document['fileType'] as String).toUpperCase()} • ${((document['fileSize'] as double) / (1024 * 1024)).toStringAsFixed(1)} MB',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFamilyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'family_restroom',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Family Management',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add family members to manage their medical records',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Family management feature coming soon'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Add Family Member'),
          ),
        ],
      ),
    );
  }
}
