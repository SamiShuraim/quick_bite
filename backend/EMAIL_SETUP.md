# Email Configuration Setup

This guide explains how to configure email sending for QuickBite authentication features.

## Email Features

The backend now supports:
- ✅ Email verification with 4-digit code
- ✅ Resend verification code
- ✅ Password reset with 4-digit code
- ✅ Beautiful HTML email templates

## Environment Variables

Add these variables to your `.env` file:

```env
# Email Configuration (Gmail example)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

## Option 1: Gmail Setup (Recommended for Development)

### Step 1: Enable 2-Factor Authentication
1. Go to your Google Account: https://myaccount.google.com
2. Navigate to Security
3. Enable 2-Step Verification

### Step 2: Generate App Password
1. Go to App Passwords: https://myaccount.google.com/apppasswords
2. Select "Mail" and your device
3. Click "Generate"
4. Copy the 16-character password
5. Use this password as `SMTP_PASS` in your `.env` file

### Step 3: Update .env
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-16-char-app-password
```

## Option 2: SendGrid (Recommended for Production)

### Step 1: Create SendGrid Account
1. Sign up at https://sendgrid.com
2. Verify your email
3. Create an API key

### Step 2: Update .env
```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your-sendgrid-api-key
```

## Option 3: Other Email Services

### Mailgun
```env
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USER=your-mailgun-username
SMTP_PASS=your-mailgun-password
```

### Amazon SES
```env
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USER=your-ses-username
SMTP_PASS=your-ses-password
```

## Testing Email Locally

For local development without setting up real email:

### Option 1: Mailtrap (Recommended)
1. Sign up at https://mailtrap.io
2. Get your credentials from the inbox
3. Update .env:
```env
SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USER=your-mailtrap-username
SMTP_PASS=your-mailtrap-password
```

### Option 2: Ethereal Email (Free, No Signup)
The service will log emails to console if SMTP fails, so you can still test without email setup.

## API Endpoints

### 1. Register (Sends Verification Email)
```bash
POST /api/v1/auth/register
{
  "email": "user@example.com",
  "password": "Password123",
  "name": "John Doe"
}
```

### 2. Verify Email
```bash
POST /api/v1/auth/verify-email
{
  "email": "user@example.com",
  "code": "1234"
}
```

### 3. Resend Verification Code
```bash
POST /api/v1/auth/resend-verification
{
  "email": "user@example.com"
}
```

### 4. Forgot Password
```bash
POST /api/v1/auth/forgot-password
{
  "email": "user@example.com"
}
```

### 5. Reset Password
```bash
POST /api/v1/auth/reset-password
{
  "email": "user@example.com",
  "code": "1234",
  "newPassword": "NewPassword123"
}
```

## Troubleshooting

### "Failed to send email" Error
- Check your SMTP credentials
- Verify SMTP_HOST and SMTP_PORT are correct
- For Gmail, ensure you're using an App Password, not your regular password
- Check if your email service requires additional authentication

### Emails Not Arriving
- Check spam/junk folder
- Verify the recipient email is correct
- Check email service logs/dashboard
- For Gmail, ensure "Less secure app access" is not blocking emails

### Rate Limiting
- The verification code is valid for 10 minutes
- You can resend after 60 seconds
- Rate limiting prevents spam (5 requests per 15 minutes)

## Production Considerations

1. **Use a Dedicated Email Service**: Don't use personal Gmail in production
2. **Set Up SPF/DKIM**: Configure DNS records to prevent emails going to spam
3. **Monitor Email Delivery**: Use service dashboards to track delivery rates
4. **Handle Failures Gracefully**: The app continues even if email fails
5. **Secure Credentials**: Never commit .env file to version control

## Email Templates

The service includes beautiful HTML email templates with:
- QuickBite branding
- Responsive design
- Clear call-to-action
- Professional styling

You can customize templates in `backend/src/services/emailService.ts`

