# Booking MVP Deployment Playbook

This repository contains a Flutter mobile app (`mobile/`) and a NestJS API (`server/`).
Use the scripts in `scripts/` for a consistent, repeatable start-to-deploy experience.

## Step-by-step Automation

### Development Workflow

1. **Local setup** – installs dependencies and checks toolchains:
   ```bash
   scripts/step1_setup_local.sh
   ```

2. **Static analysis & compile checks** – run Flutter analyze and Nest build:
   ```bash
   scripts/step2_run_checks.sh
   ```

3. **Start API locally** – requires a populated `server/.env`:
   ```bash
   scripts/step3_start_server.sh
   ```

4. **Run Flutter app** – points at the local API by default (`API_BASE_URL` override optional):
   ```bash
   scripts/step4_run_flutter_app.sh
   ```

### Release & Deployment Workflow

5. **Build Android release artifact** – pass a flavor name if you have one:
   ```bash
   scripts/step5_build_mobile_release.sh [flavor]
   ```

6. **Trigger server deploy workflow** – requires the GitHub CLI (`gh`) and repo access:
   ```bash
   scripts/step6_trigger_server_deploy.sh <environment> [image_tag]
   ```

7. **Prepare release** – validates builds and checks version numbers:
   ```bash
   scripts/step7_prepare_release.sh
   ```

8. **Build and sign Android release** – generates signed APK/AAB:
   ```bash
   # Generate keystore first (one-time)
   scripts/generate_keystore.sh
   
   # Build with signing
   export KEYSTORE_PATH=/path/to/keystore.jks
   export KEYSTORE_PASSWORD=...
   export KEY_ALIAS=upload
   export KEY_PASSWORD=...
   scripts/step8_build_and_sign.sh
   ```

9. **Build Docker image** – creates containerized server:
   ```bash
   export REGISTRY=ghcr.io/your-username
   export IMAGE_TAG=v1.0.0
   scripts/step9_docker_build.sh
   ```

10. **Deploy Docker image** – deploys to your platform:
    ```bash
    scripts/step10_deploy_docker.sh <environment> <image_tag>
    ```

11. **Validate deployment** – checks API health:
    ```bash
    scripts/step11_validate_deployment.sh https://your-api.example.com
    ```

12. **Setup monitoring** – configures observability:
    ```bash
    scripts/step12_setup_monitoring.sh
    ```

### Production Deployment Workflow

13. **Prepare Android release** – validates Android configuration:
    ```bash
    scripts/step13_prepare_android_release.sh
    ```

14. **Build release AAB** – creates signed Android App Bundle:
    ```bash
    export KEYSTORE_PATH=/path/to/keystore.jks
    export KEYSTORE_PASSWORD=...
    export KEY_ALIAS=upload
    export KEY_PASSWORD=...
    scripts/step14_build_release_aab.sh
    ```

15. **Upload to Play Store** – uploads AAB to Google Play:
    ```bash
    scripts/step15_upload_to_play.sh production
    ```

16. **Setup Play App Signing** – configures Google Play App Signing:
    ```bash
    scripts/step16_setup_play_signing.sh
    ```

17. **Production validation** – validates production readiness:
    ```bash
    scripts/step17_production_validation.sh https://your-api.com
    ```

18. **EMM deployment** (optional) – enterprise deployment guide:
    ```bash
    scripts/step18_emm_deployment.sh
    ```

19. **Complete production deployment** – orchestrates full deployment:
    ```bash
    scripts/step19_production_deploy.sh prod https://your-api.com
    ```

For detailed deployment instructions, see [DEPLOYMENT.md](./DEPLOYMENT.md) and [PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md).

## GitHub Environments & Secrets

We use three environments: **dev**, **staging**, **prod**. Each environment stores the secrets consumed by `server-deploy.yml`.

1. **Create environments** – GitHub → Repository → Settings → *Environments* → create `dev`, `staging`, `prod`. Add reviewers/branch protections as needed.
2. **Add environment secrets** (repeat per environment):
   - `GOOGLE_CLIENT_ID`
     - OAuth client with Calendar scope
   - `GOOGLE_CLIENT_SECRET`
   - `GOOGLE_REDIRECT_URI`
     - Often `https://developers.google.com/oauthplayground`
   - `GOOGLE_REFRESH_TOKEN`
     - Generated from OAuth Playground with Calendar scope
   - *(Optional, for GHCR pushes)* `GHCR_USERNAME`, `GHCR_TOKEN`
3. **Run a deploy** – Actions → *server-deploy* → **Run workflow** → choose environment (`dev`/`staging`/`prod`). The job builds the Nest server and, when GHCR secrets exist, publishes an image tagged `ghcr.io/<owner>/<repo>/mvp-server:<git-sha>`.
4. **Local secrets** – Copy `server/.env.example` to `server/.env` and fill values:
   ```
   PORT=3000
   GOOGLE_CLIENT_ID=...
   GOOGLE_CLIENT_SECRET=...
   GOOGLE_REDIRECT_URI=...
   GOOGLE_REFRESH_TOKEN=...
   ```
   `npm run start:dev` (or `scripts/step3_start_server.sh`) will load them via `@nestjs/config`.
5. **Protect production** – In *Environments → prod* add required reviewers and restrict to `main`. The workflow uses `environment: ${{ inputs.environment }}` so protections apply automatically.

## CI/CD Summary

- `server-ci.yml`: installs Node 20, runs `npm ci` and `npm run build` for the API.
- `server-deploy.yml`: manual workflow that builds the server, optionally builds/pushes a Docker image, and leaves a deployment hook for platform-specific commands.
- `flutter-ci.yml`: fetches dependencies and runs `flutter analyze` with Flutter `3.24.0`.
- `flutter-build-android.yml`: manual workflow that produces an unsigned APK artifact, optionally for a named flavor.

Extend these pipelines with automated tests (`dart test`, `npm run test`) as they are added to the codebase.
