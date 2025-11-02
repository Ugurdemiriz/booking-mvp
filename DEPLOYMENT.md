# Complete Deployment Guide

This guide walks you through deploying the Booking MVP from local development to production.

## Prerequisites

- Flutter SDK 3.24.0+
- Node.js 20.x
- Docker (for containerized deployments)
- Google Cloud Platform account (for Calendar API)
- Android SDK (for mobile builds)
- GitHub account with repository access

## Quick Start

Run the numbered scripts in order:

```bash
scripts/step1_setup_local.sh          # Install dependencies
scripts/step2_run_checks.sh           # Validate code quality
scripts/step3_start_server.sh         # Start API (requires .env)
scripts/step4_run_flutter_app.sh      # Run mobile app
scripts/step7_prepare_release.sh      # Pre-release checks
scripts/step8_build_and_sign.sh       # Build signed Android APK/AAB
scripts/step9_docker_build.sh         # Build Docker image
scripts/step10_deploy_docker.sh       # Deploy to platform
scripts/step11_validate_deployment.sh # Verify deployment
scripts/step12_setup_monitoring.sh    # Configure observability
```

## Detailed Steps

### Step 1: Local Setup

```bash
./scripts/step1_setup_local.sh
```

This installs:
- Flutter packages (`mobile/`)
- Node.js dependencies (`server/`)

**Next:** Create `server/.env` from `server/.env.example` with your Google OAuth credentials.

### Step 2: Code Quality Checks

```bash
./scripts/step2_run_checks.sh
```

Validates:
- Flutter static analysis
- TypeScript compilation

### Step 3: Start API Locally

```bash
./scripts/step3_start_server.sh
```

**Requirements:**
- `server/.env` file with:
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
  - `GOOGLE_REDIRECT_URI`
  - `GOOGLE_REFRESH_TOKEN`

