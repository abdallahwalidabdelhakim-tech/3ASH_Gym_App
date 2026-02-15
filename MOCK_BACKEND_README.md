# Mock Backend Setup

This app now supports testing without a backend server using mock services.

## How It Works

The app automatically uses mock services when `AppConfig.useMockBackend` is set to `true` (which is the default). All API calls are intercepted and return mock data instead of making real HTTP requests.

## Configuration

### Enable/Disable Mock Backend

Edit `lib/core/config/app_config.dart`:

```dart
static const bool useMockBackend = true; // Set to false to use real backend
```

Or use environment variables when running:

```bash
# Use mock backend (default)
flutter run

# Use real backend
flutter run --dart-define=USE_MOCK_BACKEND=false
```

## Mock Services

### MockAuthService
- **Login**: Accepts any username/password combination (creates user if doesn't exist)
- **Sign Up**: Creates new users in memory
- **Password Reset**: Generates 4-digit codes (printed to console)
- **Change Password**: Updates password for authenticated users

### MockUserService
- **Get Current User**: Returns user data from mock storage
- **Update Profile**: Updates username, country, phone number
- **Onboarding**: Stores and retrieves onboarding data

## Testing Without Backend

1. **Default Behavior**: The app uses mock backend by default, so you can run it immediately:
   ```bash
   flutter run
   ```

2. **Default Test User**: A test user is automatically created when the app starts:
   - **Username**: `testuser`
   - **Email**: `test@example.com`
   - **Password**: `password123`
   - **Country**: `USA`
   - **Phone**: `+1234567890`

3. **Login Credentials**: 
   - Use the default test user credentials above, OR
   - Sign up with any credentials (they'll be created automatically)
   - Password reset codes are printed to console: `[MOCK] Password reset code for email: 1234`

4. **Create Additional Test Users**: You can create more test users programmatically:
   ```dart
   await MockAuthService.createTestUser(
     username: 'anotheruser',
     email: 'another@example.com',
     password: 'password123',
   );
   ```

## Switching to Real Backend

To use the real backend:

1. Set `useMockBackend = false` in `app_config.dart`, OR
2. Run with: `flutter run --dart-define=USE_MOCK_BACKEND=false`
3. Make sure your backend server is running on `http://localhost:3001` (or update `baseUrl`)

## Mock Data Storage

- **In-Memory**: All mock data is stored in memory and cleared when the app restarts
- **SharedPreferences**: Auth tokens are still saved to SharedPreferences (for persistence across app restarts)
- **No Database**: Mock services don't use any database - everything is in-memory

## Notes

- Mock services simulate network delays (300-500ms) for realistic testing
- All mock endpoints return the same response format as the real backend
- Password reset codes are 4-digit numbers printed to console for testing
- User data persists in SharedPreferences (tokens), but user records are in-memory only

