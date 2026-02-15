/// Application constants and static data
///
/// This class contains static constant values used throughout the application,
/// including the list of supported countries for user registration.
class AppConstants {
  /// List of all countries supported by the application
  /// 
  /// Used for country selection in user registration and profile management.
  /// The list includes countries from all major regions of the world.
  static const List<String> countries = [
    // Asia
    'Afghanistan', 'Bahrain', 'Bangladesh', 'China', 'India', 'Indonesia', 
    'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan', 'Kuwait', 'Lebanon', 'Libya', 
    'Malaysia', 'Pakistan', 'Palestine', 'Philippines', 'Qatar', 'Saudi Arabia', 
    'Singapore', 'South Korea', 'Syria', 'Thailand', 'Turkey', 'United Arab Emirates', 
    'Vietnam', 'Yemen',
    
    // Africa
    'Algeria', 'Egypt', 'Morocco', 'Nigeria', 'South Africa', 'Tunisia', 'Zimbabwe',
    
    // Europe
    'Albania', 'Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Czech Republic', 
    'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 
    'Iceland', 'Ireland', 'Italy', 'Netherlands', 'Norway', 'Poland', 'Portugal', 
    'Romania', 'Russia', 'Spain', 'Sweden', 'Switzerland', 'Ukraine', 'United Kingdom',
    
    // Americas
    'Argentina', 'Brazil', 'Canada', 'Chile', 'Colombia', 'Mexico', 'United States', 'Venezuela',
    
    // Oceania
    'Australia', 'New Zealand',
  ];
}
