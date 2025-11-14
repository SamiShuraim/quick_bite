/**
 * Email Service
 * Handles sending emails for verification and password reset
 */

import nodemailer from 'nodemailer';
import { config } from '../config/environment';
import { Logger } from '../utils/logger';

export class EmailService {
  private static transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587'),
    secure: false, // true for 465, false for other ports
    auth: {
      user: process.env.SMTP_USER || 'your-email@gmail.com',
      pass: process.env.SMTP_PASS || 'your-app-password',
    },
  });

  /**
   * Send email verification code
   */
  static async sendVerificationEmail(
    email: string,
    code: string
  ): Promise<void> {
    try {
      const mailOptions = {
        from: `"QuickBite" <${process.env.SMTP_USER || 'noreply@quickbite.com'}>`,
        to: email,
        subject: 'Verify Your Email - QuickBite',
        html: `
          <!DOCTYPE html>
          <html>
            <head>
              <style>
                body {
                  font-family: Arial, sans-serif;
                  line-height: 1.6;
                  color: #333;
                }
                .container {
                  max-width: 600px;
                  margin: 0 auto;
                  padding: 20px;
                }
                .header {
                  background-color: #FF7622;
                  color: white;
                  padding: 20px;
                  text-align: center;
                  border-radius: 10px 10px 0 0;
                }
                .content {
                  background-color: #f9f9f9;
                  padding: 30px;
                  border-radius: 0 0 10px 10px;
                }
                .code {
                  font-size: 32px;
                  font-weight: bold;
                  color: #FF7622;
                  text-align: center;
                  padding: 20px;
                  background-color: white;
                  border-radius: 10px;
                  margin: 20px 0;
                  letter-spacing: 10px;
                }
                .footer {
                  text-align: center;
                  margin-top: 20px;
                  color: #666;
                  font-size: 12px;
                }
              </style>
            </head>
            <body>
              <div class="container">
                <div class="header">
                  <h1>🍔 QuickBite</h1>
                </div>
                <div class="content">
                  <h2>Verify Your Email</h2>
                  <p>Thank you for signing up with QuickBite! Please use the verification code below to complete your registration:</p>
                  <div class="code">${code}</div>
                  <p>This code will expire in 10 minutes.</p>
                  <p>If you didn't request this code, please ignore this email.</p>
                </div>
                <div class="footer">
                  <p>&copy; ${new Date().getFullYear()} QuickBite. All rights reserved.</p>
                </div>
              </div>
            </body>
          </html>
        `,
      };

      await this.transporter.sendMail(mailOptions);
      Logger.info(`Verification email sent to: ${email}`);
    } catch (error) {
      Logger.error('Failed to send verification email', error as Error);
      throw error;
    }
  }

  /**
   * Send password reset code
   */
  static async sendPasswordResetEmail(
    email: string,
    code: string
  ): Promise<void> {
    try {
      const mailOptions = {
        from: `"QuickBite" <${process.env.SMTP_USER || 'noreply@quickbite.com'}>`,
        to: email,
        subject: 'Reset Your Password - QuickBite',
        html: `
          <!DOCTYPE html>
          <html>
            <head>
              <style>
                body {
                  font-family: Arial, sans-serif;
                  line-height: 1.6;
                  color: #333;
                }
                .container {
                  max-width: 600px;
                  margin: 0 auto;
                  padding: 20px;
                }
                .header {
                  background-color: #FF7622;
                  color: white;
                  padding: 20px;
                  text-align: center;
                  border-radius: 10px 10px 0 0;
                }
                .content {
                  background-color: #f9f9f9;
                  padding: 30px;
                  border-radius: 0 0 10px 10px;
                }
                .code {
                  font-size: 32px;
                  font-weight: bold;
                  color: #FF7622;
                  text-align: center;
                  padding: 20px;
                  background-color: white;
                  border-radius: 10px;
                  margin: 20px 0;
                  letter-spacing: 10px;
                }
                .footer {
                  text-align: center;
                  margin-top: 20px;
                  color: #666;
                  font-size: 12px;
                }
              </style>
            </head>
            <body>
              <div class="container">
                <div class="header">
                  <h1>🍔 QuickBite</h1>
                </div>
                <div class="content">
                  <h2>Reset Your Password</h2>
                  <p>We received a request to reset your password. Please use the code below:</p>
                  <div class="code">${code}</div>
                  <p>This code will expire in 10 minutes.</p>
                  <p>If you didn't request this password reset, please ignore this email and your password will remain unchanged.</p>
                </div>
                <div class="footer">
                  <p>&copy; ${new Date().getFullYear()} QuickBite. All rights reserved.</p>
                </div>
              </div>
            </body>
          </html>
        `,
      };

      await this.transporter.sendMail(mailOptions);
      Logger.info(`Password reset email sent to: ${email}`);
    } catch (error) {
      Logger.error('Failed to send password reset email', error as Error);
      throw error;
    }
  }

  /**
   * Generate a 4-digit verification code
   */
  static generateVerificationCode(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }
}

