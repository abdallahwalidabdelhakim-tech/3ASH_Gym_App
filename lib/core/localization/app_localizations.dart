/// Application localization and translation management
///
/// Provides access to translated strings based on the selected locale.
/// Supports English and Arabic languages with all UI text translations.
library;
import 'package:flutter/material.dart';
import 'app_localizations_delegate.dart';

class AppLocalizations {

  /// Creates an instance with the specified locale
  AppLocalizations(this.locale);
  /// The current locale being used for translations
  final Locale locale;

  /// Retrieves the AppLocalizations instance from the current build context
  /// 
  /// Parameters:
  /// - context: The build context to retrieve the localization from
  /// Returns: AppLocalizations instance if available, null otherwise
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Gets the localization delegate for AppLocalizations
  static LocalizationsDelegate<AppLocalizations> get delegate =>
      const AppLocalizationsDelegate();

  /// Localized string values map
  /// 
  /// Contains all translation strings organized by language code and message key.
  /// Supported languages:
  /// - 'en': English (United States)
  /// - 'ar': Arabic (Saudi Arabia)
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Name
      'app_name': '3ASH',
      
      // Splash Screen
      'loading': 'Loading...',
      
      // Login Screen
      'login': 'Login',
      'hi_welcome_back': 'Hi, Welcome back!',
      'username': 'Username',
      'password': 'Password',
      'remember_me': 'Remember me',
      'forgot_password': 'Forgot password',
      'continue_with_facebook': 'Continue with Facebook',
      'continue_with_google': 'Continue with Google',
      'continue_with_apple': 'Continue with Apple',
      'dont_have_account': "Don't have an account?",
      'sign_up': 'Sign up',
      
      // Sign Up Screen
      'create_new_account': 'Create new account',
      'connect_with_us': 'Connect with us!!!',
      'enter_username': 'Enter username',
      'enter_email': 'Enter Email',
      'date_of_birth': 'YY / MM / DD',
      'enter_password': 'Enter password',
      're_enter_password': 'Re-enter password',
      'already_have_account': 'Already have an account?',
      
      // Forgot Password
      'forgot_password_title': 'Forgot password?',
      'forgot_password_description': 'We will send you an email to set or reset your password',
      'enter_your_email': 'Enter your email',
      'submit': 'Submit',
      'want_try_another_account': 'Want try another account?',
      'verify': 'Verify',
      'verify_description': 'Please enter the code we sent you to email',
      'didnt_receive_code': "Didn't Receive the Code?",
      'resend_code': 'Resend Code',
      'create_new_password': 'Create a New Password',
      'show_password': 'Show Password',
      'congratulations': 'Congratulations!',
      'password_reset_successful': 'Password Reset successful',
      'redirect_to_login': "You'll be redirected to the login screen now",
      
      // Home Screen
      'good_morning': 'Good Morning',
      'my_plan_for_today': 'My plan For today',
      'complete': 'complete',
      'Workout Plans': 'Workout Plans',
      'exercise_library': 'Exercise Library',
      'today_plan': 'Today Plan',
      'push_up': 'Push Up',
      'push_up_goal': '100 Push up a day',
      'sit_up': 'Sit Up',
      'sit_up_goal': '20 Sit up a day',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'home': 'Home',
      'calendar': 'Calendar',
      'progress': 'Progress',
      'profile': 'Profile',
      'start_workout': 'Start Workout',
      
