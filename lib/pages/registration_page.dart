import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_minor/pages/otp_login_page.dart';
import 'package:new_minor/read_sms.dart';
import '../controllers/email_register_controller.dart';
import '../controllers/register_user.dart';
import '../models/user.dart' as api_user;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emailOtpController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  final mobileOtpController = TextEditingController();

  String selectedBank = '';
  bool isLoading = false;
  bool isPasswordVisible = false;

  bool isEmailOtpSent = false;
  bool isEmailOtpVerified = false;
  bool isVerifyingEmailOtp = false;

  bool isMobileOtpSent = false;
  bool isMobileOtpVerified = false;
  bool isVerifyingMobileOtp = false;
  String? verificationId;

  Future<bool> sendEmailOtp(String email) async {
    try {
      return await EmailOtpService.sendOtpToEmail(email);
    } catch (e) {
      print(e);
      _showSnackBar("Error sending OTP: $e");
      return false;
    }
  }

  Future<bool> verifyEmailOtp(String email, String otp) async {
    try {
      return await EmailOtpService.verifyEmailOtp(email, otp);
    } catch (e) {
      print(e);
      _showSnackBar("Error verifying OTP: $e");
      return false;
    }
  }

  void handleSendEmailOtp() async {
    if (emailController.text.isEmpty) {
      _showSnackBar("Please enter an email first");
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      _showSnackBar("Please enter a valid email");
      return;
    }

    setState(() => isLoading = true);
    try {
      bool sent = await sendEmailOtp(emailController.text.trim());
      if (sent) {
        setState(() {
          isEmailOtpSent = true;
          isEmailOtpVerified = false;
        });
        _showSnackBar("OTP sent to your email");
      } else {
        _showSnackBar("Failed to send OTP");
      }
    } catch (e) {
      print('failed in console: ${e}');
      _showSnackBar("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void handleVerifyEmailOtp() async {
    if (emailOtpController.text.isEmpty) {
      _showSnackBar("Please enter the OTP");
      return;
    }
    setState(() => isVerifyingEmailOtp = true);
    try {
      bool verified = await verifyEmailOtp(
          emailController.text.trim(),
          emailOtpController.text.trim()
      );
      if (verified) {
        setState(() {
          isEmailOtpVerified = true;
          isEmailOtpSent = false;
          emailOtpController.clear();
        });
        _showSnackBar("Email verified successfully");
      } else {
        _showSnackBar("Invalid OTP");
      }
    } catch (e) {
      _showSnackBar("Verification error: $e");
    } finally {
      setState(() => isVerifyingEmailOtp = false);
    }
  }

  void handleSendMobileOtp() async {
    String phone = mobileController.text.trim();
    if (phone.length != 10) {
      _showSnackBar("Enter a valid 10-digit mobile number");
      return;
    }
    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackBar("Mobile OTP failed: ${e.message}");
        setState(() => isLoading = false);
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          isMobileOtpSent = true;
          isMobileOtpVerified = false;
          isLoading = false;
        });
        _showSnackBar("OTP sent to your mobile");
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  void handleVerifyMobileOtp() async {
    if (mobileOtpController.text.isEmpty || verificationId == null) {
      _showSnackBar("Please enter the OTP");
      return;
    }
    setState(() => isVerifyingMobileOtp = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: mobileOtpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isMobileOtpVerified = true;
        isMobileOtpSent = false;
        mobileOtpController.clear();
      });
      _showSnackBar("Mobile verified successfully");
    } catch (e) {
      _showSnackBar("Invalid mobile OTP: $e");
    } finally {
      setState(() => isVerifyingMobileOtp = false);
    }
  }

  void handleRegistration() async {
    if (formKey.currentState!.validate()) {
      if (!isEmailOtpVerified || !isMobileOtpVerified) {
        _showSnackBar("Please verify email and mobile first");
        return;
      }
      setState(() => isLoading = true);

      final user = api_user.User(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bank: selectedBank,
        mobile: mobileController.text.trim(),
      );

      try {
        bool success = await ApiService.registerUser(user);
        if (success) {
          _showSnackBar("Registration successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReadSms()));
        }
      } catch (e) {
        _showSnackBar("Error: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
        TextInputType inputType = TextInputType.text,
        Widget? suffixIcon,
        String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator ??
              (value) =>
          value == null || value.trim().isEmpty ? "$label cannot be empty" : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBank.isNotEmpty ? selectedBank : null,
      decoration: InputDecoration(
        labelText: "Select Bank",
        prefixIcon: const Icon(Icons.account_balance),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: ['BOI', 'HDFC', 'BOB', 'SBI'].map((bank) {
        return DropdownMenuItem(value: bank, child: Text(bank));
      }).toList(),
      validator: (value) =>
      value == null || value.isEmpty ? "Please select a bank" : null,
      onChanged: (value) => setState(() => selectedBank = value ?? ''),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    emailOtpController.dispose();
    mobileController.dispose();
    mobileOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text("Create Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text("Register",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700)),
                    const SizedBox(height: 20),

                    _buildTextField(nameController, "Full Name", Icons.person),
                    const SizedBox(height: 16),

                    // Mobile Field with Send OTP
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            mobileController,
                            "Mobile Number",
                            Icons.phone_android,
                            inputType: TextInputType.phone,
                            suffixIcon: isMobileOtpVerified
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mobile number cannot be empty";
                              } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return "Enter a valid 10-digit mobile number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isMobileOtpSent && !isMobileOtpVerified)
                          ElevatedButton(
                            onPressed: isLoading ? null : handleSendMobileOtp,
                            child: const Text("Send OTP"),
                          ),
                      ],
                    ),

                    if (isMobileOtpSent && !isMobileOtpVerified) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              mobileOtpController,
                              "Enter Mobile OTP",
                              Icons.message,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isVerifyingMobileOtp ? null : handleVerifyMobileOtp,
                            child: isVerifyingMobileOtp
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text("Verify"),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Email Field with Send OTP
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            emailController,
                            "Email",
                            Icons.email,
                            inputType: TextInputType.emailAddress,
                            suffixIcon: isEmailOtpVerified
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : null,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!isEmailOtpSent && !isEmailOtpVerified)
                          ElevatedButton(
                            onPressed: isLoading ? null : handleSendEmailOtp,
                            child: const Text("Send OTP"),
                          ),
                      ],
                    ),

                    if (isEmailOtpSent && !isEmailOtpVerified) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              emailOtpController,
                              "Enter Email OTP",
                              Icons.lock_clock,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: isVerifyingEmailOtp ? null : handleVerifyEmailOtp,
                            child: isVerifyingEmailOtp
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text("Verify"),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),
                    _buildDropdown(),
                    const SizedBox(height: 24),

                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: handleRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
