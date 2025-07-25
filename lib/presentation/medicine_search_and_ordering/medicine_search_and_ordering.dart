import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_badge_widget.dart';
import './widgets/medicine_card_widget.dart';
import './widgets/medicine_filter_widget.dart';
import './widgets/medicine_search_bar_widget.dart';
import './widgets/pharmacy_selector_widget.dart';
import './widgets/quick_view_modal_widget.dart';

class MedicineSearchAndOrdering extends StatefulWidget {
  const MedicineSearchAndOrdering({Key? key}) : super(key: key);

  @override
  State<MedicineSearchAndOrdering> createState() =>
      _MedicineSearchAndOrderingState();
}

class _MedicineSearchAndOrderingState extends State<MedicineSearchAndOrdering>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Search and filter state
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};
  bool _isLoading = false;
  bool _isSearching = false;

  // Cart state
  int _cartItemCount = 0;

  // Pharmacy state
  Map<String, dynamic>? _selectedPharmacy;

  // Camera state
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // Bottom navigation
  late TabController _tabController;
  int _currentTabIndex = 1; // Medicine search tab

  // Mock data
  final List<Map<String, dynamic>> _medicines = [
    {
      "id": 1,
      "name": "Paracetamol 500mg",
      "genericName": "Acetaminophen",
      "manufacturer": "PharmaCorp Ltd.",
      "dosage": "500mg Tablets",
      "price": "\$12.99",
      "image":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&h=400&fit=crop",
      "prescriptionRequired": false,
      "isAvailable": true,
      "availability": "In Stock",
      "pharmacyCount": 8,
      "description":
          "Paracetamol is a pain reliever and fever reducer used to treat mild to moderate pain and reduce fever.",
      "dosageInstructions":
          "Take 1-2 tablets every 4-6 hours as needed. Do not exceed 8 tablets in 24 hours.",
      "sideEffects":
          "Rare side effects may include nausea, stomach pain, or allergic reactions.",
      "warnings":
          "Do not exceed recommended dose. Consult doctor if symptoms persist.",
      "pharmacyAvailability": [
        {
          "name": "HealthPlus Pharmacy",
          "distance": "0.5 miles",
          "status": "In Stock"
        },
        {
          "name": "MediCare Center",
          "distance": "1.2 miles",
          "status": "In Stock"
        },
        {
          "name": "City Pharmacy",
          "distance": "2.1 miles",
          "status": "Low Stock"
        },
      ]
    },
    {
      "id": 2,
      "name": "Amoxicillin 250mg",
      "genericName": "Amoxicillin",
      "manufacturer": "BioMed Solutions",
      "dosage": "250mg Capsules",
      "price": "\$24.50",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=400&fit=crop",
      "prescriptionRequired": true,
      "isAvailable": true,
      "availability": "In Stock",
      "pharmacyCount": 6,
      "description":
          "Amoxicillin is an antibiotic used to treat bacterial infections including pneumonia, bronchitis, and infections of the ear, nose, throat, skin, and urinary tract.",
      "dosageInstructions":
          "Take one capsule three times daily for 7-10 days or as prescribed by your doctor.",
      "sideEffects":
          "Common side effects include nausea, vomiting, diarrhea, and stomach pain.",
      "warnings":
          "Complete the full course even if you feel better. Do not use if allergic to penicillin.",
      "pharmacyAvailability": [
        {
          "name": "HealthPlus Pharmacy",
          "distance": "0.5 miles",
          "status": "In Stock"
        },
        {
          "name": "MediCare Center",
          "distance": "1.2 miles",
          "status": "In Stock"
        },
      ]
    },
    {
      "id": 3,
      "name": "Vitamin D3 1000 IU",
      "genericName": "Cholecalciferol",
      "manufacturer": "NutriHealth Inc.",
      "dosage": "1000 IU Softgels",
      "price": "\$18.75",
      "image":
          "https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400&h=400&fit=crop",
      "prescriptionRequired": false,
      "isAvailable": true,
      "availability": "In Stock",
      "pharmacyCount": 12,
      "description":
          "Vitamin D3 supplement helps maintain healthy bones, teeth, and immune system function.",
      "dosageInstructions":
          "Take one softgel daily with food or as directed by your healthcare provider.",
      "sideEffects":
          "Generally well tolerated. Excessive doses may cause nausea, vomiting, or kidney problems.",
      "pharmacyAvailability": [
        {
          "name": "HealthPlus Pharmacy",
          "distance": "0.5 miles",
          "status": "In Stock"
        },
        {
          "name": "MediCare Center",
          "distance": "1.2 miles",
          "status": "In Stock"
        },
        {
          "name": "City Pharmacy",
          "distance": "2.1 miles",
          "status": "In Stock"
        },
      ]
    },
    {
      "id": 4,
      "name": "Ibuprofen 400mg",
      "genericName": "Ibuprofen",
      "manufacturer": "PainRelief Corp",
      "dosage": "400mg Tablets",
      "price": "\$15.25",
      "image":
          "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400&h=400&fit=crop",
      "prescriptionRequired": false,
      "isAvailable": false,
      "availability": "Out of Stock",
      "pharmacyCount": 3,
      "description":
          "Ibuprofen is a nonsteroidal anti-inflammatory drug (NSAID) used to reduce fever and treat pain or inflammation.",
      "dosageInstructions":
          "Take 1 tablet every 6-8 hours as needed. Do not exceed 3 tablets in 24 hours.",
      "sideEffects":
          "May cause stomach upset, heartburn, dizziness, or drowsiness.",
      "warnings":
          "Take with food to reduce stomach irritation. Avoid alcohol while taking this medication.",
      "pharmacyAvailability": [
        {
          "name": "City Pharmacy",
          "distance": "2.1 miles",
          "status": "Out of Stock"
        },
        {
          "name": "Corner Drugstore",
          "distance": "3.5 miles",
          "status": "Low Stock"
        },
      ]
    },
    {
      "id": 5,
      "name": "Metformin 500mg",
      "genericName": "Metformin Hydrochloride",
      "manufacturer": "DiabetesCare Ltd.",
      "dosage": "500mg Extended Release",
      "price": "\$32.80",
      "image":
          "https://images.unsplash.com/photo-1576671081837-49000212a370?w=400&h=400&fit=crop",
      "prescriptionRequired": true,
      "isAvailable": true,
      "availability": "In Stock",
      "pharmacyCount": 9,
      "description":
          "Metformin is used to treat type 2 diabetes by helping to control blood sugar levels.",
      "dosageInstructions":
          "Take with meals as prescribed by your doctor, usually twice daily.",
      "sideEffects":
          "Common side effects include nausea, diarrhea, stomach upset, and metallic taste.",
      "warnings":
          "Monitor blood sugar regularly. Inform doctor of kidney problems or excessive alcohol use.",
      "pharmacyAvailability": [
        {
          "name": "HealthPlus Pharmacy",
          "distance": "0.5 miles",
          "status": "In Stock"
        },
        {
          "name": "MediCare Center",
          "distance": "1.2 miles",
          "status": "In Stock"
        },
        {
          "name": "Diabetes Specialty Pharmacy",
          "distance": "1.8 miles",
          "status": "In Stock"
        },
      ]
    },
  ];

  final List<Map<String, dynamic>> _pharmacies = [
    {
      "id": 1,
      "name": "HealthPlus Pharmacy",
      "address": "123 Main Street, Downtown",
      "distance": "0.5 miles",
      "deliveryTime": "30-45 min",
      "inventoryStatus": "In Stock",
    },
    {
      "id": 2,
      "name": "MediCare Center",
      "address": "456 Oak Avenue, Midtown",
      "distance": "1.2 miles",
      "deliveryTime": "45-60 min",
      "inventoryStatus": "In Stock",
    },
    {
      "id": 3,
      "name": "City Pharmacy",
      "address": "789 Pine Road, Uptown",
      "distance": "2.1 miles",
      "deliveryTime": "60-75 min",
      "inventoryStatus": "Low Stock",
    },
    {
      "id": 4,
      "name": "Corner Drugstore",
      "address": "321 Elm Street, Westside",
      "distance": "3.5 miles",
      "deliveryTime": "75-90 min",
      "inventoryStatus": "In Stock",
    },
  ];

  List<Map<String, dynamic>> _filteredMedicines = [];
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this, initialIndex: _currentTabIndex);
    _filteredMedicines = List.from(_medicines);
    _selectedPharmacy = _pharmacies.first;
    _initializeCamera();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb && await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras.first,
          );

          _cameraController = CameraController(
            camera,
            ResolutionPreset.high,
          );

          await _cameraController!.initialize();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    }

    _filterMedicines();
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _filters = filters;
    });
    _filterMedicines();
  }

  void _filterMedicines() {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _filteredMedicines = _medicines.where((medicine) {
            // Search query filter
            if (_searchQuery.isNotEmpty) {
              final name = (medicine['name'] as String).toLowerCase();
              final genericName =
                  (medicine['genericName'] as String).toLowerCase();
              final query = _searchQuery.toLowerCase();

              if (!name.contains(query) && !genericName.contains(query)) {
                return false;
              }
            }

            // Type filter
            if (_filters['type'] != null) {
              final isPrescription = medicine['prescriptionRequired'] as bool;
              if (_filters['type'] == 'prescription' && !isPrescription)
                return false;
              if (_filters['type'] == 'otc' && isPrescription) return false;
            }

            // Category filter
            final categories = _filters['categories'] as List<String>?;
            if (categories != null && categories.isNotEmpty) {
              // For demo purposes, we'll match based on medicine name keywords
              final medicineName = (medicine['name'] as String).toLowerCase();
              bool matchesCategory = false;
              for (final category in categories) {
                if (category.toLowerCase().contains('pain') &&
                    (medicineName.contains('paracetamol') ||
                        medicineName.contains('ibuprofen'))) {
                  matchesCategory = true;
                  break;
                }
                if (category.toLowerCase().contains('antibiotic') &&
                    medicineName.contains('amoxicillin')) {
                  matchesCategory = true;
                  break;
                }
                if (category.toLowerCase().contains('vitamin') &&
                    medicineName.contains('vitamin')) {
                  matchesCategory = true;
                  break;
                }
              }
              if (!matchesCategory) return false;
            }

            // Price range filter
            if (_filters['minPrice'] != null || _filters['maxPrice'] != null) {
              final priceStr = medicine['price'] as String;
              final price = double.tryParse(priceStr.replaceAll('\$', '')) ?? 0;
              final minPrice = _filters['minPrice'] ?? 0;
              final maxPrice = _filters['maxPrice'] ?? 1000;

              if (price < minPrice || price > maxPrice) return false;
            }

            return true;
          }).toList();

          _isLoading = false;
        });
      }
    });
  }

  void _onBarcodePressed() async {
    if (_isCameraInitialized && _cameraController != null) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
        // In a real app, this would open a barcode scanner
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barcode scanner opened'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera not available'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera not available'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MedicineFilterWidget(
        currentFilters: _filters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _onAddToCart(Map<String, dynamic> medicine) {
    setState(() {
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine['name']} added to cart'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _onUploadPrescription(Map<String, dynamic> medicine) async {
    if (_isCameraInitialized && _cameraController != null) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription uploaded for ${medicine['name']}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture prescription'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } else {
      // Fallback for web or when camera is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription upload feature not available'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _onAddToWishlist(Map<String, dynamic> medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine['name']} added to wishlist'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _onSetReminder(Map<String, dynamic> medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${medicine['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onQuickView(Map<String, dynamic> medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickViewModalWidget(
        medicine: medicine,
        onAddToCart: () {
          Navigator.pop(context);
          _onAddToCart(medicine);
        },
        onUploadPrescription: () {
          Navigator.pop(context);
          _onUploadPrescription(medicine);
        },
      ),
    );
  }

  void _onCartPressed() {
    // Navigate to cart screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart has $_cartItemCount items'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onPharmacySelected(Map<String, dynamic> pharmacy) {
    setState(() {
      _selectedPharmacy = pharmacy;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    // Navigate to different screens based on tab
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 1:
        // Current screen - Medicine Search
        break;
      case 2:
        Navigator.pushNamed(context, '/prescription-upload-and-verification');
        break;
      case 3:
        Navigator.pushNamed(context, '/payment-processing');
        break;
      case 4:
        Navigator.pushNamed(
            context, '/appointment-history-and-medical-records');
        break;
      case 5:
        Navigator.pushNamed(context, '/user-profile-and-settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Medicine Search',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CartBadgeWidget(
            itemCount: _cartItemCount,
            onPressed: _onCartPressed,
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          MedicineSearchBarWidget(
            onSearchChanged: _onSearchChanged,
            onBarcodePressed: _onBarcodePressed,
            onFilterPressed: _onFilterPressed,
          ),

          // Pharmacy Selector
          PharmacySelectorWidget(
            pharmacies: _pharmacies,
            selectedPharmacy: _selectedPharmacy,
            onPharmacySelected: _onPharmacySelected,
          ),

          // Medicine List
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Searching Pharmacies...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : _filteredMedicines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search_off',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 15.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No medicines found',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try adjusting your search or filters',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _filters.clear();
                                  _filteredMedicines = List.from(_medicines);
                                });
                              },
                              child: Text('Clear Filters'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(bottom: 2.h),
                        itemCount: _filteredMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = _filteredMedicines[index];
                          return MedicineCardWidget(
                            medicine: medicine,
                            onAddToCart: () => _onAddToCart(medicine),
                            onUploadPrescription: () =>
                                _onUploadPrescription(medicine),
                            onAddToWishlist: () => _onAddToWishlist(medicine),
                            onSetReminder: () => _onSetReminder(medicine),
                            onQuickView: () => _onQuickView(medicine),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _currentTabIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'local_pharmacy',
              color: _currentTabIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'upload_file',
              color: _currentTabIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'payment',
              color: _currentTabIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _currentTabIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentTabIndex == 5
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
