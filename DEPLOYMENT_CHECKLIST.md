# Deployment Checklist

Use this checklist to ensure a smooth deployment from development to production.

## Pre-Deployment

### Environment Setup
- [ ] Flutter SDK 3.24.0+ installed (`flutter doctor`)
- [ ] Node.js 20.x installed
- [ ] Docker installed (for containerized deployment)
- [ ] Android SDK configured
- [ ] Google Cloud Console project created
- [ ] Google Calendar API enabled
- [ ] OAuth 2.0 credentials created

### Configuration
- [ ] `server/.env` created from `.env.example`
- [ ] Google OAuth credentials configured:
  - [ ] `GOOGLE_CLIENT_ID`
  - [ ] `GOOGLE_CLIENT_SECRET`
  - [ ] `GOOGLE_REDIRECT_URI`
  - [ ] `GOOGLE_REFRESH_TOKEN`
- [ ] API base URL configured in Flutter app (if needed)

### Code Quality
- [ ] Run `scripts/step1_setup_local.sh` successfully
- [ ] Run `scripts/step2_run_checks.sh` - all checks pass
- [ ] Flutter analyze passes with no errors
- [ ] TypeScript compilation succeeds
- [ ] Manual testing completed locally

## Development Deployment

### Local Testing
- [ ] Server starts successfully (`scripts/step3_start_server.sh`)
- [ ] Flutter app runs (`scripts/step4_run_flutter_app.sh`)
- [ ] Booking flow works end-to-end
- [ ] Calendar event creation works
- [ ] Google Meet links are generated correctly
- [ ] Error handling works as expected

## Release Preparation

### Version Management
- [ ] Update version in `mobile/pubspec.yaml`
- [ ] Update version in `server/package.json`
- [ ] Update changelog/release notes
- [ ] Tag release in git (if using semantic versioning)

### Android Release
- [ ] Generate signing keystore (`scripts/generate_keystore.sh`)
- [ ] Store keystore securely (not in git)
- [ ] Backup keystore and passwords
- [ ] Build release APK (`scripts/step5_build_mobile_release.sh`)
- [ ] Build and sign release (`scripts/step8_build_and_sign.sh`)
- [ ] Test signed APK on physical device
- [ ] Verify AAB (App Bundle) if targeting Play Store

### Server Release
- [ ] Run `scripts/step7_prepare_release.sh`
- [ ] Review server build output
- [ ] Test Docker build locally (`scripts/step9_docker_build.sh`)
- [ ] Verify Docker image runs with production env vars

## GitHub Deployment

### GitHub Setup
- [ ] Repository configured with GitHub Actions
- [ ] Environments created: `dev`, `staging`, `prod`
- [ ] Environment secrets configured for each environment:
  - [ ] `GOOGLE_CLIENT_ID`
  - [ ] `GOOGLE_CLIENT_SECRET`
  - [ ] `GOOGLE_REDIRECT_URI`
  - [ ] `GOOGLE_REFRESH_TOKEN`
  - [ ] `GHCR_USERNAME` (optional, for Docker)
  - [ ] `GHCR_TOKEN` (optional, for Docker)
- [ ] Production environment protected (reviewers, branch restrictions)

### CI/CD Workflows
- [ ] `server-ci.yml` runs successfully on PRs
- [ ] `flutter-ci.yml` runs successfully on PRs
- [ ] `server-deploy.yml` can be triggered manually
- [ ] `flutter-build-android.yml` can be triggered manually

### Deployment Execution
- [ ] Deploy to `dev` environment first
- [ ] Validate dev deployment (`scripts/step11_validate_deployment.sh`)
- [ ] Test all features in dev environment
- [ ] Deploy to `staging` (if applicable)
- [ ] Validate staging deployment
- [ ] Get approval for production deployment
- [ ] Deploy to `prod` environment
- [ ] Validate production deployment

## Platform-Specific Deployment