      // Settings Screen
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'english': 'English',
      'arabic': 'Arabic',
      'logout': 'Logout',
      'account': 'Account',
      'notifications': 'Notifications',
      'privacy': 'Privacy',
      'about': 'About',
      'preferences': 'Preferences',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      
      // Validation Messages
      'username_required': 'Username is required',
      'email_required': 'Email is required',
      'email_invalid': 'Please enter a valid email',
      'password_required': 'Password is required',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_not_match': 'Passwords do not match',
      'change_password': 'Change Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'date_required': 'Date of birth is required',
      'cameraAi':'Camera Ai'
    },
    'ar': {
      // App Name
      'app_name': 'عاش',
      
      // Splash Screen
      'loading': 'جاري التحميل...',
      
      // Login Screen
      'login': 'تسجيل الدخول',
      'hi_welcome_back': 'مرحباً، أهلاً بعودتك!',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'remember_me': 'تذكرني',
      'forgot_password': 'نسيت كلمة المرور',
      'continue_with_facebook': 'المتابعة مع فيسبوك',
      'continue_with_google': 'المتابعة مع جوجل',
      'continue_with_apple': 'المتابعة مع آبل',
      'dont_have_account': 'ليس لديك حساب؟',
      'sign_up': 'إنشاء حساب',
      
      // Sign Up Screen
      'create_new_account': 'إنشاء حساب جديد',
      'connect_with_us': 'تواصل معنا!!!',
      'enter_username': 'أدخل اسم المستخدم',
      'enter_email': 'أدخل البريد الإلكتروني',
      'date_of_birth': 'سنة / شهر / يوم',
      'enter_password': 'أدخل كلمة المرور',
      're_enter_password': 'أعد إدخال كلمة المرور',
      'already_have_account': 'لديك حساب بالفعل؟',
      
      // Forgot Password
      'forgot_password_title': 'نسيت كلمة المرور؟',
      'forgot_password_description': 'سنرسل لك بريداً إلكترونياً لتعيين أو إعادة تعيين كلمة المرور',
      'enter_your_email': 'أدخل بريدك الإلكتروني',
      'submit': 'إرسال',
      'want_try_another_account': 'تريد تجربة حساب آخر؟',
      'verify': 'التحقق',
      'verify_description': 'يرجى إدخال الرمز الذي أرسلناه إلى بريدك الإلكتروني',
      'didnt_receive_code': 'لم تستلم الرمز؟',
      'resend_code': 'إعادة إرسال الرمز',
      'create_new_password': 'إنشاء كلمة مرور جديدة',
      'show_password': 'إظهار كلمة المرور',
      'congratulations': 'تهانينا!',
      'password_reset_successful': 'تم إعادة تعيين كلمة المرور بنجاح',
      'redirect_to_login': 'سيتم توجيهك إلى شاشة تسجيل الدخول الآن',
      
      // Home Screen
      'good_morning': 'صباح الخير',
      'my_plan_for_today': 'خطتي لليوم',
      'complete': 'مكتمل',
      'start_workout': 'بدء التمرين',
      'exercise_library': 'مكتبة التمارين',
      'today_plan': 'خطة اليوم',
      'push_up': 'ضغط',
      'push_up_goal': '100 ضغطة في اليوم',
      'sit_up': 'جلوس',
      'sit_up_goal': '20 جلوس في اليوم',
      'beginner': 'مبتدئ',
      'intermediate': 'متوسط',
      'advanced': 'متقدم',
      'home': 'الرئيسية',
      'calendar': 'التقويم',
      'progress': 'التقدم',
      'profile': 'الملف الشخصي',
      
      // Settings Screen
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'light_theme': 'فاتح',
      'dark_theme': 'داكن',
      'system_theme': 'النظام',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'logout': 'تسجيل الخروج',
      'account': 'الحساب',
      'notifications': 'الإشعارات',
      'privacy': 'الخصوصية',
      'about': 'حول',
      'preferences': 'التفضيلات',
      'logout_confirmation': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'cancel': 'إلغاء',
      
      // Validation Messages
      'username_required': 'اسم المستخدم مطلوب',
      'email_required': 'البريد الإلكتروني مطلوب',
      'email_invalid': 'يرجى إدخال بريد إلكتروني صحيح',
      'password_required': 'كلمة المرور مطلوبة',
      'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'passwords_not_match': 'كلمات المرور غير متطابقة',
      'change_password': 'تغيير كلمة المرور',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'date_required': 'تاريخ الميلاد مطلوب',
      'cameraAi':'كاميرا ai'
    },
  };

  /// Translates a key to the current locale's string
  /// 
  /// Parameters:
  /// - key: The translation key to look up
  /// Returns: The translated string for the current locale, or the key if not found
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Getters for easy access
  String get appName => translate('app_name');
  String get loading => translate('loading');
  String get login => translate('login');
  String get hiWelcomeBack => translate('hi_welcome_back');
  String get username => translate('username');
  String get password => translate('password');
  String get rememberMe => translate('remember_me');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get signUp => translate('sign_up');
  String get createNewAccount => translate('create_new_account');
  String get connectWithUs => translate('connect_with_us');
  String get enterUsername => translate('enter_username');
  String get enterEmail => translate('enter_email');
  String get dateOfBirth => translate('date_of_birth');
  String get enterPassword => translate('enter_password');
  String get reEnterPassword => translate('re_enter_password');
  String get alreadyHaveAccount => translate('already_have_account');
  String get goodMorning => translate('good_morning');
  String get myPlanForToday => translate('my_plan_for_today');
  String get complete => translate('complete');
  String get workoutplans => translate('Workout Plans');
  String get exerciseLibrary => translate('exercise_library');
  String get todayPlan => translate('today_plan');
  String get home => translate('home');
  String get pushUp => translate('push_up');
  String get sitUp => translate('sit_up');
  String get settings => translate('settings');
  String get language => translate('language');
  String get theme => translate('theme');
  String get logout => translate('logout');
  String get cameraAi => translate('cameraAi');
  String get startWorkoutButton => translate('start_workout');
}

