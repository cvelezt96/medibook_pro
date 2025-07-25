import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/family_member_widget.dart';
import './widgets/favorite_providers_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileAndSettings extends StatefulWidget {
  const UserProfileAndSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileAndSettings> createState() => _UserProfileAndSettingsState();
}

class _UserProfileAndSettingsState extends State<UserProfileAndSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 4; // Profile tab active

  // Mock user profile data
  final Map<String, dynamic> userProfile = {
    "name": "Sarah Johnson",
    "age": 32,
    "primaryCarePhysician": "Michael Chen",
    "profileImage":
        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "totalAppointments": 24,
    "totalPrescriptions": 18,
    "yearsWithUs": 3,
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "address": "123 Main St, New York, NY 10001",
    "dateOfBirth": "1992-03-15",
    "bloodType": "O+",
    "allergies": ["Penicillin", "Shellfish"],
    "insuranceProvider": "Blue Cross Blue Shield",
    "insuranceId": "BC123456789",
  };

  // Mock emergency contacts
  final List<Map<String, dynamic>> emergencyContacts = [
    {
      "name": "John Johnson",
      "relationship": "Spouse",
      "phone": "+1 (555) 987-6543",
      "isPrimary": true,
    },
    {
      "name": "Mary Johnson",
      "relationship": "Mother",
      "phone": "+1 (555) 456-7890",
      "isPrimary": false,
    },
  ];

  // Mock family members
  final List<Map<String, dynamic>> familyMembers = [
    {
      "name": "Emma Johnson",
      "relationship": "Daughter",
      "age": 8,
      "profileImage":
          "https://images.pexels.com/photos/1462637/pexels-photo-1462637.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "hasInsurance": true,
    },
    {
      "name": "Alex Johnson",
      "relationship": "Son",
      "age": 12,
      "profileImage":
          "https://images.pexels.com/photos/1416736/pexels-photo-1416736.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "hasInsurance": true,
    },
  ];

  // Mock favorite doctors
  final List<Map<String, dynamic>> favoriteDoctors = [
    {
      "name": "Michael Chen",
      "specialization": "Family Medicine",
      "rating": 4.8,
      "location": "Downtown Medical Center",
      "profileImage":
          "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "name": "Lisa Rodriguez",
      "specialization": "Pediatrics",
      "rating": 4.9,
      "location": "Children's Health Clinic",
      "profileImage":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  // Mock favorite pharmacies
  final List<Map<String, dynamic>> favoritePharmacies = [
    {
      "name": "HealthPlus Pharmacy",
      "rating": 4.7,
      "location": "Main Street",
      "isOpen": true,
      "distance": "0.5 miles",
    },
    {
      "name": "MediCare Drugstore",
      "rating": 4.5,
      "location": "Oak Avenue",
      "isOpen": false,
      "distance": "1.2 miles",
    },
  ];

  // Settings state
  Map<String, bool> settingsState = {
    "appointmentReminders": true,
    "prescriptionRefills": true,
    "healthTips": false,
    "dataSharing": true,
    "healthKitIntegration": true,
    "thirdPartyApps": false,
    "biometricAuth": true,
    "twoFactorAuth": false,
    "pushNotifications": true,
    "emailNotifications": true,
    "smsNotifications": false,
  };

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile & Settings",
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 5.w,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userProfile: userProfile,
              onEditPressed: _editProfile,
            ),
            SizedBox(height: 3.h),

            // Personal Information Section
            SettingsSectionWidget(
              title: "Personal Information",
              items: _getPersonalInfoItems(),
              onItemTap: _handlePersonalInfoTap,
            ),

            // Emergency Contacts
            EmergencyContactWidget(
              emergencyContacts: emergencyContacts,
              onEditContact: _editEmergencyContact,
              onAddContact: _addEmergencyContact,
            ),

            // Family Members
            FamilyMemberWidget(
              familyMembers: familyMembers,
              onEditMember: _editFamilyMember,
              onAddMember: _addFamilyMember,
            ),

            // Health Preferences Section
            SettingsSectionWidget(
              title: "Health Preferences",
              items: _getHealthPreferencesItems(),
              onItemTap: _handleHealthPreferencesTap,
            ),

            // Privacy & Security Section
            SettingsSectionWidget(
              title: "Privacy & Security",
              items: _getPrivacySecurityItems(),
              onItemTap: _handlePrivacySecurityTap,
            ),

            // Favorite Providers
            FavoriteProvidersWidget(
              favoriteDoctors: favoriteDoctors,
              favoritePharmacies: favoritePharmacies,
              onRemoveFavorite: _removeFavoriteProvider,
            ),

            // App Preferences Section
            SettingsSectionWidget(
              title: "App Preferences",
              items: _getAppPreferencesItems(),
              onItemTap: _handleAppPreferencesTap,
            ),

            // Support & Legal Section
            SettingsSectionWidget(
              title: "Support & Legal",
              items: _getSupportLegalItems(),
              onItemTap: _handleSupportLegalTap,
            ),

            // Account Management Section
            SettingsSectionWidget(
              title: "Account Management",
              items: _getAccountManagementItems(),
              onItemTap: _handleAccountManagementTap,
            ),

            SizedBox(height: 10.h), // Bottom padding for navigation
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.textSecondaryLight,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 5.w,
            ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'medication',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 5.w,
            ),
            label: 'Medicine',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'upload_file',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 5.w,
            ),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'payment',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 5.w,
            ),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 5.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPersonalInfoItems() {
    return [
      {
        "key": "contact_info",
        "title": "Contact Information",
        "subtitle": "${userProfile["email"]}, ${userProfile["phone"]}",
        "icon": "contact_phone",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "key": "medical_info",
        "title": "Medical Information",
        "subtitle":
            "Blood type: ${userProfile["bloodType"]}, Allergies: ${(userProfile["allergies"] as List).join(", ")}",
        "icon": "medical_information",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "key": "insurance_info",
        "title": "Insurance Information",
        "subtitle":
            "${userProfile["insuranceProvider"]} - ${userProfile["insuranceId"]}",
        "icon": "verified_user",
        "iconColor": AppTheme.lightTheme.colorScheme.tertiary,
      },
    ];
  }

  List<Map<String, dynamic>> _getHealthPreferencesItems() {
    return [
      {
        "key": "appointmentReminders",
        "title": "Appointment Reminders",
        "subtitle": "Get notified about upcoming appointments",
        "icon": "notifications",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": settingsState["appointmentReminders"],
      },
      {
        "key": "prescriptionRefills",
        "title": "Prescription Refill Reminders",
        "subtitle": "Reminders when medications are running low",
        "icon": "medication",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
        "hasSwitch": true,
        "switchValue": settingsState["prescriptionRefills"],
      },
      {
        "key": "healthTips",
        "title": "Health Tips & Articles",
        "subtitle": "Receive personalized health content",
        "icon": "tips_and_updates",
        "iconColor": AppTheme.lightTheme.colorScheme.tertiary,
        "hasSwitch": true,
        "switchValue": settingsState["healthTips"],
      },
    ];
  }

  List<Map<String, dynamic>> _getPrivacySecurityItems() {
    return [
      {
        "key": "dataSharing",
        "title": "Data Sharing Permissions",
        "subtitle": "Control how your health data is shared",
        "icon": "share",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": settingsState["dataSharing"],
      },
      {
        "key": "healthKitIntegration",
        "title": "HealthKit Integration",
        "subtitle": "Sync with Apple Health / Google Fit",
        "icon": "health_and_safety",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
        "hasSwitch": true,
        "switchValue": settingsState["healthKitIntegration"],
      },
      {
        "key": "biometricAuth",
        "title": "Biometric Authentication",
        "subtitle": "Use fingerprint or face recognition",
        "icon": "fingerprint",
        "iconColor": AppTheme.lightTheme.colorScheme.tertiary,
        "hasSwitch": true,
        "switchValue": settingsState["biometricAuth"],
      },
      {
        "key": "twoFactorAuth",
        "title": "Two-Factor Authentication",
        "subtitle": "Add extra security to your account",
        "icon": "security",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
        "hasSwitch": true,
        "switchValue": settingsState["twoFactorAuth"],
        "badge": settingsState["twoFactorAuth"] == true ? null : "Recommended",
      },
      {
        "key": "change_password",
        "title": "Change Password",
        "subtitle": "Update your account password",
        "icon": "lock",
        "iconColor": AppTheme.lightTheme.colorScheme.error,
      },
    ];
  }

  List<Map<String, dynamic>> _getAppPreferencesItems() {
    return [
      {
        "key": "language",
        "title": "Language",
        "subtitle": "English (US)",
        "icon": "language",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "key": "units",
        "title": "Measurement Units",
        "subtitle": "Imperial (lbs, ft, °F)",
        "icon": "straighten",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "key": "accessibility",
        "title": "Accessibility Options",
        "subtitle": "Text size, contrast, voice commands",
        "icon": "accessibility",
        "iconColor": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "key": "notifications",
        "title": "Notification Settings",
        "subtitle": "Manage push, email, and SMS notifications",
        "icon": "notifications_active",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
    ];
  }

  List<Map<String, dynamic>> _getSupportLegalItems() {
    return [
      {
        "key": "help_center",
        "title": "Help Center",
        "subtitle": "FAQs, tutorials, and support articles",
        "icon": "help",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "key": "contact_support",
        "title": "Contact Support",
        "subtitle": "24/7 medical support available",
        "icon": "support_agent",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
        "badge": "24/7",
      },
      {
        "key": "hipaa_compliance",
        "title": "HIPAA Compliance",
        "subtitle": "Learn about our privacy practices",
        "icon": "verified_user",
        "iconColor": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "key": "terms_conditions",
        "title": "Terms & Conditions",
        "subtitle": "Review our terms of service",
        "icon": "description",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "key": "privacy_policy",
        "title": "Privacy Policy",
        "subtitle": "How we protect your health data",
        "icon": "privacy_tip",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
      },
    ];
  }

  List<Map<String, dynamic>> _getAccountManagementItems() {
    return [
      {
        "key": "download_data",
        "title": "Download My Data",
        "subtitle": "Export your health records (HIPAA compliant)",
        "icon": "download",
        "iconColor": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "key": "transfer_records",
        "title": "Transfer Medical Records",
        "subtitle": "Send records to another healthcare provider",
        "icon": "send",
        "iconColor": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "key": "delete_account",
        "title": "Delete Account",
        "subtitle": "Permanently delete your account and data",
        "icon": "delete_forever",
        "iconColor": AppTheme.lightTheme.colorScheme.error,
      },
    ];
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 1:
        Navigator.pushNamed(context, '/medicine-search-and-ordering');
        break;
      case 2:
        Navigator.pushNamed(context, '/prescription-upload-and-verification');
        break;
      case 3:
        Navigator.pushNamed(context, '/payment-processing');
        break;
      case 4:
        // Current screen - no navigation needed
        break;
    }
  }

  void _editProfile() {
    _showEditProfileDialog();
  }

  void _handlePersonalInfoTap(String key) {
    switch (key) {
      case "contact_info":
        _showEditContactInfoDialog();
        break;
      case "medical_info":
        _showEditMedicalInfoDialog();
        break;
      case "insurance_info":
        _showEditInsuranceInfoDialog();
        break;
    }
  }

  void _handleHealthPreferencesTap(String key) {
    setState(() {
      settingsState[key] = !(settingsState[key] ?? false);
    });
    _showSettingChangedSnackBar("Health preference updated");
  }

  void _handlePrivacySecurityTap(String key) {
    if (key == "change_password") {
      _showChangePasswordDialog();
    } else {
      setState(() {
        settingsState[key] = !(settingsState[key] ?? false);
      });
      _showSettingChangedSnackBar("Security setting updated");
    }
  }

  void _handleAppPreferencesTap(String key) {
    switch (key) {
      case "language":
        _showLanguageSelectionDialog();
        break;
      case "units":
        _showUnitsSelectionDialog();
        break;
      case "accessibility":
        _showAccessibilityOptionsDialog();
        break;
      case "notifications":
        _showNotificationSettingsDialog();
        break;
    }
  }

  void _handleSupportLegalTap(String key) {
    switch (key) {
      case "help_center":
        _showHelpCenter();
        break;
      case "contact_support":
        _showContactSupport();
        break;
      case "hipaa_compliance":
        _showHIPAAInfo();
        break;
      case "terms_conditions":
        _showTermsAndConditions();
        break;
      case "privacy_policy":
        _showPrivacyPolicy();
        break;
    }
  }

  void _handleAccountManagementTap(String key) {
    switch (key) {
      case "download_data":
        _downloadHealthData();
        break;
      case "transfer_records":
        _showTransferRecordsDialog();
        break;
      case "delete_account":
        _showDeleteAccountDialog();
        break;
    }
  }

  void _editEmergencyContact(int index) {
    _showEditEmergencyContactDialog(index);
  }

  void _addEmergencyContact() {
    _showAddEmergencyContactDialog();
  }

  void _editFamilyMember(int index) {
    _showEditFamilyMemberDialog(index);
  }

  void _addFamilyMember() {
    _showAddFamilyMemberDialog();
  }

  void _removeFavoriteProvider(String type, int index) {
    setState(() {
      if (type == "doctor") {
        favoriteDoctors.removeAt(index);
      } else {
        favoritePharmacies.removeAt(index);
      }
    });
    _showSettingChangedSnackBar("Removed from favorites");
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Logout",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to logout? You'll need to sign in again to access your health data.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    _showSettingChangedSnackBar("Logged out successfully");
    // Navigate to login screen or perform logout logic
  }

  void _showEditProfileDialog() {
    _showSettingChangedSnackBar("Profile editing feature coming soon");
  }

  void _showEditContactInfoDialog() {
    _showSettingChangedSnackBar("Contact info editing feature coming soon");
  }

  void _showEditMedicalInfoDialog() {
    _showSettingChangedSnackBar("Medical info editing feature coming soon");
  }

  void _showEditInsuranceInfoDialog() {
    _showSettingChangedSnackBar("Insurance info editing feature coming soon");
  }

  void _showChangePasswordDialog() {
    _showSettingChangedSnackBar("Password change feature coming soon");
  }

  void _showLanguageSelectionDialog() {
    _showSettingChangedSnackBar("Language selection feature coming soon");
  }

  void _showUnitsSelectionDialog() {
    _showSettingChangedSnackBar("Units selection feature coming soon");
  }

  void _showAccessibilityOptionsDialog() {
    _showSettingChangedSnackBar("Accessibility options feature coming soon");
  }

  void _showNotificationSettingsDialog() {
    _showSettingChangedSnackBar("Notification settings feature coming soon");
  }

  void _showHelpCenter() {
    _showSettingChangedSnackBar("Help center feature coming soon");
  }

  void _showContactSupport() {
    _showSettingChangedSnackBar("Contact support feature coming soon");
  }

  void _showHIPAAInfo() {
    _showSettingChangedSnackBar("HIPAA compliance info feature coming soon");
  }

  void _showTermsAndConditions() {
    _showSettingChangedSnackBar("Terms & conditions feature coming soon");
  }

  void _showPrivacyPolicy() {
    _showSettingChangedSnackBar("Privacy policy feature coming soon");
  }

  void _downloadHealthData() {
    _showSettingChangedSnackBar("Health data download started");
  }

  void _showTransferRecordsDialog() {
    _showSettingChangedSnackBar("Record transfer feature coming soon");
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Account",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Text(
          "This action cannot be undone. All your health data, appointments, and medical records will be permanently deleted. Are you sure you want to continue?",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSettingChangedSnackBar(
                  "Account deletion feature coming soon");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Delete Account"),
          ),
        ],
      ),
    );
  }

  void _showEditEmergencyContactDialog(int index) {
    _showSettingChangedSnackBar(
        "Emergency contact editing feature coming soon");
  }

  void _showAddEmergencyContactDialog() {
    _showSettingChangedSnackBar("Add emergency contact feature coming soon");
  }

  void _showEditFamilyMemberDialog(int index) {
    _showSettingChangedSnackBar("Family member editing feature coming soon");
  }

  void _showAddFamilyMemberDialog() {
    _showSettingChangedSnackBar("Add family member feature coming soon");
  }

  void _showSettingChangedSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