### Fly.io
- [ ] Fly CLI installed (`flyctl version`)
- [ ] Fly.io account created
- [ ] App created (`flyctl launch`)
- [ ] Secrets configured (`flyctl secrets set`)
- [ ] Deployment successful (`flyctl deploy`)
- [ ] Health checks passing

### Google Cloud Run
- [ ] `gcloud` CLI installed and authenticated
- [ ] Project selected (`gcloud config set project`)
- [ ] Docker image pushed to Artifact Registry
- [ ] Cloud Run service created
- [ ] Environment variables configured
- [ ] Service URL accessible

### Render
- [ ] Render account created
- [ ] Web service created
- [ ] GitHub repository connected
- [ ] Environment variables configured
- [ ] Build settings configured
- [ ] Service deployed and healthy

### Kubernetes
- [ ] Kubernetes cluster access configured
- [ ] Docker image pushed to registry
- [ ] Deployment manifests created
- [ ] Secrets configured (`kubectl create secret`)
- [ ] Deployment applied (`kubectl apply`)
- [ ] Service exposed and accessible

## Post-Deployment

### Validation
- [ ] API health endpoint returns 200
- [ ] Bookings endpoint accessible
- [ ] Calendar event creation works
- [ ] Google Meet links generated correctly
- [ ] Error responses formatted correctly
- [ ] CORS configured correctly

### Monitoring
- [ ] Logging configured (`scripts/step12_setup_monitoring.sh`)
- [ ] Error tracking set up (Sentry, etc.)
- [ ] Uptime monitoring configured
- [ ] Alerts configured for:
  - [ ] High error rates
  - [ ] Slow response times
  - [ ] API failures
  - [ ] Calendar API quota issues

### Documentation
- [ ] Deployment process documented
- [ ] Rollback procedure documented
- [ ] Troubleshooting guide updated
- [ ] Runbook for operations team (if applicable)

### Mobile App Distribution

#### Google Play Store
- [ ] Play Console account created
- [ ] App listing created (name, description, screenshots)
- [ ] Privacy policy URL provided
- [ ] Content rating questionnaire completed
- [ ] AAB uploaded to Internal Testing
- [ ] Internal testing validated
- [ ] Released to Closed Testing (if applicable)
- [ ] Released to Open Testing (if applicable)
- [ ] Production release approved
- [ ] Release notes published

#### Enterprise Distribution (EMM)
- [ ] EMM console access
- [ ] Google Workspace domain bound
- [ ] App variant created (if needed)
- [ ] Published to managed Google Play
- [ ] Configuration policies defined
- [ ] Pushed to test devices
- [ ] Validated on managed devices

## Security Checklist

- [ ] `.env` files not committed to git
- [ ] Keystore files not committed to git
- [ ] Secrets stored in environment variables (not hardcoded)
- [ ] HTTPS enabled for all production endpoints
- [ ] CORS restricted to trusted origins
- [ ] OAuth scopes limited to required permissions
- [ ] Refresh tokens stored securely
- [ ] API rate limiting configured (if applicable)
- [ ] Input validation implemented
- [ ] Error messages don't leak sensitive info

## Rollback Preparation

- [ ] Previous version image tag documented
- [ ] Previous APK/AAB version saved
- [ ] Rollback procedure tested in staging
- [ ] Database migration rollback script (if applicable)
- [ ] Communication plan for rollback

## Communication

- [ ] Team notified of deployment schedule
- [ ] Users notified (if breaking changes)
- [ ] Status page updated (if applicable)
- [ ] Post-deployment summary shared

## Post-Deployment Review

- [ ] All features working as expected
- [ ] Performance metrics within acceptable range
- [ ] Error rates normal
- [ ] User feedback collected
- [ ] Issues documented and prioritized
- [ ] Lessons learned documented

---

**Last Updated:** Generated automatically
**Next Review:** After each production deployment

