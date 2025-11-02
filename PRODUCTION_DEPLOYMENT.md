# Production Deployment Guide

Complete guide for deploying the Booking MVP to production.

## Pre-Production Checklist

### Environment Setup
- [ ] All secrets configured in GitHub Environments (dev, staging, prod)
- [ ] Google OAuth credentials ready for production
- [ ] API domain configured with HTTPS
- [ ] CORS configured for production domains only
- [ ] Monitoring and error tracking configured

### Code Quality
- [ ] All tests passing (`scripts/step2_run_checks.sh`)
- [ ] Version numbers updated in `pubspec.yaml` and `package.json`
- [ ] Debug logging removed or disabled
- [ ] Code reviewed and approved

### Mobile App
- [ ] Release AAB built (`scripts/step14_build_release_aab.sh`)
- [ ] App signed with upload key
- [ ] Play Console listing completed
- [ ] Screenshots and store assets ready
- [ ] Privacy policy URL provided

### Server
- [ ] Docker image built and tested locally
- [ ] Environment variables configured
- [ ] Database migrations run (if applicable)
- [ ] Health check endpoint configured

## Production Deployment Steps

### Step 13: Prepare Android Release

```bash
scripts/step13_prepare_android_release.sh
```

This validates:
- Flutter setup
- Android configuration
- Release build settings
- Version information

**Action items:**
- Review `android/app/build.gradle`
- Ensure `debuggable=false` for release
- Configure signing

### Step 14: Build Release AAB

```bash
# With signing
export KEYSTORE_PATH=/path/to/keystore.jks
export KEYSTORE_PASSWORD=...
export KEY_ALIAS=upload
export KEY_PASSWORD=...

scripts/step14_build_release_aab.sh
```

**Output:**
- Signed AAB ready for Play Store upload
- Location: `mobile/build/app/outputs/bundle/release/app-release.aab`

### Step 15: Upload to Play Store

```bash
# Upload to internal testing
scripts/step15_upload_to_play.sh internal

# Upload to production
scripts/step15_upload_to_play.sh production
```

**Options:**
1. **Play Console Web UI** (easiest)
   - Go to Play Console
   - Navigate to Release → Testing → Track
   - Upload AAB file

2. **fastlane** (automated)
   ```bash
   gem install fastlane
   cd mobile
   fastlane init
   # Configure Fastfile
   fastlane android deploy track:production
   ```

3. **Google Play Console API** (programmatic)
   - Enable Google Play Android Developer API
   - Create service account
   - Grant access in Play Console
   - Use API client to upload

### Step 16: Setup Play App Signing

```bash
scripts/step16_setup_play_signing.sh
```

**Steps:**
1. Enable Play App Signing in Play Console
2. Upload first AAB
3. Get certificate fingerprint from Play Console
4. Update `assetlinks.json` if using App Links

**Benefits:**
- Google manages your signing key
- Can recover from lost upload key
- Smaller app size
- Automatic key rotation

### Step 17: Production Validation

```bash
scripts/step17_production_validation.sh https://your-api.com
```

**Validates:**
- Mobile app version and build number
- Debug code removed
- Server configuration
- API health and CORS
- Docker image ready

### Step 18: EMM Deployment (If Applicable)

```bash
scripts/step18_emm_deployment.sh
```

**For enterprise customers:**
1. Create test app with new ApplicationId
2. Claim managed Google domain
3. Publish to private channel
4. Configure via EMM console

### Step 19: Complete Production Deployment

```bash
scripts/step19_production_deploy.sh prod https://your-api.com
```

**This orchestrates:**
- Pre-deployment validation
- Server deployment via GitHub Actions
- Mobile app deployment confirmation
- Post-deployment validation

## Deployment Platforms

### Fly.io

```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Login
flyctl auth login

# Launch app
flyctl launch --image ghcr.io/your-username/mvp-server:v1.0.0

# Set secrets
flyctl secrets set \
  GOOGLE_CLIENT_ID=... \
  GOOGLE_CLIENT_SECRET=... \
  GOOGLE_REFRESH_TOKEN=...
```

### Google Cloud Run

```bash
# Authenticate
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Deploy
gcloud run deploy mvp-server \
  --image ghcr.io/your-username/mvp-server:v1.0.0 \
  --platform managed \
  --region us-central1 \
  --set-env-vars "GOOGLE_CLIENT_ID=...,GOOGLE_CLIENT_SECRET=..."

# Set secrets
gcloud run services update mvp-server \
  --update-secrets GOOGLE_REFRESH_TOKEN=refresh-token:latest
```

### Render

1. Create new Web Service in Render dashboard
2. Connect GitHub repository
3. Set Docker image: `ghcr.io/your-username/mvp-server:v1.0.0`
4. Add environment variables from `.env.example`
5. Deploy

### Kubernetes

```bash
# Create deployment
kubectl create deployment mvp-server \
  --image ghcr.io/your-username/mvp-server:v1.0.0

# Set secrets
kubectl create secret generic mvp-secrets \
  --from-literal=google-client-id=... \
  --from-literal=google-client-secret=...

# Expose service
kubectl expose deployment mvp-server \
  --port=3000 \
  --type=LoadBalancer
```

## Post-Deployment

### Validation

1. **API Health Check**
   ```bash
   scripts/step11_validate_deployment.sh https://your-api.com
   ```

2. **Mobile App Testing**
   - Install from Play Store
   - Test all features
   - Verify Google Meet links
   - Check for crashes

3. **Integration Testing**
   - Create booking from mobile app
   - Verify calendar event created
   - Confirm Meet link works

### Monitoring Setup

```bash
scripts/step12_setup_monitoring.sh
```

**Recommended:**
- **Error Tracking:** Sentry (mobile + server)
- **Logging:** CloudWatch, GCP Logging, Datadog
- **APM:** New Relic, Datadog APM
- **Uptime:** UptimeRobot, Pingdom

### Rollback Procedure

#### Server Rollback

**Fly.io:**
```bash
flyctl releases list
flyctl releases rollback <release-id>
```

**Cloud Run:**
```bash
gcloud run services update-traffic mvp-server \
  --to-revisions=<previous-revision>=100
```

**Kubernetes:**
```bash
kubectl rollout undo deployment/mvp-server
```

#### Mobile App Rollback

1. Go to Play Console
2. Navigate to Release → Production
3. Set rollout percentage to 0% for broken version
4. Promote previous version to 100%

## Troubleshooting

### API Not Responding

1. Check deployment logs
2. Verify environment variables
3. Test health endpoint
4. Check CORS configuration

### Mobile App Crashes

1. Check Crashlytics/Sentry
2. Review device logs
3. Test on multiple devices
4. Check for missing permissions

### Calendar API Errors

1. Verify refresh token is valid
2. Check API quotas in Google Cloud Console
3. Review OAuth scopes
4. Test with OAuth Playground

## Security Checklist

- [ ] HTTPS enabled for all endpoints
- [ ] CORS restricted to production domains
- [ ] Secrets stored securely (not in code)
- [ ] API rate limiting configured
- [ ] Input validation implemented
- [ ] Error messages don't leak sensitive info
- [ ] OAuth scopes limited to required permissions
- [ ] Refresh tokens rotated periodically

## Support

For issues:
1. Check [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
2. Review deployment logs
3. Check monitoring dashboards
4. Consult platform-specific documentation

---

**Ready for production! 🚀**

