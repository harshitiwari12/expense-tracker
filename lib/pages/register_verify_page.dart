import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterVerifyPage extends StatefulWidget {
  final String mobileNumber;
  final String email;

  const RegisterVerifyPage({
    super.key,
    required this.mobileNumber,
    required this.email,
  });

  @override
  State<RegisterVerifyPage> createState() => _RegisterVerifyPageState();
}

class EmailVerificationRequest {
  final String email;
  final String? otp;

  EmailVerificationRequest({
    required this.email,
    this.otp,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    if (otp != null) 'otp': otp,
  };
}

class EmailVerificationResponse {
  final bool success;
  final String message;
  final String? otp;

  EmailVerificationResponse({
    required this.success,
    required this.message,
    this.otp,
  });

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      otp: json['otp'],
    );
  }
}

class _RegisterVerifyPageState extends State<RegisterVerifyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController mobileOtpController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();

  bool _isMobileOtpSent = false;
  bool _isEmailOtpSent = false;
  bool _isMobileVerified = false;
  bool _isEmailVerified = false;
  int _mobileOtpCountdown = 0;
  int _emailOtpCountdown = 0;
  String? _mobileVerificationId;
  bool _isMobileOtpLoading = false;
  bool _isEmailOtpLoading = false;

  static const String _baseUrl = 'https://your-backend-api.com'; // Replace with your API URL

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendMobileOtp();
      _sendEmailOtp();
    });
  }

  @override
  void dispose() {
    mobileOtpController.dispose();
    emailOtpController.dispose();
    super.dispose();
  }

  Future<void> _sendMobileOtp() async {
    setState(() {
      _isMobileOtpSent = true;
      _isMobileOtpLoading = true;
      _mobileOtpCountdown = 60;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setState(() {
            _isMobileVerified = true;
          });
          _showSnackBar('Mobile number automatically verified');
          _checkVerificationComplete();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isMobileOtpSent = false;
          });
          _showSnackBar('Mobile verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _mobileVerificationId = verificationId;
          });
          _showSnackBar('OTP sent to mobile number');
          _startMobileCountdown();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _mobileVerificationId = verificationId;
        },
      );
    } catch (e) {
      _showSnackBar('Error sending mobile OTP: ${e.toString()}');
      setState(() {
        _isMobileOtpSent = false;
      });
    } finally {
      setState(() => _isMobileOtpLoading = false);
    }
  }

  Future<void> _sendEmailOtp() async {
    setState(() {
      _isEmailOtpSent = true;
      _isEmailOtpLoading = true;
      _emailOtpCountdown = 60;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/send-email-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(EmailVerificationRequest(email: widget.email).toJson()),
      );

      if (response.statusCode == 200) {
        final verificationResponse =
        EmailVerificationResponse.fromJson(jsonDecode(response.body));
        if (verificationResponse.success) {
          _showSnackBar('OTP sent to your email');
          _startEmailCountdown();
        } else {
          _showSnackBar(verificationResponse.message);
          setState(() => _isEmailOtpSent = false);
        }
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Failed to send OTP: $e');
      setState(() => _isEmailOtpSent = false);
    } finally {
      setState(() => _isEmailOtpLoading = false);
    }
  }

  Future<void> _verifyMobileOtp() async {
    if (mobileOtpController.text.isEmpty) {
      _showSnackBar('Please enter mobile OTP');
      return;
    }

    setState(() => _isMobileOtpLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _mobileVerificationId!,
        smsCode: mobileOtpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);

      setState(() {
        _isMobileVerified = true;
      });
      _showSnackBar('Mobile number verified successfully');
      _checkVerificationComplete();
    } catch (e) {
      _showSnackBar('Failed to verify mobile OTP: ${e.toString()}');
    } finally {
      setState(() => _isMobileOtpLoading = false);
    }
  }

  Future<void> _verifyEmailOtp() async {
    if (emailOtpController.text.isEmpty) {
      _showSnackBar('Please enter email OTP');
      return;
    }

    setState(() => _isEmailOtpLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/verify-email-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            EmailVerificationRequest(email: widget.email, otp: emailOtpController.text.trim()).toJson()),
      );

      if (response.statusCode == 200) {
        final verificationResponse =
        EmailVerificationResponse.fromJson(jsonDecode(response.body));
        if (verificationResponse.success) {
          setState(() => _isEmailVerified = true);
          _showSnackBar('Email verified successfully');
          _checkVerificationComplete();
        } else {
          _showSnackBar(verificationResponse.message);
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Failed to verify OTP: $e');
    } finally {
      setState(() => _isEmailOtpLoading = false);
    }
  }

  void _checkVerificationComplete() {
    if (_isMobileVerified && _isEmailVerified) {
      Navigator.pop(context, true);
    }
  }

  void _startMobileCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_mobileOtpCountdown > 0 && mounted) {
        setState(() {
          _mobileOtpCountdown--;
        });
        _startMobileCountdown();
      } else if (mounted) {
        setState(() {
          _isMobileOtpSent = false;
        });
      }
    });
  }

  void _startEmailCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_emailOtpCountdown > 0 && mounted) {
        setState(() {
          _emailOtpCountdown--;
        });
        _startEmailCountdown();
      } else if (mounted) {
        setState(() {
          _isEmailOtpSent = false;
        });
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Your Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 500 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user,
                    size: 80,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Verify Your Contact Details',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We need to verify your mobile number and email address',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mobile Verification Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone_android,
                                color: _isMobileVerified ? Colors.green : Colors.indigo,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mobile Verification',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isMobileVerified ? Colors.green : Colors.indigo,
                                ),
                              ),
                              const Spacer(),
                              if (_isMobileVerified)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.mobileNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!_isMobileVerified) ...[
                            if (_isMobileOtpSent) ...[
                              TextFormField(
                                controller: mobileOtpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter OTP',
                                  prefixIcon: const Icon(Icons.lock_clock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isMobileOtpLoading ? null : _verifyMobileOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isMobileOtpLoading
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Verify',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: (_isMobileOtpSent && _mobileOtpCountdown > 0) || _isMobileOtpLoading
                                          ? null
                                          : _sendMobileOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isMobileOtpSent && _mobileOtpCountdown > 0
                                            ? Colors.grey
                                            : Colors.blueAccent,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isMobileOtpLoading
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text(
                                        _isMobileOtpSent && _mobileOtpCountdown > 0
                                            ? '$_mobileOtpCountdown s'
                                            : 'Resend',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ] else
                              ElevatedButton(
                                onPressed: _isMobileOtpLoading ? null : _sendMobileOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: _isMobileOtpLoading
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Send OTP',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Verification Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: _isEmailVerified ? Colors.green : Colors.indigo,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Email Verification',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isEmailVerified ? Colors.green : Colors.indigo,
                                ),
                              ),
                              const Spacer(),
                              if (_isEmailVerified)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!_isEmailVerified) ...[
                            if (_isEmailOtpSent) ...[
                              TextFormField(
                                controller: emailOtpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter OTP from email',
                                  prefixIcon: const Icon(Icons.lock_clock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isEmailOtpLoading ? null : _verifyEmailOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isEmailOtpLoading
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : const Text(
                                        'Verify',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: (_isEmailOtpSent && _emailOtpCountdown > 0) || _isEmailOtpLoading
                                          ? null
                                          : _sendEmailOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isEmailOtpSent && _emailOtpCountdown > 0
                                            ? Colors.grey
                                            : Colors.blueAccent,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: _isEmailOtpLoading
                                          ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text(
                                        _isEmailOtpSent && _emailOtpCountdown > 0
                                            ? '$_emailOtpCountdown s'
                                            : 'Resend',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ] else
                              ElevatedButton(
                                onPressed: _isEmailOtpLoading ? null : _sendEmailOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: _isEmailOtpLoading
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Send Verification Email',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ],
                      ),
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