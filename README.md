// ─────────────────────────────────────────────────────────────────────────────
// README snippet — GitHub Environments & Secrets (how-to)
// ─────────────────────────────────────────────────────────────────────────────
/*
# GitHub Environments & Secrets — Setup Guide


We use three environments: **dev**, **staging**, **prod**. Each environment holds its own secrets used by workflows.


## 1) Create environments
GitHub → Repository → Settings → *Environments* → **New environment** → create: `dev`, `staging`, `prod`.
(Optional) Add required reviewers and deployment branches.


## 2) Add environment secrets (repeat for each environment)
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_REDIRECT_URI` (e.g., https://developers.google.com/oauthplayground)
- `GOOGLE_REFRESH_TOKEN`
- *(Optional for GHCR)* `GHCR_USERNAME` (usually your GitHub username)
- *(Optional for GHCR)* `GHCR_TOKEN` (a classic PAT with `read:packages`, `write:packages`)


## 3) Run a deploy
Actions → *server-deploy* → **Run workflow** → pick environment (dev/staging/prod). The job reads secrets from the selected environment and builds the NestJS server. If GHCR creds exist, it also builds & pushes a Docker image named:
`ghcr.io/<owner>/<repo>/mvp-server:<git-sha>`


## 4) Consuming secrets locally
Create `server/.env` (never commit it):
```
PORT=3000
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GOOGLE_REDIRECT_URI=...
GOOGLE_REFRESH_TOKEN=...
```
`npm run start:dev` will read them via `@nestjs/config`.


## 5) Protecting production
In *Environments → prod*, add **Required reviewers** and restrict deployments to the `main` branch. The workflow uses `environment: ${{ inputs.environment }}` so approvals apply.


*/
