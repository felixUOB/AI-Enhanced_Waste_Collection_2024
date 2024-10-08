<img width="568" alt="Screenshot 2024-10-02 at 12 07 38 pm" src="https://github.com/user-attachments/assets/54dbda58-e2b7-427f-8b05-2a29cda85ce0">

# OAuth 2.0 Email Login Implementation with Google, Facebook, LinkedIn, Apple

This documentation provides an overview of how to implement email-based login using **OAuth 2.0** for major platforms like **Google**, **Facebook**, **LinkedIn**, and **Apple**. This method ensures that users can log in securely using their existing accounts, simplifying authentication without directly managing passwords.

## Features
- **Email-based OAuth Login**: Implemented through trusted platforms.
- **Secure Authentication**: Offloads security management to Google, Facebook, LinkedIn, or Apple.
- **Access Tokens**: Used to retrieve user data (e.g., email) after authentication.

## How OAuth 2.0 Works
1. **User Action**: The user clicks a button like "Sign in with Google" or "Sign in with Facebook."
2. **Redirection to OAuth Provider**: The user is redirected to the OAuth provider (Google, Facebook, LinkedIn, Apple) to log in.
3. **Authorization**: The provider prompts the user to grant permission for your app to access certain data (e.g., email).
4. **Authentication Code**: Once the user grants permission, the provider sends an authentication code back to your application.
5. **Access Token**: The authentication code is exchanged for an access token, which allows your application to retrieve user information, such as their email address.

## Platforms Supported
- **Google**
- **Facebook**
- **LinkedIn**
- **Apple**

## Setup Instructions
### Prerequisites
- **Node.js** and **npm** installed.
- Developer accounts for each platform (Google, Facebook, LinkedIn, Apple).
- OAuth credentials (Client ID, Client Secret) from the developer portals.

### OAuth Credentials Setup
#### Google
1. Go to the [Google Developer Console](https://console.cloud.google.com/).
2. Create a new project and enable the **Google OAuth API**.
3. Create OAuth credentials to get your **Client ID** and **Client Secret**.

#### Facebook
1. Go to the [Facebook Developer Portal](https://developers.facebook.com/).
2. Create an app and enable **Facebook Login**.
3. Obtain the **App ID** and **App Secret**.

#### LinkedIn
1. Go to the [LinkedIn Developer Portal](https://www.linkedin.com/developers/).
2. Create an app and configure **OAuth**.
3. Get the **Client ID** and **Client Secret**.

#### Apple
1. Go to the [Apple Developer Portal](https://developer.apple.com/).
2. Set up **Sign in with Apple**.
3. Obtain **Client ID** and **Client Secret**.

## Example Code for Google OAuth 2.0 Login
```javascript
const express = require('express');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

passport.use(new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: "/auth/google/callback"
}, function(token, tokenSecret, profile, done) {
  // Save or update user information in the database
  return done(null, profile);
}));

// Initiate Google login
app.get('/auth/google', passport.authenticate('google', { scope: ['email', 'profile'] }));

// Google OAuth callback route
app.get('/auth/google/callback', passport.authenticate('google', { 
  successRedirect: '/dashboard', 
  failureRedirect: '/' 
}));
```

## Example Code for Facebook OAuth 2.0 Login
```javascript
const FacebookStrategy = require('passport-facebook').Strategy;

passport.use(new FacebookStrategy({
  clientID: process.env.FACEBOOK_APP_ID,
  clientSecret: process.env.FACEBOOK_APP_SECRET,
  callbackURL: "/auth/facebook/callback"
}, function(accessToken, refreshToken, profile, done) {
  // Save or update user information in the database
  return done(null, profile);
}));

// Initiate Facebook login
app.get('/auth/facebook', passport.authenticate('facebook'));

// Facebook OAuth callback route
app.get('/auth/facebook/callback', passport.authenticate('facebook', { 
  successRedirect: '/dashboard', 
  failureRedirect: '/' 
}));
```

