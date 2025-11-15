# QuickBite - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Flutter SDK (3.9.0+)
- Node.js (16+)
- MongoDB (local or Atlas)

## 📱 Frontend Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Skip Authentication
- On the login screen, click **"Skip Authentication (Testing)"**
- You'll be taken directly to the home screen

### 4. Explore the App
- **Home Screen**: Browse 6 restaurants with beautiful photos
- **Search**: Try searching for "burger" or "pizza"
- **Filter**: Click the filter icon to set preferences
- **Restaurant Detail**: Click any restaurant to see their menu
- **Food Detail**: Click a menu item to customize and add to cart
- **Cart**: Click the cart icon to view and manage your order

## 🔧 Backend Setup (Optional)

The app works with dummy data, but you can set up the backend for real API calls:

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your MongoDB connection string
```

### 3. Seed Database
```bash
npm run seed
```

### 4. Start Server
```bash
npm run dev
```

Server runs on: `http://localhost:3000`

## 🎯 Key Features to Test

### ✅ Restaurant Browsing
- Scroll through restaurant list
- See ratings, delivery time, and distance
- Notice "Popular" and "Free Delivery" badges

### ✅ Search & Filter
- Search by restaurant name
- Filter by category (Burger, Pizza, Asian, etc.)
- Use advanced filters (price, distance, payment methods)

### ✅ Menu Customization
1. Go to **Burger Bliss** restaurant
2. Click on **Classic Burger**
3. Select size (Required)
4. Add cheese (Optional)
5. Add extras like bacon or avocado
6. Adjust quantity
7. Click "ADD TO CART"

### ✅ Shopping Cart
- View all items in cart
- Adjust quantities with +/- buttons
- See price breakdown:
  - Subtotal
  - Delivery fee (FREE over $30!)
  - Tax (8%)
  - Total
- Clear cart option

### ✅ Different Restaurants
Each restaurant has unique characteristics:

**Burger Bliss** (4.8★)
- 4 burger options
- Full customization (size, cheese, extras)
- Free delivery
- Popular

**Pizza Palace** (4.6★)
- 2 pizza options
- Size and crust customization
- Popular

**Sushi Master** (4.9★)
- Highest rated
- Japanese cuisine
- Premium delivery

## 📸 Screenshots Reference

### Home Screen
- Search bar at top
- Category chips below search
- Restaurant cards with images
- Cart icon with badge

### Restaurant Detail
- Large restaurant image
- Rating and info chips
- Menu category tabs
- Menu item cards

### Food Detail
- Full-screen food image
- Ingredients list
- Customization sections
- Quantity selector
- Add to cart button with price

### Cart
- Item list with images
- Quantity controls
- Price breakdown
- Checkout button

## 🎨 Design Highlights

### Colors
- **Orange** (#FF7622) - Primary actions
- **Green** - Success states
- **Red** - Errors and warnings

### Images
All images are from Unsplash:
- High quality food photography
- Consistent style
- Proper error handling

### Typography
- Bold titles for emphasis
- Secondary text for details
- Proper hierarchy

## 🐛 Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Images not loading?
- Check internet connection
- Images are loaded from Unsplash CDN

### Can't skip authentication?
- Look for "Skip Authentication (Testing)" link at bottom of login screen
- It's in gray text with underline

### Backend not connecting?
- Make sure MongoDB is running
- Check `.env` configuration
- Run `npm run seed` to populate data

## 📱 Test Scenarios

### Scenario 1: Quick Order
1. Skip authentication
2. Click "Burger Bliss"
3. Click "Classic Burger"
4. Select "Regular" size
5. Click "ADD TO CART"
6. Click cart icon
7. See your order!

### Scenario 2: Custom Order
1. Go to "Burger Bliss"
2. Click "Classic Burger"
3. Select "Large" size (+$2.99)
4. Add "Cheddar" cheese (+$1.50)
5. Add "Bacon" (+$2.50)
6. Set quantity to 2
7. See total price update
8. Add to cart

### Scenario 3: Multiple Items
1. Add burger from Burger Bliss
2. Go back to home
3. Click "Pizza Palace"
4. Add "Margherita Pizza"
5. View cart - see both items
6. Adjust quantities
7. See free delivery if over $30

### Scenario 4: Search & Filter
1. Search "burger"
2. See filtered results
3. Clear search
4. Click filter icon
5. Set price range $0-$20
6. Set distance to 5km
7. Apply filters
8. See filtered restaurants

## 🎯 What's Working

✅ All screens implemented
✅ Navigation between screens
✅ Search and filtering
✅ Cart management
✅ Price calculations
✅ Customizations
✅ Image loading
✅ Error handling
✅ Loading states
✅ Dark mode support
✅ Responsive design

## 📝 Notes

- **Skip Auth Button**: Only for testing, remove in production
- **Dummy Data**: 6 restaurants with realistic data
- **Free Delivery**: Automatically applied for orders over $30
- **Tax Rate**: Fixed at 8%
- **Checkout**: Placeholder - shows "coming soon" message

## 🎉 Enjoy Testing!

You now have a fully functional food delivery app. All features are working and ready to test. Have fun exploring! 🍔🍕🌮