**Obtaining Google OAuth Credentials:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project or select existing
3. Enable Google Calendar API
4. Create OAuth 2.0 credentials
5. Use [OAuth Playground](https://developers.google.com/oauthplayground) to get refresh token
   - Scope: `https://www.googleapis.com/auth/calendar`
   - Copy the refresh token to `.env`

### Step 4: Run Flutter App

```bash
./scripts/step4_run_flutter_app.sh
```

Or with custom API URL:
```bash
API_BASE_URL=https://your-api.example.com ./scripts/step4_run_flutter_app.sh
```

### Step 5: Build Android Release (Unsigned)

```bash
./scripts/step5_build_mobile_release.sh
```

With flavor:
```bash
./scripts/step5_build_mobile_release.sh production
```

### Step 6: Trigger GitHub Deployment

Requires GitHub CLI (`gh`) and authentication:

```bash
gh auth login
./scripts/step6_trigger_server_deploy.sh dev
```

### Step 7: Prepare Release

```bash
./scripts/step7_prepare_release.sh
```

Validates both server and mobile builds are ready.

### Step 8: Build and Sign Android Release

#### Option A: Generate Keystore

```bash
./scripts/generate_keystore.sh upload-keystore.jks upload
```

#### Option B: Build with Signing

```bash
export KEYSTORE_PATH=/path/to/keystore.jks
export KEYSTORE_PASSWORD=your_store_password
export KEY_ALIAS=upload
export KEY_PASSWORD=your_key_password

./scripts/step8_build_and_sign.sh
```

**Output:**
- Signed APK: `mobile/build/app/outputs/flutter-apk/app-release.apk`
- Signed AAB: `mobile/build/app/outputs/bundle/release/app-release.aab`

**Note:** For Play Store, prefer AAB (Android App Bundle) format.

### Step 9: Build Docker Image

```bash
export REGISTRY=ghcr.io/your-username
export IMAGE_TAG=v1.0.0

./scripts/step9_docker_build.sh
```

Or build manually:
```bash
cd server
docker build -t mvp-server:latest .
```

Test locally:
```bash
docker run -p 3000:3000 --env-file .env mvp-server:latest
```

### Step 10: Deploy Docker Image

#### Fly.io Deployment

```bash
# Install Fly CLI: https://fly.io/docs/getting-started/installing-flyctl/

flyctl auth login
flyctl launch --image ghcr.io/your-username/mvp-server:v1.0.0
flyctl secrets set \
  GOOGLE_CLIENT_ID=... \
  GOOGLE_CLIENT_SECRET=... \
  GOOGLE_REFRESH_TOKEN=...
```

#### Render Deployment

1. Create new Web Service in Render dashboard
2. Connect GitHub repository
3. Set Docker image: `ghcr.io/your-username/mvp-server:v1.0.0`
4. Add environment variables from `.env.example`
5. Deploy

#### Google Cloud Run

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Push to Artifact Registry
docker tag mvp-server:latest gcr.io/YOUR_PROJECT_ID/mvp-server:v1.0.0
docker push gcr.io/YOUR_PROJECT_ID/mvp-server:v1.0.0

# Deploy
gcloud run deploy mvp-server \
  --image gcr.io/YOUR_PROJECT_ID/mvp-server:v1.0.0 \
  --platform managed \
  --region us-central1 \
  --set-env-vars "GOOGLE_CLIENT_ID=...,GOOGLE_CLIENT_SECRET=..."
```

#### Kubernetes Deployment

```bash
kubectl create deployment mvp-server --image=ghcr.io/your-username/mvp-server:v1.0.0
kubectl set env deployment/mvp-server \
  GOOGLE_CLIENT_ID=... \
  GOOGLE_CLIENT_SECRET=...
kubectl expose deployment mvp-server --port=3000 --type=LoadBalancer
```

### Step 11: Validate Deployment

```bash
./scripts/step11_validate_deployment.sh https://your-api.example.com
```

Manually test:
- Create booking via Flutter app
- Verify Google Meet link is generated
- Check calendar event appears in Google Calendar

### Step 12: Setup Monitoring

```bash
./scripts/step12_setup_monitoring.sh
```

Recommended tools:
- **Error Tracking:** Sentry (mobile + server)
- **Logging:** CloudWatch, GCP Logging, Datadog
- **APM:** New Relic, Datadog APM
- **Uptime:** UptimeRobot, Pingdom

## GitHub Environments & Secrets

### Creating Environments

1. Go to Repository → Settings → Environments
2. Create: `dev`, `staging`, `prod`
3. Add branch protection for `prod` (require reviewers)

### Required Secrets (per environment)

| Secret | Description |
|--------|-------------|
| `GOOGLE_CLIENT_ID` | OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | OAuth client secret |
| `GOOGLE_REDIRECT_URI` | OAuth redirect URI |
| `GOOGLE_REFRESH_TOKEN` | Long-lived refresh token |
| `GHCR_USERNAME` | GitHub username (optional, for Docker pushes) |
| `GHCR_TOKEN` | GitHub PAT with `write:packages` (optional) |

## Mobile App Distribution

### Google Play Store

1. **Prepare Release:**
   - Build signed AAB: `scripts/step8_build_and_sign.sh`
   - Update version in `pubspec.yaml`

2. **Create Play Console Listing:**
   - App name, description, screenshots
   - Privacy policy URL
   - Content rating questionnaire

3. **Upload Release:**
   - Internal testing → Closed testing → Open testing → Production
   - Upload AAB file from `mobile/build/app/outputs/bundle/release/`

4. **Monitor:**
   - Pre-launch reports
   - User feedback
   - Crash reports

### Enterprise Distribution (EMM)

1. Create new app variant with different `applicationId`
2. Bind Google Workspace domain
3. Publish to managed Google Play
4. Push via EMM console to devices

## Troubleshooting

### API Not Starting

- Check `server/.env` exists and has valid credentials
- Verify port 3000 is not in use: `lsof -i :3000`
- Check Node.js version: `node --version` (should be 20.x)

### Flutter Build Fails

- Run `flutter clean && flutter pub get`
- Check Android SDK installation: `flutter doctor`
- Ensure minimum SDK version is set in `android/app/build.gradle`

### Docker Build Fails

- Verify Dockerfile syntax
- Check `.dockerignore` isn't excluding necessary files
- Build with verbose logging: `docker build --progress=plain -t ...`

### Google Calendar API Errors

- Verify refresh token is valid (may expire, regenerate via OAuth Playground)
- Check OAuth scopes include `https://www.googleapis.com/auth/calendar`
- Review API quotas in Google Cloud Console

## Security Checklist

- [ ] Never commit `.env` files
- [ ] Store keystore files securely (use secrets manager)
- [ ] Rotate Google refresh tokens periodically
- [ ] Use HTTPS for all API endpoints in production
- [ ] Enable CORS only for trusted origins
- [ ] Review and limit OAuth scopes
- [ ] Use environment-specific secrets
- [ ] Enable audit logging for production

## Rollback Procedure

### Server Rollback

1. Identify previous working image tag
2. Update deployment to previous image:
   ```bash
   # Fly.io
   flyctl releases list
   flyctl releases rollback <release-id>
   
   # Cloud Run
   gcloud run services update-traffic mvp-server --to-revisions=<previous-revision>=100
   ```

### Mobile App Rollback

1. Upload previous AAB version to Play Console
2. Set rollout percentage to 0% for broken version
3. Promote previous version to 100%

## Next Steps

- Add automated tests (unit, integration, e2e)
- Set up CI/CD for automated releases
- Implement feature flags for gradual rollouts
- Add performance monitoring
- Set up backup and disaster recovery

## Support

For issues, check:
- [Flutter Documentation](https://docs.flutter.dev/)
- [NestJS Documentation](https://docs.nestjs.com/)
- [Google Calendar API](https://developers.google.com/calendar)

