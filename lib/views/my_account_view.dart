import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'onboarding_view.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<MyAccountView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _dobCtrl;
  String? _selectedGender;

  static const List<String> _genders = ['male', 'female', 'other'];

  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _dobCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ProfileViewModel>();
      await vm.loadProfile();
      _populateFields();
    });
  }

  void _populateFields() {
    final p = context.read<ProfileViewModel>().profile;
    if (p == null) return;
    _nameCtrl.text = p.name;
    _emailCtrl.text = p.email;
    _phoneCtrl.text = p.phoneNumber ?? '';
    _dobCtrl.text = _formatDateForDisplay(p.dateOfBirth);
    setState(() {
      _selectedGender = _genders.contains(p.gender) ? p.gender : null;
      _isDirty = false;
    });
  }

  String _formatDateForDisplay(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  String _formatDateForApi(String display) {
    if (display.isEmpty) return '';
    try {
      // Accepts DD-MM-YYYY or YYYY-MM-DD
      final parts =
          display.contains('-') ? display.split('-') : display.split('/');
      if (parts.length == 3) {
        if (parts[0].length == 4) {
          // Already YYYY-MM-DD
          return DateTime.parse(display).toIso8601String();
        } else {
          // DD-MM-YYYY
          final dt = DateTime(
              int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          return dt.toIso8601String();
        }
      }
    } catch (_) {}
    return display;
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = () {
      try {
        if (_dobCtrl.text.isNotEmpty) {
          final parts = _dobCtrl.text.split('-');
          if (parts.length == 3 && parts[2].length == 4) {
            return DateTime(
                int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
          }
        }
      } catch (_) {}
      return DateTime(now.year - 20);
    }();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFCB8944),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      _markDirty();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<ProfileViewModel>();
    final success = await vm.updateProfile(
      fullName: _nameCtrl.text,
      email: _emailCtrl.text,
      phoneNumber: _phoneCtrl.text,
      dateOfBirth: _formatDateForApi(_dobCtrl.text),
      gender: _selectedGender ?? '',
    );

    if (!mounted) return;

    if (success) {
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated!',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFCB8944),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      // Refresh auth user so header also updates
      if (mounted) context.read<AuthViewModel>().refreshCurrentUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage ?? 'Update failed.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final avatarUrl = vm.profile?.avatar ?? authVm.currentUser?.avatar;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: const Color(0xFF363A33),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          'My Account',
          style: GoogleFonts.poppins(
            color: const Color(0xFF363A33),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_isDirty)
            TextButton(
              onPressed: vm.isLoading ? null : _save,
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFCB8944),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: 60),
        ],
      ),
      body: vm.isLoading && vm.profile == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFCB8944)),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ─── Avatar ───────────────────────────────────────────
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFFE8EBE6),
                                backgroundImage:
                                    avatarUrl != null && avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : const AssetImage(
                                                'assets/images/home_banner.png')
                                            as ImageProvider,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: image picker
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEFEFEE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 18,
                                      color: Color(0xFF363A33),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ─── Fields ───────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Full Name
                            _Field(
                              controller: _nameCtrl,
                              hint: 'Full name',
                              icon: Icons.person_outline,
                              onChanged: (_) => _markDirty(),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Name is required'
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            // Phone
                            _Field(
                              controller: _phoneCtrl,
                              hint: 'Phone number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              onChanged: (_) => _markDirty(),
                            ),

                            const SizedBox(height: 14),

                            // Date of Birth
                            GestureDetector(
                              onTap: _pickDate,
                              child: AbsorbPointer(
                                child: _Field(
                                  controller: _dobCtrl,
                                  hint: 'Date of birth (DD-MM-YYYY)',
                                  icon: Icons.calendar_today_outlined,
                                  onChanged: (_) => _markDirty(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Gender dropdown
                            _GenderDropdown(
                              value: _selectedGender,
                              onChanged: (v) {
                                setState(() => _selectedGender = v);
                                _markDirty();
                              },
                            ),

                            const SizedBox(height: 14),

                            // Email (read-only for now, often locked by backends)
                            _Field(
                              controller: _emailCtrl,
                              hint: 'Email address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => _markDirty(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ─── Save button (large, shown when dirty) ────────────
                      if (_isDirty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: vm.isLoading ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCB8944),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: vm.isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Save Changes',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // ─── Sign Out ──────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await context.read<AuthViewModel>().logout();
                              if (!context.mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingView(),
                                ),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.logout_rounded),
                            label: Text(
                              'Sign Out',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCB8944),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ─── Reusable field widget ───────────────────────────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: const Color(0xFF363A33),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: const Color(0xFFA0A39D),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(icon, color: const Color(0xFF91958E), size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCB8944), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
      ),
    );
  }
}

// ─── Gender dropdown ─────────────────────────────────────────────────────────

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: 'Gender',
        hintStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: const Color(0xFFA0A39D),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Icon(Icons.wc_outlined, color: Color(0xFF91958E), size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8EBE6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCB8944), width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'male', child: Text('Male')),
        DropdownMenuItem(value: 'female', child: Text('Female')),
        DropdownMenuItem(value: 'other', child: Text('Other')),
      ],
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF91958E)),
      dropdownColor: Colors.white,
      style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF363A33)),
    );
  }
}
