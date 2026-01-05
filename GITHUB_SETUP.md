# GitHub Secrets Setup Guide

## Required GitHub Secrets

Add these secrets to your repository at: Settings → Secrets and variables → Actions

### Azure Authentication
```
ARM_CLIENT_ID=xxxx
ARM_CLIENT_SECRET=xxxx
ARM_SUBSCRIPTION_ID=xxxx
ARM_TENANT_ID=xxxx
```

### Backend Configuration
```
TF_STATE_STORAGE_ACCOUNT=xxxx
TF_STATE_RESOURCE_GROUP=xxxx
```

## How to Add Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name and value above

## Test Deployment

Once secrets are added, you can:
1. Go to **Actions** tab in your repository
2. Select **Deploy Azure Component** workflow
3. Click **Run workflow**
4. Select:
   - Environment: `dev`
   - Location: `centralindia`
   - Component: `02-networking`
5. Click **Run workflow**

This will deploy foundation first, then networking components.
