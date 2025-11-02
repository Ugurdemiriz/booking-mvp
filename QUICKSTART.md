# Quick Start Guide

Get the Booking MVP up and running in 5 minutes.

## Prerequisites

- Flutter SDK installed (`flutter doctor`)
- Node.js 20.x installed
- Android Studio or Xcode (for mobile builds)

## Quick Setup

1. **Clone and setup:**
   ```bash
   cd mvp
   ./scripts/step1_setup_local.sh
   ```

2. **Configure server (one-time):**
   ```bash
   cp server/.env.example server/.env
   # Edit server/.env with your Google OAuth credentials
   ```

3. **Start the API:**
   ```bash
   ./scripts/step3_start_server.sh
   # Keep this terminal open
   ```

4. **Run the app (new terminal):**
   ```bash
   ./scripts/step4_run_flutter_app.sh
   ```

## Getting Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project
3. Enable "Google Calendar API"
4. Create OAuth 2.0 credentials (Application type: Web)
5. Use [OAuth Playground](https://developers.google.com/oauthplayground/) to get refresh token:
   - Add scope: `https://www.googleapis.com/auth/calendar`
   - Exchange code for refresh token
   - Copy refresh token to `server/.env`

## Testing the Flow

1. Open the Flutter app on your device/emulator
2. Navigate to "Calendar" tab
3. Tap "Create Meet Event"
4. Check your Google Calendar - a new event with Meet link should appear

## Next Steps

- Read [README.md](./README.md) for full documentation
- See [DEPLOYMENT.md](./DEPLOYMENT.md) for production deployment
- Customize the app UI in `mobile/lib/`

## Troubleshooting

**API won't start:**
- Check `server/.env` exists and has all required variables
- Verify port 3000 is available: `lsof -i :3000`

**Flutter app errors:**
- Run `flutter clean && flutter pub get` in `mobile/`
- Check `flutter doctor` for setup issues

**Calendar API errors:**
- Verify refresh token is valid
- Check OAuth scopes include Calendar API
- Review API quotas in Google Cloud Console

