import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models/onboarding_model.dart';
import '../../core/services/user_service.dart';
import '../../core/models/body_log.dart';
import '../../services/data_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../core/errors/exceptions.dart';

/// Screen for collecting user's personal information during onboarding process.
/// This is the third step in the onboarding flow where users provide details
/// such as sex, date of birth, age, height, weight, and target weight.
class OnboardingStep3AboutScreen extends StatefulWidget {
  
  const OnboardingStep3AboutScreen({super.key, this.initialData});
  /// Initial onboarding data passed from previous steps
  final OnboardingData? initialData;

  @override
  State<OnboardingStep3AboutScreen> createState() => _OnboardingStep3AboutScreenState();
}

class _OnboardingStep3AboutScreenState extends State<OnboardingStep3AboutScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for form fields
  final _sexController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  // Selected values for dropdown/date picker fields
  String? _selectedSex;
  DateTime? _selectedDate;
  
  // Loading state for API calls
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing data if available
    if (widget.initialData != null) {
      _selectedSex = widget.initialData!.sex;
      _selectedDate = widget.initialData!.dateOfBirth;
      
      if (_selectedSex != null) {
        _sexController.text = _selectedSex == 'male' ? 'Male' : _selectedSex == 'female' ? 'Female' : '';
      }
      
      if (_selectedDate != null) {
        _dateOfBirthController.text = '${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}';
      }
      
      if (widget.initialData!.age != null) {
        _ageController.text = widget.initialData!.age.toString();
      }
      
      if (widget.initialData!.height != null) {
        _heightController.text = widget.initialData!.height.toString();
      }
      
      if (widget.initialData!.weight != null) {
        _weightController.text = widget.initialData!.weight.toString();
      }
      
      if (widget.initialData!.targetWeight != null) {
        _targetWeightController.text = widget.initialData!.targetWeight.toString();
      }
    }
  }

  @override
  void dispose() {
    // Dispose text controllers to prevent memory leaks
    _sexController.dispose();
    _dateOfBirthController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  /// Opens date picker to select date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
        
        // Calculate age based on selected date
        final age = DateTime.now().year - picked.year;
        if (DateTime.now().month < picked.month || 
            (DateTime.now().month == picked.month && DateTime.now().day < picked.day)) {
          _ageController.text = (age - 1).toString();
        } else {
          _ageController.text = age.toString();
        }
      });
    }
  }

  /// Shows bottom sheet for selecting sex (Male/Female)
  void _showSexPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedSex = 'male';
                  _sexController.text = 'Male';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Female', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedSex = 'female';
                  _sexController.text = 'Female';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Handles form submission and validation
  void _handleConfirm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your sex'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = OnboardingData(
      goal: widget.initialData?.goal,
      activityLevel: widget.initialData?.activityLevel,
      sex: _selectedSex,
      dateOfBirth: _selectedDate,
      age: _ageController.text.isNotEmpty ? int.tryParse(_ageController.text) : null,
      height: _heightController.text.isNotEmpty ? double.tryParse(_heightController.text) : null,
      weight: _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
      targetWeight: _targetWeightController.text.isNotEmpty ? double.tryParse(_targetWeightController.text) : null,
      objective: '0.5', // Default objective
    );

    _saveAndNavigate(data);
  }

  /// Saves onboarding data to backend and navigates to home screen
  Future<void> _saveAndNavigate(OnboardingData data) async {
    setState(() => _isLoading = true);
    
    try {
      // Persist onboarding data using the real UserService
      final userService = context.read<UserService>();
      await userService.updateOnboarding(
        goal: data.goal,
        activityLevel: data.activityLevel,
        sex: data.sex,
        dateOfBirth: data.dateOfBirth?.toIso8601String(),
        age: data.age,
        height: data.height,
        weight: data.weight,
        targetWeight: data.targetWeight,
        objective: data.objective,
      );

      // Save initial weight log to appear in Analysis screen
      if (data.weight != null) {
        final dataService = DataService();
        await dataService.saveBodyLog(BodyLog(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          weight: data.weight!,
        ));
      }

      if (mounted) {
        context.go('/home', extra: data);
      }
    } catch (e) {
      if (mounted) {
        if (e is AuthorizationException || e.toString().contains('Not authenticated')) {
           context.go('/login');
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Session expired. Please log in again.')),
           );
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Error saving profile: $e')),
           );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/unsplash_NXMZxygMw8o.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .5),
          ),
          child: Column(
            children: [
              // Screen title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                child: Text(
                  'About yourself',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Form section with scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Sex field (read-only with dropdown)
                        CustomTextField(
                          controller: _sexController,
                          label: 'Sex',
                          hint: 'Select sex',
                          readOnly: true,
                          onTap: _showSexPicker,
                          suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD5FF5F)),
                          validator: (value) {
                            if (_selectedSex == null) {
                              return 'Please select your sex';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Date of birth field (read-only with date picker)
                        CustomTextField(
                          controller: _dateOfBirthController,
                          label: 'Date of birth',
                          hint: 'Select date',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (_selectedDate == null) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Age field (read-only, calculated from date of birth)
                        CustomTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: '',
                          keyboardType: TextInputType.number,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        
                        // Height field with validation
                        CustomTextField(
                          controller: _heightController,
                          label: 'Length in centimeters',
                          hint: 'Enter height',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            if (double.tryParse(value) == null) {
                              return 'The value must be entered in numbers.';
                            }
                            final height = double.tryParse(value);
                            if (height == null) {
                              return 'The value must be entered in numbers.';
                            }
                            if (height <= 100) {
                              return 'Height must be greater than 100';
                            }
                            if (height > 250) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Weight field with validation
                        CustomTextField(
                          controller: _weightController,
                          label: 'Weight in kilograms',
                          hint: 'Enter weight',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null) {
                              return 'The value must be entered in numbers.';
                            }
                            if (weight <= 50) {
                              return 'Weight must be greater than 50';
                            }
                            if (weight > 200) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Target Weight field with validation
                        CustomTextField(
                          controller: _targetWeightController,
                          label: 'Target Weight',
                          hint: 'Enter target weight (kg)',
                          prefixIcon: Icons.monitor_weight_outlined,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Target weight is required';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null) {
                              return 'Please enter a valid number';
                            }
                            if (weight <= 50) {
                              return 'Weight must be greater than 0';
                            }
                            if (weight > 200) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Confirm button with loading state
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5FF5F),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : const Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              
              // Progress indicator
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
