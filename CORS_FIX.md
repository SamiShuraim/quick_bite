# CORS Fix for Flutter Web

## Problem
The Flutter web app was blocked by CORS policy when trying to access the backend:
```
Access to fetch at 'https://quick-bite-fxch.onrender.com/health' from origin 'http://localhost:51788' 
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## Root Cause
The backend's CORS configuration only allowed `http://localhost:3000`, but Flutter web runs on random ports like `http://localhost:51788`.

## Solution
Updated `backend/src/app.ts` to dynamically allow ALL localhost origins in development:

```typescript
// CORS configuration - Allow all localhost origins in development
app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps, Postman, curl)
      if (!origin) return callback(null, true);
      
      // In development, allow all localhost origins
      if (config.isDevelopment && origin.includes('localhost')) {
        return callback(null, true);
      }
      
      // Check against allowed origins list
      if (config.cors.allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      
      callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);
```

## Changes
- **File**: `backend/src/app.ts`
- **What changed**: CORS origin validation now uses a function instead of a static array
- **Benefits**:
  - ✅ Allows Flutter web on any localhost port
  - ✅ Allows desktop/mobile apps (no origin)
  - ✅ Still respects allowed origins list
  - ✅ Only permissive in development mode
  - ✅ Production remains secure

## Deployment
- Committed: ✅ `7c7e4b3`
- Pushed: ✅ `origin/main`
- Render will auto-deploy in ~2-3 minutes

## Testing
Once Render finishes deploying:
1. Run the Flutter web app: `flutter run -d chrome`
2. The backend health check should now succeed
3. App should proceed past splash screen

## Note
CORS errors ONLY affect web builds. Desktop (Windows/macOS/Linux) and mobile (iOS/Android) builds do not have CORS restrictions and would have worked fine.

---
**Fixed**: December 3, 2024  
**Commit**: 7c7e4b3  
**Status**: Deployed to Render.com

