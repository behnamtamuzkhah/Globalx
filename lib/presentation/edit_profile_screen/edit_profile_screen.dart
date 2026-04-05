import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _idNumberCtrl = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _nationality;
  String? _country;
  String? _idType;

  static const List<String> _genders = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];
  static const List<String> _idTypes = [
    'Passport',
    'National ID',
    'Driver\'s License',
    'Residence Permit',
  ];
  static const List<String> _countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Spain',
    'Italy',
    'Netherlands',
    'Sweden',
    'Norway',
    'Denmark',
    'Switzerland',
    'Austria',
    'Belgium',
    'Portugal',
    'Ireland',
    'Finland',
    'New Zealand',
    'Singapore',
    'Japan',
    'South Korea',
    'India',
    'Brazil',
    'Mexico',
    'Argentina',
    'South Africa',
    'Nigeria',
    'Kenya',
    'Ghana',
    'United Arab Emirates',
    'Saudi Arabia',
    'Qatar',
    'Kuwait',
    'Bahrain',
    'Philippines',
    'Indonesia',
    'Malaysia',
    'Thailand',
    'Vietnam',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameCtrl.text = prefs.getString('profile_first_name') ?? 'Marco';
      _lastNameCtrl.text = prefs.getString('profile_last_name') ?? 'Reyes';
      _emailCtrl.text =
          prefs.getString('profile_email') ?? 'marco.reyes@gmail.com';
      _phoneCtrl.text = prefs.getString('profile_phone') ?? '';
      _streetCtrl.text = prefs.getString('profile_street') ?? '';
      _cityCtrl.text = prefs.getString('profile_city') ?? '';
      _stateCtrl.text = prefs.getString('profile_state') ?? '';
      _postalCtrl.text = prefs.getString('profile_postal') ?? '';
      _idNumberCtrl.text = prefs.getString('profile_id_number') ?? '';
      _gender = prefs.getString('profile_gender');
      _nationality = prefs.getString('profile_nationality');
      _country = prefs.getString('profile_country') ?? 'United States';
      _idType = prefs.getString('profile_id_type');
      final dobMs = prefs.getInt('profile_dob');
      if (dobMs != null) {
        _dob = DateTime.fromMillisecondsSinceEpoch(dobMs);
      }
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_first_name', _firstNameCtrl.text.trim());
    await prefs.setString('profile_last_name', _lastNameCtrl.text.trim());
    await prefs.setString('profile_email', _emailCtrl.text.trim());
    await prefs.setString('profile_phone', _phoneCtrl.text.trim());
    await prefs.setString('profile_street', _streetCtrl.text.trim());
    await prefs.setString('profile_city', _cityCtrl.text.trim());
    await prefs.setString('profile_state', _stateCtrl.text.trim());
    await prefs.setString('profile_postal', _postalCtrl.text.trim());
    await prefs.setString('profile_id_number', _idNumberCtrl.text.trim());
    if (_gender != null) await prefs.setString('profile_gender', _gender!);
    if (_nationality != null)
      await prefs.setString('profile_nationality', _nationality!);
    if (_country != null) await prefs.setString('profile_country', _country!);
    if (_idType != null) await prefs.setString('profile_id_type', _idType!);
    if (_dob != null)
      await prefs.setInt('profile_dob', _dob!.millisecondsSinceEpoch);
    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            surface: AppTheme.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCtrl.dispose();
    _idNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppTheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: theme.textTheme.titleMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primary,
                      ),
                    )
                  : Text(
                      'Save',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _SectionHeader(title: 'Personal Information'),
            const SizedBox(height: 12),
            _buildCard([
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameCtrl,
                      label: 'First Name',
                      hint: 'Marco',
                      required: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameCtrl,
                      label: 'Last Name',
                      hint: 'Reyes',
                      required: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailCtrl,
                label: 'Email Address',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                required: true,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final emailReg = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.\w{2,}$');
                  if (!emailReg.hasMatch(v.trim()))
                    return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                hint: '+1 555 000 0000',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\+\-\s\(\)]')),
                ],
              ),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Gender',
                value: _gender,
                items: _genders,
                onChanged: (v) => setState(() => _gender = v),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Nationality',
                value: _nationality,
                items: _countries,
                hint: 'Select nationality',
                onChanged: (v) => setState(() => _nationality = v),
              ),
            ]),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Residential Address'),
            const SizedBox(height: 12),
            _buildCard([
              _buildTextField(
                controller: _streetCtrl,
                label: 'Street Address',
                hint: '123 Main Street, Apt 4B',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityCtrl,
                      label: 'City',
                      hint: 'New York',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _stateCtrl,
                      label: 'State / Province',
                      hint: 'NY',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _postalCtrl,
                      label: 'Postal Code',
                      hint: '10001',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Country',
                      value: _country,
                      items: _countries,
                      hint: 'Select country',
                      onChanged: (v) => setState(() => _country = v),
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Identity Verification (KYC)'),
            const SizedBox(height: 12),
            _buildCard([
              _buildDropdown(
                label: 'ID Type',
                value: _idType,
                items: _idTypes,
                hint: 'Select ID type',
                onChanged: (v) => setState(() => _idType = v),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _idNumberCtrl,
                label: 'ID Number',
                hint: 'e.g. A12345678',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 13,
                    color: AppTheme.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Your ID information is encrypted and used only for KYC verification.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppTheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppTheme.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
            ),
            filled: true,
            fillColor: AppTheme.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
            ),
          ),
          validator:
              validator ??
              (required
                  ? (v) => (v == null || v.trim().isEmpty)
                        ? '$label is required'
                        : null
                  : null),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final theme = Theme.of(context);
    final dobText = _dob != null
        ? '${_dob!.day.toString().padLeft(2, '0')}/${_dob!.month.toString().padLeft(2, '0')}/${_dob!.year}'
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppTheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickDob,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dobText ?? 'DD/MM/YYYY',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: dobText != null
                          ? AppTheme.onSurface
                          : AppTheme.muted,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppTheme.muted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    String? hint,
    required void Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppTheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint ?? 'Select $label',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.surfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppTheme.muted,
        letterSpacing: 0.8,
      ),
    );
  }
}

// Expose getter for other widgets to read saved profile data
class ProfileData {
  static Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('profile_first_name') ?? 'Marco',
      'lastName': prefs.getString('profile_last_name') ?? 'Reyes',
      'email': prefs.getString('profile_email') ?? 'marco.reyes@gmail.com',
      'country': prefs.getString('profile_country') ?? 'United States',
    };
  }
}
