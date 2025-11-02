# Production Ready Checklist

Final checklist before deploying to production. Complete all items before proceeding.

## ✅ Pre-Deployment Requirements

### Code Quality
- [ ] All tests passing (`scripts/step2_run_checks.sh`)
- [ ] Flutter analyze passes with no errors
- [ ] TypeScript compilation succeeds
- [ ] Code review completed and approved
- [ ] No debug logging in production code
- [ ] Version numbers updated in `pubspec.yaml` and `package.json`

### Mobile App
- [ ] Release AAB built (`scripts/step14_build_release_aab.sh`)
- [ ] App signed with upload key
- [ ] Play Console listing completed
- [ ] Screenshots and store assets ready
- [ ] Privacy policy URL provided
- [ ] Content rating questionnaire completed
- [ ] App tested on multiple devices/Android versions
- [ ] No crashes in testing phase

### Server
- [ ] Docker image built and tested (`scripts/step9_docker_build.sh`)
- [ ] Environment variables configured
- [ ] HTTPS enabled for all endpoints
- [ ] CORS configured for production domains only
- [ ] Health check endpoint working
- [ ] Error handling implemented
- [ ] Rate limiting configured (if needed)

### Security
- [ ] All secrets stored securely (not in code)
- [ ] `.env` files not committed to git
- [ ] Keystore files not committed to git
- [ ] OAuth scopes limited to required permissions
- [ ] Input validation implemented
- [ ] Error messages don't leak sensitive information
- [ ] API endpoints secured with HTTPS
- [ ] CORS restricted to trusted origins

### Infrastructure
- [ ] GitHub Environments configured (dev, staging, prod)
- [ ] Environment secrets added to GitHub
- [ ] Deployment platform configured (Fly.io, Cloud Run, etc.)
- [ ] Monitoring and alerting set up
- [ ] Error tracking configured (Sentry, etc.)
- [ ] Log aggregation configured
- [ ] Backup and rollback plan documented

## 🚀 Deployment Steps

### Step 1: Server Deployment

1. **Trigger GitHub Actions deployment:**
   ```bash
   scripts/step6_trigger_server_deploy.sh prod
   ```

2. **Or deploy manually:**
   - Go to GitHub Actions
   - Run `server-deploy` workflow
   - Select environment: `prod`
   - Monitor deployment progress

3. **Verify deployment:**
   ```bash
   scripts/step11_validate_deployment.sh https://your-api.com
   ```

### Step 2: Mobile App Deployment

1. **Build release AAB:**
   ```bash
   export KEYSTORE_PATH=/path/to/keystore.jks
   export KEYSTORE_PASSWORD=...
   export KEY_ALIAS=upload
   export KEY_PASSWORD=...
   scripts/step14_build_release_aab.sh
   ```

2. **Upload to Play Store:**
   - Go to Play Console
   - Navigate to Release → Production
   - Create new release
   - Upload AAB file
   - Complete release notes

3. **Roll out gradually:**
   - Start with 10% rollout
   - Monitor for issues
   - Gradually increase to 100%

### Step 3: Validation

1. **Run production validation:**
   ```bash
   scripts/step17_production_validation.sh https://your-api.com
   ```

2. **Test end-to-end:**
   - Install app from Play Store
   - Create booking
   - Verify calendar event created
   - Check Google Meet link works

3. **Monitor:**
   - Error logs
   - Performance metrics
   - User feedback

## 📋 Post-Deployment Checklist

### Immediate Checks (First 24 hours)
- [ ] API health endpoint responding
- [ ] Bookings endpoint working
- [ ] Calendar integration working
- [ ] Mobile app installs correctly
- [ ] No crashes reported
- [ ] Error rates normal
- [ ] Performance metrics acceptable

### First Week
- [ ] User feedback reviewed
- [ ] Error logs analyzed
- [ ] Performance monitored
- [ ] Any critical issues resolved
- [ ] Documentation updated

### Ongoing
- [ ] Regular monitoring
- [ ] Error tracking reviewed
- [ ] Performance metrics tracked
- [ ] User feedback addressed
- [ ] Security updates applied

## 🔄 Rollback Procedure

### Server Rollback

**If issues detected:**
1. Identify previous working version
2. Roll back using platform-specific commands:
   - Fly.io: `flyctl releases rollback <release-id>`
   - Cloud Run: Update service to previous revision
   - Kubernetes: `kubectl rollout undo deployment/mvp-server`

### Mobile App Rollback

**If app crashes or issues:**
1. Go to Play Console
2. Navigate to Release → Production
3. Set rollout to 0% for broken version
4. Promote previous stable version
5. Monitor crash reports

## 🆘 Emergency Contacts

- **Development Team:** [Contact info]
- **DevOps Team:** [Contact info]
- **Platform Support:**
  - Fly.io: [Support URL]
  - Google Cloud: [Support URL]
  - Play Console: [Support URL]

## 📊 Monitoring Dashboards

- **Error Tracking:** [Sentry/Datadog URL]
- **API Performance:** [Monitoring URL]
- **Mobile Analytics:** [Firebase/Google Analytics URL]
- **Uptime Monitoring:** [UptimeRobot/Pingdom URL]

## 📚 Documentation Links

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Complete deployment guide
- [PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md) - Production-specific guide
- [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - Detailed checklist
- [QUICKSTART.md](./QUICKSTART.md) - Quick start guide

---

## ✅ Final Approval

Before deploying to production, get approval from:
- [ ] Technical Lead
- [ ] Product Owner
- [ ] DevOps Lead (if applicable)
- [ ] Security Review (if applicable)

**Deployment Date:** __________

**Deployed By:** __________

**Approved By:** __________

---

**Ready to go live! 🚀**

